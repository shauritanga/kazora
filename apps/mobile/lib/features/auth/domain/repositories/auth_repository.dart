import '../entities/user.dart';
import '../entities/user_role.dart';

abstract interface class AuthRepository {
  Future<void> requestOtp(String phone);

  Future<User> verifyOtp(String phone, String code, UserRole role);

  Future<User> me();

  Future<void> signOut();
}
