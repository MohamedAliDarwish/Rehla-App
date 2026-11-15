import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/routes/route_names.dart';

import '../cubit/admin_cubit.dart';
import '../cubit/admin_states.dart';
import '../widgets/admin_add_trip_card_widget.dart';
import '../widgets/admin_bookings_list_widget.dart';
import '../widgets/admin_bottom_nav_widget.dart';
import '../widgets/admin_header_widget.dart';
import '../widgets/admin_hero_banner_widget.dart';
import '../widgets/admin_stat_cards_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()..loadDashboardData(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: BlocBuilder<AdminCubit, AdminState>(
              builder: (context, state) {
                if (state is AdminLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (state is AdminErrorState) {
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
                              context.read<AdminCubit>().loadDashboardData(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AdminSuccessState) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<AdminCubit>().loadDashboardData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Header Widget
                          AdminHeaderWidget(
                            adminName: state.adminName,
                            onSettingsPressed: () {},
                            onNotificationsPressed: () {},
                          ),
                          const SizedBox(height: 20),

                          // 2. Hero Activity Banner Widget
                          const AdminHeroBannerWidget(),
                          const SizedBox(height: 24),

                          // 3. Statistics Cards Widget
                          AdminStatCardsWidget(stats: state.stats),
                          const SizedBox(height: 28),

                          // 4. Latest Bookings Widget
                          AdminBookingsListWidget(
                            bookings: state.bookings,
                            onViewAllPressed: () {},
                          ),
                          const SizedBox(height: 28),

                          // 5. Add New Trip Banner Widget
                          AdminAddTripCardWidget(
                            onAddTripPressed: () {
                              context.push(RouteNames.addTrip);
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          bottomNavigationBar: AdminBottomNavWidget(
            selectedIndex: 0,
            onItemTapped: (index) {
              if (index == 0) {
                // Already on dashboard
              } else if (index == 1) {
                context.go(RouteNames.adminBookings);
              } else if (index == 2) {
                context.go(RouteNames.adminTrips);
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
}
