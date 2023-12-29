import 'package:flutter/material.dart';
import 'package:flutter_wifi/presentation/screens/scan_nearby_wifis_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(useMaterial3: false),
      home: const ScanNearbyWifisScreen(),
    );
  }
}
