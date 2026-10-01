import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_local_datasource.dart';
import '../datasources/property_remote_datasource.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  const PropertyRepositoryImpl({required this.remote, required this.local});

  final PropertyRemoteDatasource remote;
  final PropertyLocalDatasource local;

  @override
  Future<List<Property>> getProperties({
    String? region,
    String? category,
    PropertyType? type,
    int? priceMin,
    int? priceMax,
  }) async {
    try {
      final models = await remote.getProperties(
        region: region,
        category: category,
        type: type?.name,
        priceMin: priceMin,
        priceMax: priceMax,
      );
      if (region == null && category == null && type == null) {
        await local.cacheProperties(models);
      }
      return models.map((e) => e.toEntity()).toList();
    } catch (e) {
      if (region == null && category == null && type == null) {
        final cached = await local.getCachedProperties();
        if (cached != null) return cached.map((e) => e.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<Property> getProperty(String id) async {
    final model = await remote.getProperty(id);
    return model.toEntity();
  }

  @override
  Future<List<Property>> searchProperties(
    String query, {
    String? region,
    PropertyType? type,
    String? category,
    int? priceMin,
    int? priceMax,
  }) async {
    final models = await remote.searchProperties(
      query,
      region: region,
      type: type?.name,
      category: category,
      priceMin: priceMin,
      priceMax: priceMax,
    );
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> toggleFavorite(String propertyId, bool isFavorite) async {
    await remote.toggleFavorite(propertyId, isFavorite);
    final ids = await local.getFavoriteIds();
    final updated = ids.toSet();
    if (isFavorite) {
      updated.add(propertyId);
    } else {
      updated.remove(propertyId);
    }
    await local.saveFavoriteIds(updated.toList());
  }
}
