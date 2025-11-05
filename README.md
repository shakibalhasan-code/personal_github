# Personal GitHub

A Flutter application for searching GitHub users and viewing their repositories with a clean architecture implementation.

## Architecture

The application follows Clean Architecture principles with five distinct layers:

### 1. Presentation Layer

Contains UI components and state management.

**Location:** `lib/presentation/`

**Components:**

- `screens/` - Full page screens (e.g., HomeScreen)
- `widgets/` - Reusable UI components (SearchResultsView, RepositoriesView, RepositoryCard)
- `controllers/` - GetX controllers for state management (HomeController)
- `bindings/` - Dependency injection bindings for screens

**State Management:**

- GetX observables for reactive state updates
- GetBuilder for conditional UI rebuilds based on view mode toggle
- Obx for automatic rebuilds when observable values change

### 2. Domain Layer

Contains business logic and abstract definitions.

**Location:** `lib/domain/`

**Components:**

- `entities/` - Core business objects (GitHubUser, GitHubRepository)
- `models/` - Domain models (GitHubUser, GitHubRepository)
- `repositories/` - Abstract repository interfaces
- `usecases/` - Business logic use cases (SearchGitHubUserUseCase, GetGitHubUserDetailsUseCase, GetGitHubUserRepositoriesUseCase)

**Use Cases:**

Each use case handles a specific business operation:

- SearchGitHubUserUseCase - Search users by username
- GetGitHubUserDetailsUseCase - Fetch full user details
- GetGitHubUserRepositoriesUseCase - Fetch user repositories

### 3. Data Layer

Handles data retrieval and transformation.

**Location:** `lib/data/`

**Components:**

- `datasources/` - API data sources (GitHubApiDataSource)
- `models/` - Data transfer objects with JSON serialization (GitHubUserModel, GitHubRepositoryModel)
- `repositories/` - Repository implementations

**Data Flow:**

- Models convert JSON responses from GitHub API to domain entities
- Repositories delegate to data sources and handle data transformation
- Manual JSON serialization without build_runner dependency

### 4. Core Layer

Infrastructure and utilities.

**Location:** `lib/core/`

**Components:**

- `constants/` - Application constants
- `errors/` - Exception handling and error definitions
- `network/` - Network configuration
- `services/` - Singleton services and utilities

### 5. Configuration Layer

Application setup and dependency injection.

**Location:** `lib/config/`

**Components:**

- `routes.dart` - Route definitions
- `service_locator.dart` - GetIt dependency injection setup
- `theme.dart` - Theme configuration (light and dark modes)

## Error Handling

The application implements comprehensive error handling across all layers:

### Exception Types

**Application Errors:**

- AppException - Base exception class
- ServerException - Server-side errors (HTTP errors, timeouts, network failures)
- CacheException - Local data storage errors

### Error Handling Flow

#### 1. Data Layer

API Response → Exception/Error Detection → Throw ServerException with message

- HTTP errors (4xx, 5xx) → ServerException
- Network timeouts → ServerException
- JSON parsing failures → ServerException

#### 2. Repository Layer

Use Case Call → Try-Catch → Map Exception → Return to Use Case

- Catches ServerException from data sources
- Logs error details
- Re-throws with context

#### 3. Domain Layer (Use Cases)

Repository Call → Try-Catch → Validate Input → Return Result

- Input validation (empty strings, null checks)
- Handles repository exceptions
- Returns Future result with error propagation

#### 4. Presentation Layer (Controller)

Use Case Call → Try-Catch → Update UI State → Show SnackBar

- Catches all exceptions from use cases
- Updates error message observable
- Displays user-friendly error messages via GetSnackbar

### Error Display

**User Feedback:**

- SnackBar notifications for errors
- Error messages displayed in UI
- Loading states show CircularProgressIndicator
- Empty states show appropriate messaging

### Example Error Flow

```dart
User searches "invalid" → 
HomeController.searchGitHubUser() → 
SearchGitHubUserUseCase() → 
GitHubRepository.searchUsers() → 
GitHubApiDataSource → 
HTTP 404 → 
ServerException("User not found") → 
Caught in Controller → 
Set errorMessage.value = "User not found" → 
Caught in Try-Catch → 
Show SnackBar("Error", "User not found")
```

## API Integration

Base URL: api.github.com

**Endpoints Used:**

- GET /search/users - Search users by username
- GET /users/{username} - Get full user details
- GET /users/{username}/repos - Get user repositories

**Two-Step Search Strategy:**

1. Initial search via /search/users for discovery
2. Fetch full user details via /users/{username} for complete data
3. Fetch repositories via /users/{username}/repos for repository information

## Dependencies

- dio: HTTP client with interceptors
- get: State management and service locator
- equatable: Value equality comparison
- get_it: Dependency injection container

## Project Structure

```txt
lib/
├── config/
│   ├── routes.dart
│   ├── service_locator.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── services/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── models/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bindings/
│   ├── controllers/
│   ├── screens/
│   └── widgets/
├── app.dart
└── main.dart
```

## Features

- Search GitHub users by username
- View user profile with statistics (followers, following, public repos)
- Display user repositories in list or grid view
- Repository information includes name, description, language, stars, and forks
- Repository timestamps showing created, updated, and pushed dates
- Responsive grid layout adapting to screen size
- Light and dark theme support
- Error handling with user-friendly messages
- Loading states for async operations
