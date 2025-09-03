import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/bluetooth_provider.dart';
import '../Provider/reading_provider.dart';
import '../widgets/BluetoothDevicesDialog.dart';
import 'LoginScreen.dart';
import 'ReportScreen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      // clear SharedPreferences before logout
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing out')),
      );
    }
  }

  void _showBluetoothDevicesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BluetoothDevicesDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final readingsProvider = context.watch<ReadingProvider>();
    final bluetoothProvider = context.watch<BluetoothProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
            tooltip: "Logout",
          ),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 🔹 Connect / Disconnect Button
              bluetoothProvider.isConnected
                  ? Column(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.bluetooth_disabled,
                        color: Colors.red),
                    label: const Text(
                      "Disconnect",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Disconnect Device"),
                          content: const Text(
                              "Do you want to disconnect the device?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                bluetoothProvider.disconnect();
                                Navigator.pop(ctx);
                              },
                              child: const Text("Disconnect"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Connected to: ${bluetoothProvider.connectedDeviceName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              )
                  : TextButton.icon(
                icon: const Icon(Icons.bluetooth,
                    color: Colors.blueAccent),
                label: const Text(
                  "Connect Bluetooth",
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () async {
                  final isOn =
                  await context.read<BluetoothProvider>().isBluetoothEnabled();
                  if (!isOn) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Bluetooth is Off"),
                          content: const Text(
                              "Please turn on Bluetooth in your phone settings."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                    return; // ❌ stop here if BT is off
                  }

                  // ✅ If Bluetooth is ON → open devices dialog
                  _showBluetoothDevicesDialog(context);
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Test Button
              ElevatedButton.icon(
                icon: const Icon(Icons.science),
                label: const Text("Test"),
                onPressed: () async {
                  final bluetoothProvider = context.read<BluetoothProvider>();
                  await readingsProvider.generateReading(
                      bluetoothProvider, context);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text("New reading generated & saved"),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Display latest reading
              if (readingsProvider.latestReading != null)
                Card(
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Latest Reading",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "🌡️ Temperature: ${readingsProvider.latestReading!.temperature.toStringAsFixed(1)} °C",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "💧 Moisture: ${readingsProvider.latestReading!.moisture.toStringAsFixed(1)} %",
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "🕒 ${readingsProvider.latestReading!.timestamp}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // 🔹 Reports Button
              ElevatedButton.icon(
                icon: const Icon(Icons.analytics),
                label: const Text("Reports"),
                onPressed: () async {
                  await readingsProvider.loadFromLocal();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
