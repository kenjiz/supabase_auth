# Supabase Auth - Flutter Authentication App

A production-ready Flutter application demonstrating authentication with Supabase using Google Sign-In as the authentication method.

## Features

- ✅ **Google OAuth Sign-In**: Seamless authentication with Google accounts
- ✅ **Session Persistence**: Automatic session restoration on app restart
- ✅ **Clean Architecture**: Well-structured code with separation of concerns
- ✅ **State Management**: Provider-based state management for auth state
- ✅ **User Profile**: Display user information with profile picture
- ✅ **Error Handling**: Comprehensive error handling with user-friendly messages
- ✅ **Deep Linking**: OAuth callback handling with deep links
- ✅ **Cross-Platform**: Configured for both Android and iOS

## Prerequisites

Before you begin, ensure you have:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- A [Supabase](https://supabase.com) account and project
- A [Google Cloud Console](https://console.cloud.google.com) project with OAuth configured

## Project Structure

```
lib/
├── config/
│   └── app_config.dart          # Environment configuration
├── models/
│   └── user_profile.dart        # User profile model
├── providers/
│   └── auth_provider.dart       # Authentication state management
├── screens/
│   ├── splash_screen.dart       # Initial loading screen
│   ├── login_screen.dart        # Google Sign-In screen
│   └── home_screen.dart         # User profile/home screen
├── services/
│   └── auth_service.dart        # Authentication service layer
├── widgets/
│   └── error_dialog.dart        # Reusable dialog widgets
└── main.dart                    # App entry point
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/kenjiz/supabase_auth.git
cd supabase_auth
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Supabase Project Setup

1. Go to [Supabase](https://supabase.com) and create a new project
2. Once your project is created, go to **Project Settings** → **API**
3. Copy the following values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **Anon/Public Key**

### 4. Google OAuth Setup

#### Create OAuth Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select an existing one
3. Enable the **Google+ API**
4. Go to **APIs & Services** → **Credentials**
5. Click **Create Credentials** → **OAuth 2.0 Client ID**
6. Configure the OAuth consent screen if prompted
7. Create credentials for:
   - **Web application** (for Supabase)
   - **Android** (if testing on Android)
   - **iOS** (if testing on iOS)

#### Configure Supabase with Google OAuth

1. In your Supabase dashboard, go to **Authentication** → **Providers**
2. Enable **Google** provider
3. Add your Google OAuth Client ID and Client Secret (from Web application credentials)
4. Add authorized redirect URLs:
   - `https://your-project.supabase.co/auth/v1/callback`
   - `io.supabase.flutterquickstart://login-callback/`

### 5. Configure Environment Variables

1. Create a `.env` file in the project root:

```bash
cp .env.example .env
```

2. Edit `.env` and add your values:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key-here
GOOGLE_WEB_CLIENT_ID=your-google-web-client-id.apps.googleusercontent.com
```

**Important**: Never commit the `.env` file to version control. It's already in `.gitignore`.

### 6. Platform-Specific Configuration

#### Android Configuration

1. **Get SHA-1 Certificate Fingerprint** (for Google Sign-In):

```bash
# Debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release keystore (if you have one)
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
```

2. Add the SHA-1 fingerprint to your OAuth credentials in Google Cloud Console:
   - Go to **APIs & Services** → **Credentials**
   - Edit your Android OAuth client
   - Add the SHA-1 certificate fingerprint
   - Package name: `com.example.supabase_auth`

3. The `AndroidManifest.xml` is already configured with deep linking

#### iOS Configuration

1. The `Info.plist` is already configured with the URL scheme
2. For production, you'll need to:
   - Add your iOS OAuth Client ID to Google Cloud Console
   - Configure your iOS bundle identifier
   - Add URL scheme matching your configuration

### 7. Run the Application

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## How It Works

### Authentication Flow

1. **App Launch**: The app starts with a splash screen that checks authentication status
2. **Not Authenticated**: User is directed to the login screen with a Google Sign-In button
3. **Google Sign-In**: Clicking the button initiates OAuth flow through a web browser
4. **OAuth Callback**: After successful authentication, the app receives a deep link callback
5. **Session Created**: Supabase creates a session with the authenticated user
6. **Home Screen**: User is redirected to the home screen showing their profile
7. **Session Persistence**: On app restart, the session is automatically restored

### State Management

The app uses **Provider** for state management:

- `AuthProvider`: Manages authentication state, user profile, and loading states
- Listeners automatically update UI when authentication state changes
- Error handling provides user-friendly messages

### Deep Linking

Deep links are configured for OAuth callbacks:
- **Scheme**: `io.supabase.flutterquickstart`
- **Callback URL**: `io.supabase.flutterquickstart://login-callback/`

Both Android and iOS are configured to handle these deep links.

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `SUPABASE_URL` | Your Supabase project URL | `https://xxxxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Your Supabase anonymous/public key | `eyJhbGc...` |
| `GOOGLE_WEB_CLIENT_ID` | Google OAuth Web Client ID | `xxxxx.apps.googleusercontent.com` |

## Security Best Practices

✅ Environment variables are never committed to version control  
✅ Anon key is safe to use in client apps (row-level security protects data)  
✅ Sessions are securely stored using Flutter Secure Storage  
✅ HTTPS-only communication with Supabase  
✅ Proper token refresh handling  
✅ Error messages don't expose sensitive information

## Troubleshooting

### Common Issues

**"SUPABASE_URL is not set in .env file"**
- Ensure `.env` file exists in the project root
- Check that the file has the correct variable names
- Make sure the file is not named `.env.example`

**"OAuth flow doesn't redirect back to app"**
- Verify deep linking is configured correctly in Android/iOS
- Check that the callback URL matches in Supabase and your app configuration
- For Android, ensure SHA-1 fingerprint is added to Google Cloud Console

**"Network error"**
- Check internet connection
- Verify Supabase URL is correct and accessible
- Check if Supabase project is active

**"Invalid credentials"**
- Verify Supabase anon key is correct
- Check Google OAuth credentials are properly configured
- Ensure all redirect URLs are added to both Supabase and Google Cloud Console

### Debug Mode

To see detailed logs:

```bash
flutter run --verbose
```

## Testing

### Manual Testing Checklist

- [ ] App launches and shows splash screen
- [ ] Redirects to login screen if not authenticated
- [ ] Google Sign-In button is visible and clickable
- [ ] OAuth flow opens in browser
- [ ] After Google sign-in, app receives callback
- [ ] User profile is displayed on home screen
- [ ] Profile picture loads (if available)
- [ ] User information is correct (name, email)
- [ ] Sign-out button works
- [ ] After sign-out, returns to login screen
- [ ] Close and reopen app - session persists
- [ ] Home screen shows immediately on relaunch

## Dependencies

- **supabase_flutter**: Supabase client for Flutter
- **flutter_dotenv**: Environment variable management
- **google_sign_in**: Google Sign-In (for enhanced functionality)
- **provider**: State management solution

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter Guide](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
- [Google Sign-In Setup](https://developers.google.com/identity/sign-in/android/start-integrating)
- [Flutter Deep Linking](https://docs.flutter.dev/development/ui/navigation/deep-linking)

## License

This project is open-source and available for educational and commercial use.

## Support

For issues and questions:
- Create an issue on GitHub
- Check Supabase documentation
- Visit Flutter community forums

---

**Built with ❤️ using Flutter and Supabase**
