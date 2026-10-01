import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../../../core/storage/local_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/request_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_state.dart';

export 'auth_state.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasource(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDatasourceProvider),
    storage: LocalStorage.instance,
  ),
);

final requestOtpProvider = Provider(
  (ref) => RequestOtp(ref.watch(authRepositoryProvider)),
);

final verifyOtpProvider = Provider(
  (ref) => VerifyOtp(ref.watch(authRepositoryProvider)),
);

final getCurrentUserProvider = Provider(
  (ref) => GetCurrentUser(ref.watch(authRepositoryProvider)),
);

class SessionNotifier extends StateNotifier<AuthState> {
  SessionNotifier(this._repository, this._getCurrentUser)
    : super(const AuthState(isRestoring: true)) {
    _restore();
  }

  final AuthRepository _repository;
  final GetCurrentUser _getCurrentUser;

  Future<void> _restore() async {
    final token = LocalStorage.instance.accessToken;
    if (token == null || token.isEmpty) {
      state = const AuthState();
      return;
    }
    try {
      final user = await _getCurrentUser();
      state = AuthState(user: user);
    } catch (_) {
      await _repository.signOut();
      state = const AuthState();
    }
  }

  Future<bool> requestOtp(String phone) async {
    state = state.copyWith(isRequestingOtp: true, clearFailure: true);
    try {
      await _repository.requestOtp(phone);
      state = state.copyWith(isRequestingOtp: false);
      return true;
    } on Failure catch (e) {
      state = state.copyWith(isRequestingOtp: false, failure: e);
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String code, UserRole role) async {
    state = state.copyWith(isVerifying: true, clearFailure: true);
    try {
      final user = await _repository.verifyOtp(phone, code, role);
      state = AuthState(user: user);
      return true;
    } on Failure catch (e) {
      state = state.copyWith(isVerifying: false, failure: e);
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState();
  }
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, AuthState>((ref) {
      return SessionNotifier(
        ref.watch(authRepositoryProvider),
        ref.watch(getCurrentUserProvider),
      );
    });
