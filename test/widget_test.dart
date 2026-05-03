import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('parse weather JSON correctly', () {
      final weather = WeatherModel.fromJson({
        'name': 'Ho Chi Minh City',
        'sys': {'country': 'VN', 'sunrise': 1714600000, 'sunset': 1714644000},
        'main': {
          'temp': 31.0,
          'feels_like': 35.0,
          'humidity': 70,
          'pressure': 1008,
          'temp_min': 28.0,
          'temp_max': 33.0,
        },
        'wind': {'speed': 4.2},
        'weather': [
          {'description': 'mây rải rác', 'icon': '03d', 'main': 'Clouds'},
        ],
        'dt': 1714620000,
        'visibility': 10000,
        'clouds': {'all': 40},
      });

      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.country, 'VN');
      expect(weather.temperature, 31.0);
      expect(weather.mainCondition, 'Clouds');
      expect(weather.visibility, 10000);
    });
  });
}
