import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

//計測スタート画面から時刻とタイトルの情報を持ってくる
class MeasurementPage extends StatefulWidget {
  //時計の描画に必要な定数
  final String selectedTitle;
  final Duration duration;

  const MeasurementPage({
    Key? key,
    required this.selectedTitle,
    required this.duration,
  }) : super(key: key);

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

//秒針UIを実装するクラス
class ClockHand extends StatelessWidget {
  final double angle; // 針の角度
  final double length; // 長さ
  final double thickness; // 太さ
  final Color color; // 色

  const ClockHand({
    super.key,
    required this.angle,
    required this.length,
    required this.thickness,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle, // 角度で回転
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(width: thickness, height: length, color: color),
      ),
    );
  }
}

class _MeasurementPageState extends State<MeasurementPage> {
  late Timer _timer;
  int elapsedSeconds = 0;
  double angle = 0.0;
  bool isRunning = true;

  int get remaining {
    final remain = widget.duration.inSeconds - elapsedSeconds;
    return remain > 0 ? remain : 0;
  }
  bool get isOver => elapsedSeconds > widget.duration.inSeconds;

  String get displayText => isOver ? "超過時間" : "予定終了まで：あと";
  Color get displayColor => isOver ? Colors.red : Colors.black;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRunning) return;
      setState(() {
        elapsedSeconds++;
        angle += pi / 30; // 1秒ごとに更新・60stepで1周
      });
    });
  }

  void _toggleTimer() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  void _finishMeasurement() {
    Navigator.of(context).pop(Duration(seconds: elapsedSeconds));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatDuration(int seconds) {
    final d = Duration(seconds: seconds.abs());
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final showSeconds = !isOver ? remaining : (elapsedSeconds - widget.duration.inSeconds);
    final stoppedText = '経過時間: ' + formatDuration(elapsedSeconds);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.selectedTitle),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isRunning
                  ? displayText
                  : '計測停止中',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: displayColor),
            ),
            const SizedBox(height: 10),
            Text(
              isRunning
                  ? formatDuration(showSeconds)
                  : stoppedText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, color: Colors.blueGrey),
            ),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //丸を描く
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                    ),
                    ClockHand(
                      angle: angle,
                      length: 100,
                      thickness: 2,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            //ストップボタン
            ElevatedButton(
              onPressed: _toggleTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning ? Colors.red[300] : Colors.green[300],
                foregroundColor: Colors.black,
                shape: const StadiumBorder(),
              ),
              child: Text(isRunning ? 'ストップ' : '再開'),
            ),
            if (!isRunning)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ElevatedButton(
                  onPressed: _finishMeasurement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    foregroundColor: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('前の画面に戻る'),
                ),
              )
          ],
        ),
      ),
    );
  }
}
