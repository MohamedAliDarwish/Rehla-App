import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';

import '../cubit/admin_trips_cubit.dart';
import '../cubit/admin_trips_states.dart';

import '../widgets/admin_bottom_nav_widget.dart';
import '../widgets/admin_trip_card_widget.dart';

class AdminTripsScreen extends StatefulWidget {
  const AdminTripsScreen({super.key});

  @override
  State<AdminTripsScreen> createState() => _AdminTripsScreenState();
}

class _AdminTripsScreenState extends State<AdminTripsScreen> {
  final List<String> _tabs = ['مسودة', 'غير منشورة', 'منشورة', 'الكل'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminTripsCubit()..loadTrips(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primary),
              onPressed: () {},
            ),
            title: Text(
              'رحلاتي',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.tune, color: AppColors.primary),
                onPressed: () {},
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  context.push(RouteNames.addTrip);
                },
                backgroundColor: AppColors.primary,
                elevation: 6,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              );
            },
          ),
          body: BlocBuilder<AdminTripsCubit, AdminTripsState>(
            builder: (context, state) {
              if (state is AdminTripsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (state is AdminTripsErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage,
                        style: const TextStyle(color: AppColors.error),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<AdminTripsCubit>().loadTrips(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              if (state is AdminTripsSuccessState) {
                return Column(
                  children: [
                    // Tabs Bar
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _tabs.map((tab) {
                          final isSelected = state.activeTab == tab;
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<AdminTripsCubit>()
                                  .filterByTab(tab);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: isSelected
                                    ? const Border(
                                        bottom: BorderSide(
                                          color: AppColors.primary,
                                          width: 3.0,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Text(
                                tab,
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFF64748B),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Trips List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () =>
                            context.read<AdminTripsCubit>().loadTrips(),
                        child: state.filteredTrips.isEmpty
                            ? Center(
                                child: Text(
                                  'لا توجد رحلات حالياً',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                                itemCount: state.filteredTrips.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final trip = state.filteredTrips[index];
                                  return AdminTripCardWidget(
                                    trip: trip,
                                    onViewPressed: () {
                                      context.push(
                                        '${RouteNames.tripDetails}/${trip.id}',
                                      );
                                    },
                                    onPublishTogglePressed: () {
                                      context
                                          .read<AdminTripsCubit>()
                                          .togglePublishTrip(trip);
                                    },
                                    onDeletePressed: () {
                                      _showDeleteDialog(context, trip.id);
                                    },
                                    onEditPressed: () {
                                      context.push(RouteNames.addTrip);
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar: AdminBottomNavWidget(
            selectedIndex: 2, // Index 2 is "رحلاتي"
            onItemTapped: (index) {
              if (index == 0) {
                context.go(RouteNames.adminDashboard);
              } else if (index == 1) {
                context.go(RouteNames.adminBookings);
              } else if (index == 2) {
                // Already on trips
              } else if (index == 3) {
                context.go(RouteNames.profile);
              }
            },
            onCenterButtonPressed: () {
              context.push(RouteNames.addTrip);
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String tripId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('حذف الرحلة'),
            content: const Text('هل أنت متأكد من رغبتك في حذف هذه الرحلة؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AdminTripsCubit>().deleteTrip(tripId);
                },
                child: const Text(
                  'حذف',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
