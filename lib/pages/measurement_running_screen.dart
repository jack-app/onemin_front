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
  late Timer timer;
  late int remaining;
  double angle = 0.0;
  String displayText = "予定終了まで：あと";
  Color displayColor = Colors.black;

  @override
  void initState() {
    super.initState();
    remaining = widget.duration.inSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        remaining--;
        angle += pi / 30;
        if (remaining <= 0) {
          displayText = "超過時間";
          displayColor = Colors.red;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.selectedTitle),
        automaticallyImplyLeading: false, // 戻るボタンを非表示にする
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //コメントの表示
            Text(
              displayText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: displayColor),
            ),
            const SizedBox(height: 10),
            //数字で残り時間・超過時間を表示
            Text(
              formatDuration(remaining),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, color: displayColor),
            ),
            // 秒針と時計の描画
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.black,
                shape: const StadiumBorder(),
              ),
              child: const Text('ストップ'),
            ),
          ],
        ),
      ),
    );
  }
}
