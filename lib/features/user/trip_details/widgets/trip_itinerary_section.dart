import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/home/models/activity_model.dart';
import 'package:rehla/features/user/home/models/day_model.dart';

class TripItinerarySection extends StatelessWidget {
  final List<DayModel> days;

  const TripItinerarySection({super.key, required this.days});

  Widget _buildActivityItem(ActivityModel activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time badge
          if (activity.time.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                activity.time,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Timeline dot and line
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (activity.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    activity.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (activity.location.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 12,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        activity.location,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.itinerary,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final day = days[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            '${day.dayNumber}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'اليوم ${day.dayNumber}: ${day.title}',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (day.activities.isNotEmpty) ...[
                      const Divider(height: 20, color: AppColors.divider),
                      ...day.activities.map(_buildActivityItem),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
