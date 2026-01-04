# Architecture & Code Structure

This document explains the architecture and code organization of the Supabase Auth Flutter app.

## Architecture Overview

The app follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────┐
│              Presentation Layer             │
│  (Screens, Widgets, UI Components)          │
└─────────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────────┐
│            State Management Layer           │
│          (Bloc, Events, States)             │
└─────────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────────┐
│             Business Logic Layer            │
│            (Services, Repositories)         │
└─────────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────────┐
│               Data Layer                    │
│        (Supabase Client, API Calls)         │
└─────────────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── config/              # Configuration and environment setup
│   └── app_config.dart  # Environment variables management
│
├── models/              # Data models
│   └── user_profile.dart # User profile model
│
├── bloc/                # State management (BLoC pattern)
│   ├── auth_bloc.dart   # Authentication bloc
│   ├── auth_event.dart  # Authentication events
│   └── auth_state.dart  # Authentication states
│
├── services/            # Business logic and API services
│   └── auth_service.dart  # Authentication service
│
├── screens/             # UI screens
│   ├── splash_screen.dart  # Initial loading screen
│   ├── login_screen.dart   # Google sign-in screen
│   └── home_screen.dart    # User profile/dashboard
│
├── widgets/             # Reusable UI components
│   └── error_dialog.dart   # Error/success dialogs
│
└── main.dart            # App entry point
```

## Layer Breakdown

### 1. Configuration Layer (`config/`)

**Purpose**: Centralize app configuration and environment variables.

**Key Files**:
- `app_config.dart`: Manages environment variables from `.env` file

**Key Features**:
- Environment variable validation
- Configuration constants (redirect URLs, etc.)
- Type-safe access to configuration values

### 2. Models Layer (`models/`)

**Purpose**: Define data structures used throughout the app.

**Key Files**:
- `user_profile.dart`: User profile data model

**Key Features**:
- Immutable data classes
- JSON serialization/deserialization
- Type-safe data structures

```dart
class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
}
```

### 3. Services Layer (`services/`)

**Purpose**: Handle business logic and external API interactions.

**Key Files**:
- `auth_service.dart`: Authentication operations

**Key Responsibilities**:
- Sign in with Google OAuth
- Sign out
- Session management
- User state queries
- Error handling

**Key Methods**:
```dart
Future<bool> signInWithGoogle()
Future<void> signOut()
bool isAuthenticated()
UserProfile? get currentUserProfile
```

### 4. Bloc Layer (`bloc/`)

**Purpose**: Manage app state and provide reactive updates to UI using the BLoC pattern.

**Key Files**:
- `auth_bloc.dart`: Authentication bloc (business logic component)
- `auth_event.dart`: Authentication events
- `auth_state.dart`: Authentication states

**Key Features**:
- Uses `Bloc` from flutter_bloc package
- Manages loading states
- Handles errors
- Provides authentication status
- Listens to Supabase auth state changes

**Events**:
```dart
AuthCheckRequested       // Check current auth status
AuthStateChanged         // Auth state changed from Supabase
AuthSignInWithGoogleRequested  // Initiate Google sign-in
AuthSignOutRequested     // Sign out user
AuthErrorCleared         // Clear error state
```

**States**:
```dart
AuthInitial              // Initial state
AuthLoading              // Checking auth status
AuthAuthenticated(user)  // User is authenticated
AuthUnauthenticated      // User is not authenticated
AuthSigningIn            // Sign-in in progress
AuthSigningOut(user)     // Sign-out in progress
AuthError(message)       // Error occurred
```

### 5. Screens Layer (`screens/`)

**Purpose**: Define the user interface and handle user interactions.

#### Splash Screen (`splash_screen.dart`)
- **Purpose**: Initial loading screen
- **Responsibilities**:
  - Check authentication status on app start
  - Navigate to login or home based on auth state
  - Display loading indicator

#### Login Screen (`login_screen.dart`)
- **Purpose**: User authentication
- **Responsibilities**:
  - Display Google Sign-In button
  - Handle OAuth flow initiation
  - Show loading states
  - Display error messages
  - Auto-navigate on successful authentication

#### Home Screen (`home_screen.dart`)
- **Purpose**: Display user profile and provide sign-out
- **Responsibilities**:
  - Show user information (name, email, photo)
  - Display profile avatar
  - Handle sign-out with confirmation
  - Show loading states during operations

### 6. Widgets Layer (`widgets/`)

**Purpose**: Reusable UI components used across multiple screens.

**Key Files**:
- `error_dialog.dart`: Dialog utilities

**Available Dialogs**:
- `showErrorDialog()`: Display error messages
- `showSuccessDialog()`: Display success messages
- `showLoadingDialog()`: Display loading indicator

## Data Flow

### Authentication Flow

```
1. User opens app
   → SplashScreen checks auth status
   
2. Not authenticated
   → Navigate to LoginScreen
   → User clicks "Sign in with Google"
   → AuthBloc receives AuthSignInWithGoogleRequested event
   → AuthService.signInWithGoogle()
   → Supabase OAuth flow initiated
   → Browser/WebView opens
   
3. User authenticates in browser
   → Google OAuth completes
   → Deep link callback to app
   → Supabase creates session
   → AuthBloc listens to auth state change
   → Emits AuthAuthenticated state with user
   → LoginScreen auto-navigates to HomeScreen
   
4. Authenticated
   → HomeScreen displays user profile
   → Session persists in secure storage
   
5. App restart
   → SplashScreen checks auth status
   → Session exists
   → Navigate directly to HomeScreen
```

### State Management Flow

```
UI Event (e.g., button press)
    ↓
Bloc event dispatched
    ↓
Bloc handler processes event
    ↓
Update state (emit new state)
    ↓
Service calls Supabase API
    ↓
Handle response/error
    ↓
Emit final state
    ↓
BlocBuilder/BlocListener receives state
    ↓
UI rebuilds automatically
```

## Key Design Decisions

### 1. flutter_bloc for State Management

**Why**: 
- Predictable state management
- Clear separation of business logic and UI
- Testable and scalable
- Industry standard for Flutter apps
- Reactive state updates

**Alternative**: Could use Provider, Riverpod for simpler apps

### 2. Supabase for Backend

**Why**:
- Complete authentication solution
- Built-in OAuth providers
- Session management handled
- Secure by default
- Easy to set up and use

### 3. Deep Linking for OAuth

**Why**:
- Standard OAuth flow
- Seamless user experience
- Works across platforms
- Secure callback handling

### 4. Environment Variables

**Why**:
- Security (no hardcoded secrets)
- Easy to configure different environments
- Standard practice
- Can't accidentally commit secrets

## Security Considerations

### Authentication
- OAuth tokens handled by Supabase
- Session stored securely (Flutter Secure Storage)
- Automatic token refresh
- HTTPS-only communication

### Configuration
- Sensitive data in `.env` (not committed)
- Environment validation on startup
- Anon key is safe for client use (protected by RLS)

### Error Handling
- User-friendly error messages
- No sensitive information exposed
- Proper error logging (for debugging)
- Graceful fallbacks

## Extension Points

Want to add features? Here's where to start:

### Add New Authentication Provider
1. Add method in `AuthService`
2. Add event in `AuthEvent`
3. Add handler in `AuthBloc`
4. Add UI button in `LoginScreen`

### Add User Data Storage
1. Create new model in `models/`
2. Create new service in `services/`
3. Add events and states in bloc
4. Update screens to display data

### Add New Screen
1. Create screen file in `screens/`
2. Add navigation logic
3. Use BlocBuilder/BlocConsumer as needed
4. Add to navigation flow

### Add Database Operations
1. Create repository in `services/`
2. Add methods for CRUD operations
3. Add events and states in blocs
4. Update UI to reflect data

## Testing Strategy

### Unit Tests
- Test models (serialization/deserialization)
- Test service methods (mock Supabase)
- Test bloc events and state transitions

### Widget Tests
- Test individual screens
- Test navigation flows
- Test error states
- Test loading states

### Integration Tests
- Test complete auth flow
- Test session persistence
- Test error scenarios

## Performance Considerations

- **Lazy Loading**: Blocs only created when needed
- **Efficient Rebuilds**: Only affected widgets rebuild with BlocBuilder
- **Session Persistence**: Reduce auth checks with secure storage
- **Image Caching**: Network images cached automatically

## Best Practices Implemented

✅ Separation of concerns  
✅ Single responsibility principle  
✅ DRY (Don't Repeat Yourself)  
✅ Type safety with null safety  
✅ Proper error handling  
✅ User-friendly error messages  
✅ Loading states for async operations  
✅ Consistent code style  
✅ Comprehensive documentation  
✅ Environment-based configuration  

## Future Improvements

Possible enhancements:
- [ ] Add more OAuth providers (GitHub, Apple)
- [ ] Implement email/password authentication
- [ ] Add user profile editing
- [ ] Add profile picture upload
- [ ] Implement password reset flow
- [ ] Add biometric authentication
- [ ] Add offline support
- [ ] Add analytics
- [ ] Add crash reporting
- [ ] Add unit tests
- [ ] Add widget tests
- [ ] Add integration tests

---

This architecture provides a solid foundation for building a production-ready authentication system while remaining flexible for future enhancements.
