import '../entities/property.dart';
import '../repositories/property_repository.dart';

class SearchProperties {
  const SearchProperties(this._repository);

  final PropertyRepository _repository;

  Future<List<Property>> call(
    String query, {
    String? region,
    PropertyType? type,
    String? category,
    int? priceMin,
    int? priceMax,
  }) {
    return _repository.searchProperties(
      query,
      region: region,
      type: type,
      category: category,
      priceMin: priceMin,
      priceMax: priceMax,
    );
  }
}
