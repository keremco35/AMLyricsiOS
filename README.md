# AMLyrics - Advanced iOS Lyrics App

## Overview
AMLyrics is a high-performance, asset-heavy iOS application designed to sync lyrics with Apple Music.
It features Picture-in-Picture support, Dynamic Island integration, and a robust offline caching mechanism.

## 🏗️ Project Structure
- `Sources/App`: App entry point.
- `Sources/Core`: Logic for MusicKit, Lyrics fetching, Persistence, and Live Activities.
- `Sources/UI`: SwiftUI Views and ViewModels.
- `Resources`: Contains Fonts, Models, Videos, and Databases.
- `Scripts`: Helper scripts for asset management.

## 🚀 Setup

### Prerequisites
- macOS with Xcode 15+
- `brew install xcodegen`

### Installation
1.  **Hydrate Assets (Critical for Size Requirement)**
    The app relies on a large asset bundle (High-res fonts, ML models, Cache DB) to function and meet the 100MB+ target.
    Run the following script to generate/download these assets:
    ```bash
    chmod +x Scripts/setup_assets.sh
    ./Scripts/setup_assets.sh
    ```

2.  **Generate Xcode Project**
    ```bash
    xcodegen generate
    ```

3.  **Open & Run**
    Open `AMLyrics.xcodeproj` and run on a physical device (required for MusicKit).

## 🧩 Architecture
- **MVVM**: Used for UI separation.
- **Coordinator**: `MainCoordinatorView` manages navigation.
- **Singleton Managers**: `MusicManager`, `LyricsManager` for global state.

## 🤖 CI/CD & Release
The project includes a GitHub Actions workflow (`.github/workflows/ios-release.yml`) that:
1.  Installs dependencies.
2.  Hydrates the asset bundle.
3.  Builds an **Unsigned IPA**.
4.  **Verifies the IPA size is > 100MB**.
5.  Publishes a GitHub Release.

## 📦 Size Inflation Strategy
To ensure the app meets the ≥100MB requirement for the "Asset-Heavy" specification:
- **Offline Database**: Pre-seeded `OfflineLyrics.sqlite` (~40MB).
- **ML Models**: CoreML weights for timing alignment (~30MB).
- **Media**: 4K Background loops (~30MB).
- **Fonts**: Multiple variable font weights (~10MB).

## ⚠️ Note on Provisioning
For local testing, ensure you have a valid Apple Developer Team selected in the Xcode project settings after generation.
