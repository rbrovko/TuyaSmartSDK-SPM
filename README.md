# TuyaSmartSDK-SPM

Swift Package Manager wrapper for Tuya Smart Home SDK with native arm64 simulator support.

## Overview

This package wraps Tuya's CocoaPods-only SDK as binary XCFrameworks for use with Swift Package Manager. It includes automated patching to support arm64 simulators (Apple Silicon Macs) without requiring Rosetta or `EXCLUDED_ARCHS` workarounds.

### Features

- ✅ Full SPM support for all Tuya Smart SDK frameworks
- ✅ Native arm64 simulator support (Apple Silicon ready)
- ✅ Bitcode stripped for modern Xcode compatibility
- ✅ No CocoaPods required in your main project
- ✅ Xcode 16+ and Rosetta deprecation ready

### Included Frameworks

- TuyaSmartActivatorKit
- TuyaSmartActivatorCoreKit
- TuyaSmartBaseKit
- TuyaSmartDeviceKit
- TuyaSmartDeviceCoreKit
- TuyaSmartMQTTChannelKit
- TuyaSmartNetworkKit
- TuyaSmartPairingCoreKit
- TuyaSmartQUIC
- TuyaSmartShareKit
- TuyaSmartSocketChannelKit
- TuyaSmartUtil
- TYMbedtls

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

#### Option 1: Xcode UI

1. In Xcode, select **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/rbrovko/TuyaSmartSDK-SPM.git
   ```
3. Select version rule (recommend: **Up to Next Major Version**)
4. Click **Add Package**
5. Select **TuyaSmartActivatorKit-SMP** library and add to your target

#### Option 2: Package.swift

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/rbrovko/TuyaSmartSDK-SPM.git", from: "4.0.0")
]
```

Then add to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "TuyaSmartActivatorKit-SMP", package: "TuyaSmartSDK-SPM")
    ]
)
```

## Usage

Import frameworks in your Swift code:

```swift
import TuyaSmartActivatorKit

/*
{
  "secret":"reKE",
  "region":"AY",
  "token":"nqMwn1Nd"
}
*/

// startConfig token = region + token + secret
// example. 
let ssid = ""
let password = ""
let token = "AYnqMwn1NdreKE" // AYnqMwn1NdreKE = "AY" + "nqMwn1Nd" + "reKE" 
TuyaSmartActivator.sharedInstance().startConfigWiFi(.EZ, ssid: ssid, password: password, token: token, timeout: 100)

```

## Migrating from CocoaPods

### Before (CocoaPods)

**Podfile:**
```ruby
pod 'TuyaSmartActivatorKit', :source => 'https://github.com/tuya/tuya-pod-specs.git'

post_install do |installer|
  # arm64 simulator exclusion workaround
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
```

### After (SPM)

1. Remove Tuya pods from `Podfile`
2. Run `pod install` to clean up
3. Add this SPM package (see Installation above)
4. **Remove** any `EXCLUDED_ARCHS` settings from your project
5. Build and run ✅

## Maintenance

### Prerequisites

- macOS with Xcode Command Line Tools
- CocoaPods installed: `sudo gem install cocoapods`
- bash > 4.0 - Install bash via Homebrew:: `brew install bash`. Check

```bash
/opt/homebrew/bin/bash --version
# GNU bash, version 5.x
```

### Updating to New Tuya SDK Version

When Tuya releases a new SDK version, follow these steps:

#### 1. Update the Preparation Script

Edit `Scripts/prepare_frameworks.sh` and update the version:

```bash
pod 'TuyaSmartActivatorKit', '4.1.0'  # Update version here
```

#### 2. Run Preparation Script

```bash
./Scripts/prepare_frameworks.sh
```

This script will:
- Download Tuya SDK via CocoaPods
- Extract XCFrameworks
- Strip bitcode
- Create arm64 simulator slices from device binaries
- Re-sign frameworks for local development

**Expected output:**
```
🔧 Preparing Tuya frameworks with arm64 simulator support...
📥 Installing pods...
📦 Processing TuyaSmartActivatorKit...
   🗜️  Stripping bitcode from: TuyaSmartActivatorKit
   🔨 Creating arm64 simulator support for: TuyaSmartActivatorKit
   📤 Extracting arm64 slice...
   🔄 Converting to simulator binary...
   🔀 Merging arm64 into existing simulator binary (x86_64)...
   ✅ Merged: Architectures in the fat file: ... are: x86_64 arm64
   ✍️  Re-signing framework...
   ✅ Done: TuyaSmartActivatorKit
...
✨ All frameworks prepared in Frameworks/
🎯 arm64 simulator support added - no EXCLUDED_ARCHS needed!
```

#### 3. Verify Frameworks

```bash
./Scripts/verify_frameworks.sh
```

**Expected output:**
```
🔍 Verifying XCFrameworks...

📦 TuyaSmartActivatorKit.xcframework
   ├─ device: armv7 arm64
   ├─ simulator: x86_64 arm64
   │  ✅ arm64 simulator supported

📦 TuyaSmartUtil.xcframework
   ├─ device: armv7 arm64
   ├─ simulator: x86_64 arm64
   │  ✅ arm64 simulator supported
...
✅ Verification complete
```

#### 4. Create ZIP archives and generate Package.swift for GitHub Release

```bash
./Scripts/create_release.sh

# Tag the release - tmp tag for check
git tag 4.1.0
git push origin 4.1.0
```

1. Go to **Releases → Draft a new release**
2. Select tag `4.1.0`
3. Title: `TuyaSmartActivatorKit 4.1.0`
4. Description:
   ```markdown
   ## Changes
   - Updated TuyaSmartActivatorKit to 4.1.0
   - Native arm64 simulator support
   - Bitcode stripped
   
   ## Installation
   ```swift
   .package(url: "https://github.com/rbrovko/TuyaSmartSDK-SPM.git", from: "4.1.0")
   ```
   ```
5. Upload all files from ./Archives/ as release assets
6. Publish release

### Version Numbering

Follow Tuya's version numbers directly:
- TuyaSmartActivatorKit `4.0.0` → Tag `4.0.0`
- TuyaSmartActivatorKit `4.1.0` → Tag `4.1.0`

If you need to patch the wrapper itself without a new Tuya version:
- Use pre-release tags: `4.0.0-patch1`, `4.0.0-patch2`

#### 5. Test Locally

Before releasing, test in a real project:

```bash
# In your app project, point to local package
# Xcode → File → Add Package Dependencies → Add Local...
# Select the TuyaSmartSDK-SPM directory

# Build for simulator (Apple Silicon)
xcodebuild -workspace YourApp.xcworkspace \
           -scheme YourApp \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           clean build
```

Verify:
- ✅ Builds without errors
- ✅ No Rosetta warnings
- ✅ Runs on arm64 simulator
- ✅ No `EXCLUDED_ARCHS` needed

#### 6. Commit and Tag

```bash
# Stage changes
git add Package.swift
git add Scripts/prepare_frameworks.sh  # If you updated version

# Commit
git commit -m "Update TuyaSmartActivatorKit to 4.1.0 with arm64 simulator support"

# Delete temp tag
git tag -d 4.1.0
git push origin --delete 4.1.0

# Create new tag
git tag 4.1.0

# Push
git push origin master
git push origin 4.1.0
```

## Troubleshooting

### Build fails with "framework not found"

**Solution:** Clean build folder
```bash
# In Xcode
Product → Clean Build Folder (Cmd+Shift+K)

# Or via command line
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### "Unsupported architecture arm64" on simulator

This means arm64 simulator slice is missing. Re-run:
```bash
./Scripts/prepare_frameworks.sh
./Scripts/verify_frameworks.sh
```

Verify output shows:
```
├─ simulator: x86_64 arm64
│  ✅ arm64 simulator supported
```

### Code signing errors

Frameworks are ad-hoc signed for local development. This is normal and expected.

If you see signing errors at runtime:
```bash
# Re-sign specific framework
codesign --force --sign - --timestamp=none \
  Frameworks/TuyaSmartUtil.xcframework/ios-arm64_x86_64-simulator/TuyaSmartUtil.framework
```

### "Building for iOS Simulator, but linking in dylib built for iOS"

You have a device-only binary in the simulator framework. Re-run preparation script:
```bash
./Scripts/prepare_frameworks.sh
```

This error should not occur if arm64 simulator slices are properly created.

## Technical Details

### Binary Patching Process

The preparation script performs these transformations:

1. **Download** via CocoaPods (official Tuya distribution)
2. **Extract** XCFrameworks from Pods directory
3. **Strip bitcode** using `bitcode_strip` (Xcode deprecated bitcode)
4. **Create arm64 simulator slice:**
   - Extract `arm64` slice from device binary
   - Change Mach-O platform flag: `1` (iOS device) → `7` (iOS simulator)
   - Merge into existing simulator binary (usually `x86_64`)
5. **Re-sign** with ad-hoc signature

### Why This Works

iOS device and iOS simulator binaries are nearly identical at the machine code level (both arm64). The primary difference is the **platform identifier** in the Mach-O header:

```
LC_BUILD_VERSION {
  platform: 1 (iOS)        → device
  platform: 7 (iOS Sim)    → simulator
}
```

By changing this flag with `vtool`, we create valid simulator binaries.

**Limitations:**
- Device-specific APIs (GPS, camera hardware access) won't work in simulator
- This is expected and normal for SDK testing
- Tuya SDK is primarily networking/API code, so compatibility is excellent

## License

This wrapper repository is provided as-is for use with Tuya Smart SDK.

Tuya Smart SDK itself is proprietary and licensed by Tuya Inc. See [Tuya License Terms](https://github.com/tuya/tuya-pod-specs).

## Contributing

### Reporting Issues

If you encounter problems:

1. Run verification script: `./Scripts/verify_frameworks.sh`
2. Check Xcode version: `xcodebuild -version`
3. Check simulator architecture:
   ```bash
   file Frameworks/TuyaSmartUtil.xcframework/ios-arm64_x86_64-simulator/TuyaSmartUtil.framework/TuyaSmartUtil
   ```
4. Open issue with output from above commands

### Pull Requests

Contributions welcome for:
- Script improvements
- Better error handling
- Documentation updates
- Support for new Tuya SDK versions

## Credits

- **Tuya Smart SDK**: [tuya-pod-specs](https://github.com/tuya/tuya-pod-specs)
- **Binary patching technique**: Inspired by community solutions for arm64 simulator support
- **Maintained by**: [Roman Brovko](https://github.com/rbrovko)

## [CHANGELOG](CHANGELOG.md)

---

**Questions?** Open an issue or check [Tuya Documentation](https://developer.tuya.com/en/docs/iot)
