import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'screens/forecast_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/error_widget_custom.dart';
import 'widgets/loading_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env.example');

  await initializeDateFormatting('vi', null);

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(
        weatherService: WeatherService(),
        locationService: LocationService(),
        storageService: StorageService(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF3182CE),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F7FA),
            surfaceTintColor: Colors.transparent,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        home: const AppEntryScreen(),
      ),
    );
  }
}

class AppEntryScreen extends StatefulWidget {
  const AppEntryScreen({super.key});

  @override
  State<AppEntryScreen> createState() => _AppEntryScreenState();
}

class _AppEntryScreenState extends State<AppEntryScreen> {
  bool _didLoad = false;

  bool get _isScreenshotMode {
    return const bool.fromEnvironment('SCREENSHOT_MODE');
  }

  String get _screen {
    return Uri.base.queryParameters['screen'] ?? 'home';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoad && _isScreenshotMode && _screen != 'home') {
      _didLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WeatherProvider>().fetchWeatherByCoordinates(
          21.0294498,
          105.8544441,
          recentSearchName: 'Hanoi, VN',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isScreenshotMode) {
      return const HomeScreen();
    }

    return switch (_screen) {
      'search' => const SearchScreen(),
      'forecast' => const ForecastScreen(),
      'settings' => const SettingsScreen(),
      'loading' => const LoadingWidget(),
      'error' => ErrorWidgetCustom(
        message:
            'Không thể tải dữ liệu thời tiết. Vui lòng kiểm tra kết nối mạng hoặc API key.',
        onRetry: () {},
        onSearch: () {},
      ),
      _ => const HomeScreen(),
    };
  }
}
