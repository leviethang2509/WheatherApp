import 'package:flutter/material.dart';

class WeatherTheme {
  final LinearGradient gradient;
  final Color accent;
  final Color surface;
  final Color textOnGradient;
  final IconData icon;

  const WeatherTheme({
    required this.gradient,
    required this.accent,
    required this.surface,
    required this.textOnGradient,
    required this.icon,
  });
}

WeatherTheme themeForWeather(String condition, String iconCode) {
  final isNight = iconCode.endsWith('n');

  if (isNight) {
    return const WeatherTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF101827), Color(0xFF2D3748)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      accent: Color(0xFF90CDF4),
      surface: Color(0xFFF7FAFC),
      textOnGradient: Colors.white,
      icon: Icons.nights_stay_rounded,
    );
  }

  switch (condition.toLowerCase()) {
    case 'clear':
      return const WeatherTheme(
        gradient: LinearGradient(
          colors: [Color(0xFFFDB813), Color(0xFF87CEEB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        accent: Color(0xFFF6AD55),
        surface: Color(0xFFFFFBEB),
        textOnGradient: Colors.white,
        icon: Icons.wb_sunny_rounded,
      );
    case 'rain':
    case 'drizzle':
    case 'thunderstorm':
      return const WeatherTheme(
        gradient: LinearGradient(
          colors: [Color(0xFF4A5568), Color(0xFF718096)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        accent: Color(0xFF63B3ED),
        surface: Color(0xFFF1F5F9),
        textOnGradient: Colors.white,
        icon: Icons.water_drop_rounded,
      );
    case 'clouds':
      return const WeatherTheme(
        gradient: LinearGradient(
          colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        accent: Color(0xFF718096),
        surface: Color(0xFFF8FAFC),
        textOnGradient: Color(0xFF1A202C),
        icon: Icons.cloud_rounded,
      );
    case 'snow':
      return const WeatherTheme(
        gradient: LinearGradient(
          colors: [Color(0xFFBEE3F8), Color(0xFFE2E8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        accent: Color(0xFF4299E1),
        surface: Color(0xFFF7FAFC),
        textOnGradient: Color(0xFF1A202C),
        icon: Icons.ac_unit_rounded,
      );
    default:
      return const WeatherTheme(
        gradient: LinearGradient(
          colors: [Color(0xFF38B2AC), Color(0xFF4299E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        accent: Color(0xFF319795),
        surface: Color(0xFFF0FDFA),
        textOnGradient: Colors.white,
        icon: Icons.thermostat_rounded,
      );
  }
}
