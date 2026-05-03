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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('Dự báo thời tiết'), centerTitle: true),
      body: forecasts.isEmpty
          ? const Center(child: Text('Chưa có dữ liệu dự báo.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: forecasts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = forecasts[index];
                final temp = provider
                    .convertTemperature(item.temperature)
                    .round();
                final min = provider.convertTemperature(item.tempMin).round();
                final max = provider.convertTemperature(item.tempMax).round();

                return Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                        height: 58,
                        width: 58,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.cloud_rounded, size: 48),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat(
                                'EEEE, dd/MM - HH:mm',
                                'vi',
                              ).format(item.dateTime),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Color(0xFF4A5568)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Độ ẩm ${item.humidity}% - Gió ${item.windSpeed.toStringAsFixed(1)} m/s',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF718096),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$temp${provider.temperatureSymbol}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '$min / $max',
                            style: const TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
