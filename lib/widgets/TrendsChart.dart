import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Provider/reading_provider.dart';

class TrendsScreen extends StatelessWidget {
  final List<Reading> readings;

  const TrendsScreen({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    final spotsTemp = readings
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.temperature))
        .toList();

    final spotsMoisture = readings
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.moisture))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trends"),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spotsTemp,
                isCurved: true,
                color: Colors.red,
                barWidth: 3,
                dotData: FlDotData(show: false),
              ),
              LineChartBarData(
                spots: spotsMoisture,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
