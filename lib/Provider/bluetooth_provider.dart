import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';

class BluetoothProvider with ChangeNotifier {
  final BluetoothManager _manager = BluetoothManager();

  String? connectedDeviceName;
  String? connectedDeviceId;
  String? connectedType;
  bool get isConnected => connectedDeviceName != null;

  // Scan BLE devices (your manager only supports BLE)
  Future<List<Map<String, dynamic>>> scanDevices() async {
    final devices = <Map<String, dynamic>>[];

    // Scan for BLE devices using your actual method name
    final bleStream = _manager.scanForDevices();

    await for (final results in bleStream) {
      devices.clear();
      for (var result in results) {
        devices.add({
          "name": result.device.platformName.isNotEmpty
              ? result.device.platformName
              : result.device.remoteId.toString(),
          "id": result.device.remoteId.toString(),
          "type": "BLE",
          "device": result.device,
          "rssi": result.rssi,
        });
      }
      break;
    }

    return devices;
  }

  Future<void> connect(Map<String, dynamic> dev, BuildContext context) async {
    try {
      final isOn = await _manager.isBluetoothOn();
      if (!isOn) {
        // Show dialog if Bluetooth is OFF
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Bluetooth is Off"),
              content: const Text("Please turn on Bluetooth in settings."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
        return;
      }

      // If Bluetooth is ON
      await _manager.connectToDevice(dev["device"]);

      connectedDeviceName = dev["name"];
      connectedDeviceId = dev["id"];
      connectedType = dev["type"];
      notifyListeners();
    } catch (e) {
      print('Connection error: $e');
      rethrow;
    }
  }


  /// 🔹 Disconnect from device
  Future<void> disconnect() async {
    try {
      await _manager.disconnect(); // This method exists in your manager
      connectedDeviceName = null;
      connectedDeviceId = null;
      connectedType = null;
      notifyListeners();
    } catch (e) {
      print('Disconnect error: $e');
      rethrow;
    }
  }

  /// 🔹 Fetch reading from connected device
  Future<Map<String, dynamic>> fetchReading() async {
    try {
      return await _manager.fetchReading(); // This method exists in your manager
    } catch (e) {
      print('Fetch reading error: $e');
      rethrow;
    }
  }

  /// 🔹 Stop scanning
  Future<void> stopScan() async {
    try {
      await _manager.stopScan(); // This method exists in your manager
    } catch (e) {
      print('Stop scan error: $e');
      rethrow;
    }
  }

  /// 🔹 Check if Bluetooth is enabled
  Future<bool> isBluetoothEnabled() async {
    try {
      return await _manager.isBluetoothOn(); // This method exists in your manager
    } catch (e) {
      print('Bluetooth check error: $e');
      return false;
    }
  }
}