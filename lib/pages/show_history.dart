import 'package:flutter/material.dart';
import '../models/schedule.dart';

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
      home: const ShowHistoryPage(title: '死守す一分', targetDuration: Duration(minutes: 5, seconds: 0), histories: []),
    );
  }
}

class ShowHistoryPage extends StatefulWidget {
  final String title;
  final Duration targetDuration;
  final List<MeasurementHistory> histories;
  const ShowHistoryPage({super.key, required this.title, required this.targetDuration, required this.histories});

  @override
  State<ShowHistoryPage> createState() => _ShowHistoryPageState();
}

class _ShowHistoryPageState extends State<ShowHistoryPage> {
  String formatDuration(Duration duration) {
    String toTwoDigits(int n) => n.toString().padLeft(2, "0");
    String ho = toTwoDigits(duration.inHours);
    String min = toTwoDigits(duration.inMinutes % 60);
    String sec = toTwoDigits(duration.inSeconds % 60);
    return (duration.inSeconds < 0) ? "-$ho:$min:$sec" : "$ho:$min:$sec";
  }
  @override
  Widget build(BuildContext context) {
    final histories = widget.histories;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} の計測履歴"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("日時", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("目標", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("実績", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("差分", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(thickness: 1),
            Expanded(
              child: ListView.builder(
                itemCount: histories.length,
                itemBuilder: (context, idx) {
                  final h = histories[idx];
                  final diff = h.actual - h.target;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        h.timestamp.toLocal().toString().substring(0, 16),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(formatDuration(h.target)),
                      Text(formatDuration(h.actual)),
                      Text(
                        formatDuration(diff),
                        style: TextStyle(
                          color: diff.inSeconds > 0 ? Colors.red : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
