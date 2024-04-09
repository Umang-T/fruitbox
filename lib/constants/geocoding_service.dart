import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  static const String _apiKey = '42a2620265f2351cfd0044f1c216c5a4d4fa10d';

  Future<String?> getAddress(double latitude, double longitude) async {
    final String apiUrl =
        'https://api.geocod.io/v1.6/reverse?q=$latitude,$longitude&api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract relevant address components
        final List<dynamic> results = data['results'];
        if (results.isNotEmpty) {
          final Map<String, dynamic> addressComponents =
          results[0]['address_components'];
          final String formattedAddress = formatAddress(addressComponents);
          return formattedAddress;
        } else {
          print('No address found for the given coordinates');
          return null;
        }
      } else {
        print('Failed to fetch address: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching address: $e');
      return null;
    }
  }

  String formatAddress(Map<String, dynamic> addressComponents) {
    // Example: Format the address using relevant components
    String formattedAddress = '';
    final String street = addressComponents['street'];
    final String city = addressComponents['city'];
    final String state = addressComponents['state'];
    final String zip = addressComponents['zip'];
    final String country = addressComponents['country'];

    formattedAddress = '$street, $city, $state, $zip, $country';

    return formattedAddress;
  }
}
