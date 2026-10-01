import '../entities/property.dart';
import '../repositories/property_repository.dart';

class GetProperties {
  const GetProperties(this._repository);

  final PropertyRepository _repository;

  Future<List<Property>> call({
    String? region,
    String? category,
    PropertyType? type,
    int? priceMin,
    int? priceMax,
  }) {
    return _repository.getProperties(
      region: region,
      category: category,
      type: type,
      priceMin: priceMin,
      priceMax: priceMax,
    );
  }
}
