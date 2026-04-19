# VelousCambo

VelousCambo is a Flutter-based bike sharing app for Phnom Penh, built with Firebase and Google Maps. It includes authentication, station discovery, bike booking, ride history, and profile management.

## Key Features

- Firebase user authentication: login, registration, and profile updates
- Google Maps integration with station markers and real-time bike availability
- Bike booking flow and active rental tracking
- Ride history screen with completed rentals
- Search screen for finding stations and bikes
- Responsive app theme and custom UI components

## Built With

- Flutter
- Firebase
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `firebase_storage`
- Google Maps (`google_maps_flutter`)
- Location services (`geolocator`)
- State management (`provider`)
- Image caching (`cached_network_image`)
- QR code rendering (`qr_flutter`)
- Animation support (`flutter_animate`)

## Project Structure

- `lib/main.dart` - app bootstrap and Firebase initialization
- `lib/app.dart` - route definitions and main app shell
- `lib/features/` - feature modules for auth, map, ride, history, profile, search, and splash screens
- `lib/data/services/firestore_service.dart` - Firestore integration and data seeding logic
- `lib/firebase_options.dart` - Firebase options loaded from build-time `--dart-define` values

## Setup

1. Install Flutter and ensure your environment is configured.
2. Create a `.env` file in the project root.
3. Add the required Firebase keys and values to `.env`.
4. Run:

```bash
flutter pub get
flutter run --dart-define-from-file=.env
```

For a specific target:

```bash
flutter run -d android --dart-define-from-file=.env
flutter run -d chrome  --dart-define-from-file=.env
```

> Linux desktop is not supported because Firebase is not fully compatible with Linux in this project.

## Required `.env` Keys

Create a `.env` file containing the following keys:

```env
FIREBASE_WEB_API_KEY=
FIREBASE_WEB_APP_ID=
FIREBASE_MESSAGING_SENDER_ID=
FIREBASE_PROJECT_ID=
FIREBASE_AUTH_DOMAIN=
FIREBASE_STORAGE_BUCKET=
FIREBASE_WEB_MEASUREMENT_ID=
FIREBASE_ANDROID_API_KEY=
FIREBASE_ANDROID_APP_ID=
FIREBASE_IOS_API_KEY=
FIREBASE_IOS_APP_ID=
FIREBASE_WINDOWS_APP_ID=
FIREBASE_WINDOWS_MEASUREMENT_ID=
```

## Notes

- The project includes an initial data seeding mechanism for bike stations and bikes inside `lib/data/services/firestore_service.dart`.
- Firebase is initialized at startup using values from `lib/firebase_options.dart`.
- If Firebase initialization fails, the app displays an error message with recommended run commands.

## Running the App

Use the same command shown in the project root:

```bash
flutter run --dart-define-from-file=.env
```

This README can be used for GitHub to describe the project, its dependencies, and how to run it locally.
