sealed class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please try again.',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class AuthorizationFailure extends Failure {
  const AuthorizationFailure([
    super.message = 'Your session has expired. Please sign in again.',
  ]);
}

final class CreditLimitFailure extends Failure {
  const CreditLimitFailure([
    super.message = 'You have no contact credits left this month.',
  ]);
}
