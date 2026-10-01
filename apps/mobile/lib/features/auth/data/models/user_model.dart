import '../../domain/entities/user.dart';
import '../../domain/entities/user_role.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  final String id;
  final String phone;
  final String role;
  final DateTime createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String? ?? 'tenant',
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      phone: phone,
      role: UserRole.fromString(role),
      createdAt: createdAt,
    );
  }
}
