import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

class TripInfoSection extends StatelessWidget {
  final TripModel trip;

  const TripInfoSection({super.key, required this.trip});

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = trip.category.nameAr.isNotEmpty
        ? trip.category.nameAr
        : trip.category.nameEn;

    final durationDays = trip.days.isNotEmpty ? trip.days.length : 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Chip
          if (categoryName.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                categoryName,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Title
          Text(
            trip.title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Location details (From -> Destination)
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.secondary,
                size: 18,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  trip.from.isNotEmpty
                      ? '${trip.from} ➔ ${trip.destination}'
                      : trip.destination,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Metrics cards row
          Row(
            children: [
              _buildMetricCard(
                icon: Icons.access_time_rounded,
                label: AppStrings.duration,
                value: '$durationDays ${AppStrings.daysCount}',
              ),
              const SizedBox(width: 10),
              _buildMetricCard(
                icon: Icons.event_seat_outlined,
                label: AppStrings.availableSeats,
                value: '${trip.availableSeats} / ${trip.capacity}',
              ),
              const SizedBox(width: 10),
              _buildMetricCard(
                icon: Icons.calendar_month_outlined,
                label: 'التاريخ',
                value: trip.startDate.isNotEmpty
                    ? trip.startDate.split('T').first
                    : 'متاح',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
