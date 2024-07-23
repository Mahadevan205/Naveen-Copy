import 'dart:convert';
import 'dart:html';

import 'package:btb/Return%20Module/return%20image.dart';
import 'package:btb/Return%20Module/return%20logical.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../fourthpage/orderspage order.dart';
import '../sprint 2 order/firstpage.dart';
import 'package:http/http.dart' as http;
import '../thirdpage/dashboard.dart';

void main() {
  runApp(
      MaterialApp(
        home: CreateReturn(),)
        );
}



class CreateReturn extends StatefulWidget {
  @override
  State<CreateReturn> createState() => _CreateReturnState();
}

class _CreateReturnState extends State<CreateReturn> {

  final _controller = TextEditingController();
  List<dynamic> _orderDetails = [];
  String _enteredValues = '';
  int Index =1 ;
  double totalAmount = 0.0;
  final totalController = TextEditingController();

  String _enteredValue = '';
  String token = window.sessionStorage["token"] ?? " ";
  double _totalAmount = 0;
  //String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkaGFuYXNla2FyIiwiUm9sZXMiOlt7ImF1dGhvcml0eSI6ImRldmVsb3BlciJ9XSwiZXhwIjoxNzIxNjMwNDQ5LCJpYXQiOjE3MjE2MjMyNDl9.xLgmiyPCmi2spO9JrevsL--RWUPlpoThuK_v1tuaD8tqr-vb1uPMSlRgqvQHIXDBzN57kfZNhvvyTHKdWtUqqA';

  Future<void> _fetchOrderDetails() async {
    final orderId = _controller.text.trim();
    final url = orderId.isEmpty
        ? 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster/'
        : 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Response: $jsonData');
      final orderData = jsonData.firstWhere(
              (order) => order['orderId'] == orderId, orElse: () => null);

      if (orderData != null) {
        setState(() {
          _orderDetails = orderData['items'].map((item) => {
            'productName': item['productName'],
            'qty': item['qty'],
            'totalAmount': item['totalAmount'],
            'price': item['price'],
            'category': item['category'],
            'subCategory': item['subCategory']
          }).toList();
        });
      } else {
        setState(() {
          _orderDetails = [{'productName': 'not found'}];
        });
      }
    } else {
      setState(() {
        _orderDetails = [{'productName': 'Error fetching order details'}];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
      AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Image.asset("images/Final-Ikyam-Logo.png"),
        // Set background color to white
        elevation: 2.0,
        shadowColor: const Color(0xFFFFFFFF),
        // Set shadow color to black
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification icon press
                },
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 35),
                child: IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    // Handle user icon press
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(

        builder: (context, constraints){
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          return Stack(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                // Added Align widget for the left side menu
                alignment: Alignment.topLeft,
                child: Container(
                  height: 1400,
                  width: 200,
                  color: const Color(0xFFF7F6FA),
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // context
                          //     .go('${PageName.main}/${PageName.subpage1Main}');
                          context.go('/Dashboard');
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation,
                                  secondaryAnimation) =>
                              const Dashboard(
                              ),
                              transitionDuration:
                              const Duration(milliseconds: 200),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                          // context.go('${PageName.dashboardRoute}');
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => Dashboard()),
                          // );
                          // Navigator.pushReplacementNamed(
                          //     context, PageName.dashboardRoute);
                          // context
                          //     .go('${PageName.main} / ${PageName.subpage1Main}');
                        },
                        icon: Icon(
                            Icons.dashboard, color: Colors.indigo[900]),
                        label: Text(
                          'Home',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {
                          context.go('/Product_List');
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation,
                                  secondaryAnimation) =>
                              const ProductPage(
                                product: null,
                              ),
                              transitionDuration:
                              const Duration(milliseconds: 200),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.image_outlined,
                            color: Colors.indigo[900]),
                        label: Text(
                          'Products',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {
                          // context.go('${PageName.main}/${PageName.subpage1Main}');

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation,
                                  secondaryAnimation) =>
                              const Orderspage(),
                              transitionDuration:
                              const Duration(milliseconds: 200),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );

                          // setState(() {
                          //   isOrdersSelected = false;
                          //   // Handle button press19
                          // });
                        },
                        icon: Icon(Icons.warehouse,
                            color: Colors.blueAccent),
                        label: const Text(
                          'Orders',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.fire_truck_outlined,
                            color: Colors.blue[900]),
                        label: Text(
                          'Delivery',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.document_scanner_rounded,
                            color: Colors.blue[900]),
                        label: Text(
                          'Invoice',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.payment_outlined,
                            color: Colors.blue[900]),
                        label: Text(
                          'Payment',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.backspace_sharp,
                            color: Colors.blue[900]),
                        label: Text(
                          'Return',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                            Icons.insert_chart, color: Colors.blue[900]),
                        label: Text(
                          'Reports',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  left: 200,
                  right: 0,
                  top: 0,
                  bottom: 0,

                  child:
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              color: Colors.white,
                              height: 40,
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      'Order Return',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 130),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // context.go(
                                          //     '${PageName.dashboardRoute}/${PageName.subpage1}');
                                          //router
                                          // context.go('/Create_Order');
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                                  CreateReturn(),
                                              transitionDuration:
                                              const Duration(milliseconds: 200),
                                              transitionsBuilder: (context, animation,
                                                  secondaryAnimation, child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                          Colors.blueAccent,
                                          // Button background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                5), // Rounded corners
                                          ),
                                          side: BorderSide.none, // No outline
                                        ),
                                        child: const Text(
                                          'Create Return',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5),
                            // Space above/below the border
                            height: 3, // Border height
                            color: Colors.grey[100], // Border color
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 100,top: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF00000029),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                              color: Color(0xFFFFFFFF),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Invoice Number'),
                                            SizedBox(height: 5,),
                                            SizedBox(
                                              height: 40,
                                              child: TextField(
                                                controller: _controller,
                                                onEditingComplete: _fetchOrderDetails,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey.shade200,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'INV1900039'


                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Reason'),
                                            SizedBox(height: 5,),
                                            SizedBox(
                                              height: 40,
                                              child: DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey.shade200,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: 'Reason For Return',
                                                ),
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text('Option 1'),
                                                    value: 'Option 1',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text('Option 2'),
                                                    value: 'Option 2',
                                                  ),

                                                  // Add more options as needed
                                                ],
                                                isExpanded: true,
                                                onChanged: (value) {
                                                  // Handle the selected value
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Contact Person'),
                                            SizedBox(height: 5,),
                                            SizedBox(
                                              height: 40,
                                              child: TextField(
                                                decoration:  InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey.shade200,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'Person Name'


                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Email'),
                                            SizedBox(height: 5,),
                                            SizedBox(
                                              height: 40,
                                              child: TextField(
                                                decoration:  InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey.shade200,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'Person Email'


                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 100,top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF00000029),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 30),
                                  child: Text(
                                    'Add Products',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Titillium Web',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: maxWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    child: SizedBox(
                                      height: 34,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 80,right: 25),
                                              child: Text(
                                                "SN",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(

                                            child: Padding(
                                              padding: EdgeInsets.only(left: 26,right: 10),
                                              child: Text(
                                                'Product Name',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(

                                            child: Padding(padding: EdgeInsets.only(left: 52,right: 15),
                                              child: Text(
                                                "Category",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left:
                                                  45,right: 5),
                                              child: Text(
                                                "Sub Category",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 65,right: 10),
                                              child: Text(
                                                "Price",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(

                                            child: Padding(
                                              padding: EdgeInsets.only(left: 65,right: 25),
                                              child: Text(
                                                "QTY",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(

                                            child: Padding(
                                              padding: EdgeInsets.only(left: 40,right: 25),
                                              child: Text(
                                                "Return QTY",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(

                                            child: Padding(
                                              padding: EdgeInsets.only(left: 25,right: 25),
                                              child: Text(
                                                "Invoice Amount",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 25,right: 5),
                                            child: Center(
                                              child: Text("Credit Request ",style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10,right: 5),
                                            child: Center(
                                              child: Text(" ",style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _orderDetails.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> item = _orderDetails[index];
                                    return Table(
                                      border: TableBorder.all(color: Colors.blue
                                    //  Color(0xFFFFFFFF)
                                      ),
                                      children: [
                                        TableRow(
                                            children:[
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only( left: 10,
                                                      right: 10,
                                                      top: 15,
                                                      bottom: 5),
                                                  child: Center(child: Text('${index + 1}')),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Center(child: Text(item['productName'],textAlign: TextAlign.center,)),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Center(child: Text(item['category'],textAlign: TextAlign.center,)),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Center(child: Text(item['subCategory'])),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Center(child: Text(item['price'].toString())),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Center(child: Text(item['qty'].toString())),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child:TextFormField(
                                                      initialValue: (item['enteredQty']?? '').toString(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (value.isEmpty) {
                                                            item['enteredQty'] = 0;
                                                            item['totalAmount2'] = 0;
                                                          } else {
                                                            item['enteredQty'] = int.parse(value);
                                                            if (item['enteredQty'] > (item['qty']?? 0)) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                SnackBar(content: Text('Please enter a valid quantity')),
                                                              );
                                                            } else {
                                                              item['totalAmount2'] = item['price'] * item['enteredQty'];
                                                            }
                                                          }
                                                          // calculate the total amount
                                                          totalAmount = _orderDetails.fold(0.0, (sum, item) => sum + (item['totalAmount2']?? 0));
                                                          totalController.text = totalAmount.toStringAsFixed(2); // update the totalController
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Center(child: Text(item['totalAmount'].toString())),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                  child: Container(
                                                    height: 35,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: Center(child: Text(item['totalAmount2']!= null? item['totalAmount2'].toString() : '0'),
                                                    ),
                                                  ),
                                                ),

                                              ),
                                            ]
                                        )
                                      ],
                                      //old copy
                                      // child: Padding(
                                      //   padding: const EdgeInsets.all(10.0),
                                      //   child: Row(
                                      //     children: [
                                      //       Expanded(
                                      //         flex: 1,
                                      //         child: Text('${index + 1}'),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 2,
                                      //         child: Text(item['productName']?? 'Unknown Product'),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 2,
                                      //         child: Text(item['category']?? 'Unknown category'),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 2,
                                      //         child: Text(item['subCategory']?? 'Unknown subCategory'),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 1,
                                      //         child: Text(item['price'].toString()?? 'Unknown price'),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 1,
                                      //         child: Text(item['qty'].toString()?? 'Unknown price'),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 2,
                                      //         child: TextFormField(
                                      //           initialValue: (item['enteredQty']?? '').toString(),
                                      //           onChanged: (value) {
                                      //             setState(() {
                                      //               if (value.isEmpty) {
                                      //                 item['enteredQty'] = 0;
                                      //                 item['totalAmount2'] = 0;
                                      //               } else {
                                      //                 item['enteredQty'] = int.parse(value);
                                      //                 if (item['enteredQty'] > (item['qty']?? 0)) {
                                      //                   ScaffoldMessenger.of(context).showSnackBar(
                                      //                     SnackBar(content: Text('Please enter a valid quantity')),
                                      //                   );
                                      //                 } else {
                                      //                   item['totalAmount2'] = item['price'] * item['enteredQty'];
                                      //                 }
                                      //               }
                                      //               // calculate the total amount
                                      //               totalAmount = _orderDetails.fold(0.0, (sum, item) => sum + (item['totalAmount2']?? 0));
                                      //               totalController.text = totalAmount.toStringAsFixed(2); // update the totalController
                                      //             });
                                      //           },
                                      //         ),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 2,
                                      //         child: Text(item['totalAmount'].toString()?? 'Unknown price'),
                                      //       ),
                                      //       Expanded(
                                      //         flex: 2,
                                      //         child: Text(item['totalAmount2']!= null? item['totalAmount2'].toString() : '0'),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    );
                                  },
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(right: 25 ,top: 5,bottom: 5),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 15,right: 10,top: 6,bottom: 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RichText(text:
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:  'Total Credit',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.blue
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: '  ₹',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                  totalController.text,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 100,top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF00000029),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                              border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Image Upload',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Titillium Web',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:
                                      1300),
                                      child: ElevatedButton.icon(
                                        icon: Icon(Icons.upload_file),
                                        label: Text('Upload'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => NextPage(_orderDetails)),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          // backgroundColor: Color(0xFF4CAF50),
                                          backgroundColor: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(color: Color(0xFFFFFFFF),),

                                SizedBox(height: 8),
                                Column(
                                  children: [
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 100,top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF00000029),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                              border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    maxLines: 5, // To make it a single line text field
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))

            ],
          );
        }
      ),
    );
  }
}
DataRow dataRow(int sn, String productName, String brand, String category, String subCategory, String price, int qty, int returnQty, String invoiceAmount, String creditRequest) {
  return DataRow(cells: [
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(sn.toString()),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(productName),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(brand),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(category),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(subCategory),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(price),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(qty.toString()),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(returnQty.toString()),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(invoiceAmount),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(creditRequest),
        ),
      ),
    ),
  ]);
}



