import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import 'weather_detail_item.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({
    super.key,
    required this.weather,
  });
  @override
  Widget build(BuildContext context) {
    final sunrise = DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chi tiết thời tiết',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                WeatherDetailItem(
                  icon: Icons.water_drop,
                  title: 'Độ ẩm',
                  value: '${weather.humidity}%',
                ),
                WeatherDetailItem(
                  icon: Icons.air,
                  title: 'Gió',
                  value: '${weather.windSpeed} m/s',
                ),
                WeatherDetailItem(
                  icon: Icons.speed,
                  title: 'Áp suất',
                  value: '${weather.pressure} hPa',
                ),
                WeatherDetailItem(
                  icon: Icons.visibility,
                  title: 'Tầm nhìn',
                  value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                ),
                WeatherDetailItem(
                  icon: Icons.cloud,
                  title: 'Mây',
                  value: '${weather.cloudiness}%',
                ),
                WeatherDetailItem(
                  icon: Icons.wb_sunny,
                  title: 'Mặt trời mọc',
                  value: DateFormat('HH:mm').format(sunrise),
                ),
                WeatherDetailItem(
                  icon: Icons.nightlight,
                  title: 'Mặt trời lặn',
                  value: DateFormat('HH:mm').format(sunset),
                ),
                WeatherDetailItem(
                  icon: Icons.thermostat,
                  title: 'Min / Max',
                  value:
                  '${weather.tempMin.round()}°C / ${weather.tempMax.round()}°C',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}