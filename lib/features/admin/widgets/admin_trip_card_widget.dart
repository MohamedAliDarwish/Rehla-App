import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_assets.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/theme/test_styles.dart';
import '../models/admin_trip_model.dart';

class AdminTripCardWidget extends StatelessWidget {
  final AdminTripModel trip;
  final VoidCallback? onViewPressed;
  final VoidCallback? onPublishTogglePressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onEditPressed;

  const AdminTripCardWidget({
    super.key,
    required this.trip,
    this.onViewPressed,
    this.onPublishTogglePressed,
    this.onDeletePressed,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isPublished = trip.status == 'منشورة' || trip.isPublished;
    final isDraft = trip.status == 'مسودة';

    ImageProvider imageProvider;
    if (trip.coverImage.startsWith('assets/')) {
      imageProvider = AssetImage(trip.coverImage);
    } else if (trip.coverImage.startsWith('http')) {
      imageProvider = NetworkImage(trip.coverImage);
    } else {
      imageProvider = const AssetImage(AppAssets.destHurghada);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Part: Image & Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Destination Thumbnail Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: imageProvider,
                    width: 105,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppAssets.destHurghada,
                      width: 105,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Trip Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Menu Dots next to it
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              trip.title,
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.more_vert,
                            color: Color(0xFF64748B),
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Duration
                      Text(
                        trip.duration,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Status Badge & Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Status Badge Pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isDraft
                                  ? const Color(0xFFF1F5F9)
                                  : (isPublished
                                      ? const Color(0xFFFDEED9)
                                      : const Color(0xFFE2E8F0)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              trip.status,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDraft
                                    ? const Color(0xFF64748B)
                                    : (isPublished
                                        ? const Color(0xFFD97706)
                                        : const Color(0xFF475569)),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          // Price Text
                          Text(
                            trip.price,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          // Bottom Action Bar (4 Action Buttons)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 1. View / عرض
                _buildActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  label: 'عرض',
                  color: const Color(0xFF475569),
                  onTap: onViewPressed,
                ),
                // 2. Publish / Republish / إعادة نشر أو نشر
                _buildActionButton(
                  icon: isPublished
                      ? Icons.refresh_rounded
                      : Icons.file_upload_outlined,
                  label: isPublished ? 'إعادة نشر' : 'نشر',
                  color: const Color(0xFF475569),
                  onTap: onPublishTogglePressed,
                ),
                // 3. Delete / حذف
                _buildActionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'حذف',
                  color: const Color(0xFFEF4444),
                  onTap: onDeletePressed,
                ),
                // 4. Edit / تعديل
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  label: 'تعديل',
                  color: const Color(0xFF475569),
                  onTap: onEditPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
