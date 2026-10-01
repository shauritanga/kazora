import '../entities/property.dart';
import '../repositories/property_repository.dart';

class GetProperty {
  const GetProperty(this._repository);

  final PropertyRepository _repository;

  Future<Property> call(String id) => _repository.getProperty(id);
}
