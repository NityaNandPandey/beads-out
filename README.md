# Beads Out

A casual puzzle game built with Flutter where players tap blocks to release colored beads onto a conveyor belt and sort them into matching containers before the conveyor overflows.

**Package:** `com.qmet.beadsout`

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (latest stable) |
| State | Riverpod |
| Routing | Go Router |
| Game Engine | Flame |
| Backend | Firebase (Auth, Firestore, Analytics, Remote Config, Crashlytics) |
| Ads | Google Mobile Ads |
| Local Storage | Shared Preferences + Hive |

## Project Structure

```
lib/
├── app/              # App shell, theme, routes, DI
├── core/             # Constants, enums, extensions, logger
├── models/           # Data models
├── repositories/     # Data access layer
├── services/         # Platform & third-party services
├── game_engine/      # Core gameplay logic
├── features/         # Feature screens (splash, home, gameplay, etc.)
└── shared/           # Reusable widgets & components
```

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on device/simulator
flutter run
```

### Firebase Setup

1. Create a Firebase project and register apps with package/bundle ID **`com.qmet.beadsout`**
2. Generate config files:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=beads-out-qmet
```

This writes `lib/firebase_options.dart`, `android/app/google-services.json`, and `ios/Runner/GoogleService-Info.plist`.

3. Firestore collections used by the app:

```
users/{uid}/data/profile
users/{uid}/data/progress
users/{uid}/data/settings
users/{uid}/data/statistics
users/{uid}/data/achievements
levels/level_001, level_002, ...
daily_challenges/
leaderboard/
```

The app signs in anonymously on launch, merges cloud progress with local saves, and syncs after level completion.

## Gameplay Flow

```
Tap Block → Break Animation → Spawn Beads → Particle Physics
    → Move to Conveyor → Collision Detection → Color Matching
    → Container Fill → Score Calculation → Combo Bonus → Level Complete
```

## Development Roadmap

| Phase | Scope |
|-------|-------|
| **1** ✅ | Project setup, architecture, routing, theme |
| **2** | Core gameplay engine (conveyor, beads, sorting, scoring) |
| **3** | Level system, progression, rewards, save/load |
| **4** | Daily challenges, achievements, analytics, ads |
| **5** | Polish: animations, sound, haptics, release |

## License

Private — All rights reserved.
