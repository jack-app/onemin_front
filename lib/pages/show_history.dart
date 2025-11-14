import 'package:flutter/material.dart';

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
        // カラースキームを決めたい
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: "NotoSansJP", //中華っぽいフォントが嫌なのでとりあえず設定した
      ),
      home: const ShowHistoryPage(title: '死守す一分'),
    );
  }
}

class ResultItem {
  //計測履歴を表すクラス
  ResultItem(this.targetDuration, this.actualDuration);
  Duration targetDuration;
  Duration actualDuration;
}

class ShowHistoryPage extends StatefulWidget {
  const ShowHistoryPage({super.key, required this.title});

  final String title;

  @override
  State<ShowHistoryPage> createState() => _ShowHistoryPageState();
}

class _ShowHistoryPageState extends State<ShowHistoryPage> {
  List<ResultItem> durations = [
    //計測履歴のサンプルデータ
    ResultItem(
      Duration(minutes: 4, seconds: 40),
      Duration(minutes: 5, seconds: 20),
    ),
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 2, seconds: 34),
    ),
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 4, seconds: 10),
    ),
    ResultItem(
      Duration(hours: 1, minutes: 4, seconds: 40),
      Duration(hours: 1, minutes: 5, seconds: 20),
    ),
    ResultItem(
      Duration(hours: 2, minutes: 3, seconds: 21),
      Duration(hours: 1, minutes: 2, seconds: 34),
    ),
    ResultItem(
      Duration(hours: 1, minutes: 3, seconds: 21),
      Duration(hours: 2, minutes: 4, seconds: 10),
    ),
    ResultItem(
      Duration(minutes: 4, seconds: 40),
      Duration(minutes: 5, seconds: 20),
    ),
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 2, seconds: 34),
    ),
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 4, seconds: 10),
    ),
    ResultItem(
      Duration(hours: 1, minutes: 4, seconds: 40),
      Duration(hours: 1, minutes: 5, seconds: 20),
    ),
    ResultItem(
      Duration(hours: 2, minutes: 3, seconds: 21),
      Duration(hours: 1, minutes: 2, seconds: 34),
    ),
    ResultItem(
      Duration(hours: 1, minutes: 3, seconds: 21),
      Duration(hours: 2, minutes: 4, seconds: 10),
    ),
    ResultItem(
      Duration(minutes: 4, seconds: 40),
      Duration(minutes: 5, seconds: 20),
    ),
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 2, seconds: 34),
    ),
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 4, seconds: 10),
    ),
    ResultItem(
      Duration(hours: 1, minutes: 4, seconds: 40),
      Duration(hours: 1, minutes: 5, seconds: 20),
    ),
    ResultItem(
      Duration(hours: 2, minutes: 3, seconds: 21),
      Duration(hours: 1, minutes: 2, seconds: 34),
    ),
    ResultItem(
      Duration(hours: 1, minutes: 3, seconds: 21),
      Duration(hours: 2, minutes: 4, seconds: 10),
    ),
  ];

  String taskName = "\$タスク名"; //タスク名のサンプルデータ

  String formatDuration(Duration duration) {
    //Durationを文字列に整形する関数
    String toTwoDigits(int n) => n.toString().padLeft(2, "0");
    String ho = toTwoDigits(duration.inHours.remainder(60).abs());
    String min = toTwoDigits(duration.inMinutes.remainder(60).abs());
    String sec = toTwoDigits(duration.inSeconds.remainder(60).abs());

    return (duration.inSeconds < 0) ? "-$ho:$min:$sec" : " $ho:$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "死守す一分",
          style: TextStyle(
            fontFamily: "NotoSansJP",
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Image.asset(
          '../../assets/alarm_edited.jpg',
          fit: BoxFit.cover,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "「$taskName」の計測履歴：",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.grey[700],
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  //横並びにする
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "回前",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "目標時間",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "計測時間",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "目標-計測",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: durations.length,
              itemBuilder: (BuildContext context, index) {
                Duration target = durations[index].targetDuration;
                Duration actual = durations[index].actualDuration;
                Widget durationDiff =
                    ((target - actual).inSeconds <
                        0) //差分が負になっていれば差分のTextを赤文字にする
                    ? Text(
                        formatDuration(target - actual),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      )
                    : Text(
                        formatDuration(target - actual),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      );
                return Container(
                  color: Colors.grey[700],
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: Row(
                      //横並びにする
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          index.toString().padLeft(3, "0"),
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 8),
                        Text(
                          formatDuration(target),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Text(
                          formatDuration(actual),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        durationDiff,
                        SizedBox(width: 3),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                /*
                スタートページへ遷移するボタンだが，ページ名未決定につき機能実装は保留
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );*/
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "スタート画面へ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
        // ),
      ),
    );
  }
}
