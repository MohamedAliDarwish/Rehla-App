import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/storage/secure_storage_service.dart';
import 'package:rehla/core/theme/test_styles.dart';
import 'package:rehla/features/admin/widgets/admin_bottom_nav_widget.dart';

class ProfileScreen extends StatefulWidget {
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
                            ],
                          ),
                        ),
                      ),
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
      ),
    );
  }
}
