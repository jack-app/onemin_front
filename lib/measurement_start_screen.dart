import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 時刻のフォーマットに使用

// 予定データを保持するためのシンプルなクラス
class Schedule {
  final String name;
  final int targetTime;

  Schedule({required this.name, required this.targetTime});
}

class MeasurementStartScreen extends StatefulWidget {
  final String scheduleName;
  final int targetTime;

  const MeasurementStartScreen({
    super.key,
    required this.scheduleName,
    required this.targetTime,
  });

  @override
  State<MeasurementStartScreen> createState() => _MeasurementStartScreenState();
}

class _MeasurementStartScreenState extends State<MeasurementStartScreen> {
  // 作成された予定を保持するリスト
  final List<Schedule> _schedules =;
  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    // 前の画面から渡された最初の予定をリストに追加
    _schedules.add(
      Schedule(name: widget.scheduleName, targetTime: widget.targetTime),
    );

    // 現在時刻を初期化
    _currentTime = _formatDateTime(DateTime.now());

    // 1秒ごとに時刻を更新するタイマーを開始
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) { // ウィジェットがまだ画面に存在するか確認
        setState(() {
          _currentTime = _formatDateTime(DateTime.now());
        });
      }
    });
  }

  // ウィジェットが破棄されるときにタイマーを確実にキャンセルする
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // DateTimeオブジェクトを 'HH:mm' 形式の文字列にフォーマットする
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('計測スタート'),
        automaticallyImplyLeading: false, // 自動で表示される戻るボタンを非表示にする
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(schedule.name),
                      trailing: Text('${schedule.targetTime} 分'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
