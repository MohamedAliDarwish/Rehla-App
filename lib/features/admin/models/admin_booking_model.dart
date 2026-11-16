class AdminBookingModel {
  final String id;
  final String code;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userAvatar;
  final String destination;
  final String date;
  final String duration;
  final String guests;
  final String price;
  final String status;
  final String image;

  AdminBookingModel({
    required this.id,
    this.code = '#BKG-250610',
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userAvatar,
    required this.destination,
    required this.date,
    this.duration = '3 أيام / 2 ليلة',
    required this.guests,
    required this.price,
    required this.status,
    required this.image,
  });

  AdminBookingModel copyWith({
    String? id,
    String? code,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? userAvatar,
    String? destination,
    String? date,
    String? duration,
    String? guests,
    String? price,
    String? status,
    String? image,
  }) {
    return AdminBookingModel(
      id: id ?? this.id,
      code: code ?? this.code,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      userAvatar: userAvatar ?? this.userAvatar,
      destination: destination ?? this.destination,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      guests: guests ?? this.guests,
      price: price ?? this.price,
      status: status ?? this.status,
      image: image ?? this.image,
    );
  }

  factory AdminBookingModel.fromJson(Map<String, dynamic> json) {
    final tripMap = json['trip'] is Map<String, dynamic>
        ? json['trip'] as Map<String, dynamic>
        : json;

    final rawId = json['_id']?.toString() ??
        json['id']?.toString() ??
        tripMap['_id']?.toString() ??
        '1';

    String codeStr = json['code']?.toString() ?? json['bookingNumber']?.toString() ?? '';
    if (codeStr.isEmpty) {
      if (rawId.length >= 6) {
        codeStr = '#BKG-${rawId.substring(rawId.length - 6).toUpperCase()}';
      } else {
        codeStr = '#BKG-250610';
      }
    }

    final dest = tripMap['destination']?.toString() ??
        tripMap['title']?.toString() ??
        json['destination']?.toString() ??
        json['tripTitle']?.toString() ??
        'شرم الشيخ';

    String dur = json['duration']?.toString() ?? '';
    if (dur.isEmpty) {
      if (tripMap['days'] is List && (tripMap['days'] as List).isNotEmpty) {
        final daysLen = (tripMap['days'] as List).length;
        dur = '$daysLen أيام / ${daysLen > 1 ? daysLen - 1 : 1} ليلة';
      } else {
        dur = '3 أيام / 2 ليلة';
      }
    }

    final rawPrice = json['totalPrice'] ?? json['price'] ?? tripMap['price'];
    String priceStr = '6,000 ج.م';
    if (rawPrice != null) {
      if (rawPrice is num) {
        priceStr = '${rawPrice.toStringAsFixed(0)} ج.م';
      } else {
        priceStr = rawPrice.toString();
        if (!priceStr.contains('ج.م') && !priceStr.contains('EGP')) {
          priceStr = '$priceStr ج.م';
        }
      }
    }

    final rawStatus = json['status']?.toString() ?? 'بانتظار الرد';

    return AdminBookingModel(
      id: rawId,
      code: codeStr,
      userName: json['userName']?.toString() ?? 'محمد أحمد',
      userEmail: json['userEmail']?.toString() ?? 'mohamed@example.com',
      userPhone: json['userPhone']?.toString() ?? '+20 100 123 4567',
      userAvatar: json['userAvatar']?.toString() ?? '',
      destination: dest,
      date: json['date']?.toString() ?? '20 - 22 يونيو 2025',
      duration: dur,
      guests: json['guests']?.toString() ?? '2 بالغ',
      price: priceStr,
      status: rawStatus,
      image: tripMap['coverImage']?.toString() ??
          json['coverImage']?.toString() ??
          json['image']?.toString() ??
          'assets/images/dest_hurghada.png',
    );
  }
}
