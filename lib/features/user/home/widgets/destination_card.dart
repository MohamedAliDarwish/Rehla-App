import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_assets.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';

class DestinationCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String? tripId;
  final VoidCallback? onTap;

  const DestinationCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.tripId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage =
        image.startsWith('http://') || image.startsWith('https://');

    return GestureDetector(
      onTap: onTap ??
          () {
            try {
              if (tripId != null && tripId!.isNotEmpty) {
                context.push(RouteNames.tripDetails, extra: tripId);
              } else {
                context.push(RouteNames.tripDetails);
              }
            } catch (_) {}
          },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: isNetworkImage
                      ? Image.network(
                          image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            AppAssets.destLuxor,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          image.isNotEmpty ? image : AppAssets.destLuxor,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            AppAssets.destLuxor,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price.contains('ج.م') ? price : '$price ج.م',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.favorite_border,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
