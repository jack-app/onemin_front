import 'package:flutter/material.dart';

class ScheduleCreationScreen extends StatefulWidget {
  const ScheduleCreationScreen({super.key});

  @override
  State<ScheduleCreationScreen> createState() => _ScheduleCreationScreenState();
}

class _ScheduleCreationScreenState extends State<ScheduleCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  // 選択された開始・終了時刻を保持する変数
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // タイムピッカーを表示して時刻を選択させる関数
  Future<void> _selectTime(BuildContext context, {required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    // 時刻が選択されたら、対応する状態変数にセット
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // 保存ボタンが押されたときの処理
  void _submitForm() {
    // バリデーションを実行
    if (_formKey.currentState!.validate()) {
      // 開始・終了時刻が選択されているかチェック
      if (_startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('開始時刻と終了時刻を選択してください')),
        );
        return; // 処理を中断
      }
      // タイトル、開始時刻、終了時刻をMap形式で前の画面に返す
      Navigator.pop(context, {
        'title': _titleController.text,
        'startTime': _startTime,
        'endTime': _endTime,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スケジュール作成'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // スケジュール名入力フォーム
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'スケジュール名',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'スケジュール名を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- ここから追加 ---
              // 開始時刻選択
              ListTile(
                title: const Text('開始時刻'),
                subtitle: Text(_startTime?.format(context) ?? '選択されていません'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, isStart: true),
              ),
              // 終了時刻選択
              ListTile(
                title: const Text('終了時刻'),
                subtitle: Text(_endTime?.format(context) ?? '選択されていません'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, isStart: false),
              ),
              // --- ここまで追加 ---

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

