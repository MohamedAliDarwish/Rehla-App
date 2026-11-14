class ActivityModel {
  final String time;
  final String title;
  final String description;
  final String location;
  final String image;

  ActivityModel({
    required this.time,
    required this.title,
    required this.description,
    required this.location,
    required this.image,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      time: json['time']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}
