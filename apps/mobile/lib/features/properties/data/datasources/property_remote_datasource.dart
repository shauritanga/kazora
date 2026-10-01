import '../../../../core/network/api_client.dart';
import '../models/property_model.dart';

class PropertyRemoteDatasource {
  const PropertyRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PropertyModel>> getProperties({
    String? region,
    String? category,
    String? type,
    int? priceMin,
    int? priceMax,
  }) async {
    final data = await _apiClient.get(
      '/properties',
      queryParameters: _buildQuery(
        region: region,
        category: category,
        type: type,
        priceMin: priceMin,
        priceMax: priceMax,
      ),
    );
    return _parseList(data);
  }

  Future<PropertyModel> getProperty(String id) async {
    final data = await _apiClient.get('/properties/$id');
    return PropertyModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<PropertyModel>> searchProperties(
    String query, {
    String? region,
    String? type,
    String? category,
    int? priceMin,
    int? priceMax,
  }) async {
    final data = await _apiClient.get(
      '/properties',
      queryParameters: {
        if (query.isNotEmpty) 'q': query,
        if (region != null) 'region': region,
        if (type != null) 'type': type,
        if (category != null) 'category': category,
        if (priceMin != null) 'price_min': priceMin,
        if (priceMax != null) 'price_max': priceMax,
      },
    );
    return _parseList(data);
  }

  Future<void> toggleFavorite(String propertyId, bool isFavorite) async {
    if (isFavorite) {
      await _apiClient.post('/properties/$propertyId/favorites');
    } else {
      await _apiClient.delete('/properties/$propertyId/favorites');
    }
  }

  Map<String, dynamic>? _buildQuery({
    String? region,
    String? category,
    String? type,
    int? priceMin,
    int? priceMax,
  }) {
    return {
      if (region != null) 'region': region,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (priceMin != null) 'price_min': priceMin,
      if (priceMax != null) 'price_max': priceMax,
    };
  }

  List<PropertyModel> _parseList(dynamic data) {
    final list = data is Map<String, dynamic>
        ? data['data'] as List<dynamic>? ?? const []
        : data as List<dynamic>? ?? const [];
    return list
        .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
