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
  List<Widget> _card1Fields = [];
  List<Widget> _card2Fields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Card 1'),
                  ),
                  ElevatedButton(
                    child: Text('Add Field'),
                    onPressed: () {
                      setState(() {
                        _card1Fields.add(
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Field ${_card1Fields.length + 1}',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _card1Fields.removeAt(_card1Fields.length - 1);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                  ..._card1Fields,
                ],
              ),
            ),
            SizedBox(height: 20), // space between cards
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Card 2'),
                  ),
                  ElevatedButton(
                    child: Text('Add Field'),
                    onPressed: () {
                      setState(() {
                        _card2Fields.add(
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Field ${_card2Fields.length + 1}',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _card2Fields.removeAt(_card2Fields.length - 1);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  ),
                  ..._card2Fields,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}