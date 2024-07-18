// // import 'package:btb/fifthpage/firstpage%20sprint%202.dart';
// // import 'package:btb/fifthpage/thirdpage%20sprint%202.dart';
// // import 'package:btb/eighth%20page/sixthpage%20sprint%202.dart';
// import 'package:btb/fourthpage/orderspage%20order.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:btb/sprint2/product.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import '../main.dart';
// // import 'eight page.dart';
// // import 'thirdpage sprint 2.dart';
//
// // void main() {
// //   runApp(FifthPage());
// // }
//
// class FifthPage extends StatefulWidget {
//
//   final List<Product> selectedProducts;
//   const FifthPage({super.key, required this.selectedProducts});
//
//   @override
//   State<FifthPage> createState() => _FifthPageState();
// }
//
// class _FifthPageState extends State<FifthPage> {
//   Timer? _searchDebounceTimer;
//   String _searchText = '';
//   String _category = '';
//   bool isOrdersSelected = false;
//   List<Product> selectedProducts = [];
//   DateTime? _selectedDate;
//   late TextEditingController _dateController;
//   String _subCategory = '';
//   int startIndex = 0;
//   List<Product> filteredProducts = [];
//   int currentPage = 1;
//   String? dropdownValue1 = 'Filter I';
//   List<Product> productList = [];
//   String token = window.sessionStorage["token"] ?? " ";
//   String? dropdownValue2 = 'Filter II';
//
//   void _onSearchTextChanged(String text) {
//     if (_searchDebounceTimer != null) {
//       _searchDebounceTimer!.cancel(); // Cancel the previous timer
//     }
//     _searchDebounceTimer = Timer(Duration(milliseconds: 500), () {
//       setState(() {
//         _searchText = text;
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _dateController = TextEditingController();
//     fetchProducts(page: currentPage);
//     print('------------dadf');
//     print(widget.selectedProducts);
//   }
//
//   Future<void> fetchProducts({int? page}) async {
//     final response = await http.get(
//       Uri.parse(
//         'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster?startIndex=$startIndex&limit=20',
//       ),
//       headers: {
//         "Content-type": "application/json",
//         "Authorization": 'Bearer ${token}'
//       },
//     );
//
//     if (response.statusCode == 200) {
//       try {
//         final jsonData = jsonDecode(response.body);
//         if (jsonData is List) {
//           final products =
//           jsonData.map((item) => Product.fromJson(item)).toList();
//           setState(() {
//             if (currentPage == 1) {
//               productList = products.take(7).toList();
//             } else {
//               productList.addAll(products);
//             }
//             startIndex += 20;
//             currentPage++;
//           });
//         } else if (jsonData is Map) {
//           final products =
//           jsonData['body'].map((item) => Product.fromJson(item)).toList();
//           setState(() {
//             if (currentPage == 1) {
//               productList = products;
//             } else {
//               productList.addAll(products);
//             }
//             startIndex += 20;
//             currentPage++;
//           });
//         } else {
//           setState(() {
//             productList = []; // Initialize with an empty list
//           });
//         }
//       } catch (e) {
//         print('Error decoding JSON: $e');
//       }
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void _deleteProduct(Product product) {
//     setState(() {
//       widget.selectedProducts.remove(product);
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchDebounceTimer
//         ?.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Color(0xFFFFFFFF),
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFFFFFF),
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           // Set background color to white
//           elevation: 2.0,
//           shadowColor: Color(0xFFFFFFFF),
//           // Set shadow color to black
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 30),
//               child: IconButton(
//                 icon: Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 120),
//               child: IconButton(
//                 icon: Icon(Icons.account_circle),
//                 onPressed: () {
//                   // Handle user icon press
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Align(
//                 // Added Align widget for the left side menu
//                 alignment: Alignment.topLeft,
//                 child: Container(
//                   height: 1400,
//                   width: 200,
//                   color: Color(0xFFF7F6FA),
//                   padding: EdgeInsets.only(left: 20, top: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextButton.icon(
//                         onPressed: () {
//                           context
//                               .go('${PageName.main}/${PageName.subpage1Main}');
//                           // context.go('${PageName.dashboardRoute}');
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(builder: (context) => Dashboard()),
//                           // );
//                           // Navigator.pushReplacementNamed(
//                           //     context, PageName.dashboardRoute);
//                           // context
//                           //     .go('${PageName.main} / ${PageName.subpage1Main}');
//                         },
//                         icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
//                         label: Text(
//                           'Home',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {
//                           // context.go(
//                           //     '${PageName.dashboardRoute}/${PageName.subpage2}');
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const ProductPage(
//                                   product: null,
//                                 )),
//                           );
//                         },
//                         icon: Icon(Icons.image_outlined,
//                             color: Colors.indigo[900]),
//                         label: Text(
//                           'Products',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {
//                           // context.go('${PageName.main}/${PageName.subpage1Main}');
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //       builder: (context) => Orderspage()),
//                           // );
//                           // setState(() {
//                           //   isOrdersSelected = false;
//                           //   // Handle button press19
//                           // });
//                         },
//                         icon: Icon(Icons.warehouse,
//                             color: isOrdersSelected
//                                 ? Colors.blueAccent
//                                 : Colors.blueAccent),
//                         label: Text(
//                           'Orders',
//                           style: TextStyle(
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.fire_truck_outlined,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Delivery',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.document_scanner_rounded,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Invoice',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.payment_outlined,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Payment',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.backspace_sharp,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Return',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
//                         label: Text(
//                           'Reports',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 200),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     color: Colors.white,
//                     height: 60,
//                     child: Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.arrow_back), // Back button icon
//                           onPressed: () {
//                             //  Navigator.push(
//                             //      context,
//                             //     MaterialPageRoute(
//                             //       builder: (context) => SecondPage()),
//                             // );
//                           },
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 30),
//                           child: Text(
//                             'Create Order',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 900),
//                           child: OutlinedButton(
//                             onPressed: () {
//                               // context.go(
//                               //     '${PageName.dashboardRoute}/${PageName.subpage1}');
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //       builder: (context) => SixthPage()),
//                               // );
//                             },
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor: Colors
//                                   .blueAccent, // Button background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                     5), // Rounded corners
//                               ),
//                               side: BorderSide.none, // No outline
//                             ),
//                             child: const Text(
//                               'Create Order',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 43, left: 200),
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(
//                       vertical: 10), // Space above/below the border
//                   height: 3, // Border height
//                   color: Colors.grey[100], // Border color
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 1250, top: 80),
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Color(0xFFEBF3FF), width: 1),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFF418CFC)
//                                 .withOpacity(0.16), // 0.2 * 0.8 = 0.16
//                             spreadRadius: 0,
//                             blurRadius: 6,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         height: 39,
//                         width: 258,
//                         decoration: BoxDecoration(
//                           color: Colors.white
//                               .withOpacity(1), // Opacity is 1, fully opaque
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                 controller: _dateController,
//                                 // Replace with your TextEditingController
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   suffixIcon: Padding(
//                                     padding: const EdgeInsets.only(right: 20),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 2, left: 10),
//                                       child: IconButton(
//                                         icon: Padding(
//                                           padding:
//                                           const EdgeInsets.only(bottom: 16),
//                                           child: Icon(Icons.calendar_month),
//                                         ),
//                                         iconSize: 20,
//                                         onPressed: () {
//                                           _showDatePicker(context);
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   hintText: '        Select Date',
//                                   fillColor: Colors.white,
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 8),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 300, top: 200),
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey, width: 10),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       // Left container with multiple form fields
//                       child: Container(
//                         width: 798,
//                         height: 500,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           // Border to emphasize split
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 30, top: 20),
//                               child: Text(
//                                 'Delivery Location',
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 10), // Space above/below the border
//                               height: 1, // Border height
//                               color: Colors.grey, // Border color
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding:
//                                   const EdgeInsets.only(left: 30, top: 10),
//                                   child: Text(
//                                     'Address',
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: const EdgeInsets.symmetric(
//                                       vertical:
//                                       10), // Space above/below the border
//                                   height: 1, // Border height
//                                   color: Colors.grey, // Border color
//                                 ),
//                               ],
//                             ),
//                             // First row with "Name" and "Phone"
//                             Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.only(left: 30),
//                                           child: Text('Select Delivery Location'),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         SizedBox(
//                                           height: 50,
//                                           width: 420,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 bottom: 15, left: 30),
//                                             child: TextFormField(
//                                               // controller: nameController,
//                                               decoration: InputDecoration(
//                                                 hintText: '',
//                                                 contentPadding:
//                                                 EdgeInsets.all(8),
//                                                 border: OutlineInputBorder(),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: 32),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.only(left: 30),
//                                           child: Text('Contact Name'),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         SizedBox(
//                                           height: 50,
//                                           width: 400,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 bottom: 15, left: 30),
//                                             child: TextFormField(
//                                               // controller: phoneController,
//                                               decoration: InputDecoration(
//                                                 hintText: 'Contact Person Name',
//                                                 contentPadding:
//                                                 EdgeInsets.all(8),
//                                                 border: OutlineInputBorder(),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Second row with "Address Line 1" and "Fax"
//                             Padding(
//                                 padding:
//                                 const EdgeInsets.only(left: 14, bottom: 20),
//                                 child: Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 367, // or any other width you want
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 30),
//                                             child: Text('Delivery Address'),
//                                           ),
//                                           SizedBox(height: 10),
//                                           SizedBox(
//                                             height: 200,
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(bottom: 15, left: 30),
//                                               child: TextFormField(
//                                                 //controller: commentsController,
//                                                 decoration: InputDecoration(
//                                                   border: OutlineInputBorder(),
//                                                   contentPadding: EdgeInsets.symmetric(
//                                                     horizontal: 5,
//                                                     vertical: 70,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 16),
//                                     SizedBox(
//                                       width: 380, // or any other width you want
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 30, top: 10),
//                                             child: Text('Contact Number'),
//                                           ),
//                                           SizedBox(height: 10),
//                                           SizedBox(
//                                             height: 50,
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(bottom: 15, left: 30),
//                                               child: TextFormField(
//                                                 //controller: faxController,
//                                                 decoration: InputDecoration(
//                                                   hintText: 'Contact Person Number',
//                                                   contentPadding: EdgeInsets.all(8),
//                                                   border: OutlineInputBorder(),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 1100, top: 200),
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Container(
//                     width: 400,
//                     height: 500,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       // Border to emphasize split
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 30, top: 20),
//                           child: Text(
//                             '',
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 10), // Space above/below the border
//                           height: 1, // Border height
//                           color: Colors.grey, // Border color
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 30, top: 10),
//                               child: Text(
//                                 'Comments',
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 10), // Space above/below the border
//                               height: 1, // Border height
//                               color: Colors.grey, // Border color
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20, top: 30, right: 20),
//                           child: Row(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     child: SizedBox(
//                                       width: 350,
//                                       height: 200,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                           left: 10,
//                                           top: 10,
//                                           bottom: 10,
//                                         ),
//                                         child: TextFormField(
//                                           //controller: commentsController,
//                                           decoration: InputDecoration(
//                                             border: OutlineInputBorder(),
//                                             contentPadding:
//                                             EdgeInsets.symmetric(
//                                               horizontal: 5,
//                                               vertical: 70,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 300, top: 800),
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey, width: 10),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         height: 350,
//                         width: 1200,
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white, // Container background color
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 30, top: 10),
//                               child: Text(
//                                 'Add Parts',
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Table(
//                               border: TableBorder.all(
//                                   color: Colors.grey, width: 2.0),
//                               columnWidths: {
//                                 0: FlexColumnWidth(5),
//                                 1: FlexColumnWidth(10),
//                                 2: FlexColumnWidth(4),
//                                 3: FlexColumnWidth(4),
//                                 4: FlexColumnWidth(5),
//                                 5: FlexColumnWidth(3),
//                                 6: FlexColumnWidth(4),
//                                 7: FlexColumnWidth(4),
//                                 8: FlexColumnWidth(5),
//                               },
//                               children: [
//                                 TableRow(
//                                   children: [
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the first column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'SN',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the second column to 50
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 10, top: 15),
//                                           child: Text(
//                                             'Product Name',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .left, // set the alignment of the text to left
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the fourth column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'Category',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the fifth column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'Sub Category',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the sixth column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'Price',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the seventh column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'QTY',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the seventh column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'Total Amount',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the seventh column to 50
//                                         child: Center(
//                                           child: Text(
//                                             ' ',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 ...widget.selectedProducts.asMap().entries.map((entry) {
//                                   int index = entry.key;
//                                   Product product = entry.value;
//                                   return TableRow(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 8),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the second cell in the first column to 30
//                                             child: Center(
//                                               child: Text(
//                                                   (index + 1).toString(),
//                                                   textAlign:
//                                                   TextAlign.center),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 8),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the second cell in the second column to 30
//                                             child: Center(
//                                               child: Text(
//                                                   product.productName,
//                                                   textAlign:
//                                                   TextAlign.center),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 8),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the second cell in the first column to 30
//                                             child: Center(
//                                               child: Text(product.category,
//                                                   textAlign:
//                                                   TextAlign.center),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 8),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the second cell in the first column to 30
//                                             child: Center(
//                                               child: Text(
//                                                   product.subCategory,
//                                                   textAlign:
//                                                   TextAlign.center),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 8),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the second cell in the first column to 30
//                                             child: Center(
//                                               child: Text(
//                                                   product.price
//                                                       .toStringAsFixed(2),
//
//                                                   textAlign:
//                                                   TextAlign.center),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 8),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the second cell in the first column to 30
//                                             child: Center(
//                                               child: Text(
//                                                   product.quantity
//                                                       .toString(),
//                                                   textAlign:
//                                                   TextAlign.center),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 5, vertical: 8),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             child: Center(
//                                               child: Text(
//                                                 '${product.price * product.quantity}',
//                                                 // Calculate rate * quantity
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.only(top: 6),
//                                         child: TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the seventh column to 50
//                                             child: Center(
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.red,
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: IconButton(
//                                                   onPressed: () {
//                                                     _deleteProduct(product);
//                                                   },
//                                                   icon: Icon(
//                                                     Icons.delete,
//                                                     color: Colors.white,
//                                                   ),
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       // Add more cells for other product properties
//                                     ],
//                                   );
//                                 }).toList(),
//                               ],
//                             ),
//                             // In this place if i click that add button it will reflect data from that into this page in the row format
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding:
//                                   const EdgeInsets.only(left: 30, top: 50),
//                                   child: OutlinedButton(
//
//                                     onPressed: () {
//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(
//                                       //       builder: (context) => OrderPage3(subText: '', inputText: '',)),
//                                       // );
//                                     },
//
//                                     style: OutlinedButton.styleFrom(
//                                       backgroundColor: Colors.blue,// Blue background color
//                                       //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(
//                                             5), // Optional: Square corners
//                                       ),
//                                       side: BorderSide.none, // No  outline
//                                     ),
//                                     child: Text('+ Add Products', style: TextStyle(color: Colors.white),),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchField() {
//     return Container(
//       padding: const EdgeInsets.only(
//         left: 20,
//         right: 1000,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(color: Colors.grey[100]!),
//                   ),
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: 'Search',
//                       contentPadding: EdgeInsets.all(8),
//                       border: OutlineInputBorder(),
//                       suffixIcon: Icon(Icons.search_outlined),
//                     ),
//                     onChanged: _onSearchTextChanged,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(2),
//                           border: Border.all(color: Colors.grey!),
//                         ),
//                         child: DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             contentPadding:
//                             EdgeInsets.symmetric(horizontal: 10),
//                             border: InputBorder.none,
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Filter I',
//                           ),
//                           value: dropdownValue1,
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               dropdownValue1 = newValue;
//                             });
//                           },
//                           items: <String>['Filter I', 'Option 2', 'Option 3']
//                               .map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(2),
//                           border: Border.all(color: Colors.grey!),
//                         ),
//                         child: DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             contentPadding:
//                             EdgeInsets.symmetric(horizontal: 10),
//                             border: InputBorder.none,
//                             filled: true,
//                             fillColor: Colors.white,
//                             hintText: 'Filter II',
//                           ),
//                           value: dropdownValue2,
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               dropdownValue2 = newValue;
//                             });
//                           },
//                           items: <String>['Filter II', 'Option 2', 'Option 3']
//                               .map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDataTable() {
//     filteredProducts = productList
//         .where((Product) => Product.productName
//         .toLowerCase()
//         .contains(_searchText.toLowerCase()))
//         .where((Product) => _category.isEmpty || Product.category == _category)
//         .where((Product) =>
//     _subCategory.isEmpty || Product.subCategory == _subCategory)
//         .toList();
//
//     return Column(
//       children: [
//         Container(
//           color: Color(0xFFF7F7F7),
//           width: 1460,
//           child: DataTable(
//             headingRowHeight: 50,
//             columns: [
//               DataColumn(
//                 label: Text(
//                   'Status',
//                   style: TextStyle(
//                       color: Colors.indigo[900],
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Order ID',
//                   style: TextStyle(
//                       color: Colors.indigo[900],
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Created Date',
//                   style: TextStyle(
//                       color: Colors.indigo[900],
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Reference Number',
//                   style: TextStyle(
//                       color: Colors.indigo[900],
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Total Amount',
//                   style: TextStyle(
//                       color: Colors.indigo[900],
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(
//                   'Delivery Status',
//                   style: TextStyle(
//                       color: Colors.indigo[900],
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//             rows: filteredProducts.map((Product) {
//               return DataRow(
//                 color: MaterialStateColor.resolveWith((states) => Colors.white),
//                 cells: [
//                   DataCell(
//                     Text(
//                       Product.productName,
//                       style: TextStyle(color: Color(0xFFFFB315)),
//                     ),
//                   ),
//                   DataCell(
//                     Text(
//                       Product.category,
//                       style: TextStyle(color: Color(0xFFA6A6A6)),
//                     ),
//                   ),
//                   DataCell(
//                     Text(
//                       Product.subCategory,
//                       style: TextStyle(color: Color(0xFFA6A6A6)),
//                     ),
//                   ),
//                   DataCell(
//                     Text(
//                       Product.price.toString(),
//                       style: TextStyle(color: Color(0xFFA6A6A6)),
//                     ),
//                   ),
//                   DataCell(
//                     Text(
//                       Product.tax,
//                       style: TextStyle(color: Color(0xFFA6A6A6)),
//                     ),
//                   ),
//                   DataCell(
//                     Text(
//                       Product.unit,
//                       style: TextStyle(color: Color(0xFFA6A6A6)),
//                     ),
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showDatePicker(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2025),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _dateController.text = DateFormat.yMd().format(pickedDate);
//       });
//     }
//   }
// }
// //   void _showDatePicker(BuildContext context) {
// //     showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     ).then((selectedDate) {
// //       if (selectedDate != null) {
// //         // Handle selected date
// //       }
// //     });
// //   }
// // }
// //
// // class Product {
// //   final String proId;
// //   final String productName;
// //   final String category;
// //   final String subCategory;
// //   final double price;
// //   final String tax;
// //   String selectedVariation;
// //   String selectedUOM;
// //   final String unit;
// //
// //   Product({
// //     required this.proId,
// //     required this.productName,
// //     required this.category,
// //     required this.selectedVariation,
// //     required this.subCategory,
// //     required this.price,
// //     required this.selectedUOM,
// //     required this.tax,
// //     required this.unit,
// //   });
// //
// //   factory Product.fromJson(Map<String, dynamic> json) {
// //     return Product(
// //       proId: json['proId'] ?? '',
// //       selectedVariation: json['variation'] ?? 'Select',
// //       productName: json['productName'] ?? '',
// //       selectedUOM: json['uom'] ?? 'Select',
// //       category: json['category'] ?? '',
// //       subCategory: json['subCategory'] ?? '',
// //       price: json['price']?.toDouble() ?? 0.0,
// //       tax: json['tax'] ?? '',
// //       unit: json['unit'] ?? '',
// //     );
// //   }
