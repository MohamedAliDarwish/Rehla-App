import 'category_model.dart';
import 'day_model.dart';

class TripModel {
  final String id;
  final String title;
  final int availableSeats;
  final double averageRating;
  final String cancelPolicy;
  final int capacity;
  final CategoryModel category;
  final String coverImage;
  final List<DayModel> days;
  final String description;
  final String destination;
  final String from;
  final List<String> gallery;
  final List<String> included;
  final List<String> excluded;
  final double price;
  final int reviewsCount;
  final String startDate;
  final String endDate;
  final String status;

  TripModel({
    required this.id,
    required this.title,
    required this.availableSeats,
    required this.averageRating,
    required this.cancelPolicy,
    required this.capacity,
    required this.category,
    required this.coverImage,
    required this.days,
    required this.description,
    required this.destination,
    required this.from,
    required this.gallery,
    required this.included,
    required this.excluded,
    required this.price,
    required this.reviewsCount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      cancelPolicy: json['cancelPolicy']?.toString() ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'])
          : CategoryModel(
              id: json['category']?.toString() ?? '',
              slug: '',
              image: '',
              isActive: true,
              nameAr: '',
              nameEn: '',
            ),
      coverImage: json['coverImage']?.toString() ?? '',
      days: (json['days'] as List?)
              ?.map((e) => DayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description']?.toString() ?? '',
      destination: json['destination']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      gallery: (json['gallery'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      included: (json['included'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      excluded: (json['excluded'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
