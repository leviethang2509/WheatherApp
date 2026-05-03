import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location_suggestion.dart';
import '../providers/weather_provider.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final StorageService _storageService = StorageService();
  final WeatherService _weatherService = WeatherService();

  List<String> _recentSearches = [];
  List<String> _favoriteCities = [];
  List<LocationSuggestion> _suggestions = [];
  Timer? _debounce;
  bool _isLoadingSuggestions = false;
  String _suggestionError = '';

  @override
  void initState() {
    super.initState();
    final screenshotQuery = Uri.base.queryParameters['query'];
    if (const bool.fromEnvironment('SCREENSHOT_MODE') &&
        screenshotQuery != null) {
      _controller.text = screenshotQuery;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSuggestions(screenshotQuery);
      });
    }
    _controller.addListener(_onSearchTextChanged);
    _loadLists();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onSearchTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final keyword = _controller.text.trim();

    _debounce?.cancel();

    if (keyword.length < 2) {
      setState(() {
        _suggestions = [];
        _suggestionError = '';
        _isLoadingSuggestions = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 450), () {
      _loadSuggestions(keyword);
    });
  }

  Future<void> _loadSuggestions(String keyword) async {
    setState(() {
      _isLoadingSuggestions = true;
      _suggestionError = '';
    });

    try {
      final suggestions = await _weatherService.searchLocations(keyword);

      if (!mounted || keyword != _controller.text.trim()) {
        return;
      }

      setState(() {
        _suggestions = suggestions;
        _isLoadingSuggestions = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _suggestions = [];
        _isLoadingSuggestions = false;
        _suggestionError = e.toString();
      });
    }
  }

  Future<void> _loadLists() async {
    final recent = await _storageService.getRecentSearches();
    final favorites = await _storageService.getFavoriteCities();

    if (!mounted) {
      return;
    }

    setState(() {
      _recentSearches = recent;
      _favoriteCities = favorites;
    });
  }

  Future<void> _search(String city) async {
    final keyword = city.trim();

    if (keyword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên thành phố.')),
      );
      return;
    }

    final provider = context.read<WeatherProvider>();
    await provider.fetchWeatherByCity(keyword);

    if (mounted) {
      if (provider.state == WeatherState.loaded) {
        Navigator.pop(context);
      } else if (provider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
      }
    }
  }

  Future<void> _searchLocation(LocationSuggestion suggestion) async {
    final provider = context.read<WeatherProvider>();

    await provider.fetchWeatherByCoordinates(
      suggestion.latitude,
      suggestion.longitude,
      recentSearchName: suggestion.title,
    );

    if (mounted) {
      if (provider.state == WeatherState.loaded) {
        Navigator.pop(context);
      } else if (provider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
      }
    }
  }

  Widget _buildCityChip(String city) {
    return ActionChip(
      avatar: const Icon(Icons.location_city_rounded, size: 18),
      label: Text(city),
      onPressed: () => _search(city),
    );
  }

  Widget _buildSuggestionTile(LocationSuggestion suggestion) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.place_rounded),
      title: Text(
        suggestion.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        suggestion.subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _searchLocation(suggestion),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Tìm kiếm thành phố'),
        centerTitle: true,
      ),
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
              children: [
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                  decoration: InputDecoration(
                    labelText: 'Nhập tên thành phố',
                    hintText: 'Ví dụ: Ho Chi Minh, London, Tokyo',
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: provider.state == WeatherState.loading
                        ? null
                        : () => _search(_controller.text),
                    icon: provider.state == WeatherState.loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search_rounded),
                    label: const Text('Tìm kiếm'),
                  ),
                ),
                if (_isLoadingSuggestions) ...[
                  const SizedBox(height: 14),
                  const LinearProgressIndicator(),
                ],
                if (_suggestionError.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    _suggestionError,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
                if (_suggestions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  ..._suggestions.map(_buildSuggestionTile),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_favoriteCities.isNotEmpty) ...[
            const _SectionTitle(
              icon: Icons.favorite_rounded,
              title: 'Thành phố yêu thích',
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _favoriteCities.map(_buildCityChip).toList(),
            ),
            const SizedBox(height: 24),
          ],
          if (_recentSearches.isNotEmpty) ...[
            const _SectionTitle(
              icon: Icons.history_rounded,
              title: 'Tìm kiếm gần đây',
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map(_buildCityChip).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
