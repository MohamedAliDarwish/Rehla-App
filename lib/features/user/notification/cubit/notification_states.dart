import 'package:rehla/features/user/notification/models/notification_model.dart';

sealed class NotificationStates {}

class NotificationInitState extends NotificationStates {}

class NotificationLoadedState extends NotificationStates {
  final List<NotificationModel> notifications;

  /// 0 = all, 1 = unread, 2 = offers
  final int selectedTab;

  NotificationLoadedState({
    required this.notifications,
    this.selectedTab = 0,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get filtered {
    switch (selectedTab) {
      case 1:
        return notifications.where((n) => !n.isRead).toList();
      case 2:
        return notifications
            .where((n) => n.type == NotificationType.offer)
            .toList();
      default:
        return notifications;
    }
  }
}