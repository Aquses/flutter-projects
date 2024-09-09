import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Color.fromARGB(255, 255, 204, 128)],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildInfoCard(
              title: 'Project Weather App',
              content:
                  'This is an app that is developed for the course 1DV535 at Linnaeus University using Flutter and the OpenWeatherMap API.',
              titleFontSize: 35,
              contentFontSize: 16,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              title: 'Developed by Eldaras Zutautas',
              titleFontSize: 18,
            ),
            const SizedBox(height: 20),
            _buildProfileImage(),
          ],
        ),
      ),
    );
  }

  // Builds the information card with a title and optional content.
  Widget _buildInfoCard({
    required String title,
    String? content,
    double titleFontSize = 18,
    double contentFontSize = 14,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (content != null) ...[
              const SizedBox(height: 10),
              Text(
                content,
                style: GoogleFonts.lato(
                  fontSize: contentFontSize,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Builds the profile image widget with a circular border.
  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/chud.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
