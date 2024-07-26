import 'dart:convert';
import 'dart:html';

import 'package:btb/sprint%202%20order/seventhpage%20.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

import '../fourthpage/orderspage order.dart';
import '../screen/login.dart';
import '../thirdpage/dashboard.dart';
import 'add productmaster sample.dart';
import 'firstpage.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EighthPage(),
  ));
}


class EighthPage extends StatefulWidget {
  const EighthPage({super.key});

  @override
  State<EighthPage> createState() => _EighthPageState();
}

class _EighthPageState extends State<EighthPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> data2 = {};
  DateTime? _selectedDate;
  final TextEditingController deliveryLocationController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = [];
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  final TextEditingController CreatedDateController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  bool? _isChecked1 = true;
  bool? _isChecked2 = true;
  String token = window.sessionStorage["token"]?? " ";
  List<Map> _orders = [];
  bool _loading = false;
  bool isEditing = false;
  late TextEditingController _dateController;
  bool? _isChecked3 = false;
  bool? _isChecked4 = false;
  final TextEditingController totalAmountController = TextEditingController();
  bool isOrdersSelected = false;
  String _errorMessage = '';
  final _orderIdController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _orderIdController.addListener(_fetchOrders);
    _dateController = TextEditingController();

    _selectedDate = DateTime.now();
    _dateController.text = DateFormat.yMd().format(_selectedDate!);
  }

  @override
  void dispose() {
    _orderIdController.removeListener(_fetchOrders);
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _orders = []; // clear the orders list
        _errorMessage = ''; // clear the error message
      });
      final orderId = _orderIdController.text.trim(); // trim to remove whitespace
      if (orderId.isEmpty) {
        setState(() {
          _loading = false;
          _errorMessage = 'No product found'; // show no product found message
        });
        return; // exit the function early
      }
      try {
        final response = await http.get(
          Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId'),
          headers: {
            'Authorization': 'Bearer $token', // Replace with your API key
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final responseBody = response.body;
          if (responseBody!= null) {
            final jsonData = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
            setState(() {
              _orders = jsonData;
              _errorMessage = ''; // clear the error message
            });
          } else {
            setState(() {
              _orders = []; // clear the orders list
              _errorMessage = 'Failed to load orders';
            });
          }
        } else {
          setState(() {
            _orders = []; // clear the orders list
            _errorMessage = 'Failed to load orders';
          });
        }
      } catch (e) {
        setState(() {
          _orders = []; // clear the orders list
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFFFFFF),
        title: Image.asset("images/Final-Ikyam-Logo.png"),
        // Set background color to white
        elevation: 2.0,
        shadowColor: const Color(0xFFFFFFFF),
        // Set shadow color to black
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle notification icon press
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 35),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.go('/');
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                          const LoginScr(
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
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ];
                  },
                  offset: Offset(0, 40), // Adjust the offset to display the menu below the icon
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
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: 200,
                    height: 1050,
                    color: const Color(0xFFF7F6FA),
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          // Added Align widget for the left side menu
                          alignment: Alignment.topLeft,
                          child: Container(
                           // height: 984,
                           // width: 250,
                            color: const Color(0xFFF7F6FA),
                            padding: const EdgeInsets.only(left: 20, top: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // context
                                    //     .go('${PageName.main}/${PageName.subpage1Main}');
                                    context.go('/Orders/dashboard');
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation, secondaryAnimation) =>
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
                                  icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
                                  label: Text(
                                    'Home',
                                    style: TextStyle(color: Colors.indigo[900]),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextButton.icon(
                                  onPressed: () {
                                    context.go('/orders/productpage/:product');
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation, secondaryAnimation) =>
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
                                    setState(() {
                                      isOrdersSelected = false;
                                      // Handle button press19
                                    });
                                  },
                                  icon: Icon(Icons.warehouse,
                                      color: isOrdersSelected
                                          ? Colors.blueAccent
                                          : Colors.blueAccent),
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
                                  icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
                                  label: Text(
                                    'Reports',
                                    style: TextStyle(color: Colors.indigo[900]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                   Positioned(
                     top: 0,
                     left: 200,
                     right: 0,
                     child: Padding(
                       padding: const EdgeInsets.only(
                         top: 0,
                         left: 0,
                       ),
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 16),
                         color: Colors.white,
                         height: 50,
                         child: Row(
                           children: [
                             IconButton(
                               icon:
                               const Icon(Icons.arrow_back), // Back button icon
                               onPressed: () {
                                 Navigator.push(
                                   context,
                                   PageRouteBuilder(
                                     pageBuilder:
                                         (context, animation, secondaryAnimation) =>
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
                               },
                             ),
                             const Padding(
                               padding: EdgeInsets.only(left: 30),
                               child: Text(
                                 'Parts Order List',
                                 style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                 ),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                             // Padding(
                             //   padding: const EdgeInsets.only(left: 80),
                             //   child: IconButton(
                             //     icon: Icon(Icons.arrow_circle_left_rounded,color: Colors.blue,),
                             //     tooltip: 'Go Back', onPressed: () {  },
                             //   ),
                             // ),
                             // Text('Go back')
                           ],
                         ),
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 0, left: 500),
                     child: Container(
                       margin: const EdgeInsets.symmetric(
                           horizontal: 10), // Space above/below the border
                       height: 1050,
                       // width: 1500,
                       width: 2,// Border height
                       color: Colors.grey[300], // Border color
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top: 43, left: 200),
                     child: Container(
                       margin: const EdgeInsets.symmetric(
                           vertical: 10), // Space above/below the border
                       height: 2,
                       // width: 1500,
                       width: constraints.maxWidth,// Border height
                       color: Colors.grey[300], // Border color
                     ),
                   ),
                   Container(
                     margin: const EdgeInsets.only(
                       top: 56,
                       left: 200,
                     ),
                     width: 300,
                     height: 984,
                     decoration: BoxDecoration(
                       color: Color(0xFFFFFFFF),
                       borderRadius: BorderRadius.circular(4),
                     ),
                     child: Form(
                       key: _formKey,
                       child: SingleChildScrollView(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                           children: [
                             SizedBox(
                               height: 100,
                               width: 60,
                               child: Padding(
                                 padding: const EdgeInsets.only(
                                     left: 15, right: 15, bottom: 1,top: 10),
                                 child: TextFormField(
                                   controller: _orderIdController, // Assign the controller to the TextFormField
                                   decoration: InputDecoration(
                                     // labelText: 'Order ID',
                                     hintText: 'Search Order',
                                     contentPadding: EdgeInsets.all(8),
                                     border: OutlineInputBorder(),
                                     prefixIcon: Icon(Icons.search_outlined),
                                   ),
                                 ),
                               ),
                             ),
                             SizedBox(height: 5),
                             _loading
                                 ? Center(child: CircularProgressIndicator())
                                 : _errorMessage.isNotEmpty
                                 ? Center(child: Text(_errorMessage))
                                 : _orders.isEmpty
                                 ? Center(child: Text('No product found'))
                                 : ListView.builder(
                               shrinkWrap: true,
                               itemCount: _orders.length,
                               itemBuilder: (context, index) {
                                 return GestureDetector(
                                   onTap: (){
                                     setState(() {
                                       _showProductDetails(index);
                                       //  Text('Order # ${_orders[index]['contactPerson']}');
                                       //  contactPersonController.text = ${_orders[index]['contactPerson']
                                     });
                                   },
                                   child: Container(
                                     margin: const EdgeInsets.all(5),
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       border: Border.all(color: Colors.grey),
                                       borderRadius: BorderRadius.circular(5),
                                     ),
                                     child: ListTile(
                                       title: Text('Order #${_orders[index]['orderId']}'),
                                       subtitle: Text('Order Date: ${_orders[index]['orderDate']}'),
                                     ),
                                   ),
                                 );
                               },
                             ),
                           ],
                         ),
                       ),
                     ),

                   ),
                  Padding(
                    padding: const EdgeInsets.only(left: 550, top: 100,right: 60),
                    child: Container(
                      height: 100,
                      width: maxWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    'Order',
                                    style: TextStyle(
                                      color: Colors.black,fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    'Invoice',
                                    style: TextStyle(
                                      color: Colors.grey,fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Payments',
                                    style: TextStyle(
                                      color: Colors.grey,fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Delivery',
                                    style: TextStyle(
                                      color: Colors.grey,fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 550, top: 270,right: 60),
                    child: Container(
                      height: 115,
                      width: constraints.maxWidth * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 6),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text('Order',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Spacer(),
                                Text('Available for Download'),
                                SizedBox(width: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.download_for_offline,color: Colors.green,),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 1, // 1 pixel height
                            width: double.infinity, // match parent width
                            color: Colors.grey, // adjust the color to your liking
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child:Column(
                                         children: [
                                           Text('Field'),
                                           Text('1521321'),
                                         ],
                                       ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 550, top: 440,right: 60),
                    child: Container(
                      height: 115,
                      width: constraints.maxWidth * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 6),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text('Invoice',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Spacer(),
                                Text('Available for Download'),
                                SizedBox(width: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.download_for_offline,color: Colors.grey,),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 1, // 1 pixel height
                            width: double.infinity, // match parent width
                            color: Colors.grey, // adjust the color to your liking
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child:Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 550, top: 610,right: 60),
                    child: Container(
                      height: 115,
                      width: constraints.maxWidth * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 6),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text('Payments',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Spacer(),
                                Text('Available for Download'),
                                SizedBox(width: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.download_for_offline,color: Colors.grey,),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 1, // 1 pixel height
                            width: double.infinity, // match parent width
                            color: Colors.grey, // adjust the color to your liking
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child:Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 550, top: 780,right: 60),
                    child: Container(
                      height: 115,
                      width: constraints.maxWidth * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 6),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text('Delivery',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Spacer(),
                                Text('Available for Download'),
                                SizedBox(width: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.download_for_offline,color: Colors.grey,),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 1, // 1 pixel height
                            width: double.infinity, // match parent width
                            color: Colors.grey, // adjust the color to your liking
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child:Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text('Field'),
                                    Text('1521321'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            );
        }
      )
    );
  }

  void _showProductDetails(int index) {
    final selectedOrderDetails = _orders[index];
    print('Selected Order:');
    print('Order ID: ${selectedOrderDetails['orderId']}');
    print('Order Date: ${selectedOrderDetails['orderDate']}');
    print('Contact Person: ${selectedOrderDetails['contactPerson']}');
    print('Delivery Location: ${selectedOrderDetails['deliveryLocation']}');
    print('total: ${selectedOrderDetails['total']}');

    data2['deliveryLocation'] = selectedOrderDetails['deliveryLocation'];
    print ('--------deliver');
    print(data2['deliveryLocation']);


    //
    //
    // final selectedItem = selectedOrder['items'];
    //
    // List<String> productNames = [];
    // List<String> prices = [];
    // List<String> quantities = [];
    // List<String> categories = [];
    // List<String> subCategories = [];
    // List<String> totalAmounts = [];
    //
    // // Iterate over the items
    // for (var item in selectedItem) {
    //   productNames.add(item['productName']);
    //   prices.add(item['price'].toString());
    //   quantities.add(item['qty'].toString());
    //   categories.add(item['category']);
    //   subCategories.add(item['subCategory']);
    //   totalAmounts.add(item['totalAmount'].toString());
    // }
    // for (int i = 0; i < productNames.length; i++) {
    //   print('Product Name: ${productNames[i]}');
    //   print('Price: ${prices[i]}');
    //   print('Quantity: ${quantities[i]}');
    //   print('Category: ${categories[i]}');
    //   print('Sub Category: ${subCategories[i]}');
    //   print('Total Amount: ${totalAmounts[i]}');
    //   print('------------------------');
    // }
    //
    // print('Product Names: $productNames');
    // print('Prices: $prices');
    // print('Quantities: $quantities');
    // print('Categories: $categories');
    // print('Sub Categories: $subCategories');
    // print('Total Amounts: $totalAmounts');
    //
    // for (int i = 0; i < productNames.length; i++) {
    //   productNameController.text += '${productNames[i]}\n';
    //   priceController.text += '${prices[i]}\n';
    //   qtyController.text += '${quantities[i]}\n';
    //   categoryController.text += '${categories[i]}\n';
    //   subCategoryController.text += '${subCategories[i]}\n';
    //   totalAmountController.text += '${totalAmounts[i]}\n';
    // }
    //
    print(productNameController.text);
    CreatedDateController.text = _orders[index]['orderDate'];
    orderIdController.text = _orders[index]['orderId'];
    deliveryLocationController.text = _orders[index]['deliveryLocation'];
    contactPersonController.text = _orders[index]['contactPerson'];
    deliveryAddressController.text = _orders[index]['deliveryAddress'];

    contactNumberController.text = _orders[index]['contactNumber'];
    commentsController.text = _orders[index]['comments'];
    totalController.text = _orders[index]['total'].toString();
    // contactPersonController.text = _orders[index]['orderDate'];
    deliveryLocationController.text = _orders[index]['deliveryLocation'];
    print('------------devli');
    print(data2['deliveryLocation']);
    final selectedOrder = _orders[index];
    setState(() {
      selectedItems = List<Map<String, dynamic>>.from(selectedOrder['items']);
    });

    print('Selected Order:');
    print('Order ID: ${selectedOrder['orderId']}');
    print('Order Date: ${selectedOrder['orderDate']}');
    print('Contact Person: ${selectedOrder['contactPerson']}');
    print('Delivery Location: ${selectedOrder['deliveryLocation']}');
    print('total: ${selectedOrder['total']}');

    for (var item in selectedItems) {
      print('Product Name: ${item['productName']}');
      print('Price: ${item['price']}');
      print('Quantity: ${item['qty']}');
      print('Category: ${item['category']}');
      print('Sub Category: ${item['subCategory']}');
      print('Total Amount: ${item['totalAmount']}');
      print('------------------------');

      // Add more fields to print as needed
    }
  }



}


Widget _buildCheckboxItem(
    String title, bool? isChecked, String content, Function(bool?) onChanged) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Checkbox(
        value: isChecked,
        onChanged: (value) {
          onChanged(value);
        },
        activeColor: Colors.green,
      ),
      const SizedBox(height: 8.0),
      Text(title),
      const SizedBox(height: 4.0),
      Text(
        content,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.grey[600],
        ),
      ),
    ],
  );


}

