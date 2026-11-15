import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_assets.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/theme/test_styles.dart';

class AdminHeaderWidget extends StatelessWidget {
  final String adminName;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onNotificationsPressed;

  const AdminHeaderWidget({
    super.key,
    required this.adminName,
    this.onSettingsPressed,
    this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image Avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 1.5),
            image: const DecorationImage(
              image: AssetImage(AppAssets.userPlaceholder),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Greeting & Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'مرحباً $adminName',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'لوحة التحكم',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Settings Icon Button
        IconButton(
          onPressed: onSettingsPressed ?? () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.settings_outlined,
              size: 22,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Notification Icon Button with red badge
        IconButton(
          onPressed: onNotificationsPressed ?? () {},
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
