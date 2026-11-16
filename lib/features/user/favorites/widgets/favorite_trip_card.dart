import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_assets.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/favorites/widgets/favorite_button.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

class FavoriteTripCard extends StatelessWidget {
  final TripModel trip;

  const FavoriteTripCard({super.key, required this.trip});

  Widget _buildImage() {
    const double width = 86;
    const double height = 108;
    if (trip.coverImage.startsWith('http')) {
      return Image.network(
        trip.coverImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          AppAssets.destLuxor,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      AppAssets.destLuxor,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = trip.days.isNotEmpty ? trip.days.length : 1;

    return InkWell(
      onTap: () => context.push('${RouteNames.tripDetails}/${trip.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: _buildImage(),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: FavoriteButton(trip: trip, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    trip.destination,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$days ${AppStrings.daysCount}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.secondary,
                        size: 17,
                      ),
                      Text(
                        ' ${trip.averageRating.toStringAsFixed(1)}'
                        '${trip.reviewsCount > 0 ? ' (${trip.reviewsCount})' : ''}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '${trip.price.toInt()} ج.م',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}