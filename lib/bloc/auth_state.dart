import 'package:equatable/equatable.dart';
import '../models/user_profile.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when checking authentication status
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  final UserProfile user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when an error occurs
class AuthError extends AuthState {
  final String message;
  final bool isAuthenticated;
  final UserProfile? user;

  const AuthError({
    required this.message,
    this.isAuthenticated = false,
    this.user,
  });

  @override
  List<Object?> get props => [message, isAuthenticated, user];
}

/// State when sign-in is in progress
class AuthSigningIn extends AuthState {
  const AuthSigningIn();
}

/// State when sign-out is in progress
class AuthSigningOut extends AuthState {
  final UserProfile user;

  const AuthSigningOut(this.user);

  @override
  List<Object?> get props => [user];
}
