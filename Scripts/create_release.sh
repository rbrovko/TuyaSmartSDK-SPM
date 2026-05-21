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

# ---------------------------------------------------------------------------
# SPM source dependencies (non-binary pods that can't become xcframeworks)
# Format: "ProductName|PackageIdentifier|https://github.com/owner/repo.git|from:X.Y.Z"
# ProductName: name of the product to import from external package
# PackageIdentifier: identifier for the package (usually extracted from URL)
# ---------------------------------------------------------------------------
SPM_DEPS=(
    "YYModel|YYModel-SPM|https://github.com/rbrovko/YYModel-SPM.git|from:1.0.4"
)

# Extract product names from SPM_DEPS
SPM_PRODUCTS=()
for dep in "${SPM_DEPS[@]}"; do
    product_name="${dep%%|*}"
    SPM_PRODUCTS+=("$product_name")
done

# --- Package.swift header + products block ---
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
            name: "TuyaSmartActivatorKit",
            targets: [
PACKAGE_EOF

# Generate targets list for library (wrapper targets instead of binary targets)
for i in "${!FRAMEWORKS[@]}"; do
    comma=$([[ $i -lt $((${#FRAMEWORKS[@]} - 1)) ]] && echo "," || echo "")
    echo "                \"${FRAMEWORKS[$i]}Wrapper\"${comma}" >> "$REPO_ROOT/Package.swift"
done

cat >> "$REPO_ROOT/Package.swift" << 'PACKAGE_EOF'
            ]
        )
    ],
    dependencies: [
PACKAGE_EOF

# Add dependencies
for i in "${!SPM_DEPS[@]}"; do
    dep="${SPM_DEPS[$i]}"
    IFS='|' read -r product_name package_id dep_url dep_req <<< "$dep"
    req_key="${dep_req%%:*}"
    req_val="${dep_req##*:}"
    comma=$([[ $i -lt $((${#SPM_DEPS[@]} - 1)) ]] && echo "," || echo "")
    cat >> "$REPO_ROOT/Package.swift" << PACKAGE_EOF
        .package(url: "$dep_url", $req_key: "$req_val")${comma}
PACKAGE_EOF
done

cat >> "$REPO_ROOT/Package.swift" << 'PACKAGE_EOF'
    ],
    targets: [
PACKAGE_EOF

# --- Binary targets ---
for i in "${!FRAMEWORKS[@]}"; do
    framework="${FRAMEWORKS[$i]}"
    
    cat >> "$REPO_ROOT/Package.swift" << PACKAGE_EOF
        .binaryTarget(
            name: "$framework",
            url: "https://github.com/$GITHUB_REPO/releases/download/$VERSION/$framework.xcframework.zip",
            checksum: "${CHECKSUMS[$framework]}"
        ),
PACKAGE_EOF
done

# --- Wrapper targets ---
for i in "${!FRAMEWORKS[@]}"; do
    framework="${FRAMEWORKS[$i]}"
    
    # Build dependencies array for wrapper (binary target + SPM products)
    deps_array=("$framework")
    for spm_product in "${SPM_PRODUCTS[@]}"; do
        deps_array+=("$spm_product")
    done
    
    # Determine if comma needed after this target
    needs_comma=$([[ $i -lt $((${#FRAMEWORKS[@]} - 1)) ]] && echo "," || echo "")

    cat >> "$REPO_ROOT/Package.swift" << PACKAGE_EOF
        .target(
            name: "${framework}Wrapper",
            dependencies: [
                "$framework",
PACKAGE_EOF

    # Add SPM dependencies to wrapper
    for j in "${!SPM_DEPS[@]}"; do
        dep="${SPM_DEPS[$j]}"
        IFS='|' read -r product_name package_id _ _ <<< "$dep"
        dep_comma=$([[ $j -lt $((${#SPM_DEPS[@]} - 1)) ]] && echo "," || echo "")
        cat >> "$REPO_ROOT/Package.swift" << PACKAGE_EOF
                .product(name: "$product_name", package: "$package_id")${dep_comma}
PACKAGE_EOF
    done

    cat >> "$REPO_ROOT/Package.swift" << PACKAGE_EOF
            ],
            path: "Sources/${framework}Wrapper"
        )${needs_comma}
PACKAGE_EOF
done

cat >> "$REPO_ROOT/Package.swift" << 'PACKAGE_EOF'
    ]
)
PACKAGE_EOF

echo ""
echo "📁 Creating wrapper directories and stub files..."
for framework in "${FRAMEWORKS[@]}"; do
    WRAPPER_DIR="$REPO_ROOT/Sources/${framework}Wrapper"
    mkdir -p "$WRAPPER_DIR"
    
    # Create an empty Swift file to make the target valid
    cat > "$WRAPPER_DIR/${framework}Wrapper.swift" << 'SWIFT_EOF'
// This is a wrapper target to enable SPM dependencies for binary framework
// The binary framework is linked via target dependencies
SWIFT_EOF
    
    echo "  - Created: Sources/${framework}Wrapper/"
done

echo ""
echo "✅ Package.swift generated successfully!"
echo ""
echo "📋 Summary:"
echo "  - Created ${#FRAMEWORKS[@]} ZIP archives in ./Archives/"
echo "  - Created ${#FRAMEWORKS[@]} wrapper targets in ./Sources/"
echo "  - Updated Package.swift with remote URLs and wrapper targets"
if [[ ${#SPM_DEPS[@]} -gt 0 ]]; then
    echo "  - Added ${#SPM_DEPS[@]} SPM dependencies to all wrappers"
fi
echo ""
echo "💡 Users can now import: import TuyaSmartActivatorKit"
echo ""
echo "🎯 Next steps:"
echo "  1. Create a GitHub Release with tag '$VERSION'"
echo "  2. Upload all files from ./Archives/ as release assets"
echo "  3. Run the following commands:"
echo ""
echo "     git add Package.swift Sources/"
echo "     git commit -m 'Use remote binary targets with wrapper pattern'"
echo "     git push"
echo "     git tag -d $VERSION"
echo "     git push origin :refs/tags/$VERSION"
echo "     git tag $VERSION"
echo "     git push origin $VERSION"
echo ""
echo "🌐 Release URL: https://github.com/$GITHUB_REPO/releases/new?tag=$VERSION"
