import '../repositories/auth_repository.dart';

class RequestOtp {
  const RequestOtp(this._repository);

  final AuthRepository _repository;

  Future<void> call(String phone) => _repository.requestOtp(phone);
}
