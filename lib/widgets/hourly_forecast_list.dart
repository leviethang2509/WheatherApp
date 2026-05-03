import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/forecast_model.dart';
import '../providers/weather_provider.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final items = forecasts.take(8).toList();

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Chưa có dữ liệu dự báo theo giờ.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Dự báo 24 giờ tới',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 158,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final provider = context.watch<WeatherProvider>();
              final temp = provider
                  .convertTemperature(item.temperature)
                  .round();

              return Container(
                width: 104,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(item.dateTime),
                      style: const TextStyle(
                        color: Color(0xFF4A5568),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl:
                          'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                      height: 48,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.cloud_rounded, size: 42),
                    ),
                    Text(
                      '$temp${provider.temperatureSymbol}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
