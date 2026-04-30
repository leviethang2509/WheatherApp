import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final StorageService _storageService = StorageService();

  List<String> _recentSearches = [];
  List<String> _favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    final recent = await _storageService.getRecentSearches();
    final favorites = await _storageService.getFavoriteCities();

    setState(() {
      _recentSearches = recent;
      _favoriteCities = favorites;
    });
  }

  Future<void> _search(String city) async {
    final keyword = city.trim();

    if (keyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên thành phố.'),
        ),
      );
      return;
    }

    await context.read<WeatherProvider>().fetchWeatherByCity(keyword);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildCityChip(String city) {
    return ActionChip(
      label: Text(city),
      onPressed: () => _search(city),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm thành phố'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: _search,
            decoration: InputDecoration(
              labelText: 'Nhập tên thành phố',
              hintText: 'Ví dụ: Ho Chi Minh, London, Tokyo',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: provider.state == WeatherState.loading
                  ? null
                  : () => _search(_controller.text),
              icon: const Icon(Icons.search),
              label: const Text('Tìm kiếm'),
            ),
          ),
          const SizedBox(height: 24),

          if (_favoriteCities.isNotEmpty) ...[
            const Text(
              'Thành phố yêu thích',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _favoriteCities.map(_buildCityChip).toList(),
            ),
            const SizedBox(height: 24),
          ],

          if (_recentSearches.isNotEmpty) ...[
            const Text(
              'Tìm kiếm gần đây',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _recentSearches.map(_buildCityChip).toList(),
            ),
          ],
        ],
      ),
    );
  }
}