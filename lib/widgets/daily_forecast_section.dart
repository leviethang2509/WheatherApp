import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../providers/weather_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({
    super.key,
    required this.forecasts,
  });
  List<ForecastModel> _getDailyForecasts() {
    final Map<String, ForecastModel> daily = {};

    for (final item in forecasts) {
      final key = DateFormat('yyyy-MM-dd').format(item.dateTime);

      if (!daily.containsKey(key) && item.dateTime.hour >= 11) {
        daily[key] = item;
      }
    }

    return daily.values.take(5).toList();
  }
  @override
  Widget build(BuildContext context) {
    final dailyForecasts = _getDailyForecasts();

    if (dailyForecasts.isEmpty) {
      return const SizedBox();
    }

    final provider = context.watch<WeatherProvider>();

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
              'Dự báo 5 ngày',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...dailyForecasts.map((item) {
        final min = provider.convertTemperature(item.tempMin).round();
    final max = provider.convertTemperature(item.tempMax).round();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('EEEE', 'vi').format(item.dateTime),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              CachedNetworkImage(
                imageUrl:
                'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                height: 42,
              ),
              Expanded(
                child: Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$min / $max${provider.temperatureSymbol}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
            }),
              ],
            ),
        ),
    );
  }
}

