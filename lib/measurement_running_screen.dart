import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeasurementPage extends StatefulWidget {

    @override
    State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> { // ←クラス名は適当につけてます
// （省略）他のプロパティの定義

  String name = "通学準備";
  Duration duration Duration(minutes: 5, seconds: 10);


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('計測中'),
        automaticallyImplyLeading: false, // 戻るボタンを非表示にする
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        children: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children[
            //ストップボタン
            ElevatedButton(
              onPressed: (){},
              child: const Text('ストップ'),
              style: ElevatedButton.styleFrom(
                backgroundcolor: Colors.red[300],
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  },
},

