import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoBaseUrl = 'https://api.openweathermap.org/geo/1.0';

  static String get apiKey {
    final key = dotenv.env['OPENWEATHER_API_KEY'];

    if (key == null || key.isEmpty) {
      throw Exception('OPENWEATHER_API_KEY is missing in .env file');
    }

    return key;
  }

  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String directGeocoding = '/direct';

  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');
    final queryParams = {
      ...params,
      'appid': apiKey,
      'units': 'metric',
      'lang': 'vi',
    };
    return uri.replace(queryParameters: queryParams).toString();
  }

  static String buildGeoUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$geoBaseUrl$endpoint');
    final queryParams = {...params, 'appid': apiKey, 'limit': '5'};
    return uri.replace(queryParameters: queryParams).toString();
  }
}
