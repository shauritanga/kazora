import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client_provider.dart';
import '../../../../core/storage/local_storage.dart';
import '../../data/datasources/property_local_datasource.dart';
import '../../data/datasources/property_remote_datasource.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';
import '../../domain/usecases/favorite_property.dart';
import '../../domain/usecases/get_properties.dart';
import '../../domain/usecases/get_property.dart';
import '../../domain/usecases/search_properties.dart';
import 'property_state.dart';

export 'property_state.dart';

final propertyRemoteDatasourceProvider = Provider<PropertyRemoteDatasource>(
  (ref) => PropertyRemoteDatasource(ref.watch(apiClientProvider)),
);

final propertyLocalDatasourceProvider = Provider<PropertyLocalDatasource>(
  (ref) => PropertyLocalDatasource(LocalStorage.instance),
);

final propertyRepositoryProvider = Provider<PropertyRepository>(
  (ref) => PropertyRepositoryImpl(
    remote: ref.watch(propertyRemoteDatasourceProvider),
    local: ref.watch(propertyLocalDatasourceProvider),
  ),
);

final getPropertiesProvider = Provider(
  (ref) => GetProperties(ref.watch(propertyRepositoryProvider)),
);

final getPropertyProvider = Provider(
  (ref) => GetProperty(ref.watch(propertyRepositoryProvider)),
);

final searchPropertiesProvider = Provider(
  (ref) => SearchProperties(ref.watch(propertyRepositoryProvider)),
);

final favoritePropertyProvider = Provider(
  (ref) => FavoriteProperty(ref.watch(propertyRepositoryProvider)),
);

class PropertiesNotifier extends StateNotifier<PropertiesState> {
  PropertiesNotifier(this._getProperties, this._searchProperties)
    : super(const PropertiesState());

  final GetProperties _getProperties;
  final SearchProperties _searchProperties;

  Future<void> load({String? region, PropertyType? type}) async {
    state = state.copyWith(
      isLoading: true,
      region: region,
      type: type,
      query: '',
      clearFailure: true,
    );
    try {
      final properties = await _getProperties(region: region, type: type);
      state = state.copyWith(properties: properties, isLoading: false);
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    }
  }

  Future<void> search(
    String query, {
    String? region,
    PropertyType? type,
    String? category,
    int? priceMin,
    int? priceMax,
  }) async {
    state = PropertiesState(
      isLoading: true,
      query: query,
      region: region,
      type: type,
      category: category,
      priceMin: priceMin,
      priceMax: priceMax,
    );
    try {
      final hasFilters = region != null ||
          type != null ||
          category != null ||
          priceMin != null ||
          priceMax != null;
      final properties = query.trim().isEmpty && !hasFilters
          ? await _getProperties()
          : await _searchProperties(
              query,
              region: region,
              type: type,
              category: category,
              priceMin: priceMin,
              priceMax: priceMax,
            );
      state = state.copyWith(properties: properties, isLoading: false);
    } on Failure catch (e) {
      state = state.copyWith(isLoading: false, failure: e);
    }
  }

  Future<void> resetSearch() async {
    state = const PropertiesState(properties: []);
    await load();
  }
}

final propertiesProvider =
    StateNotifierProvider<PropertiesNotifier, PropertiesState>((ref) {
      return PropertiesNotifier(
        ref.watch(getPropertiesProvider),
        ref.watch(searchPropertiesProvider),
      );
    });

final propertyDetailsProvider = FutureProvider.family<Property, String>((
  ref,
  id,
) {
  return ref.watch(getPropertyProvider).call(id);
});

class FavoriteIdsNotifier extends StateNotifier<List<String>> {
  FavoriteIdsNotifier(this._local) : super(const []);

  final PropertyLocalDatasource _local;

  Future<void> load() async {
    final ids = await _local.getFavoriteIds();
    state = ids;
  }

  Future<void> toggle(String propertyId) async {
    final isFavorite = state.contains(propertyId);
    state = isFavorite
        ? state.where((id) => id != propertyId).toList()
        : [...state, propertyId];
  }
}

final favoriteIdsProvider =
    StateNotifierProvider<FavoriteIdsNotifier, List<String>>((ref) {
      final notifier = FavoriteIdsNotifier(
        ref.watch(propertyLocalDatasourceProvider),
      );
      notifier.load();
      return notifier;
    });
