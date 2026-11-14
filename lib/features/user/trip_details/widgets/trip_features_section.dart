import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';

class TripFeaturesSection extends StatelessWidget {
  final List<String> included;
  final List<String> excluded;

  const TripFeaturesSection({
    super.key,
    required this.included,
    required this.excluded,
  });

  Widget _buildListSection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (included.isEmpty && excluded.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (included.isNotEmpty) ...[
            _buildListSection(
              title: AppStrings.includedServices,
              items: included,
              icon: Icons.check,
              iconColor: AppColors.success,
              bgColor: AppColors.success.withValues(alpha: 0.12),
            ),
            const SizedBox(height: 16),
          ],
          if (excluded.isNotEmpty) ...[
            _buildListSection(
              title: AppStrings.excludedServices,
              items: excluded,
              icon: Icons.close,
              iconColor: AppColors.error,
              bgColor: AppColors.error.withValues(alpha: 0.12),
            ),
          ],
        ],
      ),
    );
  }
}
