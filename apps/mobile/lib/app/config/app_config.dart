import 'environment.dart';

abstract final class AppConfig {
  static const String appName = 'Kazora';
  static const String appTagline = 'Discover. Connect. Live.';

  static const int monthlyContactCredits = 5;
  static const int subscriptionPriceTzs = 5000;
  static const int extraCreditPriceTzs = 1000;
  static const int maxListingPhotos = 10;

  static const Duration otpValidity = Duration(minutes: 5);
  static const Duration apiTimeout = Duration(seconds: 30);

  static String get apiBaseUrl => Environment.apiBaseUrl;
  static bool get isProduction => Environment.isProduction;
}
