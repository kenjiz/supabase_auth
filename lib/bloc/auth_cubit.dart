import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

/// Cubit to manage authentication state
class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService();
  StreamSubscription<AuthState>? _authStateSubscription;

  AuthCubit() : super(const AuthState.initial()) {
    // Initialize auth state listener
    _initializeAuthListener();
  }

  /// Initialize authentication state listener from Supabase
  void _initializeAuthListener() {
    _authStateSubscription = _authService.authStateChanges.listen(
      (authStateChange) {
        try {
          final user = authStateChange.session?.user;
          if (user != null) {
            final userProfile = UserProfile(
              id: user.id,
              email: user.email ?? '',
              displayName: user.userMetadata?['full_name'] as String?,
              photoUrl: user.userMetadata?['avatar_url'] as String?,
            );
            emit(AuthState.authenticated(userProfile));
          } else {
            emit(const AuthState.unauthenticated());
          }
        } catch (e) {
          debugPrint('Error in auth state listener: $e');
          // Don't emit if there's an error to prevent cascading issues
        }
      },
      onError: (error) {
        debugPrint('Auth state listener error: $error');
        emit(const AuthState.unauthenticated());
      },
    );
  }

  /// Check current authentication status
  Future<void> checkAuthStatus() async {
    emit(const AuthState.loading());

    try {
      if (_authService.isAuthenticated()) {
        final userProfile = _authService.currentUserProfile;
        if (userProfile != null) {
          emit(AuthState.authenticated(userProfile));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      emit(const AuthState.error('Failed to check authentication status'));
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(const AuthState.signingIn());

    try {
      final success = await _authService.signInWithGoogle();
      if (!success) {
        emit(const AuthState.error('Failed to initiate Google Sign-In'));
      }
      // Note: On successful OAuth initiation, the user will be redirected to Google.
      // After authentication, the Supabase auth state listener will automatically
      // detect the session change and emit authenticated state.
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      final errorMessage = _getErrorMessage(e);
      emit(AuthState.error(errorMessage));
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    final currentUser = _authService.currentUserProfile;
    if (currentUser != null) {
      emit(AuthState.signingOut(currentUser));
    }

    try {
      await _authService.signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      debugPrint('Error signing out: $e');
      emit(AuthState.error(
        'Failed to sign out. Please try again.',
        user: currentUser,
      ));
    }
  }

  /// Clear error and return to appropriate state
  void clearError() {
    if (_authService.isAuthenticated()) {
      final userProfile = _authService.currentUserProfile;
      if (userProfile != null) {
        emit(AuthState.authenticated(userProfile));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } else {
      emit(const AuthState.unauthenticated());
    }
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

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
