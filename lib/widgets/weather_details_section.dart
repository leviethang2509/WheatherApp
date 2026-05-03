import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import 'weather_detail_item.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final sunrise = DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000);
    final min = provider.convertTemperature(weather.tempMin).round();
    final max = provider.convertTemperature(weather.tempMax).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chi tiết thời tiết',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                WeatherDetailItem(
                  icon: Icons.water_drop_rounded,
                  title: 'Độ ẩm',
                  value: '${weather.humidity}%',
                ),
                WeatherDetailItem(
                  icon: Icons.air_rounded,
                  title: 'Tốc độ gió',
                  value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                ),
                WeatherDetailItem(
                  icon: Icons.speed_rounded,
                  title: 'Áp suất',
                  value: '${weather.pressure} hPa',
                ),
                WeatherDetailItem(
                  icon: Icons.visibility_rounded,
                  title: 'Tầm nhìn',
                  value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                ),
                WeatherDetailItem(
                  icon: Icons.cloud_rounded,
                  title: 'Mây',
                  value: '${weather.cloudiness}%',
                ),
                WeatherDetailItem(
                  icon: Icons.wb_twilight_rounded,
                  title: 'Mặt trời mọc',
                  value: DateFormat('HH:mm').format(sunrise),
                ),
                WeatherDetailItem(
                  icon: Icons.nightlight_round,
                  title: 'Mặt trời lặn',
                  value: DateFormat('HH:mm').format(sunset),
                ),
                WeatherDetailItem(
                  icon: Icons.thermostat_rounded,
                  title: 'Min / Max',
                  value: '$min / $max${provider.temperatureSymbol}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
