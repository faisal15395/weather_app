import 'package:flutter/material.dart';

class HourlyForecastItems extends StatelessWidget {
  final String time;
  final String temprature;
  final IconData icon;
  const HourlyForecastItems(
      {super.key,
      required this.time,
      required this.temprature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          width: 100,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '${temprature}°C',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(icon),
              const SizedBox(height: 5),
              Text(
                time,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
    );
  }
}
