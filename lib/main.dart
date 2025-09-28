import 'package:flutter/material.dart';
import 'package:giant_shelf_app/pages/shelfLightPage.dart';


void main() => runApp(const ShelfClockApp());

class ShelfClockApp extends StatelessWidget {
  const ShelfClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shelf Lights',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF00A8A8),
        useMaterial3: true,
      ),
      home: const ShelfLightsPage(),
    );
  }
}
