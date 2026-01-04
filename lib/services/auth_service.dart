import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../config/app_config.dart';

/// Service class to handle all authentication operations with Supabase
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get the current authenticated user
  User? get currentUser => _supabase.auth.currentUser;

  /// Get the current session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Get auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Get current user profile
  UserProfile? get currentUserProfile {
    final user = currentUser;
    if (user == null) return null;
    
    return UserProfile(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['full_name'] as String?,
      photoUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  /// Sign in with Google OAuth
  /// This method initiates the OAuth flow with Google
  Future<bool> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: AppConfig.redirectUrl,
      );
      
      return response;
    } catch (e) {
      throw AuthException('Failed to sign in with Google: $e');
    }
  }

  /// Sign out the current user
  /// Clears the session and user data
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Failed to sign out: $e');
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return currentSession != null && currentUser != null;
  }

  /// Refresh the current session
  Future<void> refreshSession() async {
    try {
      await _supabase.auth.refreshSession();
    } catch (e) {
      throw AuthException('Failed to refresh session: $e');
    }
  }
}

/// Custom exception class for authentication errors
class AuthException implements Exception {
  final String message;
  
  AuthException(this.message);
  
  @override
  String toString() => message;
}
