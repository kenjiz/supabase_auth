import 'package:equatable/equatable.dart';
import '../models/user_profile.dart';

/// Authentication status enum
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  signingIn,
  signingOut,
  error,
}

/// Single state class for authentication
class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfile? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  /// Initial state
  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null;

  /// Loading state
  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null;

  /// Authenticated state
  const AuthState.authenticated(UserProfile this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null;

  /// Unauthenticated state
  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        errorMessage = null;

  /// Signing in state
  const AuthState.signingIn()
      : status = AuthStatus.signingIn,
        user = null,
        errorMessage = null;

  /// Signing out state
  AuthState.signingOut(UserProfile this.user)
      : status = AuthStatus.signingOut,
        errorMessage = null;

  /// Error state
  const AuthState.error(String this.errorMessage, {this.user})
      : status = AuthStatus.error;

  /// Convenience getters
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isSigningIn => status == AuthStatus.signingIn;
  bool get isSigningOut => status == AuthStatus.signingOut;
  bool get hasError => status == AuthStatus.error;

  @override
  List<Object?> get props => [status, user, errorMessage];

  /// CopyWith method for creating new states
  AuthState copyWith({
    AuthStatus? status,
    UserProfile? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
