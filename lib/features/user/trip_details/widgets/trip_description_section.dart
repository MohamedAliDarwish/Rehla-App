import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';

class TripDescriptionSection extends StatelessWidget {
  final String description;

  const TripDescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    if (description.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.overview,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
