import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
  });
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final temp = provider.convertTemperature(weather.temperature).round();
    final feelsLike = provider.convertTemperature(weather.feelsLike).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition, weather.icon),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Text(
            '${weather.cityName}, ${weather.country}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, dd/MM/yyyy HH:mm', 'vi').format(weather.dateTime),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 130,
            placeholder: (context, url) => const CircularProgressIndicator(
              color: Colors.white,
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.cloud,
              size: 100,
              color: Colors.white,
            ),
          ),
          Text(
            '$temp${provider.temperatureSymbol}',
            style: const TextStyle(
              fontSize: 72,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cảm giác như $feelsLike${provider.temperatureSymbol}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await context.read<WeatherProvider>().addCurrentCityToFavorites();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã thêm vào danh sách yêu thích.'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.favorite),
            label: const Text('Yêu thích'),
          ),
        ],
      ),
    );
  }
  LinearGradient _getWeatherGradient(String condition, String icon) {
    final isNight = icon.endsWith('n');

    if (isNight) {
      return const LinearGradient(
        colors: [
          Color(0xFF1A202C),
          Color(0xFF2D3748),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF87CEEB),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return const LinearGradient(
          colors: [
            Color(0xFF4A5568),
            Color(0xFF718096),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case 'clouds':
        return const LinearGradient(
          colors: [
            Color(0xFFA0AEC0),
            Color(0xFFCBD5E0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      default:
        return const LinearGradient(
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}