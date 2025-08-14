# MyJantes Manager - Build Instructions

## Overview
MyJantes Manager is a Flutter application for managing automotive tire and wheel renovation services. This document provides instructions for building APK and IPA files.

## Prerequisites

### For Android APK builds:
- Android Studio with Android SDK
- Flutter SDK (3.32.0 or later)
- Java Development Kit (JDK 8 or later)

### For iOS IPA builds:
- macOS with Xcode
- Flutter SDK (3.32.0 or later)
- iOS development certificates and provisioning profiles

## Building APK (Android)

### 1. Setup Android Development Environment
```bash
# Install Android Studio from: https://developer.android.com/studio
# Accept Android SDK licenses
flutter doctor --android-licenses
```

### 2. Configure Android Signing
Create `android/key.properties`:
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=<your-key-alias>
storeFile=<path-to-your-keystore>
```

### 3. Build APK
```bash
# Clean previous builds
flutter clean
flutter pub get

# Build release APK (single file)
flutter build apk --release

# Build APK split by architecture (recommended for Play Store)
flutter build apk --split-per-abi --release

# Build AAB (Android App Bundle) for Play Store
flutter build appbundle --release
```

### 4. Output Location
- APK files: `build/app/outputs/flutter-apk/`
- AAB files: `build/app/outputs/bundle/release/`

## Building IPA (iOS)

### 1. Setup iOS Development Environment
```bash
# Ensure Xcode is installed
xcode-select --install

# Install CocoaPods
sudo gem install cocoapods
```

### 2. Configure iOS Signing
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner project
3. Go to Signing & Capabilities
4. Select your development team
5. Configure Bundle Identifier

### 3. Build IPA
```bash
# Clean previous builds
flutter clean
flutter pub get

# Generate iOS build
flutter build ios --release

# Create IPA using Xcode
# Open ios/Runner.xcworkspace in Xcode
# Product > Archive
# Distribute App > Ad Hoc/App Store
```

### 4. Alternative IPA Build (Command Line)
```bash
# Build and create IPA
flutter build ipa --release

# Export IPA with specific export options
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

### 5. Output Location
- IPA files: `build/ios/ipa/`

## Environment Limitations

### Current Replit Environment
- ✅ Web builds work perfectly
- ❌ Android SDK not available for APK builds
- ❌ macOS/Xcode not available for iOS builds

### Web Deployment (Available Now)
The web version is currently running at port 5000 and can be deployed using Replit's deployment system.

## App Configuration

### Android Configuration
- **Package Name**: com.myjantes.manager
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Permissions**: Internet, Camera, Storage

### iOS Configuration
- **Bundle ID**: com.myjantes.manager
- **Min iOS**: 12.0
- **Target iOS**: 17.0
- **Capabilities**: Camera, Photo Library

## Features Included
- ✅ User authentication system
- ✅ Service catalog with 6 renovation services
- ✅ Booking and quote request system
- ✅ User profile management
- ✅ WordPress REST API integration
- ✅ Professional black/red theme
- ✅ Responsive design for mobile devices

## Testing
```bash
# Run on connected device
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Troubleshooting

### Common Android Issues
- **SDK not found**: Run `flutter doctor` and follow setup instructions
- **Build tools missing**: Update Android SDK in Android Studio
- **Signing issues**: Verify key.properties and keystore files

### Common iOS Issues
- **Xcode not found**: Install Xcode from Mac App Store
- **Provisioning profile**: Ensure valid developer account and certificates
- **CocoaPods issues**: Run `cd ios && pod install`

## Next Steps
1. Download this project to your local machine
2. Install Flutter SDK and platform-specific tools
3. Follow the build instructions above
4. Test on physical devices before release

For any issues, ensure `flutter doctor` shows all green checkmarks for your target platform.