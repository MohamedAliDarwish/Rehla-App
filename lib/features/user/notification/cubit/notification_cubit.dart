import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/features/user/notification/cubit/notification_states.dart';
import 'package:rehla/features/user/notification/models/notification_model.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitState());

  // Local sample data (no API). Replace this list when a backend is added.
  static const List<NotificationModel> _sampleData = [
    NotificationModel(
      id: '1',
      title: 'تم تأكيد حجزك',
      description: 'تم تأكيد حجزك في رحلة شرم الشيخ بنجاح',
      time: 'منذ 5 دقائق',
      type: NotificationType.booking,
    ),
    NotificationModel(
      id: '2',
      title: 'عرض خاص لفترة محدودة',
      description: 'خصم 20% على رحلات الأقصر وأسوان هذا الأسبوع',
      time: 'منذ ساعة',
      type: NotificationType.offer,
    ),
    NotificationModel(
      id: '3',
      title: 'تذكير بموعد رحلتك',
      description: 'رحلتك إلى واحة سيوة تبدأ غدًا الساعة 6 صباحًا',
      time: 'منذ 3 ساعات',
      type: NotificationType.reminder,
    ),
    NotificationModel(
      id: '4',
      title: 'عرض الصيف',
      description: 'احجز رحلة شاطئية واحصل على ليلة إضافية مجانًا',
      time: 'أمس',
      type: NotificationType.offer,
      isRead: true,
    ),
    NotificationModel(
      id: '5',
      title: 'مرحبًا بك في رحلات مصر',
      description: 'ابدأ باستكشاف أجمل الوجهات السياحية في مصر',
      time: 'منذ يومين',
      type: NotificationType.info,
      isRead: true,
    ),
  ];

  void loadNotifications() {
    emit(NotificationLoadedState(notifications: _sampleData));
  }

  void changeTab(int index) {
    final current = state;
    if (current is! NotificationLoadedState) return;
    emit(
      NotificationLoadedState(
        notifications: current.notifications,
        selectedTab: index,
      ),
    );
  }

  void markAsRead(String id) {
    final current = state;
    if (current is! NotificationLoadedState) return;
    emit(
      NotificationLoadedState(
        notifications: current.notifications
            .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
            .toList(),
        selectedTab: current.selectedTab,
      ),
    );
  }

  void markAllAsRead() {
    final current = state;
    if (current is! NotificationLoadedState) return;
    emit(
      NotificationLoadedState(
        notifications:
            current.notifications.map((n) => n.copyWith(isRead: true)).toList(),
        selectedTab: current.selectedTab,
      ),
    );
  }
}