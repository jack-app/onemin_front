import 'package:flutter/material.dart';

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
