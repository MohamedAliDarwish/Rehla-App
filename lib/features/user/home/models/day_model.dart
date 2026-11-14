import 'activity_model.dart';

class DayModel {
  final int dayNumber;
  final String title;
  final List<ActivityModel> activities;

  DayModel({
    required this.dayNumber,
    required this.title,
    required this.activities,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      activities: (json['activities'] as List?)
              ?.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
