//import 'package:btb/fifthpage/secondpage%20sprint2.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/Return%20Module/return%20module%20design.dart';
import 'package:btb/sprint%202%20order/secondpage.dart';
import 'package:btb/sprint%202%20order/seventhpage%20.dart';
//import 'package:btb/sprint%202%20order/sixthpage%20final%20responsive.dart';
import 'package:btb/sprint%202%20order/sixthpage.dart';
import 'package:btb/thirdpage/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

import '../Product Module/Product Screen.dart';
import '../screen/login.dart';
import '../sprint 2 order/firstpage.dart';
import '../dashboard.dart';


void main() {
  runApp(const Returnpage());
}

class Returnpage extends StatefulWidget {
  const Returnpage({super.key});

  @override
  State<Returnpage> createState() => _ReturnpageState();
}

class _ReturnpageState extends State<Returnpage> {
  Timer? _searchDebounceTimer;
  String _searchText = '';
  final String _category = '';
  bool isOrdersSelected = false;
  // Order? _selectedProduct;
  // List<Order> _orders = [];
  DateTime? _selectedDate;
  late TextEditingController _dateController;
  final String _subCategory = '';
  int startIndex = 0;
  List<Product> filteredProducts = [];
  int currentPage = 1;
  String? dropdownValue1 = 'Filter I';
  late Future<List<detail>> futureOrders;
  bool _loading = false;
  List<Product> productList = [];

  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Filter II';

  // 1void _onSearchTextChanged(String text) {
  //   if (_searchDebounceTimer != null) {
  //    _searchDebounceTimer!.cancel(); // Cancel the previous timer
  //  }
  //   _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
  //   setState(() {
  //       _searchText = text;
  //       _filteredOrders = _orders.where((order) => order.orderId.toLowerCase().contains(_searchText.toLowerCase())).toList();
  //     });
  //  });
  //  }



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


  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    futureOrders = fetchOrders();

  }

  Future<List<detail>> fetchOrders() async {
    final response = await http.get(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/return_master/get_all_returnmaster'),
      headers: {
        'Content-Type': 'application/json',
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
  void dispose() {
    _searchDebounceTimer
        ?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar:
        AppBar(
          automaticallyImplyLeading: false,
          leading: null,
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
            builder: (context,constraints) {
              double maxWidth = constraints.maxWidth;
              double maxHeight = constraints.maxHeight;
              return
                Stack(
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
                              },
                              icon: Icon(Icons.warehouse,
                                  color: Colors.blue[900]),
                              label:  Text(
                                'Orders',
                                style: TextStyle(
                                  color: Colors.blue[900],
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
                              onPressed: () {
                                setState(() {
                                  isOrdersSelected = false;
                                  // Handle button press19
                                });
                              },
                              icon: Icon(Icons.backspace_sharp,
                                  color: isOrdersSelected
                                      ? Colors.blueAccent
                                      : Colors.blueAccent),
                              label: const Text(
                                'Return',
                                style: TextStyle(color: Colors.blueAccent),
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
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 200),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.white,
                          height: 60,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  'Return Order List',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
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
                                       context.go('/Order_Return');
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                              CreateReturn(storeImage: 'even', imageSizeString: const [],imageSizeStrings: const [],storeImages: const [],orderDetails: const [],orderDetailsMap: const {},),
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
                                      'Create',
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
                      padding: const EdgeInsets.only(top: 43, left: 200),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10),
                        // Space above/below the border
                        height: 3, // Border height
                        color: Colors.grey[100], // Border color
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 250, top: 120, right: 150),
                      child: Container(
                        width: maxWidth,
                        height: 1100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue
                                  .withOpacity(0.2), // Light blue shadow
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: maxWidth * 0.79,
                              // padding: EdgeInsets.only(),
                              // margin: EdgeInsets.only(left: 400, right: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildSearchField(),
                                  // buildSearchField(),
                                  const SizedBox(height: 30),
                                  buildDataTable(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            // maxWidth: constraints.maxWidth,
            // maxHeight: constraints.maxHeight,
          ),
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20, // changed from 800 to 20
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth * 0.27, // 80% of screen width
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue[100]!),
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
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.13, // 40% of screen width
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(color: Colors.blue[100]!),
                                ),
                                child:
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Category',
                                  ),
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 25),
                                    child: Icon(Icons.arrow_drop_down_outlined),
                                  ), // default icon
                                  iconSize: 24, // change the size of the icon
                                  value: dropdownValue1,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue1 = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Filter I',
                                    'Select 1',
                                    'Select 2',
                                    'Select 3'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(width: constraints.maxWidth * 0.01),// 5% of screen width
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.13, // 40% of screen width
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Sub Category',
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down_outlined), // default icon
                                  iconSize: 24,
                                  value: dropdownValue2,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue2 = newValue;
                                    });
                                  },
                                  items: <String>['Filter II', 'Yes', 'No']
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    // return Container(
    //   padding: const EdgeInsets.only(
    //     left: 20,
    //     right: 800,
    //   ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const SizedBox(height: 8),
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Container(
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(4),
    //                 border: Border.all(color: Colors.grey[100]!),
    //               ),
    //               child: TextFormField(
    //                 decoration: const InputDecoration(
    //                   hintText: 'Search',
    //                   contentPadding: EdgeInsets.all(8),
    //                   border: OutlineInputBorder(),
    //                   suffixIcon: Icon(Icons.search_outlined),
    //                 ),
    //                 onChanged: _onSearchTextChanged,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 8),
    //       Row(
    //         children: [
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const SizedBox(height: 8),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: BorderRadius.circular(2),
    //                       border: Border.all(color: Colors.grey),
    //                     ),
    //                     child: DropdownButtonFormField<String>(
    //                       decoration: const InputDecoration(
    //                         contentPadding:
    //                         EdgeInsets.symmetric(horizontal: 10),
    //                         border: InputBorder.none,
    //                         filled: true,
    //                         fillColor: Colors.white,
    //                         hintText: 'Filter I',
    //                       ),
    //                       value: dropdownValue1,
    //                       onChanged: (String? newValue) {
    //                         setState(() {
    //                           dropdownValue1 = newValue;
    //                         });
    //                       },
    //                       items: <String>['Filter I', 'Option 2', 'Option 3']
    //                           .map<DropdownMenuItem<String>>((String value) {
    //                         return DropdownMenuItem<String>(
    //                           value: value,
    //                           child: Text(value),
    //                         );
    //                       }).toList(),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           const SizedBox(width: 16),
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 const SizedBox(height: 8),
    //                 Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: BorderRadius.circular(2),
    //                       border: Border.all(color: Colors.grey),
    //                     ),
    //                     child: DropdownButtonFormField<String>(
    //                       decoration: const InputDecoration(
    //                         contentPadding:
    //                         EdgeInsets.symmetric(horizontal: 10),
    //                         border: InputBorder.none,
    //                         filled: true,
    //                         fillColor: Colors.white,
    //                         hintText: 'Filter II',
    //                       ),
    //                       value: dropdownValue2,
    //                       onChanged: (String? newValue) {
    //                         setState(() {
    //                           dropdownValue2 = newValue;
    //                         });
    //                       },
    //                       items: <String>['Filter II', 'Option 2', 'Option 3']
    //                           .map<DropdownMenuItem<String>>((String value) {
    //                         return DropdownMenuItem<String>(
    //                           value: value,
    //                           child: Text(value),
    //                         );
    //                       }).toList(),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget buildDataTable() {
    return LayoutBuilder(builder: (context, constraints){
      // double padding = constraints.maxWidth * 0.065;
      double right = constraints.maxWidth;

      return FutureBuilder<List<detail>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                  width: right,
                  color: const Color(0xFFF7F7F7),
                  child: DataTable(
                    headingRowHeight: 50,
                    columns: [
                      DataColumn(label: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text('Status',style:TextStyle( color: Colors.indigo[900],   fontSize: 15,
                          fontWeight: FontWeight.bold,),),
                      )),
                      DataColumn(label: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('Order ID',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                            fontWeight: FontWeight.bold),),
                      )),
                      DataColumn(label: Text('Created Date',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                          fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Reference Number',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                          fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Total Amount',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                          fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Delivery Status',style:  TextStyle(
                          color: Colors.indigo[900],
                          fontSize: 15,
                          fontWeight: FontWeight.bold),)),
                    ],
                    rows: snapshot.data!.map((detail detail) {
                      const isSelected = false;
                      return DataRow(
                          color: MaterialStateColor.resolveWith(
                                  (states) => isSelected ? Colors.grey[200]! : Colors.white),
                          cells: [
                            DataCell(
                                Text(detail.status, style: TextStyle(fontSize: 15,color:isSelected ? Colors.deepOrange[200] : const Color(0xFFFFB315) ,),)),
                            // DataCell(
                            //     MouseRegion(
                            //       cursor: SystemMouseCursors.click,
                            //       onEnter: (event) {
                            //         setState(() {
                            //           detail.isSelected = true;
                            //         });
                            //       },
                            //       onExit: (event) {
                            //         detail.isSelected = false;
                            //       },
                            //       child: GestureDetector(
                            //         onTap: () {
                            //           //origingal
                            //           context.go('/OrdersList', extra: {
                            //             'product': detail,
                            //             'item': [], // pass an empty list of maps
                            //             'body': {},
                            //             'itemsList': [], // pass an empty list of maps
                            //           });
                            //
                            //           //  Order order = Order.fromDetail(_selectedOrder);
                            //           // setState(() {
                            //           //   _selectedProduct = order as Order?;
                            //           // });
                            //           // Navigate to the new page and pass the selected product as an argument
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => SixthPage(
                            //                   product: detail,
                            //                   item:  [],
                            //                   body: {},
                            //                   itemsList: [],
                            //                 )), // pass the selected product here
                            //           );
                            //         },
                            //         child: Container(
                            //           // padding: EdgeInsets.only(left: 40),
                            //             child: Text(detail.status, style: TextStyle(fontSize: 15,color:isSelected ? Colors.deepOrange[200] : const Color(0xFFFFB315) ,),)),
                            //       ),
                            //     )),
                            DataCell(Text(detail.orderId!)),
                            DataCell(Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(detail.orderDate),
                            )),
                            DataCell(Text(detail.referenceNumber)),
                            DataCell(Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(detail.total.toString()),
                            )),
                            DataCell(Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(detail.deliveryStatus),
                            )),

                          ]);
                    }).toList(),
                  ),
                )
              ],

            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
    });

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
        _dateController.text = DateFormat.yMd().format(pickedDate);
      });
    }
  }
}
//   void _showDatePicker(BuildContext context) {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     ).then((selectedDate) {
//       if (selectedDate != null) {
//         // Handle selected date
//       }
//     });
//   }
// }


// class detail {
//   final String? orderId;
//   final String? value;
//   final String orderDate;
//   bool isSelected = false;
//   final double total;
//   final String status;
//   final String deliveryStatus;
//   final String referenceNumber;
//   final String? deliveryLocation;
//   final String? deliveryAddress;
//   final String? contactPerson;
//   final String? contactNumber;
//   final String? comments;
//   final List<dynamic> items;
//
//   detail({
//     this.orderId,
//     required this.orderDate,
//     required this.total,
//     required this.status,
//     required this.deliveryStatus,
//     this.value,
//     required this.referenceNumber,
//     this.deliveryLocation,
//     this.deliveryAddress,
//     this.contactPerson,
//     this.contactNumber,
//     this.comments,
//     required this.items,
//
//   });
//
//   factory detail.fromJson(Map<String, dynamic> json) {
//     return detail(
//       orderId: json['orderId'],
//       orderDate: json['orderDate'] ?? 'Unknown date',
//       total: json['total'].toDouble(),
//       status: 'In preparation',
//       // Dummy value
//       deliveryStatus: 'Not Started',
//       // Dummy value
//       referenceNumber: '  ', // Dummy value
//       deliveryLocation: json['deliveryLocation'],
//       deliveryAddress: json['deliveryAddress'],
//       contactPerson: json['contactPerson'],
//       contactNumber: json['contactNumber'],
//       comments: json['comments'],
//       items: json['items'],
//     );
//   }
//
//   factory detail.fromString(String jsonString) {
//     final jsonMap = jsonDecode(jsonString);
//     return detail.fromJson(jsonMap);
//   }
//
//   @override
//   String toString() {
//     return 'Order ID: $orderId, Order Date: $orderDate, Total: $total, Status: $status, Delivery Status: $deliveryStatus, Reference Number: $referenceNumber';
//   }
//
//   String toJson() {
//     return jsonEncode({
//       "orderId": orderId,
//       "orderDate": orderDate,
//       "total": total,
//       "status": status,
//       "deliveryStatus": deliveryStatus,
//       "referenceNumber": referenceNumber,
//       "items": items,
//       "deliveryLocation": deliveryLocation,
//       "deliveryAddress": deliveryAddress,
//       "contactPerson": contactPerson,
//       "contactNumber": contactNumber,
//       "comments": comments,
//     });
//   }
// }




