import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('Cài đặt'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đơn vị nhiệt độ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'C',
                      label: Text('Celsius'),
                      icon: Icon(Icons.thermostat_rounded),
                    ),
                    ButtonSegment(
                      value: 'F',
                      label: Text('Fahrenheit'),
                      icon: Icon(Icons.device_thermostat_rounded),
                    ),
                  ],
                  selected: {provider.temperatureUnit},
                  onSelectionChanged: (values) {
                    provider.changeTemperatureUnit(values.first);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('Thông tin hiện tại'),
              subtitle: Text(
                provider.currentWeather == null
                    ? 'Chưa có dữ liệu'
                    : 'Đang xem thời tiết tại ${provider.currentWeather!.cityName}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
