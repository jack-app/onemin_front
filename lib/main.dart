import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AllResultsPage(title: '死守す一分'),
    );
  }
}

class ResultItem {
  ResultItem(this.targetDuration, this.actualDuration);

  Duration targetDuration;
  Duration actualDuration;
}

class AllResultsPage extends StatefulWidget {
  const AllResultsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AllResultsPage> createState() => _AllResultsPageState();
}

class _AllResultsPageState extends State<AllResultsPage> {
  /*  int _counter = 0;

  
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }*/

  List<ResultItem> durations = [
    //サンプルデータ
    ResultItem(
      Duration(minutes: 4, seconds: 40),
      Duration(minutes: 5, seconds: 20),
    ),
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 2, seconds: 34),
    ), // 任意に増やしてOK
    ResultItem(
      Duration(minutes: 3, seconds: 21),
      Duration(minutes: 4, seconds: 10),
    ),
  ];

  String taskName = "タスク名";

  String formatDuration(Duration duration) {
    //時間の文字列を整形
    String toTwoDigits(int n) => n.toString().padLeft(2, "0");
    String ho = toTwoDigits(duration.inHours.remainder(60).abs());
    String min = toTwoDigits(duration.inMinutes.remainder(60).abs());
    String sec = toTwoDigits(duration.inSeconds.remainder(60).abs());

    return (duration.inSeconds < 0) ? "-$ho:$min:$sec" : " $ho:$min:$sec";
  }

  //  Widget Minus

  /*
  String durationDiff(Duration a, Duration b) {
    //時間の差分を計算，整形

      bool isMinus = false;
      if(a.inHours - b.inHours < 0){
        isMinus = true;
      }else{

      }
        if(a.inMinutes - b.inMinutes < 0){
          isMinus = true;
          if(a.inSeconds - b.inSeconds < 0){
            isMinus = true;
          }
        }
      }

      days: a.inHours - b.inHours,
      minutes: a.inMinutes - b.inMinutes,
      seconds: a.inSeconds - b.inSeconds,
    
    return formatDuration(diff);
  }*/

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        //  child: Align(
        // alignment: Alignment.centerRight,
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.start,
          //  crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "[$taskName]の計測履歴：",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: durations.length,
              itemBuilder: (BuildContext context, index) {
                Duration target = durations[index].targetDuration;
                Duration actual = durations[index].actualDuration;
                Widget durationDiff =
                    ((target - actual).inSeconds < 0) //負になっていれば赤文字にする
                    ? Text(
                        "差分\n${formatDuration(target - actual)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      )
                    : Text(
                        "差分\n${formatDuration(target - actual)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      );
                return Container(
                  color: Colors.grey[700],
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "目標時間\n${formatDuration(target)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        Text(
                          "実際の時間\n${formatDuration(actual)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        durationDiff,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );*/
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "スタート画面へ戻る",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
          /*
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],*/
        ),
        // ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods. This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
    );
  }
}
