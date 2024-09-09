import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherController extends StatefulWidget {
  const WeatherController({super.key});

  @override
  _WeatherControllerState createState() => _WeatherControllerState();
}

class _WeatherControllerState extends State<WeatherController> {
  String location = '';
  String temperature = '';
  String time = '';
  String description = '';
  String iconUrl = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  // Fetches weather data for the current location using the device's GPS coordinates.
  Future<void> _getCurrentLocationWeather() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _updateLocationState('Location permission denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      WeatherService weatherService = WeatherService();
      Map<String, dynamic> weatherData = await weatherService.fetchWeather(position.latitude, position.longitude);

      _updateWeatherState(weatherData);
    } catch (e) {
      _handleWeatherError();
    }
  }

  // Updates the location-related state variables when the location is unavailable or denied.
  // This sets default values for other state variables like temperature, time, description, and iconUrl.
  void _updateLocationState(String message) {
    setState(() {
      location = message;
      temperature = '';
      time = '';
      description = '';
      iconUrl = '';
    });
  }

  // Updates the state with the fetched weather data, including location, temperature, time,
    // weather description, and the weather icon. It also formats the date and time properly.
  void _updateWeatherState(Map<String, dynamic> weatherData) {
    var dateTime = DateTime.parse(weatherData['date'] ?? DateTime.now().toString());
    var formattedDateTime = DateFormat('EEE, MMM d, yyyy, HH:mm').format(dateTime);

    setState(() {
      location = weatherData['cityName'];
      temperature = weatherData['temperature'].round().toString();
      time = formattedDateTime;
      description = _capitalizeFirstLetter(weatherData['weatherDescription'] ?? 'No Description');
      String icon = weatherData['icon'] ?? '01d';
      iconUrl = 'http://openweathermap.org/img/wn/$icon@4x.png';
    });
  }

  // Handles errors that occur while fetching weather data by updating the state,
  // with a default error message and clearing other weather-related data.
  void _handleWeatherError() {
    setState(() { 
      location = 'Error fetching data';
      temperature = '';
      time = '';
      description = '';
      iconUrl = '';
    });
  }

  // Function to capitalize the first letter of a weather description.
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  // A simple function that will return a string with time greeting based on local time.
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon!';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening!';
    } else {
      return 'Good Night!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getGreeting(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: _buildWeatherBody(),
    );
  }

  // Builds the main weather information container with a gradient background.
  // It conditionally displays weather-related widgets such as the icon, description,
  // location, time, and temperature, based on whether the corresponding data is available.
  Widget _buildWeatherBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange, Color.fromARGB(255, 255, 204, 128)],
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconUrl.isNotEmpty) _buildWeatherIcon(),
            if (description.isNotEmpty) _buildWeatherDescription(),
            if (location.isNotEmpty) _buildLocation(),
            if (time.isNotEmpty) _buildTime(),
            if (temperature.isNotEmpty) _buildTemperature(),
          ],
        ),
      ),
    );
  }

  // Builds and returns a widget displaying the weather icon.
  Widget _buildWeatherIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Image.network(iconUrl),
    );
  }

  // Builds and returns a widget displaying the weather description.
  Widget _buildWeatherDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        description,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Builds and returns a widget displaying the location name.
  Widget _buildLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        location,
        style: GoogleFonts.lato(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Builds and returns a widget displaying the formatted date and time.
  Widget _buildTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        time,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Builds and returns a widget displaying the current temperature.
  Widget _buildTemperature() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$temperature°C',
        style: GoogleFonts.lato(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
