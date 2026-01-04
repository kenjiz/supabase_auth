# Quick Setup Guide for Supabase Auth Flutter App

This guide will walk you through setting up the authentication system from scratch.

## Step 1: Install Flutter Dependencies

After cloning the repository, install all dependencies:

```bash
cd supabase_auth
flutter pub get
```

## Step 2: Create Your Supabase Project

1. Visit [supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Fill in:
   - Project name: `supabase_auth` (or your preferred name)
   - Database password: (choose a strong password)
   - Region: (choose closest to your users)
4. Wait for the project to be created (~2 minutes)
5. Once ready, go to **Settings** → **API**
6. Copy these two values (you'll need them soon):
   - **Project URL** (e.g., `https://abcdefgh.supabase.co`)
   - **Project API keys** → **anon** / **public** key

## Step 3: Set Up Google OAuth in Google Cloud Console

### Create a Google Cloud Project

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Click the project dropdown at the top
3. Click "New Project"
4. Enter project name: `Supabase Auth Flutter`
5. Click "Create"

### Configure OAuth Consent Screen

1. In the left menu, go to **APIs & Services** → **OAuth consent screen**
2. Select "External" (unless you have a Google Workspace)
3. Click "Create"
4. Fill in:
   - App name: `Supabase Auth`
   - User support email: (your email)
   - Developer contact email: (your email)
5. Click "Save and Continue"
6. Skip "Scopes" (click "Save and Continue")
7. Add test users (your email) if in testing mode
8. Click "Save and Continue"

### Create OAuth Credentials - Web Application

1. Go to **APIs & Services** → **Credentials**
2. Click "Create Credentials" → "OAuth 2.0 Client ID"
3. Application type: **Web application**
4. Name: `Supabase Auth Web`
5. Authorized JavaScript origins:
   - `https://your-project.supabase.co` (replace with your Supabase URL)
6. Authorized redirect URIs:
   - `https://your-project.supabase.co/auth/v1/callback`
7. Click "Create"
8. **IMPORTANT**: Copy the Client ID and Client Secret (you'll need these next)

### Create OAuth Credentials - Android (Optional, for Android testing)

1. Click "Create Credentials" → "OAuth 2.0 Client ID" again
2. Application type: **Android**
3. Name: `Supabase Auth Android`
4. Package name: `com.example.supabase_auth`
5. Get your SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
6. Copy the SHA-1 fingerprint (line starting with SHA1:)
7. Paste it in "SHA-1 certificate fingerprint"
8. Click "Create"

### Create OAuth Credentials - iOS (Optional, for iOS testing)

1. Click "Create Credentials" → "OAuth 2.0 Client ID" again
2. Application type: **iOS**
3. Name: `Supabase Auth iOS`
4. Bundle ID: `com.example.supabaseAuth` (or your bundle ID)
5. Click "Create"

## Step 4: Connect Google OAuth to Supabase

1. Go back to your Supabase Dashboard
2. Click **Authentication** in the left menu
3. Click **Providers**
4. Find **Google** and toggle it on
5. Fill in:
   - **Client ID**: (paste the Web Client ID from Google Cloud Console)
   - **Client Secret**: (paste the Client Secret from Google Cloud Console)
6. Add redirect URL:
   - `com.example.supabase-auth://login-callback/`
7. Click "Save"

## Step 5: Create Your .env File

1. Copy the example file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` file:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-from-step-2
   ```

3. Replace the values with your actual Supabase URL and anon key from Step 2

**IMPORTANT**: Never commit the `.env` file to Git! It's already in `.gitignore`.

## Step 6: Run the App

### On Android

```bash
# Connect your Android device or start an emulator
flutter run
```

### On iOS

```bash
# Connect your iOS device or start a simulator
flutter run
```

### On Web (for testing)

```bash
flutter run -d chrome
```

## Step 7: Test the Authentication Flow

1. The app should launch and show a splash screen
2. You'll be redirected to the login screen
3. Click "Sign in with Google"
4. Your browser will open (or an in-app browser)
5. Select your Google account
6. Authorize the app
7. You'll be redirected back to the app
8. Your profile should appear on the home screen!

## Troubleshooting

### "SUPABASE_URL is not set in .env file"

- Make sure the `.env` file exists in the project root (not `.env.example`)
- Check that the variable names are correct (no typos)
- Make sure there are no spaces around the `=` sign
- Restart the app after creating/editing the `.env` file

### OAuth redirect doesn't work

**For Android:**
1. Verify the SHA-1 fingerprint is added to Google Cloud Console
2. Check that the package name matches: `com.example.supabase_auth`
3. Make sure the redirect URL in Supabase includes: `com.example.supabase-auth://login-callback/`

**For iOS:**
1. Verify the bundle ID matches in Info.plist and Google Cloud Console
2. Check that the URL scheme is correctly configured
3. Make sure the redirect URL in Supabase includes: `com.example.supabase-auth://login-callback/`

### "Failed to sign in with Google"

1. Check your internet connection
2. Verify the Supabase URL and anon key are correct
3. Make sure Google OAuth is enabled in Supabase
4. Check that the redirect URLs match in both Supabase and Google Cloud Console
5. Look at the console logs for more detailed error messages

### App crashes on launch

1. Run `flutter clean`
2. Run `flutter pub get`
3. Run the app again
4. Check the console output for error messages

## Next Steps

Once authentication is working:

1. **Customize the UI**: Edit the screen files in `lib/screens/`
2. **Add more features**: Create new screens and services
3. **Configure for production**:
   - Get a production SHA-1 certificate for Android
   - Set up proper iOS certificates and provisioning profiles
   - Update OAuth consent screen to production mode
   - Set up proper error tracking (e.g., Sentry)

## Security Checklist

- [x] `.env` file is in `.gitignore`
- [x] Environment variables are not hardcoded
- [x] Using HTTPS for all communication
- [ ] Enable Row Level Security in Supabase (for database access)
- [ ] Set up proper OAuth consent screen (verified)
- [ ] Use production OAuth credentials for release builds
- [ ] Enable 2FA on your Supabase and Google accounts

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [Google OAuth Setup Guide](https://support.google.com/cloud/answer/6158849)
- [Supabase Flutter Quick Start](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)

## Need Help?

- Check the main [README.md](README.md) for more details
- Look at the code comments in the source files
- Visit [Supabase Discord](https://discord.supabase.com)
- Check [Flutter Community](https://flutter.dev/community)

---

**Congratulations!** 🎉 You now have a fully working Flutter app with Google authentication!
