import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/user/home/cubit/home_cubit.dart';
import 'package:rehla/features/user/home/cubit/home_states.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';
import 'package:rehla/features/user/home/widgets/destination_card.dart';

class HomePopularDestinationsWidget extends StatelessWidget {
  const HomePopularDestinationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.trips, style: AppTextStyles.titleMedium),
              GestureDetector(
                onTap: () => context.push(RouteNames.filter),
                child: Text(
                  AppStrings.viewAll,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) =>
              current is HomeTripsLoadingState ||
              current is HomeTripsSuccessState ||
              current is HomeTripsErrorState,
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            if (state is HomeTripsLoadingState ||
                (cubit.isTripsLoading && cubit.trips.isEmpty)) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (cubit.trips.isNotEmpty) {
              return SizedBox(
                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.trips.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final TripModel trip = cubit.trips[index];
                    return DestinationCard(
                      image: trip.coverImage,
                      title: trip.title,
                      price: trip.price.toInt().toString(),
                      onTap: () => context.push(
                        RouteNames.tripDetails,
                        extra: trip.id,
                      ),
                    );
                  },
                ),
              );
            }

            if (state is HomeTripsErrorState) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Text(
                      "حدث خطأ أثناء تحميل الرحلات",
                      style: TextStyle(color: AppColors.error),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.read<HomeCubit>().getAllTrips(),
                      child: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
