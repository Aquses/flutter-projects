import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  final String apiKey = '62e47556fc70712964376cf2179987ae';
  Map<String, List> forecastDataByDay = {};
  String city = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentLocation();
  }

  // Checks for location permissions and gets the current position of the users mobile.
  Future<void> fetchCurrentLocation() async {
    if (!await _isLocationServiceEnabled()) return;
    final permission = await _checkLocationPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    fetchForecast(position.latitude, position.longitude);
  }

  // Function to check, if location services are enabled.
  Future<bool> _isLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Location services are disabled.');
    }
    return serviceEnabled;
  }

  // Checks and requests location permissions.
  Future<LocationPermission> _checkLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return permission;
  }

  // Function that fetches the forecast data from OpenWeather API.
  Future<void> fetchForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        city = data['city']['name'];
        forecastDataByDay = _groupForecastByDay(data['list']);
      });
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // Groups the forecast data by day.
  Map<String, List> _groupForecastByDay(List data) {
    final Map<String, List> groupedData = {};

    for (var item in data) {
      final dateTime = DateTime.parse(item['dt_txt']);
      final day = DateFormat('EEEE').format(dateTime);

      if (!groupedData.containsKey(day)) {
        groupedData[day] = [];
      }
      groupedData[day]!.add(item);
    }
    return groupedData;
  }

  // Function that formats the time from a date string.
  String _formatTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return DateFormat('HH:mm').format(dt);
  }

  // Simple function that capitalizes the first letter of a weather description.
  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Color.fromARGB(255, 255, 204, 128)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            if (city.isNotEmpty) _buildCityText(),
            Expanded(
              child: ListView.builder(
                itemCount: forecastDataByDay.keys.length,
                itemBuilder: (context, index) {
                  final day = forecastDataByDay.keys.elementAt(index);
                  final dayForecast = forecastDataByDay[day]!;
                  return _buildForecastCard(day, dayForecast);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the widget that displays the city name.
  Widget _buildCityText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        city,
        style: GoogleFonts.lato(
            fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Builds a card widget displaying the weather forecast for specific day.
  // Each card includes the day of the week and a list of weather data points.
  Widget _buildForecastCard(String day, List dayForecast) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        color: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: GoogleFonts.lato(
                    fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...dayForecast.map((item) => _buildForecastRow(item)), // triple dots are spread operator, without them does not work lol.
            ],
          ),
        ),
      ),
    );
  }
  
  // Builds a row widget displaying a single weather data point.
  // The row includes an icon representing the weather condition, the time of the forecast, 
  // the temperature, and a description of the weather.
  Widget _buildForecastRow(dynamic item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'http://openweathermap.org/img/wn/${item['weather'][0]['icon']}@2x.png',
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTime(item['dt_txt']),
                style: GoogleFonts.lato(
                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '${item['main']['temp'].toStringAsFixed(1)} °C - ${_capitalize(item['weather'][0]['description'])}',
                style: GoogleFonts.lato(
                    fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
