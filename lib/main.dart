import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Concatenator',
      home: const MyHomePage(title: 'Text Concatenator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _result = '';

  void _concatenateTexts() {
    setState(() {
      _result = _controller1.text + _controller2.text;
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("演習1"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 1つ目のテキスト入力欄
              TextField(
                controller: _controller1,
                decoration: const InputDecoration(
                  labelText: '1つ目のテキスト',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // 2つ目のテキスト入力欄
              TextField(
                controller: _controller2,
                decoration: const InputDecoration(
                  labelText: '2つ目のテキスト',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              // 結合ボタン
              ElevatedButton(
                onPressed: _concatenateTexts,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('結合', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 30),
              // 結果表示テキスト
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _result.isEmpty ? '結果がここに表示されます' : _result,
                  style: TextStyle(
                    fontSize: 18,
                    color: _result.isEmpty ? Colors.grey[600] : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
