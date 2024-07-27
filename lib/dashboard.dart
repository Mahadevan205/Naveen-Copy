import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'package:btb/Return%20Module/return%20first%20page.dart';
import 'package:btb/sprint%202%20order/sixthpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:btb/thirdpage/productclass.dart';
import '../screen/login.dart';
import '../sprint 2 order/firstpage.dart';
import 'Product Module/Create Product.dart';
import 'Product Module/Product Screen.dart';
void main() {
  runApp( const Dashboard());
}


class Dashboard extends StatefulWidget {
  const Dashboard({super.key,});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isHomeSelected = false;
  Timer? _searchDebounceTimer;
  String _searchText = '';
  final String _category = '';
  DateTime? _selectedDate;
  int? orderCount;
 // final appData = AppData();
  late TextEditingController _dateController;
  final String _subCategory = '';
  int startIndex = 0;
  List<Product> filteredProducts = [];
  int currentPage = 1;
  String? dropdownValue1 = 'Filter I';
  final _numberNotifier = ValueNotifier<int>(0);
  List<Product> productList = [];
  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Filter II';
  int? _orderCount;

  void _onSearchTextChanged(String text) {
    if (_searchDebounceTimer != null) {
      _searchDebounceTimer!.cancel(); // Cancel the previous timer
    }
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = text;
      });
    });
  }


  Future<List<detail>> fetchOrders() async {
    final response = await http.get(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster'),
      headers: {
        'Authorization': 'Bearer $token', // Add the token to the Authorization header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> detailJson = json.decode(response.body);
      return detailJson.map((json) => detail.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }





  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
   fetchOrders().then((orders) {
    setState(() {
        orderCount = orders.length;
        print('order count');
        print(orderCount);
      //  _numberNotifier.value = orderCount;
      });
   });
    fetchProducts(page: currentPage);

  }

  Future<void> fetchProducts({int? page}) async {
    final response = await http.get(
      Uri.parse(
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster?startIndex=$startIndex&limit=20',
      ),
      // headers: {
      //   "Content-type": "application/json",
      //   "Authorization": 'Bearer ${token}'
      // },
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          final products =
          jsonData.map((item) => Product.fromJson(item)).toList();
          setState(() {
            if (currentPage == 1) {
              productList = products.take(7).toList();
            } else {
              productList.addAll(products);
            }
            startIndex += 20;
            currentPage++;
          });
        } else if (jsonData is Map) {
          final products =
          jsonData['body'].map((item) => Product.fromJson(item)).toList();
          setState(() {
            if (currentPage == 1) {
              productList = products;
            } else {
              productList.addAll(products);
            }
            startIndex += 20;
            currentPage++;
          });
        } else {
          setState(() {
            productList = []; // Initialize with an empty list
          });
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void dispose() {
    _searchDebounceTimer
        ?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          appBar:
          AppBar(
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
                    child:
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.account_circle),
                      onSelected: (value) {
                        if (value == 'logout') {
                          window.sessionStorage.remove('token');
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
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Logout'),
                          ),
                        ];
                      },
                      offset: const Offset(0, 40), // Adjust the offset to display the menu below the icon
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
                return  Stack(
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
                                setState(() {
                                  isHomeSelected = false;
                                  // Handle button press19
                                });
                              },
                              icon: Icon(Icons.dashboard,
                                  color: isHomeSelected
                                      ? Colors.blueAccent
                                      : Colors.blueAccent),
                              label: const Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                // context.go(
                                //     '${PageName.dashboardRoute}/${PageName.subpage2}');
                                context.go('/dasbaord/productpage/:product');
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
                              icon:
                              Icon(Icons.image_outlined, color: Colors.indigo[900]),
                              label: Text(
                                'Products',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                context.go('/dasbaord/Orderspage');
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                     Orderspage(),
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
                              icon: Icon(Icons.warehouse_outlined,
                                  color: Colors.indigo[900]),
                              label: Text(
                                'Orders',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                // working in progress
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation, secondaryAnimation) =>
                                //      SixthPage(),
                                //     transitionDuration:
                                //     const Duration(milliseconds: 200),
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
                              },
                              icon: Icon(Icons.fire_truck_outlined,
                                  color: Colors.blue[900]),
                              label: Text(
                                'Delivery',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                // working in progress
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation, secondaryAnimation) =>
                                //      SixthPage(),
                                //     transitionDuration:
                                //     const Duration(milliseconds: 200),
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
                              },
                              icon: Icon(Icons.document_scanner_rounded,
                                  color: Colors.blue[900]),
                              label: Text(
                                'Invoice',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {

                              },
                              icon:
                              Icon(Icons.payment_outlined, color: Colors.blue[900]),
                              label: Text(
                                'Payment',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                context.go('/dashboard/return/:return');
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                    const Returnpage(),
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
                              icon:
                              Icon(Icons.backspace_sharp, color: Colors.blue[900]),
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
                    Positioned(
                      left: 100,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                color: Colors.white,
                                height: 60,
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Text(
                                        'Dashboard',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 80),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // context.go('/details/${fid}');
                                          // context.go(
                                          //     '${PageName.dashboardRoute}/${PageName.subpage1}');
                                          context.go('/Add_Product');
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder:
                                                  (context, animation, secondaryAnimation) =>
                                              const SecondPage(),
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
                                          Colors.blueAccent, // Button background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5), // Rounded corners
                                          ),
                                          side: BorderSide.none, // No outline
                                        ),
                                        child: const Text(
                                          'Create',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 100), // Space above/below the border
                              height: 2,
                              // width: 1000,
                              width: constraints.maxWidth,// Border height
                              color: Colors.grey[300], // Border color
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:10,right: 100),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFFEBF3FF), width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF418CFC)
                                              .withOpacity(0.16), // 0.2 * 0.8 = 0.16
                                          spreadRadius: 0,
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: 39,
                                      width: maxWidth *0.13,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withOpacity(1), // Opacity is 1, fully opaque
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _dateController,
                                              // Replace with your TextEditingController
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                suffixIcon: Padding(
                                                  padding: const EdgeInsets.only(right: 20),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 2, left: 10),
                                                    child: IconButton(
                                                      icon: const Padding(
                                                        padding: EdgeInsets.only(bottom: 16),
                                                        child: Icon(Icons.calendar_month),
                                                      ),
                                                      iconSize: 20,
                                                      onPressed: () {
                                                        _showDatePicker(context);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                hintText: '  Select Date',
                                                fillColor: Colors.white,
                                                contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                                border: InputBorder.none,
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding:  const EdgeInsets.only(left: 150,right: 100,top: 30),
                              child: SizedBox(

                                width:  maxWidth,
                                // height: maxHeight,
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Card(
                                          margin:  const EdgeInsets.only(left: 1, top: 20,),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          color: Colors.white,
                                          elevation: 2, // equivalent to the boxShadow in the original code
                                          child: Container(
                                            // height: 140,
                                            width: maxWidth * 0.15,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.withOpacity(0.1),
                                                  spreadRadius: 3,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8),
                                                  child: Image.asset(
                                                    "images/open.png",
                                                    width: 35, // Set your desired width
                                                    height: 35,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                  Padding(
                                         padding: const EdgeInsets.only(left: 10),
                                     child: Text('$orderCount', // Display the orderCount data
                                       style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                   ),
                         ),
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    'Open Orders',
                                                    style:
                                                    TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:20),
                                          child: Card(
                                            // margin:  EdgeInsets.only(left: 600, top: 150),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            color: Colors.white, // Set the color to white
                                            elevation: 2, // equivalent to the boxShadow in the original code
                                            child: Container(
                                              // height: 140,
                                              width: maxWidth * 0.15,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blue.withOpacity(0.1),
                                                    spreadRadius: 3,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 3),
                                                    child: Image.asset(
                                                      "images/file.png",
                                                      width: 35,
                                                      height: 35,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                   Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      '$orderCount',
                                                      style: TextStyle(
                                                          fontSize: 25, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      'Open Invoices',
                                                      style:
                                                      TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            color: Colors.white, // Set the color to white
                                            elevation: 2, // equivalent to the boxShadow in the original code
                                            child: Container(
                                              // height: 140,
                                              width: maxWidth * 0.15,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blue.withOpacity(0.1),
                                                    spreadRadius: 3,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5),
                                                    child: Image.asset(
                                                      "images/dash.png",
                                                      width: 35,
                                                      height: 35,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                   Padding(
                                                    padding: EdgeInsets.only(left: 8),
                                                    child: Text(
                                                      "$orderCount",
                                                      style: TextStyle(
                                                          fontSize: 25, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      'Available Credit Limit',
                                                      style:
                                                      TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:20,),
                                          child: Card(

                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            color: Colors.white, // Set the color to white
                                            elevation: 2, // equivalent to the boxShadow in the original code
                                            child: Container(
                                              // height: 140,
                                              width: maxWidth * 0.15,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blue.withOpacity(0.1),
                                                    spreadRadius: 3,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 1),
                                                    child: Image.asset(
                                                      "images/nk1.png",
                                                      width: 35,
                                                      height: 35,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                   Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      '$orderCount',
                                                      style: TextStyle(
                                                          fontSize: 25, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      'Order Completed',
                                                      style:
                                                      TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],

                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 1, top: 50,),
                                        child: Container(
                                          height: 600,
                                          width: maxWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(

                                                padding:  EdgeInsets.only(
                                                  left: 20,
                                                  right: maxWidth * 0.5,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const SizedBox(height: 8),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(4),
                                                              border: Border.all(color: Colors.grey[100]!),
                                                            ),
                                                            child: TextFormField(
                                                              decoration: const InputDecoration(
                                                                hintText: 'Search',
                                                                contentPadding: EdgeInsets.all(8),
                                                                border: OutlineInputBorder(),
                                                                suffixIcon: Icon(Icons.search_outlined),
                                                              ),
                                                              onChanged: _onSearchTextChanged,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(height: 8),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(2),
                                                                    border: Border.all(color: Colors.grey),
                                                                  ),
                                                                  child: DropdownButtonFormField<String>(
                                                                    decoration: const InputDecoration(
                                                                      contentPadding:
                                                                      EdgeInsets.symmetric(horizontal: 10),
                                                                      border: InputBorder.none,
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      hintText: 'Filter I',
                                                                    ),
                                                                    value: dropdownValue1,
                                                                    onChanged: (String? newValue) {
                                                                      setState(() {
                                                                        dropdownValue1 = newValue;
                                                                      });
                                                                    },
                                                                    items: <String>['Filter I', 'Option 2', 'Option 3']
                                                                        .map<DropdownMenuItem<String>>((String value) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: value,
                                                                        child: Text(value),
                                                                      );
                                                                    }).toList(),
                                                                    isExpanded: true,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 16),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(height: 8),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(2),
                                                                    border: Border.all(color: Colors.grey),
                                                                  ),
                                                                  child: DropdownButtonFormField<String>(
                                                                    decoration: const InputDecoration(
                                                                      contentPadding:
                                                                      EdgeInsets.symmetric(horizontal: 10),
                                                                      border: InputBorder.none,
                                                                      filled: true,
                                                                      fillColor: Colors.white,
                                                                      hintText: 'Filter II',
                                                                    ),
                                                                    value: dropdownValue2,
                                                                    onChanged: (String? newValue) {
                                                                      setState(() {
                                                                        dropdownValue2 = newValue;
                                                                      });
                                                                    },
                                                                    items: <String>['Filter II', 'Option 2', 'Option 3']
                                                                        .map<DropdownMenuItem<String>>((String value) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: value,
                                                                        child: Text(value),
                                                                      );
                                                                    }).toList(),
                                                                    isExpanded: true,
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
                                              const SizedBox(height: 10),
                                              SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: buildDataTable1()),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),


                              ),

                            ),
                          ],
                        ),
                      ),
                    )


                  ],
                );
              }
          )


      ),
    );
  }

  Widget buildSearchField1() {
    double maxWidth1 = MediaQuery.of(context).size.width;
    return
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 750,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search_outlined),
                        ),
                        onChanged: _onSearchTextChanged,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Filter I',
                              ),
                              value: dropdownValue1,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue1 = newValue;
                                });
                              },
                              items: <String>['Filter I', 'Option 2', 'Option 3']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Filter II',
                              ),
                              value: dropdownValue2,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue2 = newValue;
                                });
                              },
                              items: <String>['Filter II', 'Option 2', 'Option 3']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
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
      );
  }

  Widget buildDataTable1() {
    var _mediaQuery = MediaQuery.of(context).size.width;
    filteredProducts = productList
        .where((Product) => Product.productName
        .toLowerCase()
        .contains(_searchText.toLowerCase()))
        .where((Product) => _category.isEmpty || Product.category == _category)
        .where((Product) =>
    _subCategory.isEmpty || Product.subCategory == _subCategory)
        .toList();

    return Container(
      height: 50,
      width: _mediaQuery * 0.832,
      color: const Color(0xFFF7F7F7),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),

          },
          children:  [
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900]),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        'Order Id',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900]),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        'Created Date',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900]
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        'Reference Number',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900]),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        'Total Amount',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900]),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        'Delivery Status',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =  DateFormat('d/M/y').format(pickedDate);
      });
    }
  }
}

