import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_section.dart';
import '../widgets/weather_details_section.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget_custom.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'forecast_screen.dart';

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
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.state == WeatherState.loading) {
            return const LoadingWidget();
          }

          if (provider.state == WeatherState.error &&
              provider.currentWeather == null) {
            return ErrorWidgetCustom(
              message: provider.errorMessage,
              onRetry: provider.fetchWeatherByLocation,
              onSearch: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
            );
          }

          if (provider.currentWeather == null) {
            return const Center(
              child: Text('Chưa có dữ liệu thời tiết.'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshWeather,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  CurrentWeatherCard(weather: provider.currentWeather!),

                  if (provider.isCachedData)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Đang hiển thị dữ liệu cache do không tải được dữ liệu mới.',
                        textAlign: TextAlign.center,
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SearchScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.search),
                            label: const Text('Tìm thành phố'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.filled(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  HourlyForecastList(forecasts: provider.forecast),

                  const SizedBox(height: 16),

                  DailyForecastSection(forecasts: provider.forecast),

                  const SizedBox(height: 16),

                  WeatherDetailsSection(weather: provider.currentWeather!),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForecastScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Xem màn hình dự báo'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<WeatherProvider>().fetchWeatherByLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}