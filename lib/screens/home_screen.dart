import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../utils/weather_theme.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_section.dart';
import '../widgets/error_widget_custom.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/loading_widget.dart';
import '../widgets/weather_details_section.dart';
import 'forecast_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoad) {
      _didLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WeatherProvider>().init();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.state == WeatherState.loading &&
              provider.currentWeather == null) {
            return const LoadingWidget();
          }

          if (provider.state == WeatherState.error &&
              provider.currentWeather == null) {
            return ErrorWidgetCustom(
              message: provider.errorMessage,
              onRetry: provider.fetchWeatherByLocation,
              onSearch: () => _openSearch(context),
            );
          }

          final weather = provider.currentWeather;

          if (weather == null) {
            return const Center(child: Text('Chưa có dữ liệu thời tiết.'));
          }

          final theme = themeForWeather(weather.mainCondition, weather.icon);

          return RefreshIndicator(
            color: theme.accent,
            onRefresh: provider.refreshWeather,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  CurrentWeatherCard(weather: weather),
                  if (provider.isCachedData)
                    _CachedBanner(lastUpdateTime: provider.lastUpdateTime),
                  if (provider.state == WeatherState.loading)
                    LinearProgressIndicator(color: theme.accent),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _openSearch(context),
                            icon: const Icon(Icons.search_rounded),
                            label: const Text('Tìm thành phố'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filledTonal(
                          tooltip: 'Dự báo',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForecastScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_month_rounded),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          tooltip: 'Cài đặt',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  HourlyForecastList(forecasts: provider.forecast),
                  const SizedBox(height: 18),
                  DailyForecastSection(forecasts: provider.forecast),
                  const SizedBox(height: 18),
                  WeatherDetailsSection(weather: weather),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<WeatherProvider>().fetchWeatherByLocation();
        },
        icon: const Icon(Icons.my_location_rounded),
        label: const Text('Vị trí'),
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }
}

class _CachedBanner extends StatelessWidget {
  final DateTime? lastUpdateTime;

  const _CachedBanner({required this.lastUpdateTime});

  @override
  Widget build(BuildContext context) {
    final timeText = lastUpdateTime == null
        ? 'không rõ thời gian'
        : DateFormat('HH:mm dd/MM/yyyy').format(lastUpdateTime!);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF6AD55)),
      ),
      child: Row(
        children: [
          const Icon(Icons.offline_bolt_rounded, color: Color(0xFFC05621)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Đang hiển thị dữ liệu đã lưu. Cập nhật lần cuối: $timeText.',
              style: const TextStyle(
                color: Color(0xFF744210),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
