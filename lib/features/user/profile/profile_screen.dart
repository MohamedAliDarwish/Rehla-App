// import 'package:go_router/go_router.dart';
// import 'package:material_ui/material_ui.dart';
// import 'package:rehla/core/constants/app_colors.dart';
// import 'package:rehla/core/routes/route_names.dart';
// import 'package:rehla/core/storage/secure_storage_service.dart';
// import 'package:rehla/core/theme/test_styles.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String _userName = 'مستخدم رحلة';
//   String _userEmail = '';
//   String _userPhone = '';
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final userData = await SecureStorageService.instance.getUserData();
//     if (mounted) {
//       setState(() {
//         _userName = userData['fullName'] ?? 'مستخدم رحلة';
//         _userEmail = userData['email'] ?? '';
//         _userPhone = userData['phone'] ?? '';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _logout() async {
//     final shouldLogout = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('تسجيل الخروج'),
//         content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text(
//               'تسجيل خروج',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (shouldLogout == true && mounted) {
//       // Delete token and user data from secure storage
//       await SecureStorageService.instance.logout();
//       if (mounted) {
//         context.go(RouteNames.login);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           'حسابي',
//           style: AppTextStyles.titleMedium.copyWith(
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   // User Avatar
//                   CircleAvatar(
//                     radius: 46,
//                     backgroundColor: AppColors.primary.withValues(alpha: 0.1),
//                     child: const Icon(
//                       Icons.person,
//                       size: 50,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // User Name
//                   Text(
//                     _userName,
//                     style: AppTextStyles.headlineSmall.copyWith(
//                       color: AppColors.textPrimary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   // User Email
//                   if (_userEmail.isNotEmpty)
//                     Text(
//                       _userEmail,
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   if (_userPhone.isNotEmpty)
//                     Text(
//                       _userPhone,
//                       style: AppTextStyles.bodySmall.copyWith(
//                         color: AppColors.textHint,
//                       ),
//                     ),
//                   const SizedBox(height: 32),

//                   // Menu options
//                   _buildMenuItem(
//                     icon: Icons.bookmark_outline,
//                     title: 'حجوزاتي',
//                     onTap: () => context.push(RouteNames.bookingConfirmation),
//                   ),
//                   _buildMenuItem(
//                     icon: Icons.favorite_border,
//                     title: 'المفضلة',
//                     onTap: () {},
//                   ),
//                   _buildMenuItem(
//                     icon: Icons.notifications_none,
//                     title: 'الإشعارات',
//                     onTap: () {},
//                   ),
//                   _buildMenuItem(
//                     icon: Icons.help_outline,
//                     title: 'المساعدة والدعم',
//                     onTap: () {},
//                   ),
//                   const SizedBox(height: 24),

//                   // Logout Button
//                   Material(
//                     color: AppColors.error.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(12),
//                     clipBehavior: Clip.antiAlias,
//                     child: InkWell(
//                       onTap: _logout,
//                       child: Container(
//                         width: double.infinity,
//                         height: 52,
//                         alignment: Alignment.center,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.logout, color: AppColors.error),
//                             const SizedBox(width: 8),
//                             Text(
//                               'تسجيل الخروج',
//                               style: AppTextStyles.titleSmall.copyWith(
//                                 color: AppColors.error,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Material(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(12),
//         clipBehavior: Clip.antiAlias,
//         child: ListTile(
//           leading: Icon(icon, color: AppColors.primary),
//           title: Text(
//             title,
//             style: AppTextStyles.bodyMedium.copyWith(
//               color: AppColors.textPrimary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           trailing: const Icon(
//             Icons.arrow_forward_ios,
//             size: 14,
//             color: AppColors.textHint,
//           ),
//           onTap: onTap,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/admin/widgets/admin_bottom_nav_widget.dart';
import 'package:rehla/features/user/profile/cubit/profile_cubit.dart';
import 'package:rehla/features/user/profile/cubit/profile_states.dart';
import 'package:rehla/features/user/profile/widgets/profile_header.dart';
import 'package:rehla/features/user/profile/widgets/profile_option.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'مستخدم رحلة';
  String _userEmail = '';
  String _userPhone = '';
  bool _isAdmin = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await SecureStorageService.instance.getUserData();
    final isAdmin = await SecureStorageService.instance.isAdmin();
    if (mounted) {
      setState(() {
        _userName = userData['fullName'] ?? 'مستخدم رحلة';
        _userEmail = userData['email'] ?? '';
        _userPhone = userData['phone'] ?? '';
        _isAdmin = isAdmin;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'تسجيل خروج',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

    if (shouldLogout == true && mounted) {
      await SecureStorageService.instance.logout();
      if (mounted) {
        context.go(RouteNames.login);
      }
    if (shouldLogout == true && context.mounted) {
      context.read<ProfileCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            'حسابي',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // User Avatar
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 52,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User Name
                    Text(
                      _userName,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // User Email
                    if (_userEmail.isNotEmpty)
                      Text(
                        _userEmail,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (_userPhone.isNotEmpty)
                      Text(
                        _userPhone,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    const SizedBox(height: 28),

                    // Menu options
                    _buildMenuItem(
                      icon: Icons.bookmark_outline,
                      title: 'حجوزاتي',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: 'المفضلة',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_none,
                      title: 'الإشعارات',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'المساعدة والدعم',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),

                    // Logout Button
                    Material(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _logout,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, color: AppColors.error),
                              const SizedBox(width: 8),
                              Text(
                                'تسجيل الخروج',
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is ProfileLoggedOutState) {
            context.go(RouteNames.login);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'حسابي',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
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
                                title: 'مساعدة والدعم',
                                icon: Icons.help_outline,
                                onTap: () {},
                              ),
                              ProfileOption(
                                title: 'عن التطبيق',
                                icon: Icons.info_outline,
                                onTap: () {},
                              ),
                              const SizedBox(height: 45),
                              SizedBox(
                                width: double.infinity,
                                height: 55,
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
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
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_left_rounded,
            size: 20,
            color: Color(0xFF94A3B8),
          ),
          onTap: onTap,
        ),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
