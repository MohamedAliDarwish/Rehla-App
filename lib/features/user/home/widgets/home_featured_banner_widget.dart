import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_assets.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/home/cubit/home_cubit.dart';
import 'package:rehla/features/user/home/cubit/home_states.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

class HomeFeaturedBannerWidget extends StatelessWidget {
  const HomeFeaturedBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeTripsLoadingState ||
          current is HomeTripsSuccessState ||
          current is HomeTripsErrorState,
      builder: (context, state) {
        final trips = context.read<HomeCubit>().trips;
        if (trips.isEmpty) return const SizedBox.shrink();

        return _FeaturedTripBanner(trip: trips.last);
      },
    );
  }
}

class _FeaturedTripBanner extends StatelessWidget {
  const _FeaturedTripBanner({required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final durationDays = trip.days.length;
    final durationText = durationDays > 0
        ? '$durationDays أيام / ${durationDays - 1} ليلة'
        : trip.startDate.isNotEmpty
        ? trip.startDate.split('T').first
        : 'رحلة مميزة';
    final ImageProvider<Object> image =
        trip.coverImage.startsWith('http://') ||
            trip.coverImage.startsWith('https://')
        ? NetworkImage(trip.coverImage)
        : const AssetImage(AppAssets.homeFeatured);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => context.push(RouteNames.tripDetails, extra: trip.id),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        trip.destination.isNotEmpty
                            ? trip.destination
                            : trip.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              durationText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            color: AppColors.secondary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            trip.averageRating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${trip.price.toInt()} ج.م',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          minimumSize: const Size(0, 32),
                        ),
                        onPressed: () {},
                        child: Text(
                          AppStrings.bookNow,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
