import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/models/forecast_model.dart';

class WeatherService {
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {'q': cityName},
    );

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
    );

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
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
      },
    );

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
    );

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
    final url = ApiConfig.buildUrl(
      ApiConfig.forecast,
      {'q': cityName},
    );

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
    );

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
    final url = ApiConfig.buildUrl(
      ApiConfig.forecast,
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
      },
    );

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
    );

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
}