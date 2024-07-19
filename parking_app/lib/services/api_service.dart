// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://192.168.80.251:5000/images';

  Future<List<String>> fetchImageUrls() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> images = data['images'];
      return images.map((item) => item as String).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
