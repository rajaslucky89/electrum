# Electrum Customer App

<img width="1080" height="2400" alt="Screenshot_1764138085" src="https://github.com/user-attachments/assets/b0f19bbf-e14e-4dff-afae-db179bd3140f" />

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK

### Steps
1. **Clone the repository** (if applicable)
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   - For Web:
     ```bash
     flutter run -d chrome
     ```
   - For Mobile (Android/iOS):
     ```bash
     flutter run
     ```

## Architecture Overview

The app follows a **Feature-First** architecture with **Riverpod** for state management and **GoRouter** for navigation.

- **`lib/src/features/`**: Contains feature-specific code (Auth, Home, Bikes). Each feature is split into:
  - `domain`: Entities and models.
  - `data`: Repositories and data sources.
  - `presentation`: Widgets, screens, and controllers.
- **`lib/src/core/`**: Shared utilities like Theme.
- **`lib/src/routing/`**: Navigation configuration.

### Key Decisions & Trade-offs
- **State Management**: Used **Riverpod** for its compile-time safety, easy testing, and separation of concerns. It allows for easy dependency injection of repositories.
- **Navigation**: Used **GoRouter** for declarative routing, which simplifies deep linking and auth redirection logic.
- **Data Persistence**: Used `shared_preferences` for a simple, lightweight persistence solution for the user session. For a real app, a secure storage solution would be preferred for sensitive tokens.
- **Mock Data**: Used mock repositories with hardcoded data to focus on UI/UX and architecture without needing a backend.
- **UI/UX**: Prioritized a clean, branded UI with consistent styling. Used standard Flutter widgets for simplicity and performance.

## What I'd do next with more time
- **Backend Integration**: Connect to a real backend (Firebase or REST API).
- **Testing**: Add unit tests for providers and repositories, and widget tests for critical flows.
- **Error Handling**: Implement more robust error handling and user feedback (e.g., toast messages, retry mechanisms).
- **Animations**: Add more micro-animations using `flutter_animate` to enhance delight.
- **Bike Filtering**: Add more advanced filters (price range, availability dates).
- **Map View**: Show bike locations on a map.

## AI Tools Usage
AI tools were used to:
- Suggest UI layouts and widget structures.
- Draft this README and the implementation plan.

