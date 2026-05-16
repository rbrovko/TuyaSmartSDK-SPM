#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORKS_DIR="$SCRIPT_DIR/../Frameworks"

echo "🔍 Verifying XCFrameworks..."
echo ""

find "$FRAMEWORKS_DIR" -name "*.xcframework" | while read xcframework; do
  xcf_name=$(basename "$xcframework")
  echo "📦 $xcf_name"
  
  find "$xcframework" -name "*.framework" | while read framework; do
    framework_name=$(basename "$framework" .framework)
    binary="$framework/$framework_name"
    
    if [ -f "$binary" ]; then
      # Get parent directory name for context
      parent=$(basename $(dirname "$framework"))
      
      # Check architectures
      archs=$(lipo -info "$binary" 2>/dev/null | sed 's/.*: //')
      
      # Check platform
      platform="unknown"
      if echo "$parent" | grep -q "simulator"; then
        platform="simulator"
      elif echo "$parent" | grep -q "ios-arm"; then
        platform="device"
      fi
      
      echo "   ├─ $platform: $archs"
      
      # Verify arm64 simulator specifically
      if [ "$platform" = "simulator" ]; then
        if echo "$archs" | grep -q "arm64"; then
          echo "   │  ✅ arm64 simulator supported"
        else
          echo "   │  ❌ arm64 simulator MISSING"
        fi
      fi
    fi
  done
  echo ""
done

echo "✅ Verification complete"
