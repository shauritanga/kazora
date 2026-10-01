import '../entities/user.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  Future<User> call(String phone, String code, UserRole role) {
    return _repository.verifyOtp(phone, code, role);
  }
}
