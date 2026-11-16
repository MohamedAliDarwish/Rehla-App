import 'package:material_ui/material_ui.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/theme/test_styles.dart';

class AdminBottomNavWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final VoidCallback? onCenterButtonPressed;

  const AdminBottomNavWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.onCenterButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Item 0: الرئيسية
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                label: 'الرئيسية',
              ),
              // Item 1: الحجوزات
              _buildNavItem(
                index: 1,
                icon: Icons.calendar_month_outlined,
                label: 'الحجوزات',
              ),
              // Empty space for center floating button
              const SizedBox(width: 56),
              // Item 2: رحلاتي
              _buildNavItem(
                index: 2,
                icon: Icons.business_center_outlined,
                label: 'رحلاتي',
              ),
              // Item 3: حسابي
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'حسابي',
              ),
            ],
          ),
          // Center Floating FAB Button
          Positioned(
            top: -18,
            child: GestureDetector(
              onTap: onCenterButtonPressed,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFFB47C35) : const Color(0xFF64748B);

    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
