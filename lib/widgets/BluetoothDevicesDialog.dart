import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/bluetooth_provider.dart';

class BluetoothDevicesDialog extends StatefulWidget {
  @override
  _BluetoothDevicesDialogState createState() => _BluetoothDevicesDialogState();
}

class _BluetoothDevicesDialogState extends State<BluetoothDevicesDialog> {
  List<Map<String, dynamic>> devices = [];
  bool isScanning = false;
  String? connectingDeviceId;

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  Future<void> _scanForDevices() async {
    if (isScanning) return;

    setState(() {
      isScanning = true;
      devices.clear();
    });

    try {
      final bluetoothProvider = context.read<BluetoothProvider>();
      final scannedDevices = await bluetoothProvider.scanDevices();

      if (mounted) {
        setState(() {
          devices = scannedDevices;
          isScanning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning devices: $e')),
        );
      }
    }
  }

  String _getDeviceName(Map<String, dynamic> device) {
    // Handle different possible name fields
    String? name = device["name"];

    if (name == null || name.isEmpty || name.trim().isEmpty) {
      // If name is null or empty, try alternative fields
      name = device["localName"] ?? device["advertisementName"] ?? device["deviceName"];
    }

    if (name == null || name.isEmpty || name.trim().isEmpty) {
      // If still no name, use a fallback based on device type
      String deviceType = device["type"] ?? "Unknown";
      return "Unknown $deviceType Device";
    }

    return name.trim();
  }

  Future<void> _connectToDevice(Map<String, dynamic> device) async {
    setState(() {
      connectingDeviceId = device["id"];
    });

    try {
      final bluetoothProvider = context.read<BluetoothProvider>();
      await bluetoothProvider.connect(device, context);

      if (mounted) {
        setState(() {
          connectingDeviceId = null;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to ${_getDeviceName(device)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          connectingDeviceId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to ${_getDeviceName(device)}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Available Devices"),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isScanning ? Colors.grey : Colors.blue,
            ),
            onPressed: isScanning ? null : _scanForDevices,
            tooltip: "Refresh devices",
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 350,
        child: Column(
          children: [
            if (isScanning)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text("Scanning for devices..."),
                  ],
                ),
              ),
            Expanded(
              child: devices.isEmpty && !isScanning
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bluetooth_disabled,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "No devices found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  final deviceName = _getDeviceName(device);
                  final deviceId = device["id"] ?? "";
                  final deviceType = device["type"] ?? "Unknown";
                  final isConnecting = connectingDeviceId == deviceId;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        deviceType == "BLE"
                            ? Icons.bluetooth
                            : Icons.bluetooth_connected,
                        color: deviceType == "BLE"
                            ? Colors.blue
                            : Colors.green,
                      ),
                      title: Text(
                        deviceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deviceType,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          if (deviceId.isNotEmpty)
                            Text(
                              deviceId,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      trailing: isConnecting
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : ElevatedButton(
                        onPressed: () => _connectToDevice(device),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          "Connect",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}