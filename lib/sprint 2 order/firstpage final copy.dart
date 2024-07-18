import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Order {
  final String orderId;
  final String orderDate;
  final double total;
  final String status;
  final String deliveryStatus;
  final String referenceNumber;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.total,
    required this.status,
    required this.deliveryStatus,
    required this.referenceNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      orderDate: json['orderDate'] ?? 'Unknown date',
      total: json['total'].toDouble(),
      status: 'In preparation', // Dummy value
      deliveryStatus: 'Not Started', // Dummy value
      referenceNumber: '  ', // Dummy value
    );
  }
}

class OrderListPage extends StatefulWidget {

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  String token = window.sessionStorage["token"]?? " ";
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
  }

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster'),
      headers: {
        'Authorization': 'Bearer $token', // Add the token to the Authorization header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> ordersJson = json.decode(response.body);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body:
      FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Created Date')),
                  DataColumn(label: Text('Total Amount')),
                  DataColumn(label: Text('Delivery Status')),
                  DataColumn(label: Text('Reference Number')),
                ],
                rows: snapshot.data!.map((order) {
                  return DataRow(cells: [
                    DataCell(Text(order.status)),
                    DataCell(Text(order.orderId)),
                    DataCell(Text(order.orderDate)),
                    DataCell(Text(order.total.toString())),
                    DataCell(Text(order.deliveryStatus)),
                    DataCell(Text(order.referenceNumber)),
                  ]);
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
