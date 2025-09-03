import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/bluetooth_service.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});
  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final BluetoothManager _bluetoothService = BluetoothManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Devices")),
      body: StreamBuilder<List<ScanResult>>(
        stream: _bluetoothService.scanForDevices(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                title: Text(
                  result.device.name.isNotEmpty
                      ? result.device.name
                      : result.device.id.toString(),
                ),
                subtitle: Text(result.rssi.toString()),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await _bluetoothService.connectToDevice(result.device);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Connected to ${result.device.platformName}",
                        ),
                      ),
                    );
                    Navigator.pop(context, _bluetoothService.connectedDevice);
                  },
                  child: const Text("Connect"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
