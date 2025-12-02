import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'schedule_creation_screen.dart';
import '../models/schedule.dart'; // Scheduleクラスをインポート

class MeasurementStartScreen extends StatefulWidget {
  const MeasurementStartScreen({super.key});

  @override
  State<MeasurementStartScreen> createState() => _MeasurementStartScreenState();
}

class _MeasurementStartScreenState extends State<MeasurementStartScreen> {
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('schedules') ?? [];
    final schedules = stored.map((encoded) {
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      return _scheduleFromMap(decoded);
    }).toList();
    setState(() {
      _schedules = schedules;
    });
  }

  Future<void> _saveSchedules(List<Schedule> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = schedules.map((schedule) => jsonEncode(_scheduleToMap(schedule))).toList();
    await prefs.setStringList('schedules', encoded);
  }

  // スケジュール作成画面に遷移し、新しいスケジュールを受け取るメソッド
  void _navigateAndAddSchedule(BuildContext context) async {
    // Map形式でデータを受け取るように変更
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ScheduleCreationScreen()),
    );

    // データが返ってきた場合、Scheduleオブジェクトを生成してリストに追加
    if (result != null) {
      final newSchedule = Schedule(
        title: result['title'] as String,
        duration: result['duration'] as Duration,
      );
      setState(() {
        _schedules = [..._schedules, newSchedule];
      });
      await _saveSchedules(_schedules);
    }
  }

  Future<void> _deleteSchedule(int index) async {
    setState(() {
      _schedules = List.of(_schedules)..removeAt(index);
    });
    await _saveSchedules(_schedules);
  }

  Map<String, dynamic> _scheduleToMap(Schedule schedule) {
    return {
      'title': schedule.title,
      'durationMinutes': schedule.duration.inMinutes,
    };
  }

  Schedule _scheduleFromMap(Map<String, dynamic> map) {
    if (map.containsKey('durationMinutes')) {
      return Schedule(
        title: map['title'] as String,
        duration: Duration(minutes: (map['durationMinutes'] as num).toInt()),
      );
    }

    final startHour = (map['startHour'] as num).toInt();
    final startMinute = (map['startMinute'] as num).toInt();
    final endHour = (map['endHour'] as num).toInt();
    final endMinute = (map['endMinute'] as num).toInt();
    final startTotal = startHour * 60 + startMinute;
    final endTotal = endHour * 60 + endMinute;
    var diff = endTotal - startTotal;
    if (diff <= 0) {
      diff += 24 * 60;
    }

    return Schedule(
      title: map['title'] as String,
      duration: Duration(minutes: diff),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final parts = <String>[];
    if (hours > 0) {
      parts.add('$hours時間');
    }
    if (minutes > 0) {
      parts.add('$minutes分');
    }
    if (parts.isEmpty) {
      parts.add('0分');
    }
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('測定開始')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'スケジュール一覧',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_schedules.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'スケジュールがありません。\n下のボタンから作成してください。',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            // スケジュールリストの表示部分を修正
            Expanded(
              child: ListView.builder(
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  final schedule = _schedules[index];
                  final durationText = _formatDuration(schedule.duration);
                  return Card(
                    child: ListTile(
                      title: Text(schedule.title),
                      subtitle: Text('所要時間: $durationText'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteSchedule(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndAddSchedule(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'スケジュールを作成',
      ),
    );
  }
}
