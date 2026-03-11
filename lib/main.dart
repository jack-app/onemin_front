import 'dart:async'; // 追加：タイマー用
import 'dart:convert'; // 追加：データのエンコード/デコード用
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 追加：ローカル保存用

import 'package:onemin_front/models/schedule.dart'; // 追加：Scheduleモデルのインポート

// 既存のインポート
import 'package:onemin_front/pages/show_history.dart';
import 'package:onemin_front/pages/schedule_creation_screen.dart';
import 'package:onemin_front/pages/measurement_start_screen.dart';
import 'package:onemin_front/pages/notification_timer_page.dart';
import 'package:onemin_front/pages/measurement_running_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // ==========================================
  // 【追加】スタート画面用の状態変数
  // ==========================================
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now().toUtc().add(const Duration(hours: 9)); // 東京時間に設定
  List<Schedule> _schedules = [];
  Schedule? _selectedSchedule;

  @override
  void initState() {
    super.initState();
    // 1. 時計を1秒ごとに更新するタイマー
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateTime.now().toUtc().add(const Duration(hours: 9));
      });
    });
    // 2. アプリ起動時に保存されたスケジュールを読み込む
    _loadSchedules();
  }

  @override
  void dispose() {
    _clockTimer.cancel(); // 画面を破棄するときにタイマーを止める
    super.dispose();
  }

  // 【追加】ローカルからスケジュールを読み込む処理
  Future<void> _loadSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('schedules') ?? [];
    final schedules = stored.map((encoded) {
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      return Schedule.fromJson(decoded);
    }).toList();

    setState(() {
      _schedules = schedules;
      // 再読み込み時、選択されていたスケジュールがまだ存在するか確認する
      if (_selectedSchedule != null) {
        try {
          _selectedSchedule = _schedules.firstWhere((s) => s.title == _selectedSchedule!.title);
        } catch (e) {
          _selectedSchedule = null;
        }
      }
    });
  }

  // 【追加】計測結果をローカルに保存する処理
  Future<void> _saveSchedules(List<Schedule> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = schedules
        .map((schedule) => jsonEncode(schedule.toJson()))
        .toList();
    await prefs.setStringList('schedules', encoded);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 時間表示用の文字列 (例: 17:20)
    final timeString = "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // 【重要】既存要素を消さずにエラーを防ぐため、SingleChildScrollViewで画面全体をスクロール可能にしました
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ==========================================
              // 【追加】アプリ開始画面のUI (添付画像を再現)
              // ==========================================
              const SizedBox(height: 30),
              
              // 1. 現在時刻の表示
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                ),
                child: Column(
                  children: [
                    const Text('現在時刻', style: TextStyle(fontSize: 24)),
                    Text(
                      timeString,
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              const Text('これからの予定', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              const Text('予定を選択⇓', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 10),

              // 2. 予定のプルダウン選択
              DropdownButton<Schedule>(
                hint: const Text('予定を選択してください', style: TextStyle(fontSize: 18)),
                value: _selectedSchedule,
                items: _schedules.map((Schedule schedule) {
                  return DropdownMenuItem<Schedule>(
                    value: schedule,
                    child: Text(schedule.title, style: const TextStyle(fontSize: 18)),
                  );
                }).toList(),
                onChanged: (Schedule? newValue) {
                  setState(() {
                    _selectedSchedule = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),

              // 3. 目標時間の表示
              const Text('目標時間', style: TextStyle(fontSize: 24)),
              Text(
                _selectedSchedule != null
                    ? "${_selectedSchedule!.duration.inHours.toString().padLeft(2, '0')}:${(_selectedSchedule!.duration.inMinutes % 60).toString().padLeft(2, '0')}"
                    : "--:--",
                style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // 4. スタートボタン (予定選択時のみ押せる)
              ElevatedButton(
                onPressed: _selectedSchedule == null
                    ? null // 予定未選択時は null を渡してボタンを無効化
                    : () async {
                        // 計測画面へ遷移
                        final result = await Navigator.push<Duration>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeasurementPage(
                              selectedTitle: _selectedSchedule!.title,
                              duration: _selectedSchedule!.duration,
                            ),
                          ),
                        );

                        // 5. 計測が完了し、結果が返ってきたら履歴に保存する
                        if (result != null) {
                          // 保存されているリストから、計測した予定を探す
                          final index = _schedules.indexWhere((s) => s.title == _selectedSchedule!.title);
                          if (index != -1) {
                            final schedule = _schedules[index];
                            final his = List<MeasurementHistory>.from(schedule.histories)
                              ..add(MeasurementHistory(
                                target: schedule.duration,
                                actual: result,
                                timestamp: DateTime.now(),
                              ));
                            
                            setState(() {
                              // 新しい履歴を持った予定に上書き
                              _schedules[index] = schedule.copyWith(histories: his);
                              _selectedSchedule = _schedules[index];
                            });
                            // ローカルへ保存
                            await _saveSchedules(_schedules);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  disabledBackgroundColor: Colors.grey[300], // 無効時の色
                ),
                child: const Text('スタート', style: TextStyle(fontSize: 28, color: Colors.black)),
              ),
              
              const SizedBox(height: 50),
              const Divider(thickness: 2),
              const Text('--- 以下、既存のテスト用ボタン群 ---', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              
              // ==========================================
              // 以下、既存の要素 (一切削除していません)
              // ==========================================
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowHistoryPage(
                          title: "show history page",
                          targetDuration: Duration(minutes: 10),
                          histories: [],
                        )
                    ),
                  );
                },
                child: const Text('Go to show_history'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationTimerPage(),
                    ),
                  );
                },
                child: const Text('Go to Start'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeasurementStartScreen(),
                    ),
                  ).then((_) => _loadSchedules()); // 戻ってきた時に予定リストを最新にするための追加
                },
                child: const Text('Go to measurement_start_screen'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleCreationScreen(),
                    ),
                  ).then((_) => _loadSchedules()); // 戻ってきた時に予定リストを最新にするための追加
                },
                child: const Text('Go to schedule_creation_screen'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeasurementPage(
                        selectedTitle: "テスト用予定名",
                        duration: Duration(minutes: 90), 
                      ),
                    ), 
                  );
                },
                child: const Text('Go to measurement_running_screen'),
              ),
              const SizedBox(height: 50), // スクロールの一番下の余白
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}