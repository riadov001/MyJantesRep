#!/bin/bash

# MyJantes Manager - Mobile Build Script
# This script builds APK and IPA files for the Flutter application

set -e

echo "🚀 MyJantes Manager - Mobile Build Script"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed. Please install Flutter first.${NC}"
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter doctor
echo -e "${YELLOW}🔍 Checking Flutter environment...${NC}"
flutter doctor

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get

# Function to build Android APK
build_android() {
    echo -e "${YELLOW}📱 Building Android APK...${NC}"
    
    # Check if Android toolchain is available
    if flutter doctor | grep -q "Android toolchain.*✓"; then
        echo -e "${GREEN}✅ Android toolchain found${NC}"
        
        # Build APK
        echo "Building release APK..."
        flutter build apk --release
        
        # Build split APKs for better performance
        echo "Building split APKs..."
        flutter build apk --split-per-abi --release
        
        # Build App Bundle for Play Store
        echo "Building App Bundle..."
        flutter build appbundle --release
        
        echo -e "${GREEN}✅ Android builds completed!${NC}"
        echo "📂 APK files location: build/app/outputs/flutter-apk/"
        echo "📂 AAB files location: build/app/outputs/bundle/release/"
        
        # List generated files
        echo -e "${YELLOW}Generated APK files:${NC}"
        ls -la build/app/outputs/flutter-apk/
        
    else
        echo -e "${RED}❌ Android toolchain not available${NC}"
        echo "Please install Android Studio and SDK"
        return 1
    fi
}

# Function to build iOS IPA
build_ios() {
    echo -e "${YELLOW}🍎 Building iOS IPA...${NC}"
    
    # Check if iOS toolchain is available (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if flutter doctor | grep -q "Xcode.*✓"; then
            echo -e "${GREEN}✅ iOS toolchain found${NC}"
            
            # Build iOS
            echo "Building iOS release..."
            flutter build ios --release
            
            # Build IPA if export options exist
            if [ -f "ios/ExportOptions.plist" ]; then
                echo "Building IPA with export options..."
                flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
            else
                echo "Building IPA with default options..."
                flutter build ipa --release
            fi
            
            echo -e "${GREEN}✅ iOS builds completed!${NC}"
            echo "📂 IPA files location: build/ios/ipa/"
            
            # List generated files
            echo -e "${YELLOW}Generated IPA files:${NC}"
            ls -la build/ios/ipa/ 2>/dev/null || echo "No IPA files found (manual Xcode archive may be required)"
            
        else
            echo -e "${RED}❌ Xcode not available or not properly configured${NC}"
            echo "Please install Xcode and run 'sudo xcode-select --install'"
            return 1
        fi
    else
        echo -e "${RED}❌ iOS builds require macOS${NC}"
        echo "Current OS: $OSTYPE"
        return 1
    fi
}

# Function to build web version
build_web() {
    echo -e "${YELLOW}🌐 Building Web version...${NC}"
    
    flutter build web --release
    
    echo -e "${GREEN}✅ Web build completed!${NC}"
    echo "📂 Web files location: build/web/"
    echo "🚀 You can serve with: python3 -m http.server 5000 --bind 0.0.0.0 --directory build/web"
}

# Main execution
echo -e "${YELLOW}Select build target:${NC}"
echo "1) Android APK"
echo "2) iOS IPA"
echo "3) Web"
echo "4) All platforms"
echo "5) Check requirements only"

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        build_android
        ;;
    2)
        build_ios
        ;;
    3)
        build_web
        ;;
    4)
        echo -e "${YELLOW}🔄 Building for all platforms...${NC}"
        build_web
        build_android
        build_ios
        ;;
    5)
        echo -e "${YELLOW}📋 Checking requirements only...${NC}"
        flutter doctor -v
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Build script completed!${NC}"
echo ""
echo -e "${YELLOW}📝 Build Summary:${NC}"
echo "- Project: MyJantes Manager"
echo "- Flutter Version: $(flutter --version | head -n 1)"
echo "- Build Date: $(date)"
echo ""
echo -e "${YELLOW}🚀 Next steps:${NC}"
echo "1. Test the generated files on physical devices"
echo "2. Sign the builds for distribution"
echo "3. Upload to app stores or distribute directly"