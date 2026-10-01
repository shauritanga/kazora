import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';

@immutable
class AuthState {
  const AuthState({
    this.user,
    this.isRestoring = false,
    this.isRequestingOtp = false,
    this.isVerifying = false,
    this.failure,
  });

  final User? user;
  final bool isRestoring;
  final bool isRequestingOtp;
  final bool isVerifying;
  final Failure? failure;

  bool get isSignedIn => user != null;

  AuthState copyWith({
    User? user,
    bool? isRestoring,
    bool? isRequestingOtp,
    bool? isVerifying,
    Failure? failure,
    bool clearUser = false,
    bool clearFailure = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isRestoring: isRestoring ?? this.isRestoring,
      isRequestingOtp: isRequestingOtp ?? this.isRequestingOtp,
      isVerifying: isVerifying ?? this.isVerifying,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}
