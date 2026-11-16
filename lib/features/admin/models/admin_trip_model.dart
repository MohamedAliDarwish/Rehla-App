class AdminTripModel {
  final String id;
  final String title;
  final String duration;
  final String price;
  final String status;
  final String coverImage;
  final bool isPublished;

  AdminTripModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
    required this.status,
    required this.coverImage,
    required this.isPublished,
  });

  factory AdminTripModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    final titleStr = json['title']?.toString() ?? json['destination']?.toString() ?? 'رحلة جديدة';

    String durStr = json['duration']?.toString() ?? '';
    if (durStr.isEmpty) {
      if (json['days'] is List && (json['days'] as List).isNotEmpty) {
        final daysCount = (json['days'] as List).length;
        durStr = '$daysCount أيام / ${daysCount > 1 ? daysCount - 1 : 1} ليلة';
      } else {
        durStr = '3 أيام / 2 ليلة';
      }
    }

    final rawPrice = json['price'];
    String priceStr = '2,950 ج.م';
    if (rawPrice != null) {
      if (rawPrice is num) {
        priceStr = '${rawPrice.toStringAsFixed(0)} ج.م';
      } else {
        priceStr = rawPrice.toString();
        if (!priceStr.contains('ج.م')) priceStr = '$priceStr ج.م';
      }
    }

    final isPub = json['isPublished'] == true ||
        json['status'] == 'published' ||
        json['status'] == 'منشورة' ||
        json['isActive'] == true;

    final rawStatus = json['status']?.toString() ?? '';
    String statusStr = 'منشورة';
    if (rawStatus == 'مسودة' || rawStatus == 'draft') {
      statusStr = 'مسودة';
    } else if (!isPub || rawStatus == 'غير منشورة' || rawStatus == 'unpublished') {
      statusStr = 'غير منشورة';
    }

    return AdminTripModel(
      id: rawId,
      title: titleStr,
      duration: durStr,
      price: priceStr,
      status: statusStr,
      coverImage: json['coverImage']?.toString() ?? json['image']?.toString() ?? 'assets/images/dest_hurghada.png',
      isPublished: isPub,
    );
  }

  AdminTripModel copyWith({
    String? id,
    String? title,
    String? duration,
    String? price,
    String? status,
    String? coverImage,
    bool? isPublished,
  }) {
    return AdminTripModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      status: status ?? this.status,
      coverImage: coverImage ?? this.coverImage,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
