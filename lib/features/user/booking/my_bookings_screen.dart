import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_cubit.dart';
import 'booking_states.dart';
import 'trip_model.dart';
import 'booking_details_screen.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCubit()..getTrips(),
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          var cubit = BookingCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: const Text('حجوزاتي', style: TextStyle(color: Colors.black)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cubit.filters.length,
                    itemBuilder: (context, index) {
                      bool isSelected = cubit.selectedFilterIndex == index;
                      return GestureDetector(
                        onTap: () => cubit.changeFilter(index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1E2843) : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              cubit.filters[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: _buildTripsList(state, cubit.allTrips),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripsList(BookingState state, List<TripModel> trips) {
    if (state is GetTripsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state is GetTripsError) {
      return Center(child: Text(state.error));
    }

    if (trips.isEmpty) {
      return const Center(child: Text('لا توجد حجوزات'));
    }

    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return BookingCardWidget(trip: trips[index]);
      },
    );
  }
}

class BookingCardWidget extends StatelessWidget {
  final TripModel trip;

  const BookingCardWidget({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${trip.startDate} - ${trip.endDate}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        trip.status,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(trip: trip),
                      ),
                    );
                  },
                  child: const Text('التفاصيل'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('السعر', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      '${trip.price} ج.م',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}