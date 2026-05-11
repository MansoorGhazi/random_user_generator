import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RandomUserApp());
}

class RandomUserApp extends StatelessWidget {
  const RandomUserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random User Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
