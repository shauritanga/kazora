import 'dart:convert';

import '../../../../core/storage/local_storage.dart';
import '../models/property_model.dart';

class PropertyLocalDatasource {
  const PropertyLocalDatasource(this._storage);

  final LocalStorage _storage;

  Future<void> ensureReady() => _storage.init();

  Future<List<PropertyModel>?> getCachedProperties() async {
    await ensureReady();
    final raw = _storage.propertiesCache;
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheProperties(List<PropertyModel> properties) async {
    final raw = jsonEncode(properties.map((e) => e.toJson()).toList());
    await _storage.savePropertiesCache(raw);
  }

  Future<List<String>> getFavoriteIds() async {
    await ensureReady();
    return _storage.favoriteIds;
  }

  Future<void> saveFavoriteIds(List<String> ids) =>
      _storage.saveFavoriteIds(ids);
}
