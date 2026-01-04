import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/error_dialog.dart';
import 'home_screen.dart';

/// Login screen with Google Sign-In button
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  /// Handle Google Sign-In
  void _handleGoogleSignIn(BuildContext context) {
    context.read<AuthCubit>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.isAuthenticated) {
              // Navigate to home screen if authenticated
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else if (state.isSigningIn) {
              // Show snackbar when OAuth flow is initiated
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to Google Sign-In...'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state.hasError && state.errorMessage != null) {
              // Show error dialog
              showErrorDialog(context, state.errorMessage!);
              // Clear error after showing
              context.read<AuthCubit>().clearError();
            }
          },
          builder: (context, state) {
            final isLoading = state.isSigningIn || state.isLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo/icon
                    Icon(
                      Icons.lock_outline,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 32),
                    
                    // Welcome text
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Supabase Auth',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sign in with your Google account\nto get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Google Sign-In button
                    isLoading
                        ? const CircularProgressIndicator()
                        : _GoogleSignInButton(
                            onPressed: () => _handleGoogleSignIn(context),
                          ),
                    
                    const SizedBox(height: 24),
                    
                    // Info text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        'By signing in, you agree to our Terms of Service and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Custom Google Sign-In button widget
class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Container(
        padding: const EdgeInsets.all(4),
        child: const Icon(
          Icons.login,
          size: 20,
          color: Colors.blue,
        ),
      ),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black12),
        ),
        minimumSize: const Size(double.infinity, 56),
      ),
    );
  }
}
