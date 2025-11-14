import 'package:flutter/material.dart';
import 'schedule_creation_screen.dart';
import '../models/schedule.dart'; // Scheduleクラスをインポート

class MeasurementStartScreen extends StatefulWidget {
  const MeasurementStartScreen({super.key});

  @override
  State<MeasurementStartScreen> createState() => _MeasurementStartScreenState();
}

class _MeasurementStartScreenState extends State<MeasurementStartScreen> {
  final List<Schedule> _schedules = [];

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
        title: result['title'],
        startTime: result['startTime'],
        endTime: result['endTime'],
      );
      setState(() {
        _schedules.add(newSchedule);
      });
    }
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
