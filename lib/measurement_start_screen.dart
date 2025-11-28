import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'schedule_creation_screen.dart';
import 'main.dart'; // Scheduleクラスをインポート
import 'package:shared_preferences/shared_preferences.dart';

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
    final loaded = stored.map((encoded) {
      final data = jsonDecode(encoded) as Map<String, dynamic>;
      return _scheduleFromMap(data);
    }).toList();
    setState(() {
      _schedules = loaded;
    });
  }

  // スケジュール作成画面に遷移し、新しいスケジュールを受け取るメソッド
  void _navigateAndAddSchedule(BuildContext context) async {
    // Map形式でデータを受け取るように変更
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ScheduleCreationScreen()),
    );

    // データが返ってきた場合、Scheduleオブジェクトを生成してリストに追加
    //if (result != null) {
    //final newSchedule = Schedule(
    //    title: result['title'],
    //    startTime: result['startTime'],
    //    endTime: result['endTime'],
    //  );
    //  setState(() {
    //    _schedules.add(newSchedule);
    //  });
    //}
    
    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      final newSchedule = Schedule(
        title: result['title'] as String,
        startTime: result['startTime'] as TimeOfDay,
        endTime: result['endTime'] as TimeOfDay,
      );

      final stored = prefs.getStringList('schedules') ?? [];
      stored.add(jsonEncode(_scheduleToMap(newSchedule)));
      await prefs.setStringList('schedules', stored);

      setState(() {
        _schedules = [..._schedules, newSchedule];
      });
    }
  }

  Map<String, dynamic> _scheduleToMap(Schedule schedule) {
    return {
      'title': schedule.title,
      'startHour': schedule.startTime.hour,
      'startMinute': schedule.startTime.minute,
      'endHour': schedule.endTime.hour,
      'endMinute': schedule.endTime.minute,
    };
  }

  Schedule _scheduleFromMap(Map<String, dynamic> data) {
    final startHour = data['startHour'] as int;
    final startMinute = data['startMinute'] as int;
    final endHour = data['endHour'] as int;
    final endMinute = data['endMinute'] as int;
    return Schedule(
      title: data['title'] as String,
      startTime: TimeOfDay(hour: startHour, minute: startMinute),
      endTime: TimeOfDay(hour: endHour, minute: endMinute),
    );
  }
  
  
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('測定開始'),
      ),
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
                  // 時刻を見やすいようにフォーマット
                  final startTime = schedule.startTime.format(context);
                  final endTime = schedule.endTime.format(context);
                  return Card(
                    child: ListTile(
                      title: Text(schedule.title),
                      // サブタイトルに開始・終了時刻を表示
                      subtitle: Text('開始: $startTime - 終了: $endTime'),
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

