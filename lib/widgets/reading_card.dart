import 'package:flutter/material.dart';
import '../Provider/reading_provider.dart';
import 'package:intl/intl.dart';


class ReadingCard extends StatelessWidget {
  final Reading reading;

  const ReadingCard({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.thermostat, color: Colors.green),
        title: Text("Temp: ${reading.temperature.toStringAsFixed(1)} °C"),
        subtitle: Text("Moisture: ${reading.moisture.toStringAsFixed(1)} %"),
        trailing: Text(DateFormat("HH:mm").format(reading.timestamp)),
      ),
    );
  }
}
