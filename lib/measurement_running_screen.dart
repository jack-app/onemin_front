import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'measurement_start_screen.dart';

//計測スタート画面から時刻とタイトルの情報を持ってくる
class MeasurementPage extends StatefulWidget {
  final String selected_title;
  final TimeOfDay selected_time_e;
  final TimeOfDay selected_time_s;

 void main(){
    final now = DateTime.now();
    final startTimeS = DateTime(now.year, now.month, now.day, selected_time_s.hour, selected_time_s.minute);
    final startTimeE = DateTime(now.year, now.month, now.day, selected_time_e.hour, selected_time_e.minute);
  }

  const MeasurementPage({
    super.key,
    required this.selected_title,
  });

    @override
    State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> { // ←クラス名は適当につけてます
  //late;
  //late;

  //String selected_title = "通学準備";
  //Duration duration Duration(minutes: 5, seconds: 10);

  //@override
  //void initState(){}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selected_title),
        automaticallyImplyLeading: false, // 戻るボタンを非表示にする
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            //時計の描画

            //ストップボタン
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200,200),
                backgroundColor: Colors.red[300],
                foregroundColor: Colors.black,
              ),
              child: const Text('ストップ'),
            ),
          ],
        ),
      ),
    );
  }
}

