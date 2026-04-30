import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Đơn vị nhiệt độ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<String>(
            value: 'C',
            groupValue: provider.temperatureUnit,
            onChanged: (value) {
              if (value != null) {
                provider.changeTemperatureUnit(value);
              }
            },
            title: const Text('Celsius - °C'),
          ),
          RadioListTile<String>(
            value: 'F',
            groupValue: provider.temperatureUnit,
            onChanged: (value) {
              if (value != null) {
                provider.changeTemperatureUnit(value);
              }
            },
            title: const Text('Fahrenheit - °F'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Thông tin'),
            subtitle: Text(
              provider.currentWeather == null
                  ? 'Chưa có dữ liệu'
                  : 'Đang xem thời tiết tại ${provider.currentWeather!.cityName}',
            ),
          ),
        ],
      ),
    );
  }
}