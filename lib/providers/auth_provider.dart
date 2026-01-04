import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

/// Provider class to manage authentication state across the app
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initializeAuthListener();
  }

  /// Initialize authentication state listener
  void _initializeAuthListener() {
    _authService.authStateChanges.listen((AuthState data) {
      final user = data.session?.user;
      if (user != null) {
        _currentUser = UserProfile(
          id: user.id,
          email: user.email ?? '',
          displayName: user.userMetadata?['full_name'] as String?,
          photoUrl: user.userMetadata?['avatar_url'] as String?,
        );
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  /// Check current authentication status
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_authService.isAuthenticated()) {
        _currentUser = _authService.currentUserProfile;
      } else {
        _currentUser = null;
      }
    } catch (e) {
      _errorMessage = 'Failed to check authentication status';
      debugPrint('Error checking auth status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.signInWithGoogle();
      return success;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      debugPrint('Error signing in with Google: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _errorMessage = 'Failed to sign out. Please try again.';
      debugPrint('Error signing out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }
    
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorString.contains('cancelled') || errorString.contains('canceled')) {
      return 'Sign-in was cancelled.';
    } else if (errorString.contains('invalid')) {
      return 'Invalid credentials. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
