class TripModel {
  final String title;
  final String from;
  final String description;
  final String destination;
  final double price;
  final int capacity;
  final int availableSeats;
  final String startDate;
  final String endDate;
  final String status;
  final String coverImage;
  final List<String> included;
  final List<String> excluded;
  final String cancelPolicy;
  final List<DayModel> days;

  TripModel.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        from = json['from'] ?? '',
        description = json['description'] ?? '',
        destination = json['destination'] ?? '',
        price = (json['price'] ?? 0).toDouble(),
        capacity = json['capacity'] ?? 0,
        availableSeats = json['availableSeats'] ?? 0,
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        status = json['status'] ?? '',
        coverImage = json['coverImage'] ?? '',
        included = List<String>.from(json['included'] ?? []),
        excluded = List<String>.from(json['excluded'] ?? []),
        cancelPolicy = json['cancelPolicy'] ?? '',
        days = (json['days'] as List?)
                ?.map((day) => DayModel.fromJson(day))
                .toList() ??
            [];
}

class DayModel {
  final int dayNumber;
  final String title;
  final List<ActivityModel> activities;

  DayModel.fromJson(Map<String, dynamic> json)
      : dayNumber = json['dayNumber'] ?? 0,
        title = json['title'] ?? '',
        activities = (json['activities'] as List?)
                ?.map((activity) => ActivityModel.fromJson(activity))
                .toList() ??
            [];
}

class ActivityModel {
  final String time;
  final String title;
  final String description;
  final String location;
  final String image;

  ActivityModel.fromJson(Map<String, dynamic> json)
      : time = json['time'] ?? '',
        title = json['title'] ?? '',
        description = json['description'] ?? '',
        location = json['location'] ?? '',
        image = json['image'] ?? '';
}