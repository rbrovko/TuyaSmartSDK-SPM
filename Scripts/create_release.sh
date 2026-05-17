#!/opt/homebrew/bin/bash

set -e

echo "🚀 Creating ZIP archives and generating Package.swift for GitHub Release"
echo ""

# Define paths relative to script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
FRAMEWORKS_DIR="$REPO_ROOT/Frameworks"
ARCHIVES_DIR="$REPO_ROOT/Archives"

# GitHub repository
GITHUB_REPO="rbrovko/TuyaSmartSDK-SPM"
VERSION="4.0.0"

# Check if Frameworks directory exists
if [[ ! -d "$FRAMEWORKS_DIR" ]]; then
    echo "❌ Error: Frameworks directory not found at $FRAMEWORKS_DIR"
    exit 1
fi

# Automatically discover all .xcframework files in Frameworks directory
echo "🔍 Discovering frameworks..."
FRAMEWORKS=()
while IFS= read -r framework_path; do
    framework_name=$(basename "$framework_path" .xcframework)
    FRAMEWORKS+=("$framework_name")
    echo "  - Found: $framework_name"
done < <(find "$FRAMEWORKS_DIR" -maxdepth 1 -name "*.xcframework" -type d | sort)

if [[ ${#FRAMEWORKS[@]} -eq 0 ]]; then
    echo "❌ Error: No .xcframework files found in $FRAMEWORKS_DIR"
    exit 1
fi

echo ""
echo "📦 Found ${#FRAMEWORKS[@]} frameworks"
echo ""

# Create directory for archives
mkdir -p "$ARCHIVES_DIR"
cd "$FRAMEWORKS_DIR"

echo "📦 Creating ZIP archives..."
for framework in "${FRAMEWORKS[@]}"; do
    echo "  - $framework.xcframework"
    zip -r -q "$ARCHIVES_DIR/$framework.xcframework.zip" "$framework.xcframework"
done

cd "$REPO_ROOT"

echo ""
echo "🔐 Computing checksums..."
declare -A CHECKSUMS

for framework in "${FRAMEWORKS[@]}"; do
    checksum=$(swift package compute-checksum "Archives/$framework.xcframework.zip")
    CHECKSUMS[$framework]=$checksum
    echo "  - $framework: $checksum"
done

echo ""
echo "📝 Generating Package.swift..."

cat > "$REPO_ROOT/Package.swift" << 'PACKAGE_EOF'
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TuyaSmartSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TuyaSmartActivatorKit-SMP",
            targets: [
PACKAGE_EOF

# Generate targets list for library
for i in "${!FRAMEWORKS[@]}"; do
    if [[ $i -eq $((${#FRAMEWORKS[@]} - 1)) ]]; then
        # Last element without comma
        echo "                \"${FRAMEWORKS[$i]}\"" >> "$REPO_ROOT/Package.swift"
    else
        echo "                \"${FRAMEWORKS[$i]}\"," >> "$REPO_ROOT/Package.swift"
    fi
done

cat >> "$REPO_ROOT/Package.swift" << 'PACKAGE_EOF'
            ]
        )
    ],
    targets: [
PACKAGE_EOF

# Generate binary targets with checksums
for i in "${!FRAMEWORKS[@]}"; do
    framework="${FRAMEWORKS[$i]}"
    cat >> "$REPO_ROOT/Package.swift" << PACKAGE_EOF
        .binaryTarget(
            name: "$framework",
            url: "https://github.com/$GITHUB_REPO/releases/download/$VERSION/$framework.xcframework.zip",
            checksum: "${CHECKSUMS[$framework]}"
        )PACKAGE_EOF
    
    # Add comma if not the last element
    if [[ $i -lt $((${#FRAMEWORKS[@]} - 1)) ]]; then
        echo "," >> "$REPO_ROOT/Package.swift"
    else
        echo "" >> "$REPO_ROOT/Package.swift"
    fi
done

cat >> "$REPO_ROOT/Package.swift" << 'PACKAGE_EOF'
    ]
)
PACKAGE_EOF

echo "✅ Package.swift generated successfully!"
echo ""
echo "📋 Summary:"
echo "  - Created ${#FRAMEWORKS[@]} ZIP archives in ./Archives/"
echo "  - Updated Package.swift with remote URLs"
echo ""
echo "🎯 Next steps:"
echo "  1. Create a GitHub Release with tag '$VERSION'"
echo "  2. Upload all files from ./Archives/ as release assets"
echo "  3. Run the following commands:"
echo ""
echo "     git add Package.swift"
echo "     git commit -m 'Use remote binary targets from GitHub Releases'"
echo "     git push"
echo "     git tag -d $VERSION"
echo "     git push origin :refs/tags/$VERSION"
echo "     git tag $VERSION"
echo "     git push origin $VERSION"
echo ""
echo "🌐 Release URL: https://github.com/$GITHUB_REPO/releases/new?tag=$VERSION"
