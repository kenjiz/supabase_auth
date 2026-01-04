import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc to manage authentication state and events
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();
  StreamSubscription<AuthState>? _authStateSubscription;

  AuthBloc() : super(const AuthInitial()) {
    // Initialize auth state listener
    _initializeAuthListener();

    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthErrorCleared>(_onErrorCleared);
  }

  /// Initialize authentication state listener from Supabase
  void _initializeAuthListener() {
    _authStateSubscription = _authService.authStateChanges.listen(
      (authStateChange) {
        final user = authStateChange.session?.user;
        if (user != null) {
          add(AuthStateChanged(
            isAuthenticated: true,
            userId: user.id,
            email: user.email ?? '',
            displayName: user.userMetadata?['full_name'] as String?,
            photoUrl: user.userMetadata?['avatar_url'] as String?,
          ));
        } else {
          add(const AuthStateChanged(isAuthenticated: false));
        }
      },
    );
  }

  /// Handle authentication status check
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      if (_authService.isAuthenticated()) {
        final userProfile = _authService.currentUserProfile;
        if (userProfile != null) {
          emit(AuthAuthenticated(userProfile));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      emit(const AuthError(
        message: 'Failed to check authentication status',
        isAuthenticated: false,
      ));
    }
  }

  /// Handle authentication state changes from Supabase listener
  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.isAuthenticated && event.userId != null && event.email != null) {
      final user = UserProfile(
        id: event.userId!,
        email: event.email!,
        displayName: event.displayName,
        photoUrl: event.photoUrl,
      );
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle Google Sign-In request
  Future<void> _onSignInWithGoogleRequested(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSigningIn());

    try {
      final success = await _authService.signInWithGoogle();
      if (!success) {
        emit(const AuthError(
          message: 'Failed to initiate Google Sign-In',
          isAuthenticated: false,
        ));
      }
      // Note: The actual authentication state will be updated via the auth state listener
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      final errorMessage = _getErrorMessage(e);
      emit(AuthError(
        message: errorMessage,
        isAuthenticated: false,
      ));
    }
  }

  /// Handle sign-out request
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Get current user before signing out for loading state
    final currentUser = _authService.currentUserProfile;
    if (currentUser != null) {
      emit(AuthSigningOut(currentUser));
    }

    try {
      await _authService.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      debugPrint('Error signing out: $e');
      emit(AuthError(
        message: 'Failed to sign out. Please try again.',
        isAuthenticated: currentUser != null,
        user: currentUser,
      ));
    }
  }

  /// Handle error cleared
  void _onErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    // Check current authentication status
    if (_authService.isAuthenticated()) {
      final userProfile = _authService.currentUserProfile;
      if (userProfile != null) {
        emit(AuthAuthenticated(userProfile));
      } else {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
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
