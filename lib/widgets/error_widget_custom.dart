import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onSearch;

  const ErrorWidgetCustom({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 20),
              const Text(
                'Có lỗi xảy ra',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại vị trí hiện tại'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onSearch,
                icon: const Icon(Icons.search),
                label: const Text('Tìm thành phố thủ công'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}