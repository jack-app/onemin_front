import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

//計測スタート画面から時刻とタイトルの情報を持ってくる
class MeasurementPage extends StatefulWidget {
  //時計の描画に必要な定数
  final String selected_title;
  final TimeOfDay selected_time_s;
  final TimeOfDay selected_time_e;

  const MeasurementPage({
    Key? key,
    required this.selected_title,
    required this.selected_time_s,
    required this.selected_time_e,
  }):super(key: key);

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}
//秒針UIを実装するクラス
class ClockHand extends StatelessWidget {
  final double angle;      // 針の角度
  final double length;     // 長さ
  final double thickness;  // 太さ
  final Color color;       // 色

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
      angle: angle,  // 角度で回転
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
          width: thickness,
          height: length,
          color: color,
        ),
      ),
    );
  }
}


class _MeasurementPageState extends State<MeasurementPage> { 
  late DateTime startTimeS;
  late DateTime startTimeE;
  late int limit;
  late int overtime;

//Timerで表示するコメントを切り替える
  late Timer timer;
    int remaining = 0;
    int overTime = 0;
    double angle = 0.0;

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
   limit = diff.inSeconds;

   remaining = limit;
    //制限時間が過ぎたら文字を切り替える
   timer = Timer.periodic(Duration(seconds: 1), (t){
      setState((){
        remaining --;
        //60分の1周づつ回転
        angle += pi / 30;
      });

      if (remaining <= 0){
        setState((){
          displayText = "超過時間";
          displayColor = Colors.red; 
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  //時間をhour,minutes,secondsで区切り、＊＊：＊＊：＊＊の形で表示する
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
            //数字で残り時間・超過時間を表示
            Text(
              formatDuration(remaining),  
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                color: displayColor,
              ),
            ),
            //時計の描画
            //シンプルな丸を描く
            // 秒針
            Transform.rotate(
              angle: angle, // ラジアン
              child: ClockHand(
                angle: 2*pi*(limit/60),
                thickness: 2,
                length: 140,
                color: Colors.pink,
              ),
            ),
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
