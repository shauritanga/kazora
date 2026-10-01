import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  const AuthRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<void> requestOtp(String phone) {
    return _apiClient.post('/auth/otp/request', body: {'phone': phone});
  }

  Future<({String token, UserModel user})> verifyOtp(
    String phone,
    String code,
    String role,
  ) async {
    final data = await _apiClient.post(
      '/auth/otp/verify',
      body: {'phone': phone, 'code': code, 'role': role},
    ) as Map<String, dynamic>;
    return (
      token: data['accessToken'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  Future<UserModel> me() async {
    final data = await _apiClient.get('/auth/me') as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }
}
