import 'package:flutter/material.dart';
import 'measurement_start_screen.dart';

// Scheduleクラスに開始・終了時刻のプロパティを追加
class Schedule {
  final String title;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Schedule({
    required this.title,
    required this.startTime,
    required this.endTime,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MeasurementStartScreen(),
    );
  }
}

