# GEO MAPID Explorer — Flutter Map Case Study

A Flutter mobile application built with **Clean Architecture** and **BLoC** pattern that consumes vector/GeoJSON map layers from GEO MAPID, renders them using **MapLibre GL** over **OpenFreeMap** basemap styles, supports interactive feature details popups, and captures real-time user GPS location.

---

## 🌟 Key Features

1. **OpenFreeMap Basemap**: Interactive MapLibre GL map loaded with `https://tiles.openfreemap.org/styles/liberty`.
2. **GEO MAPID Layer Integration**: Automatically fetches and renders GeoJSON vector layer features dynamically via Dio HTTP client.
3. **Interactive Feature Popups**: Tap on map point objects to view detail cards displaying attributes (e.g., Name, Address, District, Regency, Time).
4. **GPS User Location**: Live GPS position acquisition using `geolocator` and runtime permission management with smooth camera navigation.
5. **Robust Error Handling & States**: Visible Loading, Success, and Retry states managed via `flutter_bloc` and functional `Either<Failure, Success>` with `dartz`.
6. **Secure Environment Credentials**: API keys and endpoint parameters loaded securely via `flutter_dotenv` (excluded from VCS).

---

## 🏗️ Architecture Overview

The app strictly follows **Clean Architecture** principles separated into four decoupled layers:

```
lib/
├── main.dart                          # App Entrypoint & Provider Setup
├── injection_container.dart          # Dependency Injection (GetIt)
│
├── core/                              # Shared Core Assets & Utilities
│   ├── constants/                     # App, API, and Asset Constants
│   ├── error/                         # Failure & Exception Definitions
│   ├── network/                       # Dio Client & Interceptors
│   ├── theme/                         # Color Palette, Typography & Theme
│   ├── utils/                         # Logger & Permission Helpers
│   └── widgets/                       # Shared UI Components (Popups, Loaders, Error Views)
│
├── domain/                            # Enterprise / Business Logic
│   ├── entities/                      # Pure Business Entities
│   ├── repositories/                  # Repository Interfaces
│   └── usecases/                      # Feature UseCases (GetMapLayer, GetCurrentLocation)
│
├── data/                              # Data Access & Operations
│   ├── datasources/                   # Remote API & GPS Data Sources
│   ├── models/                        # GeoJSON & Location Data Models
│   └── repositories/                  # Repository Implementations
│
├── presentation/                      # UI Presentation & State Management
│   ├── bloc/                          # MapLayerBloc & UserLocationBloc
│   ├── pages/                         # MapPage Main Screen
│   └── widgets/                       # MapView & UserLocation Controls
│
└── services/                          # MapLibre Controller & Location Helpers
    ├── map_service.dart
    └── location_service.dart
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.24.3 or higher)
- Dart SDK (v3.5.3 or higher)
- Android SDK / Xcode for mobile emulation/device testing

### ⚙️ Setup Environment Variables

1. Copy `.env.example` to `.env` in the project root:

```bash
cp .env.example .env
```

2. Configure your credentials inside `.env`:

```env
MAPID_API_KEY=8a41b8d031864ba9ae82ccff447460f3
MAPID_LAYER_ID=6aaa479abf51a2f0185a601b
MAPID_PROJECT_ID=6aa3b36388f2c84b0c10cb58
MAP_BASEMAP_URL=https://tiles.openfreemap.org/styles/liberty
MAPID_BASE_URL=https://geoserver.mapid.io
```

> **Note**: `.env` is listed in `.gitignore` to prevent committing sensitive keys.

---

## 🧪 Running Unit Tests

To run the test suite (covering UseCases and BLoCs):

```bash
flutter test
```

---

## 📦 Building APK

To generate a debug APK:

```bash
flutter build apk --debug
```

The compiled APK will be available at:
`build/app/outputs/flutter-apk/app-debug.apk`

---

## 📜 License

Created for MAPID Mobile Developer Case Study Assessment.
