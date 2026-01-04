/// Model representing a user profile
class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  /// Create UserProfile from Supabase User data
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['user_metadata']?['full_name'] as String?,
      photoUrl: json['user_metadata']?['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, displayName: $displayName)';
  }
}
