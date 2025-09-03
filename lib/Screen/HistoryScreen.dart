import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/reading_provider.dart';
import '../widgets/TrendsChart.dart';
import '../widgets/reading_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<ReadingProvider>();

    // 1️⃣ Load from local cache first
    await provider.loadFromLocal();

    // 2️⃣ Refresh from Firestore in background
    await provider.fetchReadings();

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final readings = context.watch<ReadingProvider>().readings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: "View Trends",
            onPressed: () {
              if (readings.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrendsScreen(readings: readings),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No data available for chart")),
                );
              }
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F8E9), Color(0xFFA5D6A7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : readings.isEmpty
            ? const Center(
          child: Text(
            "No history available yet",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: readings.length,
          itemBuilder: (context, index) {
            final reading = readings[index];
            return ReadingCard(reading: reading);
          },
        ),
      ),
    );
  }
}
