import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/theme/test_styles.dart';

class NotificationTabs extends StatelessWidget {
  final int selectedTab;
  final int unreadCount;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onMarkAllAsRead;

  const NotificationTabs({
    super.key,
    required this.selectedTab,
    required this.unreadCount,
    required this.onTabChanged,
    required this.onMarkAllAsRead,
  });

  Widget _tab({required int index, required String title, Widget? badge}) {
    final isSelected = selectedTab == index;
    return InkWell(
      onTap: () => onTabChanged(index),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (badge != null) ...[const SizedBox(width: 4), badge],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          _tab(index: 0, title: 'الكل'),
          _tab(
            index: 1,
            title: 'غير مقروءة',
            badge: unreadCount > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
          _tab(index: 2, title: 'العروض'),
          const Spacer(),
          if (unreadCount > 0)
            InkWell(
              onTap: onMarkAllAsRead,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  'قراءة الكل',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}