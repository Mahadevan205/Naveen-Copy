import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FocusNode _productNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _productNameFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab Key Press Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              focusNode: _productNameFocusNode,
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
          ],
        ),
      ),
    );
  }
}