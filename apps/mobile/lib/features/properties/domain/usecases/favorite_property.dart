import '../repositories/property_repository.dart';

class FavoriteProperty {
  const FavoriteProperty(this._repository);

  final PropertyRepository _repository;

  Future<void> call(String propertyId, bool isFavorite) =>
      _repository.toggleFavorite(propertyId, isFavorite);
}
