import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/core/widgets/app_button.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

class TripBottomBar extends StatelessWidget {
  final TripModel trip;

  const TripBottomBar({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Price Details
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.perPerson,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                Text(
                  '${trip.price.toInt()} ج.م',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),

            // Booking Action Button using custom AppMainButton component
            Expanded(
              child: AppMainButton(
                txt: AppStrings.bookNow,
                backgroundColor: AppColors.primary,
                onPressed: () {
                  try {
                    context.push(
                      RouteNames.bookingConfirmation,
                      extra: trip,
                    );
                  } catch (_) {}
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
