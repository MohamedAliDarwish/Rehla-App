import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/constants/app_strings.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/core/widgets/app_button.dart';
import 'package:rehla/features/user/trip_details/cubit/trip_details_cubit.dart';
import 'package:rehla/features/user/trip_details/cubit/trip_details_states.dart';
import 'package:rehla/features/user/trip_details/widgets/trip_bottom_bar.dart';
import 'package:rehla/features/user/trip_details/widgets/trip_cancellation_section.dart';
import 'package:rehla/features/user/trip_details/widgets/trip_description_section.dart';
import 'package:rehla/features/user/trip_details/widgets/trip_features_section.dart';
import 'package:rehla/features/user/trip_details/widgets/trip_image_header.dart';
import 'package:rehla/features/user/trip_details/widgets/trip_info_section.dart';
import 'package:rehla/features/user/trip_details/widgets/trip_itinerary_section.dart';

class TripDetailsScreen extends StatelessWidget {
  final String tripId;

  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripDetailsCubit()..getTripDetails(tripId),
      child: _TripDetailsView(tripId: tripId),
    );
  }
}

class _TripDetailsView extends StatelessWidget {
  final String tripId;

  const _TripDetailsView({required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<TripDetailsCubit, TripDetailsStates>(
        builder: (context, state) {
          if (state is TripDetailsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TripDetailsErrorState) {
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 60,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      AppMainButton(
                        txt: AppStrings.retry,
                        onPressed: () {
                          context.read<TripDetailsCubit>().getTripDetails(
                            tripId,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'الرجوع للخلف',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is TripDetailsSuccessState) {
            final trip = state.trip;
            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TripImageHeader(trip: trip),
                        TripInfoSection(trip: trip),
                        TripDescriptionSection(description: trip.description),
                        TripItinerarySection(days: trip.days),
                        TripFeaturesSection(
                          included: trip.included,
                          excluded: trip.excluded,
                        ),
                        TripCancellationSection(
                          cancelPolicy: trip.cancelPolicy,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: TripBottomBar(trip: trip),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
