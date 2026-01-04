import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event when authentication state changes (from Supabase listener)
class AuthStateChanged extends AuthEvent {
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  const AuthStateChanged({
    required this.isAuthenticated,
    this.userId,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [isAuthenticated, userId, email, displayName, photoUrl];
}

/// Event to sign in with Google
class AuthSignInWithGoogleRequested extends AuthEvent {
  const AuthSignInWithGoogleRequested();
}

/// Event to sign out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Event to clear error message
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}
