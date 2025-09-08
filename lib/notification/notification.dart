import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/services.dart';

class NotificationTimerPage extends StatelessWidget{
  final player = AudioPlayer();

  final audioSourceUrl = 'alarm.mp3';
  Future<void> playSound() async {
    await player.play(AssetSource(audioSourceUrl));
  }

  Future<void> vibration() async {
    await HapticFeedback.lightImpact();
  }

  void activateNotificationTimer({int minutes = 0, int seconds = 0}) {
    // ここに通知を設定するコードを追加
    Timer(Duration(seconds: seconds, minutes: minutes), () {
      playSound();
      vibration();
      debugPrint("test");
    });
  }

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
}