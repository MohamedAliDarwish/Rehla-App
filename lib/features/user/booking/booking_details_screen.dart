import 'package:material_ui/material_ui.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';
import 'booking_confirmation_screen.dart';
import 'cubit/booking_cubit.dart';


class BookingDetailsScreen extends StatelessWidget {
  final TripModel trip;

  const BookingDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('تفاصيل الحجز', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTripHeader(),
            const SizedBox(height: 20),
            _buildBookingData(),
            const SizedBox(height: 20),
            _buildTripData(),
            const SizedBox(height: 30),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTripHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            trip.coverImage.isNotEmpty ? trip.coverImage : 'https://via.placeholder.com/80',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${trip.startDate} - ${trip.endDate}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingData() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('بيانات الحجز', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
          const Divider(),
          _buildInfoRow('رقم الحجز', '#TRP-250620'),
          _buildInfoRow('تاريخ الحجز', '15 يونيو 2025'),
          _buildInfoRow('الحالة', 'مؤكد', valueColor: Colors.orange),
          _buildInfoRow('الأفراد', '2 بالغين'),
          _buildInfoRow('طريقة الدفع', 'بطاقة بنكية'),
          const Divider(),
          _buildInfoRow('السعر الإجمالي', '${trip.price} ج.م', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildTripData() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('بيانات الرحلة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
          const Divider(),
          _buildInfoRow('الوجهة', trip.destination),
          _buildInfoRow('تواريخ الرحلة', '${trip.startDate} - ${trip.endDate}'),
          _buildInfoRow('نقطة التجمع', trip.from),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {Color? valueColor, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: isTotal ? Colors.black : Colors.grey, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: const Text('إلغاء الحجز', style: TextStyle(color: Colors.red, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E2843),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              BookingCubit.get(context).setBasePrice(trip.price);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingConfirmationScreen(trip: trip),
                ),
              );
            },
            child: const Text('تأكيد الحجز', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}