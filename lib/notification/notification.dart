import 'package:flutter/material.dart';

class NotificationTimerPage extends StatelessWidget{
  // 前略
  void activateNotificationTimer({int minutes = 0, int seconds = 0}) {
    // ここに通知を設定するコードを追加
  }

  // 中略
 @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("通知テスト"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                activateNotificationTimer(minutes: 5, seconds :0);
              },
              child: const Text('5分後に通知'),
            ),
            ElevatedButton(
              onPressed: () {
                activateNotificationTimer(seconds :10);
              },
              child: const Text('10秒後に通知'),
            ),
          ],
        ),
      ),
    );
  }
  // 後略
}