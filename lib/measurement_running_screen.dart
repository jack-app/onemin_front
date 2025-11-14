import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

//計測スタート画面から時刻とタイトルの情報を持ってくる
class MeasurementPage extends StatefulWidget {
  //時計の描画に必要な定数
  final String selected_title;
  final TimeOfDay selected_time_s;
  final TimeOfDay selected_time_e;

  final double radius;
  final Color plateColor;
  final Color dialColor;
  final Color secondColor;

  const MeasurementPage({
    Key? key,
    required this.selected_title,
    required this.selected_time_s,
    required this.selected_time_e,
    this.radius = 120.0,
    this.plateColor = Colors.white,
    this.dialColor = Colors.black,
    this.secondColor = Colors.red,
  }):super(key: key);

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> { 
  late DateTime startTimeS;
  late DateTime startTimeE;
  late int limit;

//Timerで表示するコメントを切り替える
  late Timer timer;
    int remaining = 0;
  //時間超過前のテキストを設定
  String displayText = "予定終了まで：あと";
  Color displayColor = Colors.black;

  //String selected_title = "通学準備";
  //Duration duration Duration(minutes: 5, seconds: 10);

  @override
  void initState(){
   super.initState();

   final now = DateTime.now();
     startTimeS = DateTime(now.year, now.month, now.day,
      widget.selected_time_s.hour, widget.selected_time_s.minute);
     startTimeE = DateTime(now.year, now.month, now.day,
      widget.selected_time_e.hour, widget.selected_time_e.minute);

    // `difference`メソッドを使用して時間差を計算
    Duration diff = startTimeE.difference(startTimeS);
    int limit = diff.inSeconds;

    remaining = limit; //制限時間が過ぎたら文字を切り替える

    timer = Timer.periodic(Duration(seconds: 1), (t){
      setState((){
        remaining--;
      });

      if (remaining <= 0){
        setState((){
          displayText = "超過時間";
          displayColor = Colors.red; 
        });
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
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
        title: Text(widget.selected_title),
        automaticallyImplyLeading: false, // 戻るボタンを非表示にする
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            //コメントの表示
            Text(
              displayText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: displayColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              formatDuration(remaining),
              style: const TextStyle(
                fontSize: 50,
              ),
            ),
            //時計の描画
            //for (var i = 0; i < 60; i++)
              //ClockMarker(
                //index: i,
                //radius: widget.radius,
                //markerWidth: 1,
                //markerHeight: 12,
                //fontSize: 18,
              //),
            // 秒針
            //ClockHand(
              //angle: (2 *pi) * ( limit / 60),
              //thickness: 1,
              //length: 140,
              //color: Colors.pink,
            //),
            //ストップボタン
            ElevatedButton(
              onPressed: (){},
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
