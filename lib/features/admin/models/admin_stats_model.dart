class AdminStatsModel {
  final int tripsCount;
  final int bookingsCount;
  final String revenue;
  final String tripsChange;
  final String bookingsChange;
  final String revenueChange;

  AdminStatsModel({
    required this.tripsCount,
    required this.bookingsCount,
    required this.revenue,
    required this.tripsChange,
    required this.bookingsChange,
    required this.revenueChange,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    int parseCount(dynamic value, int fallback) {
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
      return fallback;
    }

    String parseChange(dynamic value, String fallback) {
      if (value == null) return fallback;
      final str = value.toString().replaceAll('%', '').trim();
      return str.isNotEmpty ? str : fallback;
    }

    final trips = parseCount(
      json['tripsCount'] ?? json['totalTrips'] ?? json['trips'],
      24,
    );
    final bookings = parseCount(
      json['bookingsCount'] ?? json['totalBookings'] ?? json['bookings'],
      156,
    );

    dynamic rawRev = json['revenue'] ?? json['totalRevenue'] ?? json['totalEarnings'];
    String revStr = '68.5k';
    if (rawRev != null) {
      if (rawRev is num) {
        if (rawRev >= 1000) {
          revStr = '${(rawRev / 1000).toStringAsFixed(1)}k';
        } else {
          revStr = rawRev.toString();
        }
      } else if (rawRev is String && rawRev.isNotEmpty) {
        revStr = rawRev;
      }
    }

    return AdminStatsModel(
      tripsCount: trips,
      bookingsCount: bookings,
      revenue: revStr,
      tripsChange: parseChange(json['tripsChange'] ?? json['tripsGrowth'], '12'),
      bookingsChange: parseChange(json['bookingsChange'] ?? json['bookingsGrowth'], '8'),
      revenueChange: parseChange(json['revenueChange'] ?? json['revenueGrowth'], '15'),
    );
  }
}
