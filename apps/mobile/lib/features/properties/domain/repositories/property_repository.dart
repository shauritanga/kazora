import '../entities/property.dart';

abstract interface class PropertyRepository {
  Future<List<Property>> getProperties({
    String? region,
    String? category,
    PropertyType? type,
    int? priceMin,
    int? priceMax,
  });

  Future<Property> getProperty(String id);

  Future<List<Property>> searchProperties(
    String query, {
    String? region,
    PropertyType? type,
    String? category,
    int? priceMin,
    int? priceMax,
  });

  Future<void> toggleFavorite(String propertyId, bool isFavorite);
}
