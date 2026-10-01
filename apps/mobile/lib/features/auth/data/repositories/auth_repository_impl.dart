import '../../../../core/storage/local_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.remote, required this.storage});

  final AuthRemoteDatasource remote;
  final LocalStorage storage;

  @override
  Future<void> requestOtp(String phone) => remote.requestOtp(phone);

  @override
  Future<User> verifyOtp(String phone, String code, UserRole role) async {
    final result = await remote.verifyOtp(phone, code, role.value);
    await storage.saveAccessToken(result.token);
    await storage.saveRole(result.user.role);
    return result.user.toEntity();
  }

  @override
  Future<User> me() async {
    final model = await remote.me();
    return model.toEntity();
  }

  @override
  Future<void> signOut() async {
    await storage.clearAccessToken();
    await storage.removeRole();
  }
}
