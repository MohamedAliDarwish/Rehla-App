class CategoryModel {
  final String id;
  final String slug;
  final String image;
  final bool isActive;
  final String nameAr;
  final String nameEn;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.image,
    required this.isActive,
    required this.nameAr,
    required this.nameEn,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
      isActive: json['isActive'] ?? false,
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
    );
  }
}
