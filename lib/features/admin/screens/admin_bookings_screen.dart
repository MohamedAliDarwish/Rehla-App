import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/constants/app_colors.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/core/routes/route_names.dart';
import 'package:rehla/core/theme/test_styles.dart';
import '../models/admin_booking_model.dart';
import '../widgets/admin_bottom_nav_widget.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  String _activeFilter = 'الكل';
  bool _isLoading = true;
  String? _errorMessage;

  final ApiDataSourse _apiDataSourse = ApiDataSourse();
  List<AdminBookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rawList = await _apiDataSourse.getAdminBookings();
      final loaded = rawList.map((item) => AdminBookingModel.fromJson(item)).toList();
      setState(() {
        _bookings = loaded;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
        _isLoading = false;
      });
    }
  }

  int get _countAll => _bookings.length;
  int get _countPending => _bookings.where((b) => b.status == 'بانتظار الرد' || b.status == 'قيد الانتظار').length;
  int get _countAccepted => _bookings.where((b) => b.status == 'مقبولة' || b.status == 'مؤكد').length;
  int get _countRejected => _bookings.where((b) => b.status == 'مرفوضة' || b.status == 'ملغي').length;

  List<AdminBookingModel> get _filteredBookings {
    if (_activeFilter == 'بانتظار الرد') {
      return _bookings.where((b) => b.status == 'بانتظار الرد' || b.status == 'قيد الانتظار').toList();
    } else if (_activeFilter == 'مقبولة') {
      return _bookings.where((b) => b.status == 'مقبولة' || b.status == 'مؤكد').toList();
    } else if (_activeFilter == 'مرفوضة') {
      return _bookings.where((b) => b.status == 'مرفوضة' || b.status == 'ملغي').toList();
    }
    return _bookings;
  }

  Future<void> _updateStatus(String id, String newStatus) async {
    final originalIndex = _bookings.indexWhere((b) => b.id == id);
    if (originalIndex == -1) return;

    final oldBooking = _bookings[originalIndex];
    setState(() {
      _bookings[originalIndex] = oldBooking.copyWith(status: newStatus);
    });

    try {
      await _apiDataSourse.updateBookingStatus(id, newStatus);
    } catch (e) {
      // Revert if API update fails
      if (mounted) {
        setState(() {
          _bookings[originalIndex] = oldBooking;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر تحديث حالة الحجز على السيرفر: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterTabs = [
      {'key': 'الكل', 'label': 'الكل ($_countAll)'},
      {'key': 'بانتظار الرد', 'label': 'بانتظار الرد ($_countPending)'},
      {'key': 'مقبولة', 'label': 'مقبولة ($_countAccepted)'},
      {'key': 'مرفوضة', 'label': 'مرفوضة ($_countRejected)'},
    ];

    return Directionality(
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
            'طلبات الحجز',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
              onPressed: _fetchBookings,
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 12),
            // Horizontal Filter Pills List
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: filterTabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final tab = filterTabs[index];
                  final isSelected = _activeFilter == tab['key'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeFilter = tab['key'] as String;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tab['label'] as String,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Booking Cards List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                style: const TextStyle(color: AppColors.error),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchBookings,
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchBookings,
                          child: _filteredBookings.isEmpty
                              ? Center(
                                  child: Text(
                                    'لا توجد طلبات حجز حالياً',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _filteredBookings.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                                  itemBuilder: (context, index) {
                                    final booking = _filteredBookings[index];
                                    return _buildBookingCard(booking);
                                  },
                                ),
                        ),
            ),
          ],
        ),
        bottomNavigationBar: AdminBottomNavWidget(
          selectedIndex: 1, // Index 1 is "الحجوزات"
          onItemTapped: (index) {
            if (index == 0) {
              context.go(RouteNames.adminDashboard);
            } else if (index == 1) {
              // Already on bookings
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
    );
  }

  Widget _buildBookingCard(AdminBookingModel booking) {
    final isPending = booking.status == 'بانتظار الرد' || booking.status == 'قيد الانتظار';
    final isAccepted = booking.status == 'مقبولة' || booking.status == 'مؤكد';
    final isRejected = booking.status == 'مرفوضة' || booking.status == 'ملغي';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Top Section: User Avatar & Info + Status Badge & 3-dots Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar Circle
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFE2E8F0),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF64748B),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // User Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.userName,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.userEmail,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.userPhone,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge & Menu Dots
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending
                            ? const Color(0xFFFDEED9)
                            : (isAccepted ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E8)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        booking.status,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isPending
                              ? const Color(0xFFD97706)
                              : (isAccepted ? const Color(0xFF166534) : const Color(0xFFDC2626)),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Middle Section: Cover Thumbnail & Details
            Row(
              children: [
                // Destination Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: booking.image.startsWith('http')
                      ? Image.network(
                          booking.image,
                          width: 95,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 95,
                            height: 75,
                            color: const Color(0xFFE2E8F0),
                            child: const Icon(Icons.image, color: Color(0xFF94A3B8)),
                          ),
                        )
                      : Image.asset(
                          booking.image,
                          width: 95,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 95,
                            height: 75,
                            color: const Color(0xFFE2E8F0),
                            child: const Icon(Icons.image, color: Color(0xFF94A3B8)),
                          ),
                        ),
                ),
                const SizedBox(width: 12),

                // Trip Info (Title, Date, Guests, Total Price)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.destination,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking.date,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'عدد الأفراد',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                booking.guests,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'الإجمالي',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                booking.price,
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bottom Action Section
            if (isPending)
              Row(
                children: [
                  // Accept Button (Dark Navy)
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _updateStatus(booking.id, 'مقبولة'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'قبول',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Reject Button (Red Outlined)
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFEF4444)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _updateStatus(booking.id, 'مرفوضة'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.close_rounded, color: Color(0xFFEF4444), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'رفض',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xFFEF4444),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            if (isAccepted)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDCFCE7)),
                ),
                child: Center(
                  child: Text(
                    'تم قبول الطلب وجاري المتابعة',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF166534),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

            if (isRejected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFEE2E8)),
                ),
                child: Center(
                  child: Text(
                    'تم رفض الطلب',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFFDC2626),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
