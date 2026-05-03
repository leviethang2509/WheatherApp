import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/location_suggestion.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  bool get _isScreenshotMode {
    return const bool.fromEnvironment('SCREENSHOT_MODE');
  }

  String get _screenshotWeather {
    return Uri.base.queryParameters['weather'] ?? 'clouds';
  }

  Future<List<LocationSuggestion>> searchLocations(String keyword) async {
    final query = keyword.trim();

    if (query.isEmpty) {
      return [];
    }

    if (_isScreenshotMode) {
      return [
        LocationSuggestion(
          name: 'Tokyo',
          country: 'JP',
          state: 'Tokyo',
          latitude: 35.6762,
          longitude: 139.6503,
        ),
        LocationSuggestion(
          name: 'Hanoi',
          country: 'VN',
          state: 'Ha Noi',
          latitude: 21.0294,
          longitude: 105.8544,
        ),
        LocationSuggestion(
          name: 'London',
          country: 'GB',
          state: 'England',
          latitude: 51.5072,
          longitude: -0.1276,
        ),
      ];
    }

    final url = ApiConfig.buildGeoUrl(ApiConfig.directGeocoding, {'q': query});

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((item) => LocationSuggestion.fromJson(item))
          .where((item) => item.name.isNotEmpty)
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception('API key khong hop le. Hay kiem tra file .env.');
    }

    if (response.statusCode == 429) {
      throw Exception('Ban da vuot qua gioi han goi API.');
    }

    throw Exception('Khong the tai danh sach dia diem.');
  }

  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    if (_isScreenshotMode) {
      return _mockWeather(cityName);
    }

    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {'q': cityName});

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    }

    if (response.statusCode == 404) {
      throw Exception('Không tìm thấy thành phố.');
    }

    if (response.statusCode == 401) {
      throw Exception('API key không hợp lệ. Hãy kiểm tra file .env.');
    }

    if (response.statusCode == 429) {
      throw Exception('Bạn đã vượt quá giới hạn gọi API.');
    }

    throw Exception('Không thể tải dữ liệu thời tiết.');
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    if (_isScreenshotMode) {
      return _mockWeather(_mockCityNameForCoordinates(lat, lon));
    }

    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw Exception('API key không hợp lệ. Hãy kiểm tra file .env.');
    }

    if (response.statusCode == 429) {
      throw Exception('Bạn đã vượt quá giới hạn gọi API.');
    }

    throw Exception('Không thể tải dữ liệu thời tiết theo vị trí.');
  }

  Future<List<ForecastModel>> getForecastByCity(String cityName) async {
    if (_isScreenshotMode) {
      return _mockForecast();
    }

    final url = ApiConfig.buildUrl(ApiConfig.forecast, {'q': cityName});

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['list'] ?? [];

      return list.map((item) => ForecastModel.fromJson(item)).toList();
    }

    throw Exception('Không thể tải dữ liệu dự báo.');
  }

  Future<List<ForecastModel>> getForecastByCoordinates(
    double lat,
    double lon,
  ) async {
    if (_isScreenshotMode) {
      return _mockForecast();
    }

    final url = ApiConfig.buildUrl(ApiConfig.forecast, {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['list'] ?? [];

      return list.map((item) => ForecastModel.fromJson(item)).toList();
    }

    throw Exception('Không thể tải dữ liệu dự báo theo vị trí.');
  }

  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  String getLargeIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }

  WeatherModel _mockWeather(String cityName) {
    final mode = _screenshotWeather.toLowerCase();
    final now = DateTime.now();

    final data = switch (mode) {
      'sunny' => ('Clear', 'troi quang', '01d', 32.0),
      'rain' => ('Rain', 'mua nhe', '10d', 26.0),
      'night' => ('Clear', 'troi quang', '01n', 24.0),
      _ => ('Clouds', 'nhieu may', '04d', 28.0),
    };

    return WeatherModel(
      cityName: cityName,
      country: cityName == 'Tokyo' ? 'JP' : 'VN',
      temperature: data.$4,
      feelsLike: data.$4 + 1,
      humidity: mode == 'rain' ? 88 : 70,
      windSpeed: mode == 'rain' ? 5.4 : 2.6,
      pressure: 1008,
      description: data.$2,
      icon: data.$3,
      mainCondition: data.$1,
      dateTime: now,
      tempMin: data.$4 - 2,
      tempMax: data.$4 + 3,
      visibility: 10000,
      cloudiness: mode == 'sunny' ? 8 : 86,
      sunrise:
          now.subtract(const Duration(hours: 4)).millisecondsSinceEpoch ~/ 1000,
      sunset: now.add(const Duration(hours: 8)).millisecondsSinceEpoch ~/ 1000,
    );
  }

  String _mockCityNameForCoordinates(double lat, double lon) {
    if ((lat - 35.6762).abs() < 1 && (lon - 139.6503).abs() < 1) {
      return 'Tokyo';
    }

    if ((lat - 51.5072).abs() < 1 && (lon + 0.1276).abs() < 1) {
      return 'London';
    }

    return 'Hanoi';
  }

  List<ForecastModel> _mockForecast() {
    final mode = _screenshotWeather.toLowerCase();
    final now = DateTime.now();
    final main = mode == 'rain'
        ? 'Rain'
        : mode == 'sunny'
        ? 'Clear'
        : 'Clouds';
    final icon = mode == 'rain'
        ? '10d'
        : mode == 'sunny'
        ? '01d'
        : '04d';
    final description = mode == 'rain'
        ? 'mua nhe'
        : mode == 'sunny'
        ? 'troi quang'
        : 'nhieu may';

    return List.generate(40, (index) {
      final temp = 25.0 + (index % 6);
      return ForecastModel(
        dateTime: now.add(Duration(hours: 3 * (index + 1))),
        temperature: temp,
        description: description,
        icon: icon,
        mainCondition: main,
        tempMin: temp - 1.5,
        tempMax: temp + 2,
        humidity: 65 + (index % 20),
        windSpeed: 2.0 + (index % 5),
      );
    });
  }
}
