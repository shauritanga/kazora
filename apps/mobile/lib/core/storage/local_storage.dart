import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static final LocalStorage instance = LocalStorage._();

  SharedPreferences? _prefs;

  static const String _accessTokenKey = 'access_token';
  static const String _onboardingDoneKey = 'onboarding_done';
  static const String _localeKey = 'locale';
  static const String _roleKey = 'role';
  static const String _propertiesCacheKey = 'properties_cache';
  static const String _favoriteIdsKey = 'favorite_ids';
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 5;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get accessToken => _prefs?.getString(_accessTokenKey);

  Future<void> saveAccessToken(String token) async {
    final prefs = await _instance;
    await prefs.setString(_accessTokenKey, token);
  }

  Future<void> clearAccessToken() async {
    final prefs = await _instance;
    await prefs.remove(_accessTokenKey);
  }

  bool get onboardingDone => _prefs?.getBool(_onboardingDoneKey) ?? false;

  Future<void> setOnboardingDone(bool done) async {
    final prefs = await _instance;
    await prefs.setBool(_onboardingDoneKey, done);
  }

  String? get locale => _prefs?.getString(_localeKey);

  Future<void> saveLocale(String locale) async {
    final prefs = await _instance;
    await prefs.setString(_localeKey, locale);
  }

  String? get role => _prefs?.getString(_roleKey);

  Future<void> saveRole(String role) async {
    final prefs = await _instance;
    await prefs.setString(_roleKey, role);
  }

  Future<void> removeRole() async {
    final prefs = await _instance;
    await prefs.remove(_roleKey);
  }

  String? get propertiesCache => _prefs?.getString(_propertiesCacheKey);

  Future<void> savePropertiesCache(String json) async {
    final prefs = await _instance;
    await prefs.setString(_propertiesCacheKey, json);
  }

  List<String> get favoriteIds {
    final raw = _prefs?.getString(_favoriteIdsKey);
    if (raw == null || raw.isEmpty) return const [];
    return raw.split(',').where((e) => e.isNotEmpty).toList();
  }

  Future<void> saveFavoriteIds(List<String> ids) async {
    final prefs = await _instance;
    await prefs.setString(_favoriteIdsKey, ids.join(','));
  }

  List<String> get recentSearches {
    return _prefs?.getStringList(_recentSearchesKey) ?? const [];
  }

  Future<void> saveRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final prefs = await _instance;
    final updated = prefs
        .getStringList(_recentSearchesKey)
        ?.where((e) => e.toLowerCase() != trimmed.toLowerCase())
        .toList() ??
        <String>[];
    await prefs.setStringList(
      _recentSearchesKey,
      [trimmed, ...updated].take(_maxRecentSearches).toList(),
    );
  }

  Future<void> clearRecentSearches() async {
    final prefs = await _instance;
    await prefs.remove(_recentSearchesKey);
  }

  Future<void> clear() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}
