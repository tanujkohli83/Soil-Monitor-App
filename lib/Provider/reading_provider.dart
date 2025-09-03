import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bluetooth_provider.dart';

class Reading {
  final double temperature;
  final double moisture;
  final DateTime timestamp;

  Reading({
    required this.temperature,
    required this.moisture,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "temperature": temperature,
      "moisture": moisture,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      temperature: (map["temperature"] as num).toDouble(),
      moisture: (map["moisture"] as num).toDouble(),
      timestamp: DateTime.parse(map["timestamp"]),
    );
  }
}

class ReadingProvider with ChangeNotifier {
  final List<Reading> _readings = [];
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Reading> get readings => _readings;
  Reading? get latestReading => _readings.isNotEmpty ? _readings.last : null;

  // Generate reading (ONLY if Bluetooth is connected)
  Future<void> generateReading(
      BluetoothProvider bluetoothProvider, BuildContext context) async {
    if (!bluetoothProvider.isConnected) {
      // Show warning popup instead of generating fallback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please connect a Bluetooth device first!"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Get mock structured reading from BluetoothProvider
    Map<String, dynamic> data = await bluetoothProvider.fetchReading();

    final reading = Reading(
      temperature: (data["temperature"] as num).toDouble(),
      moisture: (data["moisture"] as num).toDouble(),
      timestamp: DateTime.parse(data["timestamp"]),
    );

    _readings.add(reading);
    notifyListeners();

    // Save to Firestore
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection("users")
            .doc(user.uid)
            .collection("readings")
            .add(reading.toMap());
      }
    } catch (e) {
      debugPrint("Error saving to Firestore: $e");
    }

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final list = _readings.map((r) => jsonEncode(r.toMap())).toList();
    await prefs.setStringList("readings", list);
  }

  // Load from Firebase (and cache locally)
  Future<void> fetchReadings() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection("users")
            .doc(user.uid)
            .collection("readings")
            .orderBy("timestamp", descending: false)
            .get();

        _readings.clear();
        for (var doc in snapshot.docs) {
          _readings.add(Reading.fromMap(doc.data()));
        }

        // Save locally
        final prefs = await SharedPreferences.getInstance();
        final list = _readings.map((r) => jsonEncode(r.toMap())).toList();
        await prefs.setStringList("readings", list);

        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching from Firestore: $e");
    }
  }

  // Load only from local cache (offline mode)
  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("readings") ?? [];

    _readings.clear();
    for (var item in list) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      _readings.add(Reading.fromMap(map));
    }
    notifyListeners();
  }
}
