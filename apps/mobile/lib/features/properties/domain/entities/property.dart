enum PropertyType { residential, commercial }

enum PropertyStatus { available, rented, pending, archived }

class Property {
  const Property({
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
  final PropertyType type;
  final String category;
  final String region;
  final String district;
  final String area;
  final int priceTzs;
  final List<String> photos;
  final PropertyStatus status;
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

  bool get isContactRevealed =>
      landlordPhone != null && landlordPhone!.isNotEmpty;

  String get locationLabel => '$area, $district, $region';

  Property copyWith({
    String? id,
    String? title,
    PropertyType? type,
    String? category,
    String? region,
    String? district,
    String? area,
    int? priceTzs,
    List<String>? photos,
    PropertyStatus? status,
    int? bedrooms,
    int? bathrooms,
    bool? furnished,
    List<String>? amenities,
    bool? isVerified,
    bool? isFeatured,
    String? landlordName,
    String? landlordPhone,
    String? landlordWhatsApp,
    String? description,
    DateTime? createdAt,
    String? videoUrl,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      category: category ?? this.category,
      region: region ?? this.region,
      district: district ?? this.district,
      area: area ?? this.area,
      priceTzs: priceTzs ?? this.priceTzs,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      furnished: furnished ?? this.furnished,
      amenities: amenities ?? this.amenities,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      landlordName: landlordName ?? this.landlordName,
      landlordPhone: landlordPhone ?? this.landlordPhone,
      landlordWhatsApp: landlordWhatsApp ?? this.landlordWhatsApp,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }
}
