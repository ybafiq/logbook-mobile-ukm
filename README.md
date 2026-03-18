# Logbook UKM

A Flutter application for managing logbook entries, designed for UKM (Universiti Kebangsaan Malaysia) students and users to track daily activities, projects, and personal records.

## Features

- **User Authentication**: Secure login and registration system
- **Daily Logbook**: Record and manage daily activities and entries
- **Project Management**: Create and track project-related logbook entries
- **Profile Management**: User profile with personal information
- **PDF Export**: Generate PDF reports for logbook entries
- **Offline Support**: Local database storage using SQLite
- **Cross-Platform**: Runs on Android and iOS devices

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Android/iOS device or emulator

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   cd flutter_training
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

### Building for Production

#### Android APK
```
flutter build apk --release
```

#### iOS (on macOS)
```
flutter build ios --release
```

## Project Structure

- `lib/` - Main application code
  - `auth2/` - Authentication screens
  - `models/` - Data models
  - `screen/` - Main application screens
  - `services/` - Database and API services
  - `testing/` - Test utilities
- `android/` - Android-specific configuration
- `ios/` - iOS-specific configuration
- `test/` - Unit and widget tests

## Dependencies

Key packages used in this project:
- `sqflite` - SQLite database
- `shared_preferences` - Local storage
- `pdf` - PDF generation
- `image_picker` - Image selection
- `flutter_svg` - SVG support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
