import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stack with ScrollView and Positioned Widgets'),
        ),
        body: Stack(
          children: <Widget>[
            // SingleChildScrollView for scrollable content
            SingleChildScrollView(
              child: Column(
                children: List.generate(
                  20,
                  (index) => Container(
                    margin: EdgeInsets.all(10),
                    height: 100,
                    color: Colors.blue[(index % 9 + 1) * 100],
                    child: Center(
                      child: Text(
                        'Item $index',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned widget
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text(
                  'Positioned Widget',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            // Align widget
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.green,
                child: Text(
                  'Aligned Widget',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
