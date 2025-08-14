# MyJantes Manager

## Overview

MyJantes Manager is a Flutter mobile application designed for managing automotive tire and wheel data. The app provides a cross-platform solution for iOS and Android with image handling capabilities, secure data storage, and network-based operations. The application follows Flutter's standard architecture patterns with state management through Provider and includes features for image picking, caching, and secure credential storage.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Framework**: Flutter with Dart programming language
- **State Management**: Provider pattern for reactive state management across the application
- **Navigation**: GoRouter for declarative, type-safe navigation with deep linking support
- **UI Components**: Material Design components with Cupertino icons for iOS-style elements

### Data Management
- **Local Storage**: SharedPreferences for simple key-value storage of user preferences and app settings
- **Secure Storage**: FlutterSecureStorage for sensitive data like authentication tokens and credentials
- **Image Caching**: CachedNetworkImage for efficient network image loading and local caching
- **Internationalization**: Intl package for date formatting and localization support

### Network Layer
- **HTTP Client**: Dio for advanced HTTP operations with interceptors, request/response transformation, and error handling
- **Fallback HTTP**: Standard HTTP package as secondary networking option
- **Image Handling**: ImagePicker for capturing photos from camera or selecting from gallery

### Mobile Platform Integration
- **Cross-Platform**: Single codebase targeting both iOS and Android platforms
- **Native Features**: Integration with device camera, gallery, and secure storage capabilities
- **iOS Specific**: LLDB debugging helper for iOS development and debugging

## External Dependencies

### Core Flutter Dependencies
- **flutter**: Core Flutter framework
- **cupertino_icons**: iOS-style icons and UI elements

### Networking & Data
- **dio**: Advanced HTTP client for API communications
- **http**: Standard HTTP client for basic network requests
- **cached_network_image**: Network image loading with caching capabilities

### Storage Solutions
- **shared_preferences**: Local key-value storage for app preferences
- **flutter_secure_storage**: Encrypted storage for sensitive information

### UI & Navigation
- **provider**: State management solution for reactive UI updates
- **go_router**: Modern routing solution with type safety and deep linking
- **intl**: Internationalization and localization utilities

### Media Handling
- **image_picker**: Camera and gallery integration for image selection

### Development Tools
- **flutter_lints**: Code analysis and linting rules for code quality
- **flutter_test**: Testing framework for unit and widget testing