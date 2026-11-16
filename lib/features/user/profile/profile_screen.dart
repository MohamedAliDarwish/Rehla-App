import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/storage/secure_storage_service.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/admin/widgets/admin_bottom_nav_widget.dart';
import 'package:rehla/features/user/profile/cubit/profile_cubit.dart';
import 'package:rehla/features/user/profile/cubit/profile_states.dart';
import 'package:rehla/features/user/profile/widgets/profile_header.dart';
import 'package:rehla/features/user/profile/widgets/profile_option.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await SecureStorageService.instance.isAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'تسجيل خروج',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<ProfileCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is ProfileLoggedOutState) {
            context.go(RouteNames.login);
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                title: Text(
                  'حسابي',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: state is ProfileLoadedState
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ProfileHeader(
                            name: state.name,
                            email: state.email,
                            phone: state.phone,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                ProfileOption(
                                  title: 'البيانات الشخصية',
                                  icon: Icons.person_outline,
                                  onTap: () {},
                                ),
                                ProfileOption(
                                  title: 'تعديل الحساب',
                                  icon: Icons.edit_outlined,
                                  onTap: () {},
                                ),
                                ProfileOption(
                                  title: 'تغيير كلمة المرور',
                                  icon: Icons.lock_outline,
                                  onTap: () {},
                                ),
                                ProfileOption(
                                  title: 'المساعدة والدعم',
                                  icon: Icons.help_outline,
                                  onTap: () {},
                                ),
                                ProfileOption(
                                  title: 'عن التطبيق',
                                  icon: Icons.info_outline,
                                  onTap: () {},
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _confirmLogout(context),
                                    icon: const Icon(
                                      Icons.logout,
                                      color: AppColors.error,
                                    ),
                                    label: Text(
                                      'تسجيل الخروج',
                                      style: AppTextStyles.titleSmall.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.error.withValues(
                                        alpha: 0.08,
                                      ),
                                      side: BorderSide(
                                        color: AppColors.error.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
              bottomNavigationBar: _isAdmin
                  ? AdminBottomNavWidget(
                      selectedIndex: 3,
                      onItemTapped: (index) {
                        if (index == 0) {
                          context.go(RouteNames.adminDashboard);
                        } else if (index == 1) {
                          context.go(RouteNames.adminBookings);
                        } else if (index == 2) {
                          context.go(RouteNames.adminTrips);
                        } else if (index == 3) {
                          // Already on profile
                        }
                      },
                      onCenterButtonPressed: () {
                        context.push(RouteNames.addTrip);
                      },
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
