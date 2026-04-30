import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final forecasts = provider.forecast;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dự báo thời tiết'),
      ),
      body: forecasts.isEmpty
          ? const Center(
        child: Text('Chưa có dữ liệu dự báo.'),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: forecasts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = forecasts[index];
          final temp =
          provider.convertTemperature(item.temperature).round();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl:
                  'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                  height: 56,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, dd/MM HH:mm', 'vi')
                            .format(item.dateTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(item.description),
                      Text('Độ ẩm: ${item.humidity}%'),
                      Text('Gió: ${item.windSpeed} m/s'),
                    ],
                  ),
                ),
                Text(
                  '$temp${provider.temperatureSymbol}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}