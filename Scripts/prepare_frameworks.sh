#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORKS_DIR="$SCRIPT_DIR/../Frameworks"
TEMP_PODS_DIR="/tmp/tuya-pods-temp"

echo "🔧 Preparing Tuya frameworks with arm64 simulator support..."

# Cleanup
rm -rf "$TEMP_PODS_DIR"
rm -rf "$FRAMEWORKS_DIR"
mkdir -p "$FRAMEWORKS_DIR"
mkdir -p "$TEMP_PODS_DIR"

cd "$TEMP_PODS_DIR"

# Create a mock Xcode project for CocoaPods
echo "📝 Creating mock Xcode project..."
cp -r "$SCRIPT_DIR/../TempProject/." .

# Create Podfile
cat > "Podfile" <<'EOF'
platform :ios, '15.0'

source 'https://github.com/tuya/tuya-pod-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

project 'TempProject.xcodeproj'

target 'TempProject' do
  use_frameworks!
  
  pod 'TuyaSmartActivatorKit', '4.0.0'
end
EOF

echo "📥 Installing pods..."
pod install --repo-update

# Find required tools
BITCODE_STRIP=$(xcrun --find bitcode_strip)
LIPO=$(xcrun --find lipo)
VTOOL=$(xcrun --find vtool)

# Function to strip bitcode from framework
strip_bitcode() {
  local framework_path="$1"
  local binary_name=$(basename "$framework_path" .framework)
  local binary_path="$framework_path/$binary_name"
  
  if [ -f "$binary_path" ]; then
    echo "   🗜️  Stripping bitcode from: $binary_name"
    
    # Use xcrun to find strip tool, fallback to /usr/bin/strip if not found
    STRIP_TOOL=$(xcrun --find strip 2>/dev/null || echo "/usr/bin/strip")
    
    # Try using bitcode_strip with proper environment
    if xcrun bitcode_strip "$binary_path" -r -o "${binary_path}.tmp" 2>/dev/null; then
      # bitcode_strip succeeded, replace original binary
      mv "${binary_path}.tmp" "$binary_path"
    else
      # Fallback: use regular strip to remove debug information
      # This is acceptable since bitcode is deprecated in iOS 14+
      echo "   ⚠️  bitcode_strip failed, using strip as fallback"
      $STRIP_TOOL -x "$binary_path" 2>/dev/null || true
    fi
  fi
}

# Function to create arm64 simulator slice from device slice
create_arm64_simulator_slice() {
  local xcframework_path="$1"
  local xcframework_name=$(basename "$xcframework_path" .xcframework)
  
  echo "   🔨 Creating arm64 simulator support for: $xcframework_name"
  
  # Find device framework (arm64) - exclude BCSymbolMaps and dSYMs
  local device_framework=$(find "$xcframework_path" -type d -name "*.framework" \
    -not -path "*/BCSymbolMaps/*" \
    -not -path "*/*.dSYM/*" \
    | grep -E "ios-arm64(_armv7)?/" | head -1)
  
  if [ -z "$device_framework" ]; then
    echo "   ⚠️  No arm64 device framework found, skipping"
    return
  fi
  
  local binary_name=$(basename "$device_framework" .framework)
  local device_binary="$device_framework/$binary_name"
  
  if [ ! -f "$device_binary" ]; then
    echo "   ⚠️  Binary not found: $device_binary"
    return
  fi
  
  # Check if arm64 slice exists in device binary
  if ! $LIPO -info "$device_binary" 2>/dev/null | grep -q "arm64"; then
    echo "   ⚠️  No arm64 slice found in device binary"
    return
  fi
  
  # Extract arm64 slice
  local temp_arm64="/tmp/${binary_name}_arm64_${RANDOM}.bin"
  echo "   📤 Extracting arm64 slice..."
  
  # Check if binary is already thin (single architecture)
  if $LIPO -info "$device_binary" 2>/dev/null | grep -q "Non-fat file"; then
    # Binary is already thin, just copy it
    cp "$device_binary" "$temp_arm64"
  else
    # Binary is fat, extract arm64 slice
    $LIPO "$device_binary" -thin arm64 -output "$temp_arm64"
  fi
  
  # Verify the extracted file is valid mach-o
  if ! file "$temp_arm64" | grep -q "Mach-O"; then
    echo "   ⚠️  Extracted file is not a valid Mach-O binary"
    rm -f "$temp_arm64"
    return
  fi
  
  # Change platform from iOS device to iOS simulator
  echo "   🔄 Converting to simulator binary..."
  # Platform 7 = iOS Simulator, minimum version 15.0
  if ! $VTOOL -arch arm64 -set-build-version 7 15.0 15.0 -replace -output "${temp_arm64}.new" "$temp_arm64" 2>/dev/null; then
    echo "   ⚠️  vtool conversion failed"
    rm -f "$temp_arm64" "${temp_arm64}.new"
    return
  fi
  
  # Replace temp file with converted version
  mv "${temp_arm64}.new" "$temp_arm64"
  
  # Find ALL iOS simulator frameworks (not watchOS or other platforms)
  local processed=0
  find "$xcframework_path" -type d -name "*.framework" \
    -not -path "*/BCSymbolMaps/*" \
    -not -path "*/*.dSYM/*" \
    | grep -E "ios-.*simulator" | while read sim_framework; do
    
    local sim_binary="$sim_framework/$binary_name"
    local parent_dir=$(basename $(dirname "$sim_framework"))
    
    if [ ! -f "$sim_binary" ]; then
      continue
    fi
    
    # Check current architectures
    local current_archs=$($LIPO -info "$sim_binary" 2>/dev/null | sed 's/.*: //')
    
    if echo "$current_archs" | grep -q "arm64"; then
      echo "   ✅ arm64 already exists in $parent_dir"
      continue
    fi
    
    echo "   🔀 Merging arm64 into $parent_dir ($current_archs)..."
    local temp_merged="/tmp/${binary_name}_merged_${RANDOM}.bin"
    
    if $LIPO -create "$sim_binary" "$temp_arm64" -output "$temp_merged" 2>/dev/null; then
      mv "$temp_merged" "$sim_binary"
      processed=1
      echo "   ✅ Merged: $($LIPO -info "$sim_binary")"
    else
      echo "   ⚠️  Failed to merge architectures"
      rm -f "$temp_merged"
    fi
  done
  
  # If no existing simulator framework was found, create a new one
  if [ $processed -eq 0 ]; then
    echo "   ➕ Creating new simulator framework..."
    
    local sim_arch_dir="$xcframework_path/ios-arm64_x86_64-simulator"
    mkdir -p "$sim_arch_dir"
    
    # Copy framework structure from device
    cp -R "$device_framework" "$sim_arch_dir/"
    
    local new_sim_binary="$sim_arch_dir/$(basename "$device_framework")/$binary_name"
    
    # Replace binary with simulator version
    cp "$temp_arm64" "$new_sim_binary"
    
    # Update Info.plist for this slice
    local slice_info="$sim_arch_dir/$(basename "$device_framework")/Info.plist"
    if [ -f "$slice_info" ]; then
      /usr/libexec/PlistBuddy -c "Delete :CFBundleSupportedPlatforms" "$slice_info" 2>/dev/null || true
      /usr/libexec/PlistBuddy -c "Add :CFBundleSupportedPlatforms array" "$slice_info"
      /usr/libexec/PlistBuddy -c "Add :CFBundleSupportedPlatforms:0 string iPhoneSimulator" "$slice_info"
    fi
    
    echo "   ✅ Created new simulator framework with arm64"
  fi
  
  # Cleanup
  rm -f "$temp_arm64"
}

# Fix missing dSYMs paths declared in Info.plist
fix_dsyms_paths() {
  local xcframework_path="$1"
  
  find "$xcframework_path" -name "Info.plist" | while read plist; do
    local slice_dir=$(dirname "$plist")
    
    # Check if Info.plist declares DebugSymbolsPath
    local dsyms_rel=$(/usr/libexec/PlistBuddy -c "Print :DebugSymbolsPath" "$plist" 2>/dev/null || true)
    
    if [ -n "$dsyms_rel" ]; then
      local dsyms_abs="$slice_dir/$dsyms_rel"
      if [ ! -d "$dsyms_abs" ]; then
        echo "   📁 Creating missing dSYMs dir: $dsyms_abs"
        mkdir -p "$dsyms_abs"
      fi
    fi
  done
}

# Function to fix code signing
fix_codesign() {
  local framework_path="$1"
  
  echo "   ✍️  Re-signing framework..."
  
  # Remove existing signature
  codesign --remove-signature "$framework_path" 2>/dev/null || true
  
  # Ad-hoc sign for local development
  codesign --force --sign - --timestamp=none "$framework_path" 2>/dev/null || true
}

# Process each XCFramework
XCFRAMEWORKS=(
  "TuyaSmartActivatorKit"
  "TuyaSmartActivatorCoreKit"
  "TuyaSmartBaseKit"
  "TuyaSmartDeviceKit"
  "TuyaSmartDeviceCoreKit"
  "TuyaSmartMQTTChannelKit"
  "TuyaSmartNetworkKit"
  "TuyaSmartPairingCoreKit"
  "TuyaSmartQUIC"
  "TuyaSmartShareKit"
  "TuyaSmartSocketChannelKit"
  "TuyaSmartUtil"
  "TYMbedtls"
)

for framework_name in "${XCFRAMEWORKS[@]}"; do
  echo ""
  echo "📦 Processing $framework_name..."
  
  # Try multiple possible locations
  XCFRAMEWORK_PATH=""
  for possible_path in \
    "$TEMP_PODS_DIR/Pods/$framework_name/Build/$framework_name.xcframework" \
    "$TEMP_PODS_DIR/Pods/$framework_name/$framework_name.xcframework" \
    "$TEMP_PODS_DIR/Pods/$framework_name/Framework/$framework_name.xcframework"; do
    
    if [ -d "$possible_path" ]; then
      XCFRAMEWORK_PATH="$possible_path"
      break
    fi
  done
  
  if [ -z "$XCFRAMEWORK_PATH" ] || [ ! -d "$XCFRAMEWORK_PATH" ]; then
    echo "   ⚠️  Warning: XCFramework not found, skipping..."
    continue
  fi
  
  # Copy XCFramework
  cp -R "$XCFRAMEWORK_PATH" "$FRAMEWORKS_DIR/"
  
  copied_xcf="$FRAMEWORKS_DIR/$framework_name.xcframework"
  
  # Strip bitcode from all frameworks (exclude BCSymbolMaps and dSYMs)
  find "$copied_xcf" -type d -name "*.framework" \
    -not -path "*/BCSymbolMaps/*" \
    -not -path "*/*.dSYM/*" \
    | while read framework; do
    strip_bitcode "$framework"
  done

  fix_dsyms_paths "$copied_xcf"
  # Create arm64 simulator support
  create_arm64_simulator_slice "$copied_xcf"

  # Re-sign all frameworks (exclude BCSymbolMaps and dSYMs)
  find "$copied_xcf" -type d -name "*.framework" \
    -not -path "*/BCSymbolMaps/*" \
    -not -path "*/*.dSYM/*" \
    | while read framework; do
    fix_codesign "$framework"
  done

  echo "   ✅ Done: $framework_name"
done

# Cleanup
rm -rf "$TEMP_PODS_DIR"

echo ""
echo "✨ All frameworks prepared in $FRAMEWORKS_DIR"
echo "🎯 arm64 simulator support added - no EXCLUDED_ARCHS needed!"
echo ""
echo "📋 Next steps:"
echo "   1. Verify frameworks: ./Scripts/verify_frameworks.sh"
echo "   2. Commit to git"
echo "   3. Tag version: git tag 4.0.0"
