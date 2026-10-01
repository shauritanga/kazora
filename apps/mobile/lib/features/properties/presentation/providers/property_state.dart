import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/property.dart';

@immutable
class PropertiesState {
  const PropertiesState({
    this.properties = const [],
    this.isLoading = false,
    this.failure,
    this.query = '',
    this.region,
    this.type,
    this.category,
    this.priceMin,
    this.priceMax,
  });

  final List<Property> properties;
  final bool isLoading;
  final Failure? failure;
  final String query;
  final String? region;
  final PropertyType? type;
  final String? category;
  final int? priceMin;
  final int? priceMax;

  bool get isEmpty => !isLoading && properties.isEmpty && failure == null;

  bool get hasActiveFilters =>
      region != null ||
      type != null ||
      category != null ||
      priceMin != null ||
      priceMax != null;

  PropertiesState copyWith({
    List<Property>? properties,
    bool? isLoading,
    Failure? failure,
    String? query,
    String? region,
    PropertyType? type,
    String? category,
    int? priceMin,
    int? priceMax,
    bool clearFailure = false,
  }) {
    return PropertiesState(
      properties: properties ?? this.properties,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : (failure ?? this.failure),
      query: query ?? this.query,
      region: region ?? this.region,
      type: type ?? this.type,
      category: category ?? this.category,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
    );
  }
}
