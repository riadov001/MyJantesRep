# MyJantes Manager - Cloud Build Setup Guide

## Overview
Since you don't have Mac or laptop access, here are the best cloud services to build APK and IPA files for your Flutter app completely online.

## ⭐ RECOMMENDED: Codemagic (Best for Flutter)

### Why Codemagic?
- **Built specifically for Flutter projects**
- **Build iOS apps without Mac hardware**
- **Automatic project detection**
- **Free tier with generous limits**
- **5-minute setup time**

### Setup Steps:
1. **Sign Up**: Visit [codemagic.io](https://codemagic.io)
2. **Connect Repository**: 
   - Connect your GitHub account
   - Select MyJantes Manager repository
3. **Auto-Configuration**: Codemagic automatically detects Flutter project
4. **Build Settings**:
   ```yaml
   # Builds both APK and IPA automatically
   - Android APK (release)
   - Android App Bundle (for Play Store)
   - iOS IPA (requires Apple Developer account for signing)
   ```

### Pricing:
- **Free**: 500 build minutes/month
- **Paid**: $0.095/build minute for unlimited builds

### Build Commands (Auto-configured):
```bash
flutter build apk --release
flutter build appbundle --release
flutter build ipa --release
```

## 🚀 Alternative Option: GitHub Actions (Free)

### Setup for GitHub Actions:
1. **Push to GitHub**: Upload your project to GitHub
2. **Create Workflow File**: `.github/workflows/flutter_build.yml`
3. **Automatic Builds**: Triggered on every push

### GitHub Actions Workflow:
```yaml
name: Flutter CI/CD
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build_android:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '12.x'
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.32.0'
    - run: flutter pub get
    - run: flutter build apk --release
    - run: flutter build appbundle --release
    - uses: actions/upload-artifact@v3
      with:
        name: android-builds
        path: |
          build/app/outputs/flutter-apk/
          build/app/outputs/bundle/

  build_ios:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.32.0'
    - run: flutter pub get
    - run: flutter build ios --release --no-codesign
    - uses: actions/upload-artifact@v3
      with:
        name: ios-build
        path: build/ios/iphoneos/
```

### Pricing:
- **Free**: 2000 minutes/month for private repos
- **Unlimited**: For public repositories

## 🔧 Option 3: Bitrise (Enterprise-Grade)

### Features:
- **350+ integrations**
- **Automatic Flutter detection**
- **Visual workflow builder**
- **Advanced testing capabilities**

### Setup:
1. Sign up at [bitrise.io](https://bitrise.io)
2. Add your repository
3. Select Flutter project template
4. Configure build steps automatically

## 📱 Option 4: Appcircle (No-Mac iOS Builds)

### Specialization:
- **Build iOS without Mac hardware**
- **Enterprise app distribution**
- **Flutter-specific templates**

### Setup:
1. Register at [appcircle.io](https://appcircle.io)
2. Connect your Git repository
3. Select Flutter build profile
4. Configure iOS signing (Apple Developer account required)

## 🔑 Required for iOS Builds (Any Service)

### Apple Developer Account Setup:
1. **Enroll**: Sign up for Apple Developer Program ($99/year)
2. **Certificates**: Create iOS distribution certificate
3. **Provisioning**: Create App Store/Ad Hoc provisioning profiles
4. **App ID**: Register com.myjantes.manager bundle ID

### Export P12 Certificate:
```bash
# You'll need to export these from Keychain Access:
- iOS Distribution Certificate (.p12)
- iOS Distribution Private Key (.p12)
- Provisioning Profile (.mobileprovision)
```

## 🚀 Quick Start Recommendations

### For Immediate APK Build (Android Only):
1. **Use GitHub Actions** (free, fastest setup)
2. Push your code to GitHub
3. Download APK from Actions artifacts in ~10 minutes

### For Complete APK + IPA Solution:
1. **Use Codemagic** (easiest Flutter-specific setup)
2. Get Apple Developer account for iOS signing
3. Build both platforms simultaneously

### For Budget-Conscious Approach:
1. **Start with free tier of any service**
2. **GitHub Actions**: Free forever for public repos
3. **Codemagic**: 500 free minutes/month
4. **Upgrade only when you need more builds**

## 📦 Build Output Locations

### Android (APK):
```
build/app/outputs/flutter-apk/
├── app-armeabi-v7a-release.apk
├── app-arm64-v8a-release.apk
└── app-x86_64-release.apk
```

### Android (App Bundle for Play Store):
```
build/app/outputs/bundle/release/
└── app-release.aab
```

### iOS (IPA):
```
build/ios/ipa/
└── MyJantes Manager.ipa
```

## 🔧 Next Steps

1. **Choose a service** (I recommend starting with Codemagic)
2. **Sign up and connect your repository**
3. **For iOS**: Get Apple Developer account
4. **Trigger your first build**
5. **Download APK/IPA files**
6. **Test on physical devices**

Would you like me to help you set up any of these services step-by-step?