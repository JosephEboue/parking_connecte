import 'package:flutter/material.dart';
import '../services/parking_service.dart';
import '../widgets/parking_info_widget.dart';
import '../models/parking_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<ParkingStatus> futureParkingStatus;

  @override
  void initState() {
    super.initState();
    futureParkingStatus = ParkingService().fetchParkingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Status'),
      ),
      body: Center(
        child: FutureBuilder<ParkingStatus>(
          future: futureParkingStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ParkingInfoWidget(status: snapshot.data!);
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
