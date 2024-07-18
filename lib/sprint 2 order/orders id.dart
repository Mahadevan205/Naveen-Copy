import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatefulWidget {
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  final _formKey = GlobalKey<FormState>();
  String token = window.sessionStorage["token"]?? " ";
  final _orderIdController = TextEditingController();
  List<Map> _orders = [];
  bool _loading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _orderIdController.addListener(_fetchOrders);
  }

  @override
  void dispose() {
    _orderIdController.removeListener(_fetchOrders);
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        final orderId = _orderIdController.text;
        final response = await http.get(
          Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId'),
          headers: {
            'Authorization': 'Bearer $token', // Replace with your API key
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            _orders = jsonData;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load orders';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: $e';
        });
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Order Master'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _orderIdController, // Assign the controller to the TextFormField
                decoration: InputDecoration(
                  labelText: 'Order ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an order ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : _orders.isEmpty
                  ? Center(child: Text('No orders found'))
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Order ID #${_orders[index]['orderId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Date: ${_orders[index]['orderDate']}'),
                        Text('Delivery Location: ${_orders[index]['deliveryLocation']}'),
                        Text('Delivery Address: ${_orders[index]['deliveryAddress']}'),
                        Text('Contact Person: ${_orders[index]['contactPerson']}'),
                        Text('Contact Number: ${_orders[index]['contactNumber']}'),
                        Text('Comments: ${_orders[index]['comments']}'),
                        Text('Total: ${_orders[index]['total'].toString()}'),
                        Text('Items:'),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _orders[index]['items'].length,
                          itemBuilder: (context, itemIndex) {
                            return ListTile(
                              title: Text(_orders[index]['items'][itemIndex]['productName']),
                              subtitle: Text('Quantity: ${_orders[index]['items'][itemIndex]['qty']}'),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}