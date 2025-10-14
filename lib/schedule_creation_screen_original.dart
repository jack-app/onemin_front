import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'measurement_start_screen.dart'; // 計測スタート画面をインポート

class ScheduleCreationScreen extends StatefulWidget {
  const ScheduleCreationScreen({super.key});

  @override
  State<ScheduleCreationScreen> createState() => _ScheduleCreationScreenState();
}

class _ScheduleCreationScreenState extends State<ScheduleCreationScreen> {
  // Formの状態を管理するためのキー
  final _formKey = GlobalKey<FormState>();
  // 各テキストフィールドの入力を管理するためのコントローラー
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();

  // ウィジェットが破棄される際にコントローラーも破棄する
  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('予定作成'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:,
                validator: (value) {
                  if (value == null |

| value.isEmpty) {
                    return '目標時間を入力してください';
                  }
                  return null;
                },
              ),
              const Spacer(), // 残りのスペースをすべて埋める
              // ボタンを配置するRow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:,
              ),
            ],
          ),
        ),
      ),
    );
  }
}