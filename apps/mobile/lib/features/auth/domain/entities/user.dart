import 'user_role.dart';

class User {
  const User({
    required this.id,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String phone;
  final UserRole role;
  final DateTime createdAt;

  User copyWith({
    String? id,
    String? phone,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
