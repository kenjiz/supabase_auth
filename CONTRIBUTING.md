# Contributing to Supabase Auth Flutter

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Getting Started

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/supabase_auth.git
   cd supabase_auth
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

Follow the [SETUP_GUIDE.md](SETUP_GUIDE.md) to set up your development environment.

## Code Style

### Dart Style Guide

This project follows the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

- Use `flutter analyze` to check for linting issues
- Use `dart format .` to format your code

### Key Conventions

1. **File Naming**: Use `snake_case` for file names
   - ✅ `auth_provider.dart`
   - ❌ `AuthProvider.dart` or `auth-provider.dart`

2. **Class Naming**: Use `PascalCase` for class names
   - ✅ `class AuthProvider`
   - ❌ `class auth_provider`

3. **Variable Naming**: Use `camelCase` for variables
   - ✅ `final userName = 'John';`
   - ❌ `final user_name = 'John';`

4. **Private Members**: Prefix with underscore
   - ✅ `String _privateField;`
   - ✅ `void _privateMethod() {}`

5. **Comments**: Use `///` for documentation comments
   ```dart
   /// This is a documentation comment
   /// Use it for public APIs
   void publicMethod() {}
   
   // This is a regular comment
   // Use it for implementation details
   ```

## Project Structure

Follow the existing architecture:

```
lib/
├── config/      # Configuration files
├── models/      # Data models
├── providers/   # State management
├── screens/     # UI screens
├── services/    # Business logic
└── widgets/     # Reusable widgets
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture information.

## Making Changes

### Adding a New Feature

1. **Check existing issues** or create a new one to discuss the feature
2. **Create a new branch** from `main`
3. **Implement the feature** following the architecture
4. **Add documentation** if needed
5. **Test your changes** manually
6. **Commit your changes** with clear messages
7. **Push and create a pull request**

### Fixing a Bug

1. **Create an issue** describing the bug (if it doesn't exist)
2. **Create a new branch** from `main`
3. **Fix the bug** with minimal changes
4. **Test the fix** to ensure it works
5. **Add regression test** if possible
6. **Commit and create a pull request**

## Commit Messages

Write clear, descriptive commit messages:

### Format
```
type: Brief description (50 chars or less)

Detailed explanation if needed (wrap at 72 chars).
Include motivation for the change and how it differs
from previous behavior.

Fixes #123
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

Good:
```
feat: Add password reset functionality

Implements password reset flow using Supabase auth.
Users can now request a password reset email from
the login screen.

Fixes #42
```

Bad:
```
fixed stuff
```

## Pull Request Guidelines

### Before Submitting

- [ ] Code follows the style guide
- [ ] Code has been tested manually
- [ ] Documentation has been updated (if needed)
- [ ] Commit messages are clear and descriptive
- [ ] Branch is up to date with `main`

### PR Description Template

```markdown
## Description
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring
- [ ] Other (please describe)

## Testing
Describe how you tested your changes.

## Screenshots (if applicable)
Add screenshots for UI changes.

## Checklist
- [ ] Code follows style guide
- [ ] Self-reviewed the code
- [ ] Added/updated documentation
- [ ] Tested on Android
- [ ] Tested on iOS (if applicable)

## Related Issues
Fixes #(issue number)
```

## Code Review Process

1. **Submit PR**: Create a pull request with clear description
2. **Automated Checks**: Wait for CI checks (if configured)
3. **Review**: Maintainers will review your code
4. **Address Feedback**: Make requested changes
5. **Approval**: Once approved, PR will be merged

## Testing

### Manual Testing

Before submitting a PR, test your changes:

1. **Clean build**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Run on device/emulator**:
   ```bash
   flutter run
   ```

3. **Test all affected flows**:
   - Sign in
   - Sign out
   - Session persistence
   - Error handling

### Automated Testing (Future)

When tests are added:
```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Adding Dependencies

If you need to add a new dependency:

1. **Check if necessary**: Can the feature be implemented without it?
2. **Research alternatives**: Is this the best package for the job?
3. **Check maintenance**: Is the package actively maintained?
4. **Check size**: Will it significantly increase app size?
5. **Add to pubspec.yaml**: Include version constraint
6. **Document usage**: Update README if needed
7. **Mention in PR**: Explain why the dependency is needed

## Documentation

### Code Comments

- Document public APIs with `///`
- Explain complex logic with regular comments
- Keep comments up to date with code changes

### README Updates

Update README.md if you:
- Add new features
- Change setup process
- Modify configuration
- Add new dependencies

### Architecture Updates

Update ARCHITECTURE.md if you:
- Change project structure
- Modify data flow
- Add new layers/patterns
- Change design decisions

## Security

### Reporting Security Issues

**Do not create public issues for security vulnerabilities.**

Instead, email the maintainers with:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Security Best Practices

When contributing, ensure:
- No secrets in code
- No sensitive data in logs
- Proper input validation
- Secure data storage
- HTTPS-only communication

## Getting Help

- **Questions**: Create a discussion or issue
- **Bugs**: Create an issue with reproduction steps
- **Features**: Create an issue to discuss before implementing
- **Documentation**: Create an issue or PR with improvements

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in:
- GitHub contributors page
- Release notes (for significant contributions)

Thank you for contributing! 🎉
