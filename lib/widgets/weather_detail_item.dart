import 'package:flutter/material.dart';

class WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const WeatherDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.blueGrey),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}