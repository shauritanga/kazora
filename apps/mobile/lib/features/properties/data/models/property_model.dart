import '../../domain/entities/property.dart';

class PropertyModel {
  const PropertyModel({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.region,
    required this.district,
    required this.area,
    required this.priceTzs,
    required this.photos,
    required this.status,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.furnished = false,
    this.amenities = const [],
    this.isVerified = false,
    this.isFeatured = false,
    this.landlordName,
    this.landlordPhone,
    this.landlordWhatsApp,
    this.description,
    this.createdAt,
    this.videoUrl,
  });

  final String id;
  final String title;
  final String type;
  final String category;
  final String region;
  final String district;
  final String area;
  final int priceTzs;
  final List<String> photos;
  final String status;
  final int bedrooms;
  final int bathrooms;
  final bool furnished;
  final List<String> amenities;
  final bool isVerified;
  final bool isFeatured;
  final String? landlordName;
  final String? landlordPhone;
  final String? landlordWhatsApp;
  final String? description;
  final DateTime? createdAt;
  final String? videoUrl;

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String? ?? 'residential',
      category: json['category'] as String? ?? 'room',
      region: json['region'] as String? ?? '',
      district: json['district'] as String? ?? '',
      area: json['area'] as String? ?? '',
      priceTzs: json['priceTzs'] as int? ?? 0,
      photos: (json['photos'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String? ?? 'available',
      bedrooms: json['bedrooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      furnished: json['furnished'] as bool? ?? false,
      amenities: (json['amenities'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      isVerified: json['isVerified'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      landlordName: json['landlordName'] as String?,
      landlordPhone: json['landlordPhone'] as String?,
      landlordWhatsApp: json['landlordWhatsApp'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      videoUrl: json['videoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'category': category,
      'region': region,
      'district': district,
      'area': area,
      'priceTzs': priceTzs,
      'photos': photos,
      'status': status,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'furnished': furnished,
      'amenities': amenities,
      'isVerified': isVerified,
      'isFeatured': isFeatured,
      'landlordName': landlordName,
      'landlordPhone': landlordPhone,
      'landlordWhatsApp': landlordWhatsApp,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'videoUrl': videoUrl,
    };
  }

  Property toEntity() {
    return Property(
      id: id,
      title: title,
      type: type == 'commercial'
          ? PropertyType.commercial
          : PropertyType.residential,
      category: category,
      region: region,
      district: district,
      area: area,
      priceTzs: priceTzs,
      photos: photos,
      status: _parseStatus(status),
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      furnished: furnished,
      amenities: amenities,
      isVerified: isVerified,
      isFeatured: isFeatured,
      landlordName: landlordName,
      landlordPhone: landlordPhone,
      landlordWhatsApp: landlordWhatsApp,
      description: description,
      createdAt: createdAt,
      videoUrl: videoUrl,
    );
  }

  static PropertyStatus _parseStatus(String status) {
    return PropertyStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => PropertyStatus.available,
    );
  }
}
