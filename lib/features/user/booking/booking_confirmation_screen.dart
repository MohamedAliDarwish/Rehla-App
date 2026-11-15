import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/booking_cubit.dart';
import 'cubit/booking_states.dart';
import 'model/trip_model.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final TripModel trip;
  final TextEditingController notesController = TextEditingController();

  BookingConfirmationScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('تأكيد الحجز', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          var cubit = BookingCubit.get(context);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTripHeader(),
                const SizedBox(height: 20),
                _buildPeopleCounter(cubit),
                const SizedBox(height: 20),
                _buildNotesField(),
                const SizedBox(height: 20),
                _buildPriceSummary(cubit),
                const SizedBox(height: 30),
                BlocConsumer<BookingCubit, BookingState>(
                  listener: (context, state) {
                    if (state is BookTripSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تأكيد الحجز بنجاح!'), backgroundColor: Colors.green),
                      );
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else if (state is BookTripError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E2843),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: state is BookTripLoading
                            ? null
                            : () {
                                cubit.confirmBooking(
                                  tripId: trip.title, 
                                  notes: notesController.text,
                                );
                              },
                        child: state is BookTripLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('تأكيد الحجز', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'بتأكيدك أنت توافق على سياسة الحجز والإلغاء الخاصة بنا',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        },
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

  Widget _buildPeopleCounter(BookingCubit cubit) {
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
          const Text('عدد الأفراد', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => cubit.changePeopleCount(true),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add),
                ),
              ),
              Column(
                children: [
                  Text('${cubit.peopleCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('${cubit.pricePerPerson} ج.م / للفرد', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              InkWell(
                onTap: () => cubit.changePeopleCount(false),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.remove),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ملاحظات خاصة (اختياري)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'أي طلبات أو متطلبات خاصة...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(BookingCubit cubit) {
    double total = cubit.peopleCount * cubit.pricePerPerson;
    
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
          const Text('ملخص السعر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تكلفة الرحلة (${cubit.peopleCount} × ${cubit.pricePerPerson})', style: const TextStyle(color: Colors.grey)),
              Text('$total ج.م'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('رسوم الخدمة', style: TextStyle(color: Colors.grey)),
              Text('0 ج.م'),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('السعر النهائي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('$total ج.م', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}