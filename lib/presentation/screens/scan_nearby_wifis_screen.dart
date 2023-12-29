import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart';

class ScanNearbyWifisScreen extends StatefulWidget {
  const ScanNearbyWifisScreen({super.key});

  @override
  State<ScanNearbyWifisScreen> createState() => _ScanNearbyWifisScreenState();
}

class _ScanNearbyWifisScreenState extends State<ScanNearbyWifisScreen> {
  List<WiFiAccessPoint> results = [];
  StreamSubscription<List<WiFiAccessPoint>>? _scanSubscription;
  bool isScanning = false;

  void _startScan() async {
    isScanning = true;
    setState(() {});

    final can = await WiFiScan.instance.canStartScan(askPermissions: true);
    print('can1: $can');

    if (can == CanStartScan.noLocationServiceDisabled) {
      await Permission.accessMediaLocation.request();
      return;
    }

    if (can == CanStartScan.yes) {
      final isScanning = await WiFiScan.instance.startScan();
      print('isScanning: $isScanning');

      if (isScanning) {
        final can = await WiFiScan.instance.canGetScannedResults(askPermissions: true);
        print('can2: $can');

        if (can == CanGetScannedResults.yes) {
          _scanSubscription = WiFiScan.instance.onScannedResultsAvailable.listen((event) {
            setState(() {
              results = event;
            });
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scanSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return InkWell(
            onTap: () async {
              // TODO: Connect to wifi with wifi iot
              final response = await WiFiForIoTPlugin.connect(result.ssid, password: '1234567890');
              print('response: $response');
            },
            child: ListTile(
              title: Text(result.ssid),
              subtitle: Text(result.bssid),
              trailing: Text('${result.level}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startScan(),
        child: isScanning ? const Icon(Icons.stop) : const Icon(Icons.scanner),
      ),
    );
  }
}
