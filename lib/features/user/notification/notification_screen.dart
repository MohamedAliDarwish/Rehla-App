import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/notification/cubit/notification_cubit.dart';
import 'package:rehla/features/user/notification/cubit/notification_states.dart';
import 'package:rehla/features/user/notification/widgets/notification_item.dart';
import 'package:rehla/features/user/notification/widgets/notification_tabs.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..loadNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.navNotifications,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: BlocBuilder<NotificationCubit, NotificationStates>(
          builder: (context, state) {
            if (state is! NotificationLoadedState) {
              return const Center(child: CircularProgressIndicator());
            }

            final cubit = context.read<NotificationCubit>();
            final items = state.filtered;

            return Column(
              children: [
                NotificationTabs(
                  selectedTab: state.selectedTab,
                  unreadCount: state.unreadCount,
                  onTabChanged: cubit.changeTab,
                  onMarkAllAsRead: cubit.markAllAsRead,
                ),
                const Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_off_outlined,
                                size: 60,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'لا توجد إشعارات',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return NotificationItem(
                              notification: item,
                              onTap: () => cubit.markAsRead(item.id),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
