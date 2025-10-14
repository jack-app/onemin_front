import 'package:flutter/material.dart';
import 'schedule_creation_screen.dart'; // 予定作成画面をインポート

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneMin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // アプリの開始画面として予定作成画面を指定
      home: const ScheduleCreationScreen(),
    );
  }
}

//{
//    "名前" : "なにか",
//    "タスク" : "料理",
//    "時間" : [ 2, 4, 6]
//}
//
//
//
//
