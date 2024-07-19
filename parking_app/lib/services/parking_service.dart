import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/parking_status.dart';

class ParkingService {
  final String apiUrl = 'http://192.168.80.251/status';

  Future<ParkingStatus> fetchParkingStatus() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return ParkingStatus.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load parking status');
    }
  }
}
