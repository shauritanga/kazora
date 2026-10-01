import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  NetworkInfo({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> onConnectivityChange() async* {
    await for (final result in _connectivity.onConnectivityChanged) {
      yield !result.contains(ConnectivityResult.none);
    }
  }

  Future<bool> get hasConnection async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
