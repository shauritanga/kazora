enum AppEnvironment { development, staging, production }

abstract final class Environment {
  static const AppEnvironment current = AppEnvironment.development;

  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;
    switch (current) {
      case AppEnvironment.development:
        return 'http://10.0.2.2:3000';
      case AppEnvironment.staging:
        return 'https://staging-api.kazora.co.tz';
      case AppEnvironment.production:
        return 'https://api.kazora.co.tz';
    }
  }

  static bool get isProduction => current == AppEnvironment.production;
}
