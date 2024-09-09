import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = ''; // API key.
  final String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final int statusCodeOK = 200;

  // Fetch weather data for given latitude and longitude
  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'), // Sending HTTP GET request to OpenWeather API.
    );

    // debugging
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    // Check if the request was successful
    if (response.statusCode == statusCodeOK) {
      final data = jsonDecode(response.body); // Decode the JSON response body
      
      // Extract necessary fields from the response.
      final cityName = data['name'];
      final country = data['sys']['country'];
      final temperature = data['main']['temp'];
      final weatherDescription = data['weather'][0]['description'];
      final icon = data['weather'][0]['icon']; // Get the icon/image code.
      final date = DateTime.now();

      // Return a map containing the weather information.
      return {
        'cityName': '$cityName, $country',
        'temperature': temperature, 
        'weatherDescription': weatherDescription,
        'icon': icon,
        'date': date.toString(),
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
