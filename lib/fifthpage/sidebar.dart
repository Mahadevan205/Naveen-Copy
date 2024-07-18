import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body:
      Row(
        children: <Widget>[
          // Sidebar
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: Colors.blue),
                  title: Text('Home', style: TextStyle(color: Colors.black)),
                  onTap: () {
                   print('onpress');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag, color: Colors.blue),
                  title: Text('Orders', style: TextStyle(color: Colors.blue)),
                  onTap: () {
                    // Handle orders tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.local_shipping, color: Colors.blue),
                  title: Text('Delivery', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    // Handle delivery tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt, color: Colors.blue),
                  title: Text('Invoice', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    // Handle invoice tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.payment, color: Colors.blue),
                  title: Text('Payment', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    // Handle payment tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.refresh, color: Colors.blue),
                  title: Text('Return', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    // Handle return tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.insert_chart, color: Colors.blue),
                  title: Text('Reports', style: TextStyle(color: Colors.black)),
                  onTap: () {
                    // Handle reports tap
                  },
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    color: Colors.red,
                    child: Center(child: Text('Content 1')),
                  ),
                  Container(
                    height: 200,
                    color: Colors.green,
                    child: Center(child: Text('Content 2')),
                  ),
                  Container(
                    height: 200,
                    color: Colors.blue,
                    child: Center(child: Text('Content 3')),
                  ),
                  Container(
                    height: 200,
                    color: Colors.yellow,
                    child: Center(child: Text('Content 4')),
                  ),
                  Container(
                    height: 200,
                    color: Colors.orange,
                    child: Center(child: Text('Content 5')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
