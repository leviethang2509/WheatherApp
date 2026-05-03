import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../utils/weather_theme.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final temp = provider.convertTemperature(weather.temperature).round();
    final feelsLike = provider.convertTemperature(weather.feelsLike).round();
    final min = provider.convertTemperature(weather.tempMin).round();
    final max = provider.convertTemperature(weather.tempMax).round();
    final theme = themeForWeather(weather.mainCondition, weather.icon);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: BoxDecoration(
        gradient: theme.gradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accent.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(theme.icon, color: theme.textOnGradient, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.cityName}, ${weather.country}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 28,
                          color: theme.textOnGradient,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'EEEE, dd/MM/yyyy - HH:mm',
                          'vi',
                        ).format(weather.dateTime),
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textOnGradient.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$temp${provider.temperatureSymbol}',
                        style: TextStyle(
                          fontSize: 72,
                          height: 0.95,
                          color: theme.textOnGradient,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.description.toUpperCase(),
                        style: TextStyle(
                          color: theme.textOnGradient,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Cảm giác như $feelsLike${provider.temperatureSymbol}',
                        style: TextStyle(
                          color: theme.textOnGradient.withValues(alpha: 0.82),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                CachedNetworkImage(
                  imageUrl:
                      'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                  height: 132,
                  placeholder: (context, url) => SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      color: theme.textOnGradient,
                      strokeWidth: 3,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.cloud_rounded,
                    size: 92,
                    color: theme.textOnGradient,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
              ),
              child: Row(
                children: [
                  _SummaryItem(
                    icon: Icons.thermostat_rounded,
                    label: 'Thấp / cao',
                    value: '$min / $max${provider.temperatureSymbol}',
                    textColor: theme.textOnGradient,
                  ),
                  _SummaryItem(
                    icon: Icons.water_drop_rounded,
                    label: 'Độ ẩm',
                    value: '${weather.humidity}%',
                    textColor: theme.textOnGradient,
                  ),
                  _SummaryItem(
                    icon: Icons.air_rounded,
                    label: 'Gió',
                    value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                    textColor: theme.textOnGradient,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.accent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  await context
                      .read<WeatherProvider>()
                      .addCurrentCityToFavorites();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Đã thêm thành phố vào danh sách yêu thích.',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.favorite_rounded),
                label: const Text('Lưu thành phố yêu thích'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.76),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
