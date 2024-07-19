import 'package:flutter/material.dart';
import '../models/parking_status.dart';

class ParkingInfoWidget extends StatelessWidget {
  final ParkingStatus status;

  const ParkingInfoWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Available Spots: ${status.availableSpots}',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        Text(
          'Occupied Spots: ${status.occupiedSpots}',
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
