// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:btb/fourthpage/orderspage%20order.dart';
// import 'package:btb/sprint%202%20order/firstpage.dart';
// import 'package:btb/sprint%202%20order/fourthpage.dart';
// import 'package:btb/sprint%202%20order/sixthpage.dart';
// import 'package:btb/thirdpage/productclass.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../thirdpage/dashboard.dart';
//
//
// void main(){
//   runApp(FifthPage(selectedProducts: [], data: {}, select: '', ));
// }
//
// class FifthPage extends StatefulWidget {
//   final List<Product> selectedProducts;
//   final Map<String, dynamic> data;
//   final String select;
//
//
//   const FifthPage(
//       {super.key, required this.selectedProducts,
//         required this.select,
//
//         required this.data});
//
//   @override
//   State<FifthPage> createState() => _FifthPageState();
// }
//
// class _FifthPageState extends State<FifthPage> {
//   List<Product> products = [];
//   final dummyProducts = '';
//   Timer? _searchDebounceTimer;
//   double _total = 0.0;
//   String _searchText = '';
//   final String _category = '';
//   final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
//   bool isOrdersSelected = false;
//   List<Product> selectedProducts = [];
//   final TextEditingController commentsController = TextEditingController();
//
//   final TextEditingController totalAmountController = TextEditingController();
//
//   final TextEditingController totalController = TextEditingController();
//   final TextEditingController productNameController = TextEditingController();
//   List<Product> showProducts = [];
//   final TextEditingController deliveryAddressController = TextEditingController();
//   final TextEditingController contactNumberController = TextEditingController();
//
//   final TextEditingController contactPersonController = TextEditingController();
//
//
//   DateTime? _selectedDate;
//   late TextEditingController _dateController;
//   final String _subCategory = '';
//   Map<String, dynamic> data2 = {};
//   int startIndex = 0;
//   List<Product> filteredProducts = [];
//   int currentPage = 1;
//   String? dropdownValue1 = 'Filter I';
//   List<Product> productList = [];
//   String token = window.sessionStorage["token"] ?? " ";
//   String? dropdownValue2 = 'Filter II';
//
//   void onSearchTextChanged(String text) {
//     if (_searchDebounceTimer != null) {
//       _searchDebounceTimer!.cancel(); // Cancel the previous timer
//     }
//     _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
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
//
//
//     commentsController.text = widget.data['Comments'] ?? '';
//     deliveryAddressController.text = widget.data['Address'] ?? '';
//     contactNumberController.text = widget.data['ContactNumber'] ?? '';
//     contactPersonController.text = widget.data['ContactName'] ?? '';
//
//     print('------------dadf');
//
//     _calculateTotal();
//     _selectedDate = DateTime.now();
//     _dateController.text = DateFormat.yMd().format(_selectedDate!);
//     print(widget.data);
//     print('-hello');
//     data2 = widget.data;
//     data2 = Map.from(widget.data);
//     // totalAmountController.text = data2['totalAmount'];
//     print(widget.selectedProducts);
//     // print(showProducts);
//   }
//
//   void _calculateTotal() {
//     _total = 0.0;
//     for (var product in widget.selectedProducts) {
//       _total += product.total; // Add the total of each product to _total
//     }
//     setState(() {
//
//     });
//   }
//
//
//   Future<void> callApi() async {
//
//     List<Map<String, dynamic>> items = [];
//
//     for (int i = 0; i < widget.selectedProducts.length; i++) {
//       Product product = widget.selectedProducts[i];
//       items.add({
//         "productName": product.productName,
//         "category": product.category,
//         "subCategory": product.subCategory,
//         "price": product.price.toStringAsFixed(2),
//         "qty": product.quantity.toString(),
//         "totalAmount": (product.price * product.quantity).toStringAsFixed(2),
//       });
//     }
//
//     final url = 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/add_order_master';
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${token}',
//     };
//     final body = {
//       "orderDate": data2['date'],
//       "deliveryLocation": data2['deliveryLocation'],
//       "deliveryAddress":  deliveryAddressController.text,
//       "contactPerson": contactPersonController.text,
//       "contactNumber": contactNumberController.text,
//       "comments":  commentsController.text,
//       "total": data2['totalAmount'],
//       "items": items,
//     };
//
//     final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
//
//     if (response.statusCode == 200) {
//       print('API call successful');
//       final responseData = json.decode(response.body);
//
//       // Add null checks and error handling
//       String orderId;
//       try {
//         orderId = responseData['id'];
//       } catch (e) {
//         print('Error parsing orderId: $e');
//         orderId = ''; // or some default value
//       }
//
//       detail details;
//       try {
//         details = detail(
//           orderId: orderId,
//           orderDate: data2['date'],
//           total: double.parse(data2['totalAmount']),
//           status: '', // Initialize status as empty string
//           deliveryStatus: '', // Initialize delivery status as empty string
//           referenceNumber: '', items: [], // Initialize reference number as empty string
//         );
//       } catch (e) {
//         print('Error creating detail object: $e');
//         details = detail(orderId: '', orderDate: '', total: 0, status: '', deliveryStatus: '', referenceNumber: '', items: []); // or some default value
//       }
//
//       if (details != null) {
//         context.go('/Place_Order/Order_List');
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (
//                 context, animation,
//                 secondaryAnimation) =>
//                 SixthPage(
//               product: details,
//               item: items,
//               body: body,
//               itemsList: items,
//             ),
//           ),
//         );
//       } else {
//         print('Failed to create detail object, not navigating to SixthPage');
//       }
//     } else {
//       print('API call failed with status code ${response.statusCode}');
//     }
//   }
//
//
//   void _deleteProduct(Product product) {
//     setState(() {
//       widget.selectedProducts.remove(product);
//       _calculateTotal();
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
//           backgroundColor: const Color(0xFFFFFFFF),
//           appBar: AppBar(
//             backgroundColor: const Color(0xFFFFFFFF),
//             title: Image.asset("images/Final-Ikyam-Logo.png"),
//             // Set background color to white
//             elevation: 2.0,
//             shadowColor: const Color(0xFFFFFFFF),
//             // Set shadow color to black
//             actions: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   icon: const Icon(Icons.notifications),
//                   onPressed: () {
//                     // Handle notification icon press
//                   },
//                 ),
//               ),
//               SizedBox(width: 10,),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 35),
//                   child: IconButton(
//                     icon: const Icon(Icons.account_circle),
//                     onPressed: () {
//                       // Handle user icon press
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body:
//           LayoutBuilder(
//               builder: (context, constraints){
//                 double maxHeight = constraints.maxHeight;
//                 double maxWidth = constraints.maxWidth;
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Stack(
//                       children: [
//                         Align(
//                           // Added Align widget for the left side menu
//                           alignment: Alignment.topLeft,
//                           child: Container(
//                             height: 1400,
//                             width: 200,
//                             color: const Color(0xFFF7F6FA),
//                             padding: const EdgeInsets.only(left: 20, top: 30),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextButton.icon(
//                                   onPressed: () {
//                                     // context
//                                     //     .go('${PageName.main}/${PageName.subpage1Main}');
//                                     context.go('/Orderspage/placingorder/dasbaord');
//                                     Navigator.push(
//                                       context,
//                                       PageRouteBuilder(
//                                         pageBuilder:
//                                             (context, animation, secondaryAnimation) =>
//                                         const Dashboard(
//
//                                         ),
//                                         transitionDuration:
//                                         const Duration(milliseconds: 200),
//                                         transitionsBuilder: (context, animation,
//                                             secondaryAnimation, child) {
//                                           return FadeTransition(
//                                             opacity: animation,
//                                             child: child,
//                                           );
//                                         },
//                                       ),
//                                     );
//
//                                     // Navigator.pushReplacementNamed(
//                                     //     context, PageName.dashboardRoute);
//                                     // context
//                                     //     .go('${PageName.main} / ${PageName.subpage1Main}');
//                                   },
//                                   icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
//                                   label: Text(
//                                     'Home',
//                                     style: TextStyle(color: Colors.indigo[900]),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextButton.icon(
//                                   onPressed: () {
//                                     context.go(
//                                         '/Orderspage/placingorder/productpage:product');
//                                     Navigator.push(
//                                       context,
//                                       PageRouteBuilder(
//                                         pageBuilder:
//                                             (context, animation, secondaryAnimation) =>
//                                         const ProductPage(
//                                           product: null,
//                                         ),
//                                         transitionDuration:
//                                         const Duration(milliseconds: 200),
//                                         transitionsBuilder: (context, animation,
//                                             secondaryAnimation, child) {
//                                           return FadeTransition(
//                                             opacity: animation,
//                                             child: child,
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   },
//                                   icon: Icon(Icons.image_outlined,
//                                       color: Colors.indigo[900]),
//                                   label: Text(
//                                     'Products',
//                                     style: TextStyle(color: Colors.indigo[900]),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextButton.icon(
//                                   onPressed: () {
//                                     context.go('/BeforplacingOrder/Orderspage');
//                                     // Navigator.push(
//                                     //   context,
//                                     //   PageRouteBuilder(
//                                     //     pageBuilder: (context, animation,
//                                     //         secondaryAnimation) =>
//                                     //     const Orderspage(),
//                                     //     transitionDuration: const Duration(
//                                     //         milliseconds: 200),
//                                     //     transitionsBuilder:
//                                     //         (context, animation, secondaryAnimation,
//                                     //         child) {
//                                     //       return FadeTransition(
//                                     //         opacity: animation,
//                                     //         child: child,
//                                     //       );
//                                     //     },
//                                     //   ),
//                                     // );
//                                     setState(() {
//                                       isOrdersSelected = false;
//                                       // Handle button press19
//                                     });
//                                   },
//                                   icon: Icon(Icons.warehouse,
//                                       color: isOrdersSelected
//                                           ? Colors.blueAccent
//                                           : Colors.blueAccent),
//                                   label: const Text(
//                                     'Orders',
//                                     style: TextStyle(
//                                       color: Colors.blueAccent,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextButton.icon(
//                                   onPressed: () {},
//                                   icon: Icon(Icons.fire_truck_outlined,
//                                       color: Colors.blue[900]),
//                                   label: Text(
//                                     'Delivery',
//                                     style: TextStyle(color: Colors.indigo[900]),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextButton.icon(
//                                   onPressed: () {},
//                                   icon: Icon(Icons.document_scanner_rounded,
//                                       color: Colors.blue[900]),
//                                   label: Text(
//                                     'Invoice',
//                                     style: TextStyle(color: Colors.indigo[900]),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextButton.icon(
//                                   onPressed: () {},
//                                   icon: Icon(Icons.payment_outlined,
//                                       color: Colors.blue[900]),
//                                   label: Text(
//                                     'Payment',
//                                     style: TextStyle(color: Colors.indigo[900]),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextButton.icon(
//                                   onPressed: () {},
//                                   icon: Icon(Icons.backspace_sharp,
//                                       color: Colors.blue[900]),
//                                   label: Text(
//                                     'Return',
//                                     style: TextStyle(color: Colors.indigo[900]),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextButton.icon(
//                                   onPressed: () {},
//                                   icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
//                                   label: Text(
//                                     'Reports',
//                                     style: TextStyle(color: Colors.indigo[900]),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 200),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 16),
//                               color: Colors.white,
//                               height: 60,
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     icon:
//                                     const Icon(Icons.arrow_back), // Back button icon
//                                     onPressed: () {
//                                       context.go(
//                                           '/dasbaord/Orderspage/placeorder/arrowback');
//                                       //  Navigator.push(
//                                       //      context,
//                                       //     MaterialPageRoute(
//                                       //       builder: (context) => NextPage(product: , data: data2, inputText: '', subText: '')),
//                                       // );
//                                     },
//                                   ),
//                                   const Padding(
//                                     padding: EdgeInsets.only(left: 30),
//                                     child: Text(
//                                       'Create Order',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 850),
//                                     child: OutlinedButton(
//                                       onPressed: () async {
//                                         await callApi();
//                                       },
//                                       style: OutlinedButton.styleFrom(
//                                         backgroundColor:
//                                         Colors.blueAccent, // Button background color
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                           BorderRadius.circular(5), // Rounded corners
//                                         ),
//                                         side: BorderSide.none, // No outline
//                                       ),
//                                       child: const Text(
//                                         'Create Order',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 43, left: 200),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 10), // Space above/below the border
//                             height: 2,
//                             // width: 1000,
//                             width: constraints.maxWidth,// Border height
//                             color: Colors.grey[300], // Border color
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 1190,top: 90),
//                           child: Text(('Order Date')),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 1190, top: 120),
//                               child: Container(
//                                 height: 39,
//                                 width: 208,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[300]!
//                                       .withOpacity(1), // Opacity is 1, fully opaque
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                       child: TextFormField(
//                                         controller: _dateController,
//                                         // Replace with your TextEditingController
//                                         readOnly: true,
//                                         decoration: InputDecoration(
//                                           suffixIcon: Padding(
//                                             padding: const EdgeInsets.only(right: 20),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   top: 2, left: 10),
//                                               child: IconButton(
//                                                 icon: const Padding(
//                                                   padding: EdgeInsets.only(bottom: 16),
//                                                   child: Icon(Icons.calendar_month),
//                                                 ),
//                                                 iconSize: 20,
//                                                 onPressed: () {
//                                                   // _showDatePicker(context);
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                           hintText: '        Select Date',
//                                           fillColor: Colors.grey[200],
//                                           contentPadding: const EdgeInsets.symmetric(
//                                               horizontal: 8, vertical: 8),
//                                           border: InputBorder.none,
//                                           filled: true,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.start,
//                         //   children: [
//                         //     Padding(
//                         //       padding: const EdgeInsets.only(left: 1150, top: 80),
//                         //       child: DecoratedBox(
//                         //         decoration: BoxDecoration(
//                         //           border: Border.all(
//                         //               color: const Color(0xFFEBF3FF), width: 1),
//                         //           borderRadius: BorderRadius.circular(10),
//                         //           boxShadow: [
//                         //             BoxShadow(
//                         //               color: const Color(0xFF418CFC)
//                         //                   .withOpacity(0.16), // 0.2 * 0.8 = 0.16
//                         //               spreadRadius: 0,
//                         //               blurRadius: 6,
//                         //               offset: const Offset(0, 3),
//                         //             ),
//                         //           ],
//                         //         ),
//                         //         child: Container(
//                         //           height: 39,
//                         //           width: 258,
//                         //           decoration: BoxDecoration(
//                         //             color: Colors.white
//                         //                 .withOpacity(1), // Opacity is 1, fully opaque
//                         //             borderRadius: BorderRadius.circular(4),
//                         //           ),
//                         //           child: Column(
//                         //             children: [
//                         //               Expanded(
//                         //                 child: TextFormField(
//                         //                   controller: TextEditingController(
//                         //                       text: data2['date'] != null
//                         //                           ? DateFormat('dd-MM-yyyy').format(
//                         //                           DateTime.parse(data2['date']))
//                         //                           : 'Select Date'),
//                         //                   // Replace with your TextEditingController
//                         //                   readOnly: true,
//                         //                   decoration: InputDecoration(
//                         //                     suffixIcon: Padding(
//                         //                       padding: const EdgeInsets.only(right: 20),
//                         //                       child: Padding(
//                         //                         padding: const EdgeInsets.only(
//                         //                             top: 2, left: 10),
//                         //                         child: IconButton(
//                         //                           icon: const Padding(
//                         //                             padding: EdgeInsets.only(bottom: 16),
//                         //                             child: Icon(Icons.calendar_month),
//                         //                           ),
//                         //                           iconSize: 20,
//                         //                           onPressed: () {
//                         //                             // _showDatePicker(context);
//                         //                           },
//                         //                         ),
//                         //                       ),
//                         //                     ),
//                         //                     hintText: '        Select Date',
//                         //                     fillColor: Colors.white,
//                         //                     contentPadding: const EdgeInsets.symmetric(
//                         //                         horizontal: 8, vertical: 8),
//                         //                     border: InputBorder.none,
//                         //                     filled: true,
//                         //                   ),
//                         //                 ),
//                         //               ),
//                         //             ],
//                         //           ),
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 300,top: 200),
//                           child: Container(
//                             height:  350,
//                             width: 1100,
//                             // padding: EdgeInsets.all(16.0),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey,width: 2),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child:  Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Padding(
//                                   padding:  EdgeInsets.only(left: 30,top: 10),
//                                   child: Text(
//                                     'Delivery Location',
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 const Divider(color: Colors.grey),
//                                 const Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Padding(
//                                       padding:  EdgeInsets.only(left: 30,bottom: 5),
//                                       child: Text(
//                                         'Address',
//                                         style: TextStyle(
//                                           fontSize: 15.0,
//                                           // fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(right:300),
//                                       child: Text(
//                                         'Comments',
//                                         style: TextStyle(
//                                           fontSize: 15.0,
//                                           //fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(
//                                   color: Colors.grey,
//                                   thickness: 1.0,
//                                   height: 1.0,
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           const Padding(
//                                             padding:  EdgeInsets.only(left: 30),
//                                             child: Text('Select Delivery Location'),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 30),
//                                             child: SizedBox(
//                                               width: 350,
//                                               height: 40,
//                                               child: DropdownButtonFormField<String>(
//                                                 value: data2['deliveryLocation'],
//                                                 decoration: InputDecoration(
//                                                   filled: true,
//                                                   fillColor: Colors.grey[200],
//                                                   border: OutlineInputBorder(
//                                                     borderRadius: BorderRadius.circular(5.0),
//                                                     borderSide: BorderSide.none,
//                                                   ),
//                                                   contentPadding:const EdgeInsets.symmetric(
//                                                       horizontal: 8, vertical: 8),
//                                                 ),
//                                                 onChanged: (String? value) {
//                                                   setState(() {
//                                                     data2['deliveryLocation'] = value!;
//                                                   });
//                                                 },
//                                                 items: list.map<DropdownMenuItem<String>>((String value) {
//                                                   return DropdownMenuItem<String>(
//                                                     value: value,
//                                                     child: Text(value),
//                                                   );
//                                                 }).toList(),
//                                                 isExpanded: true,
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 20.0),
//                                           const Padding(
//                                             padding:  EdgeInsets.only(left: 30),
//                                             child: Text('Delivery Address'),
//                                           ),
//                                           const SizedBox(height: 10,),
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 30),
//                                             child: SizedBox(
//                                               width: 350,
//
//                                               child: TextField(
//                                                 controller: deliveryAddressController,
//                                                 decoration: InputDecoration(
//                                                   filled: true,
//                                                   fillColor: Colors.grey[200],
//                                                   border: OutlineInputBorder(
//                                                     borderRadius: BorderRadius.circular(5.0),
//                                                     borderSide: BorderSide.none,
//                                                   ),
//                                                   hintText: 'Address Details',
//                                                 ),
//                                                 maxLines: 3,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(width: 30.0),
//                                     Expanded(
//                                       flex: 3,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           const Text('Contact Person'),
//                                           SizedBox(
//                                             width: 350,
//                                             height: 40,
//                                             child: TextField(
//                                               controller: contactPersonController,
//                                               decoration: InputDecoration(
//                                                 filled: true,
//                                                 fillColor: Colors.grey[200],
//                                                 border: OutlineInputBorder(
//                                                   borderRadius: BorderRadius.circular(5.0),
//                                                   borderSide: BorderSide.none,
//                                                 ),
//                                                 hintText: 'Contact Person Name',
//                                                 contentPadding:const EdgeInsets.symmetric(
//                                                     horizontal: 8, vertical: 8),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 20.0),
//                                           const Text('Contact Number'),
//                                           const SizedBox(height: 10,),
//                                           SizedBox(
//                                             width: 350,
//                                             height: 40,
//                                             child: TextField(
//                                               controller: contactNumberController,
//                                               keyboardType:
//                                               TextInputType.number,
//                                               // inputFormatters: [
//                                               //   FilteringTextInputFormatter
//                                               //       .digitsOnly,
//                                               //   LengthLimitingTextInputFormatter(
//                                               //       10),
//                                               //   // limits to 10 digits
//                                               // ],
//                                               decoration: InputDecoration(
//                                                 filled: true,
//                                                 fillColor: Colors.grey[200],
//                                                 border: OutlineInputBorder(
//                                                   borderRadius: BorderRadius.circular(5.0),
//                                                   borderSide: BorderSide.none,
//                                                 ),
//                                                 hintText: 'Contact Person Number',
//                                                 contentPadding:const EdgeInsets.symmetric(
//                                                     horizontal: 8, vertical: 8),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 250,
//                                       width: 1,
//                                       color: Colors.grey, // Vertical line at the start
//                                       margin: EdgeInsets.zero, // Adjust margin if needed
//                                     ),
//                                     const SizedBox(width: 20.0),
//                                     Expanded(
//                                       flex: 3,
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           const Text('    '),
//                                           Padding(
//                                             padding: const EdgeInsets.only(right: 10),
//                                             child: SizedBox(
//                                               child: TextField(
//                                                 controller: commentsController,
//                                                 decoration: InputDecoration(
//                                                   filled: true,
//                                                   fillColor: Colors.grey[200],
//                                                   border: OutlineInputBorder(
//                                                     borderRadius: BorderRadius.circular(5.0),
//                                                     borderSide: BorderSide.none,
//                                                   ),
//                                                   hintText: 'PLEASE INVOICE DIRECTLY. 90 DAY ARRANGEMENT'
//                                                       ' AS PER PRASANTH',
//                                                 ),
//                                                 maxLines: 5,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(left: 300, top: 600),
//                               child: SizedBox(
//                                 // height: 350,
//                                 width: 1100,
//                                 child: SizedBox(
//                                   width: 1100,
//                                   // height: 350,
//                                   child: Container(
//                                     width: 1100,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey, width: 2),
//                                       // color: Colors.white,
//                                       // Container background color
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const Padding(
//                                           padding:  EdgeInsets.only(top: 10,left: 30),
//                                           child:  Text(
//                                             'Add Parts',
//                                             style: TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10,),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: Colors.grey,),
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.only(
//                                               top: 5,
//                                               bottom: 5,
//                                             ),
//                                             child: SizedBox(
//                                               height: 34,
//                                               child: Row(
//                                                 children: [
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 48,
//                                                       right: 55,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "SN",
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 40,
//                                                       right: 39,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         'Product Name',
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 25,
//                                                       right: 50,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "Category",
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 8,
//                                                       right: 50,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "Sub Category",
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 25,
//                                                       right: 40,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "Price",
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 59,
//                                                       right: 45,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "QTY",
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                       left: 52,
//                                                       right: 30,
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         "Total Amount",
//                                                         style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Center(
//                                                     child: Text("  ",
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         ListView.builder(
//                                           shrinkWrap: true,
//                                           physics: const NeverScrollableScrollPhysics(),
//                                           itemCount: widget.selectedProducts.length,
//                                           itemBuilder: (context, index) {
//                                             Product product = widget
//                                                 .selectedProducts[index];
//                                             return Table(
//                                               border: TableBorder.all(
//                                                   color: Colors.grey),
//                                               // Add this line
//                                               children: [
//                                                 TableRow(
//                                                   children: [
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding:const EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             top: 15,
//                                                             bottom: 5),
//                                                         child: Center(
//                                                           child: Text(
//                                                             (index + 1).toString(),
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding:const  EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             top: 5,
//                                                             bottom: 5),
//                                                         child: Container(
//                                                           height: 35,
//                                                           width: 50,
//                                                           decoration: BoxDecoration(
//                                                               color: Colors.grey[300],
//                                                               borderRadius: BorderRadius.circular(4.0)
//                                                           ),
//                                                           child: Center(
//                                                             child: Text(
//                                                               product.productName,
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding:const EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             top: 5,
//                                                             bottom: 5),
//                                                         child: Container(
//                                                           height: 35,
//                                                           width: 50,
//                                                           decoration: BoxDecoration(
//                                                               color: Colors.grey[300],
//                                                               borderRadius: BorderRadius.circular(4.0)
//                                                           ),
//                                                           child: Center(
//                                                             child: Text(
//                                                               product.category,
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             top: 5,
//                                                             bottom: 5),
//                                                         child: Container(
//                                                           height: 35,
//                                                           decoration: BoxDecoration(
//                                                               color: Colors.grey[300],
//                                                               borderRadius: BorderRadius.circular(4.0)
//                                                           ),
//                                                           child: Center(
//                                                             child: Text(
//                                                               product.subCategory,
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             top: 5,
//                                                             bottom: 5),
//                                                         child: Container(
//                                                           height: 35,
//                                                           decoration: BoxDecoration(
//                                                               color: Colors.grey[300],
//                                                               borderRadius: BorderRadius.circular(4.0)
//                                                           ),
//                                                           child: Center(
//                                                             child: Text(
//                                                               product.price
//                                                                   .toStringAsFixed(2),
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             top: 5,
//                                                             bottom: 5),
//                                                         child: Container(
//                                                           height: 35,
//                                                           decoration: BoxDecoration(
//                                                               color: Colors.grey[300],
//                                                               borderRadius: BorderRadius.circular(4.0)
//                                                           ),
//                                                           child: Center(
//                                                             child: Text(
//                                                               product.quantity
//                                                                   .toString(),
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             left: 10,
//                                                             right: 10,
//                                                             top: 5,
//                                                             bottom: 5),
//                                                         child: Container(
//                                                           height: 35,
//                                                           decoration: BoxDecoration(
//                                                               color: Colors.grey[300],
//                                                               borderRadius: BorderRadius.circular(4.0)
//                                                           ),
//                                                           child: Center(
//                                                             child: Text(
//                                                               '${product.price *
//                                                                   product.quantity}',
//                                                               textAlign: TextAlign
//                                                                   .center,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     TableCell(
//                                                       child: Padding(
//                                                         padding: const EdgeInsets
//                                                             .symmetric(vertical: 20),
//                                                         // Add padding top and bottom
//                                                         child: InkWell(
//                                                           onTap: () {
//                                                             _deleteProduct(product);
//                                                           },
//                                                           child: const Icon(
//                                                             Icons
//                                                                 .remove_circle_outline,
//                                                             size: 18,
//                                                             color: Colors.blue,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         ),
//                                         Row(
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 30, top: 20),
//                                               child: OutlinedButton(
//                                                 onPressed: () {
//                                                   // List<Product> products = widget.selectedProducts;
//                                                   Product? selectedProduct;
//                                                   if (widget.selectedProducts.isNotEmpty) {
//                                                     for (var selectedProduct in widget.selectedProducts) {
//                                                       print('----yes');
//                                                       print(selectedProduct);
//                                                       Map<String, dynamic> data = {
//                                                         'deliveryLocation': data2['deliveryLocation'],
//                                                         'ContactName': contactPersonController.text,
//                                                         'Address': deliveryAddressController.text,
//                                                         'ContactNumber': contactNumberController.text,
//                                                         'Comments': commentsController.text,
//                                                         'date': _selectedDate.toString(),
//                                                       };
//                                                       data2 = data;
//                                                       Navigator.push(
//                                                         context,
//                                                         PageRouteBuilder(
//                                                           pageBuilder: (context,
//                                                               animation,
//                                                               secondaryAnimation) =>
//                                                               NextPage(
//                                                                 //product: Product(prodId: '', category: '', productName: '', subCategory: '', unit: '', selectedUOM: '', selectedVariation: '', quantity: 0, total: 0, totalamount: 0, tax: '', discount: '', price: 0, imageId: ''),
//                                                                 data: data2,
//                                                                 product: selectedProduct,
//                                                                 inputText: '',
//                                                                 products: products,
//                                                                 subText: 'hii',
//                                                                 selectedProducts: widget.selectedProducts, notselect: 'selectedproduct',),
//                                                           // NextPage(
//                                                           //   // selectedProducts: widget.selectedProducts,
//                                                           //   selectedProducts: widget.selectedProducts,                                                         data: widget.data,
//                                                           //   inputText: '',
//                                                           //   subText: '',
//                                                           //    data: null,
//                                                           //    products: products,
//                                                           //   product: selectedProduct),
//                                                           transitionDuration:
//                                                           const Duration(
//                                                               milliseconds: 200),
//                                                           transitionsBuilder: (
//                                                               context,
//                                                               animation,
//                                                               secondaryAnimation,
//                                                               child) {
//                                                             return FadeTransition(
//                                                               opacity: animation,
//                                                               child: child,
//                                                             );
//                                                           },
//                                                         ),
//                                                       );
//                                                     }
//                                                   } else {
//                                                     selectedProduct = null;
//                                                   }
//
//
//                                                   // context.go(
//                                                   //   '/dasbaord/Orderspage/addproduct/addparts/addbutton/saveproducts',
//                                                   //   extra: {
//                                                   //     'selectedProducts': products,
//                                                   //     'data': data2,
//                                                   //   },
//                                                   // );
//
//                                                 },
//                                                 style: OutlinedButton.styleFrom(
//                                                   backgroundColor: Colors
//                                                       .blue,
//                                                   // Blue background color
//                                                   //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius
//                                                         .circular(
//                                                         5), // Optional: Square corners
//                                                   ),
//                                                   side: BorderSide
//                                                       .none, // No  outline
//                                                 ),
//                                                 child: const Text(
//                                                   '+ Add Products',
//                                                   style: TextStyle(
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(top: 10,),
//                                           child: Container(
//                                             // Space above/below the border
//                                             height: 1, // Border height
//                                             color: Colors.grey,// Border color
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(top: 8,left: 755,bottom: 10),
//                                           child: Row(
//                                             children: [
//                                               const SizedBox(width: 10), // add some space between the line and the text
//                                               SizedBox(
//                                                 width: 220,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(color: Colors.blue),
//                                                   ),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(
//                                                       top: 10,
//                                                       bottom: 10,
//                                                       left: 5,
//                                                       right: 5,
//                                                     ),
//                                                     child: RichText(
//                                                       text: TextSpan(
//                                                         children: [
//                                                           const TextSpan(
//                                                             text: '         ', // Add a space character
//                                                             style: TextStyle(
//                                                               fontSize: 10, // Set the font size to control the width of the gap
//                                                             ),
//                                                           ),
//                                                           const TextSpan(
//                                                             text: 'Total',
//                                                             style: TextStyle(
//                                                               fontWeight: FontWeight.bold,
//                                                               color: Colors.blue,
//                                                             ),
//                                                           ),
//                                                           const TextSpan(
//                                                             text: '             ', // Add a space character
//                                                             style: TextStyle(
//                                                               fontSize: 10, // Set the font size to control the width of the gap
//                                                             ),
//                                                           ),
//                                                           const TextSpan(
//                                                             text: '₹',
//                                                             style: TextStyle(
//                                                               color: Colors.black,
//                                                             ),
//                                                           ),
//                                                           TextSpan(
//                                                             text: data2['totalAmount'] = _total.toStringAsFixed(2),
//                                                             style: const TextStyle(
//                                                               color: Colors.black,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//           )
//
//
//       ),
//     );
//   }
// }
//
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/fourthpage/orderspage%20order.dart';
import 'package:btb/screen/login.dart';
import 'package:btb/sprint%202%20order/add%20productmaster%20sample.dart';
import 'package:btb/sprint%202%20order/firstpage.dart';
import 'package:btb/sprint%202%20order/fourthpage.dart';
import 'package:btb/sprint%202%20order/sixthpage.dart';
import 'package:btb/thirdpage/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../thirdpage/dashboard.dart';


void main(){
  runApp(FifthPage(selectedProducts: [], data: {}, select: '', ));
}


class FifthPage extends StatefulWidget {
  final List<Product> selectedProducts;
  final Map<String, dynamic> data;
  final String select;


  const FifthPage(
      {super.key, required this.selectedProducts,
        required this.select,

        required this.data});

  @override
  State<FifthPage> createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  List<Product> products = [];
  final dummyProducts = '';
  Timer? _searchDebounceTimer;
  double _total = 0.0;
  String _searchText = '';
  final String _category = '';
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  bool isOrdersSelected = false;
  List<Product> selectedProducts = [];
  final TextEditingController commentsController = TextEditingController();

  final TextEditingController totalAmountController = TextEditingController();

  final TextEditingController totalController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  List<Product> showProducts = [];
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  final TextEditingController contactPersonController = TextEditingController();

  bool _isRefreshed = false;
  DateTime? _selectedDate;
  late TextEditingController _dateController;
  final String _subCategory = '';
  Map<String, dynamic> data2 = {};
  int startIndex = 0;
  List<Product> filteredProducts = [];
  int currentPage = 1;
  String? dropdownValue1 = 'Filter I';
  List<Product> productList = [];
  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Filter II';

  void onSearchTextChanged(String text) {
    if (_searchDebounceTimer != null) {
      _searchDebounceTimer!.cancel(); // Cancel the previous timer
    }
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = text;
      });
    });
  }
  //
  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();

    commentsController.text = widget.data?['Comments'] ?? '';
    deliveryAddressController.text = widget.data?['Address'] ?? '';
    contactNumberController.text = widget.data?['ContactNumber'] ?? '';
    contactPersonController.text = widget.data?['ContactName'] ?? '';
    print('------------dadf');

    _calculateTotal();
    _selectedDate = DateTime.now();
    _dateController.text = _selectedDate != null ? DateFormat.yMd().format(_selectedDate!) : '';
    print(widget.data);
    print('-hello');
    data2 = Map.from(widget.data);
    // totalAmountController.text = data2['totalAmount'];
    print(widget.selectedProducts);
    // print(showProducts);
  }



  void _calculateTotal() {
    _total = 0.0;
    for (var product in widget.selectedProducts) {
      _total += product.total; // Add the total of each product to _total
    }
    setState(() {

    });
  }


  Future<void> callApi() async {

    List<Map<String, dynamic>> items = [];

    for (int i = 0; i < widget.selectedProducts.length; i++) {
      Product product = widget.selectedProducts[i];
      items.add({
        "productName": product.productName,
        "category": product.category,
        "subCategory": product.subCategory,
        "price": product.price,
        "qty": product.quantity,
        "totalAmount": (product.price * product.quantity),
      });
    }

    final url = 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/add_order_master';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    final body = {
      "orderDate": data2['date'],
      "deliveryLocation": data2['deliveryLocation'],
      "deliveryAddress":  deliveryAddressController.text,
      "contactPerson": contactPersonController.text,
      "contactNumber": contactNumberController.text,
      "comments":  commentsController.text,
      "total": data2['totalAmount'],
      "items": items,
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      print('API call successful');
      final responseData = json.decode(response.body);

      // Add null checks and error handling
      String orderId;
      try {
        orderId = responseData['id'];
      } catch (e) {
        print('Error parsing orderId: $e');
        orderId = ''; // or some default value
      }

      detail details;
      try {
        details = detail(
          orderId: orderId,
          orderDate: data2['date'],
          total: double.parse(data2['totalAmount']),
          status: '', // Initialize status as empty string
          deliveryStatus: '', // Initialize delivery status as empty string
          referenceNumber: '', items: [], // Initialize reference number as empty string
        );
      } catch (e) {
        print('Error creating detail object: $e');
        details = detail(orderId: '', orderDate: '', total: 0, status: '', deliveryStatus: '', referenceNumber: '', items: []); // or some default value
      }

      if (details != null) {
         context.go('/Placed_Order_List', extra: {
           'product': details,
           'item': items,
           'body': body,
           'itemsList': items,
         });
        // context.go('/Place_Order/Order_List', extra: {
        //   'product': details,
        //   'item': items,
        //   'body': body,
        //   'itemsList': items,
        // });
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SixthPage(
              product: details,
              item: items,
              body: body,
              itemsList: items,
            ),
          ),
        );
      } else {
        print('Failed to create detail object, not navigating to SixthPage');
      }
    } else {
      print('API call failed with status code ${response.statusCode}');
    }
  }


  void _deleteProduct(Product product) {
    setState(() {
      widget.selectedProducts.remove(product);
      _calculateTotal();
    });
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
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.account_circle),
                      onSelected: (value) {
                        if (value == 'logout') {
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
          body:
          LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;

                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 1200,
                        width: 200,
                        color: const Color(0xFFF7F6FA),
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextButton.icon(
                              onPressed: () {
                                // context
                                //     .go('${PageName.main}/${PageName.subpage1Main}');
                                context.go('/Orderspage/placingorder/dasbaord');
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
                                context.go(
                                    '/Orderspage/placingorder/productpage:product');
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
                                context.go('/BeforplacingOrder/Orderspage');
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder: (context, animation,
                                //         secondaryAnimation) =>
                                //     const Orderspage(),
                                //     transitionDuration: const Duration(
                                //         milliseconds: 200),
                                //     transitionsBuilder:
                                //         (context, animation, secondaryAnimation,
                                //         child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
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
                      left: 200,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0,bottom: 5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.white,
                                height: 40,
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 30,top: 10),
                                      child: Text(
                                        'Create Order',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 100,top: 10),
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          await callApi();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent, // Button background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5), // Rounded corners
                                          ),
                                          side: BorderSide.none, // No outline
                                        ),
                                        child: const Text(
                                          'Create Order',
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
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5), // Space above/below the border
                              height: 2,
                              // width: 1000,
                              width: constraints.maxWidth,// Border height
                              color: Colors.grey[300], // Border color
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: maxWidth* 0.630,top: 70,right: 120),
                              child: const Text((' Order Date')),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: maxWidth * 0.66
                                , top:10,),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFEBF3FF), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: const Color(0xFF418CFC)
                                  //         .withOpacity(0.16), // 0.2 * 0.8 = 0.16
                                  //     spreadRadius: 0,
                                  //     blurRadius: 6,
                                  //     offset: const Offset(0, 3),
                                  //   ),
                                  // ],
                                ),
                                child: Container(
                                  height: 39,
                                  width: maxWidth *0.13,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white
                                  //       .withOpacity(1), // Opacity is 1, fully opaque
                                  //   borderRadius: BorderRadius.circular(4),
                                  // ),
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
                                                    // _showDatePicker(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                            hintText: '        Select Date',
                                            fillColor: Colors.grey.shade200,
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
                            //SizedBox(height: 20.h),
                            Padding(
                              padding:  EdgeInsets.only(left: 150,top: 50, right: 100),
                              child: Container(
                                height:  380,
                                width: 2100,
                                //padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(left: 30,top: 10),
                                      child: Text(
                                        'Delivery Location',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Colors.grey),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(left: 30,bottom: 5),
                                          child: Text(
                                            'Address',
                                            style: TextStyle(
                                              fontSize: 14.0,

                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right:400),
                                          child: Text(
                                            'Comments',
                                            style: TextStyle(
                                              fontSize: 14.0,

                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1.0,
                                      height: 1.0,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:  EdgeInsets.only(left: 30),
                                                child: Text('Select Delivery Location'),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding:  EdgeInsets.only(left: 30),
                                                child: SizedBox(
                                                  width: 400,
                                                  height: 40,
                                                  child: DropdownButtonFormField<String>(
                                                    value: data2['deliveryLocation'],
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.grey.shade200,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      hintText: 'Select Location',
                                                      contentPadding:const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 8),
                                                    ),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        data2['deliveryLocation'] = value!;
                                                      });
                                                    },
                                                    items: list.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    isExpanded: true,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Padding(
                                                padding:  EdgeInsets.only(left: 30),
                                                child: Text('Delivery Address'),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding:  EdgeInsets.only(left: 30),
                                                child: SizedBox(
                                                  width: 400,
                                                  child: TextField(
                                                    controller: deliveryAddressController,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.grey.shade200,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      hintText: 'Enter your Address',
                                                    ),
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 30),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Contact Person'),
                                              SizedBox(height: 10,),
                                              SizedBox(
                                                width: 400,
                                                height: 40,
                                                child: TextField(
                                                  controller: contactPersonController,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey.shade200,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'Contact Person Name',
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 8),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              const Text('Contact Number'),
                                              SizedBox(height: 10,),
                                              SizedBox(
                                                width: 400,
                                                height: 40,
                                                child: TextField(
                                                  controller: contactNumberController,
                                                  keyboardType:
                                                  TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        10),
                                                    // limits to 10 digits
                                                  ],
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey.shade200,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'Contact Person Number',
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 270,
                                          width: 1,
                                          color: Colors.grey, // Vertical line at the start
                                          margin: EdgeInsets.zero, // Adjust margin if needed
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('    '),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: SizedBox(
                                                  height: 150,
                                                  child: TextField(
                                                    controller:
                                                    commentsController,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.grey.shade200,
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                          borderSide: BorderSide.none,
                                                        ),
                                                        hintText: 'Enter Your Comments'


                                                    ),
                                                    maxLines: 5,
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


                            // Padding(
                            //   padding: const EdgeInsets.only(left: 250 ,top: 200,right: 100),
                            //   child: Container(
                            //     // height:  350,
                            //     // padding: EdgeInsets.all(16.0),
                            //     decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.grey,width: 2),
                            //       borderRadius: BorderRadius.circular(8.0),
                            //     ),
                            //     child:  Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         const Padding(
                            //           padding:  EdgeInsets.only(left: 30,top: 10),
                            //           child: Text(
                            //             'Delivery Location',
                            //             style: TextStyle(
                            //               fontSize: 18.0,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //           ),
                            //         ),
                            //         const Divider(color: Colors.grey),
                            //         const Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Padding(
                            //               padding:  EdgeInsets.only(left: 30,bottom: 5),
                            //               child: Text(
                            //                 'Address',
                            //                 style: TextStyle(
                            //                   fontSize: 15.0,
                            //                   // fontWeight: FontWeight.bold,
                            //                 ),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: EdgeInsets.only(right:300),
                            //               child: Text(
                            //                 'Comments',
                            //                 style: TextStyle(
                            //                   fontSize: 15.0,
                            //                   //fontWeight: FontWeight.bold,
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         const Divider(
                            //           color: Colors.grey,
                            //           thickness: 1.0,
                            //           height: 1.0,
                            //         ),
                            //         const SizedBox(height: 5.0),
                            //         Row(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Expanded(
                            //               // flex: 2,
                            //               child: Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   const Padding(
                            //                     padding:  EdgeInsets.only(left: 30),
                            //                     child: Text('Select Delivery Location'),
                            //                   ),
                            //                   Padding(
                            //                     padding: const EdgeInsets.only(left: 30),
                            //                     child: SizedBox(
                            //                       width: 350,
                            //                       height: 40,
                            //                       child: DropdownButtonFormField<String>(
                            //                         value: data2['deliveryLocation'],
                            //                         decoration: InputDecoration(
                            //                           filled: true,
                            //                           fillColor: Colors.grey[200],
                            //                           border: OutlineInputBorder(
                            //                             borderRadius: BorderRadius.circular(5.0),
                            //                             borderSide: BorderSide.none,
                            //                           ),
                            //                           hintText: 'SELECT LOCATION',
                            //                           contentPadding:const EdgeInsets.symmetric(
                            //                               horizontal: 8, vertical: 8),
                            //                         ),
                            //                         onChanged: (String? value) {
                            //                           setState(() {
                            //                             data2['deliveryLocation'] = value!;
                            //                           });
                            //                         },
                            //                         items: list.map<DropdownMenuItem<String>>((String value) {
                            //                           return DropdownMenuItem<String>(
                            //                             value: value,
                            //                             child: Text(value),
                            //                           );
                            //                         }).toList(),
                            //                         isExpanded: true,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   const SizedBox(height: 20.0),
                            //                   const Padding(
                            //                     padding:  EdgeInsets.only(left: 30),
                            //                     child: Text('Delivery Address'),
                            //                   ),
                            //                   const SizedBox(height: 10,),
                            //                   Padding(
                            //                     padding: const EdgeInsets.only(left: 30),
                            //                     child: SizedBox(
                            //                       width: 350,
                            //
                            //                       child: TextField(
                            //                         controller: deliveryAddressController,
                            //                         decoration: InputDecoration(
                            //                           filled: true,
                            //                           fillColor: Colors.grey[200],
                            //                           border: OutlineInputBorder(
                            //                             borderRadius: BorderRadius.circular(5.0),
                            //                             borderSide: BorderSide.none,
                            //                           ),
                            //                           hintText: 'ENTER YOUR ADDRESS DETAILS',
                            //                         ),
                            //                         maxLines: 3,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             const SizedBox(width: 30.0),
                            //             Expanded(
                            //               // flex: 3,
                            //               child: Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   const Text('Contact Person'),
                            //                   SizedBox(
                            //                     width: 350,
                            //                     height: 40,
                            //                     child: TextField(
                            //                       controller: contactPersonController,
                            //                       decoration: InputDecoration(
                            //                         filled: true,
                            //                         fillColor: Colors.grey[200],
                            //                         border: OutlineInputBorder(
                            //                           borderRadius: BorderRadius.circular(5.0),
                            //                           borderSide: BorderSide.none,
                            //                         ),
                            //                         hintText: 'CONTACT PERSON NAME',
                            //                         contentPadding:const EdgeInsets.symmetric(
                            //                             horizontal: 8, vertical: 8),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   const SizedBox(height: 20.0),
                            //                   const Text('Contact Number'),
                            //                   const SizedBox(height: 10,),
                            //                   SizedBox(
                            //                     width: 350,
                            //                     height: 40,
                            //                     child: TextField(
                            //                       controller: contactNumberController,
                            //                       keyboardType:
                            //                       TextInputType.number,
                            //                       inputFormatters: [
                            //                         FilteringTextInputFormatter
                            //                             .digitsOnly,
                            //                         LengthLimitingTextInputFormatter(
                            //                             10),
                            //                         // limits to 10 digits
                            //                       ],
                            //                       decoration: InputDecoration(
                            //                         filled: true,
                            //                         fillColor: Colors.grey[200],
                            //                         border: OutlineInputBorder(
                            //                           borderRadius: BorderRadius.circular(5.0),
                            //                           borderSide: BorderSide.none,
                            //                         ),
                            //                         hintText: 'CONTACT PERSON NUMBER',
                            //                         contentPadding:const EdgeInsets.symmetric(
                            //                             horizontal: 8, vertical: 8),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             Container(
                            //               height: 250,
                            //               width: 1,
                            //               color: Colors.grey, // Vertical line at the start
                            //               margin: EdgeInsets.zero, // Adjust margin if needed
                            //             ),
                            //             const SizedBox(width: 20.0),
                            //             Expanded(
                            //               // flex: 3,
                            //               child: Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   const Text('    '),
                            //                   Padding(
                            //                     padding: const EdgeInsets.only(right: 10),
                            //                     child: SizedBox(
                            //                       child: TextField(
                            //                         controller: commentsController,
                            //                         decoration: InputDecoration(
                            //                           filled: true,
                            //                           fillColor: Colors.grey[200],
                            //                           border: OutlineInputBorder(
                            //                             borderRadius: BorderRadius.circular(5.0),
                            //                             borderSide: BorderSide.none,
                            //                           ),
                            //                           hintText: 'ENTER YOUR COMMENTS'
                            //                           ,
                            //                         ),
                            //                         maxLines: 5,
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // frst copy in add products
                            //    Row(
                            //      mainAxisAlignment: MainAxisAlignment.start,
                            //      children: [
                            //        Padding(
                            //          padding:  EdgeInsets.only(left: 250, top: 650,right: 200.w),
                            //          child: SizedBox(
                            //            // height: 350,
                            //            width: maxWidth * 0.8,
                            //            child: SizedBox(
                            //              width: maxWidth * 0.8,
                            //              // height: 350,
                            //              child: Container(
                            //                width: maxWidth * 0.8,
                            //                decoration: BoxDecoration(
                            //                  border: Border.all(color: Colors.grey, width: 2),
                            //                  // color: Colors.white,
                            //                  // Container background color
                            //                  borderRadius: BorderRadius.circular(10),
                            //                ),
                            //                child: Column(
                            //                  mainAxisAlignment: MainAxisAlignment.start,
                            //                  crossAxisAlignment: CrossAxisAlignment.start,
                            //                  children: [
                            //                    const Padding(
                            //                      padding:  EdgeInsets.only(top: 10,left: 30),
                            //                      child:  Text(
                            //                        'Add Products',
                            //                        style: TextStyle(
                            //                            fontSize: 20,
                            //                            fontWeight: FontWeight.bold,
                            //                            color: Colors.black),
                            //                      ),
                            //                    ),
                            //                    const SizedBox(height: 10,),
                            //                    Container(
                            //                      decoration: BoxDecoration(
                            //                        border: Border.all(
                            //                          color: Colors.grey,),
                            //                      ),
                            //                      child: const Padding(
                            //                        padding: EdgeInsets.only(
                            //                          top: 5,
                            //                          bottom: 5,
                            //                        ),
                            //                        child: SizedBox(
                            //                          height: 34,
                            //                          child: Row(
                            //                            children: [
                            //                              Padding(
                            //                                padding: EdgeInsets.only(
                            //                                  left: 48,
                            //                                  right: 55,
                            //                                ),
                            //                                child: Center(
                            //                                  child: Text(
                            //                                    "SN",
                            //                                    style: TextStyle(
                            //                                      fontWeight: FontWeight.bold,
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                              Padding(
                            //                                padding: EdgeInsets.only(
                            //                                  left: 40,
                            //                                  right: 39,
                            //                                ),
                            //                                child: Center(
                            //                                  child: Text(
                            //                                    'Product Name',
                            //                                    style: TextStyle(
                            //                                      fontWeight: FontWeight.bold,
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                              Padding(
                            //                                padding: EdgeInsets.only(
                            //                                  left: 25,
                            //                                  right: 50,
                            //                                ),
                            //                                child: Center(
                            //                                  child: Text(
                            //                                    "Category",
                            //                                    style: TextStyle(
                            //                                      fontWeight: FontWeight.bold,
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                              Padding(
                            //                                padding: EdgeInsets.only(
                            //                                  left: 8,
                            //                                  right: 50,
                            //                                ),
                            //                                child: Center(
                            //                                  child: Text(
                            //                                    "Sub Category",
                            //                                    style: TextStyle(
                            //                                      fontWeight: FontWeight.bold,
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                              Padding(
                            //                                padding: EdgeInsets.only(
                            //                                  left: 25,
                            //                                  right: 40,
                            //                                ),
                            //                                child: Center(
                            //                                  child: Text(
                            //                                    "Price",
                            //                                    style: TextStyle(
                            //                                      fontWeight: FontWeight.bold,
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                              Padding(
                            //                                padding: EdgeInsets.only(
                            //                                  left: 59,
                            //                                  right: 45,
                            //                                ),
                            //                                child: Center(
                            //                                  child: Text(
                            //                                    "QTY",
                            //                                    style: TextStyle(
                            //                                      fontWeight: FontWeight.bold,
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                              Padding(
                            //                                padding: EdgeInsets.only(
                            //                                  left: 52,
                            //                                  right: 30,
                            //                                ),
                            //                                child: Center(
                            //                                  child: Text(
                            //                                    "Total Amount",
                            //                                    style: TextStyle(
                            //                                      fontWeight: FontWeight.bold,
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                              Center(
                            //                                child: Text("  ",
                            //                                ),
                            //                              ),
                            //                            ],
                            //                          ),
                            //                        ),
                            //                      ),
                            //                    ),
                            //                    ListView.builder(
                            //                      shrinkWrap: true,
                            //                      physics: const NeverScrollableScrollPhysics(),
                            //                      itemCount: widget.selectedProducts.length,
                            //                      itemBuilder: (context, index) {
                            //                        Product product = widget
                            //                            .selectedProducts[index];
                            //                        return Table(
                            //                          border: TableBorder.all(
                            //                              color: Colors.grey),
                            //                          // Add this line
                            //                          children: [
                            //                            TableRow(
                            //                              children: [
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding:const EdgeInsets.only(
                            //                                        left: 10,
                            //                                        right: 10,
                            //                                        top: 15,
                            //                                        bottom: 5),
                            //                                    child: Center(
                            //                                      child: Text(
                            //                                        (index + 1).toString(),
                            //                                        textAlign: TextAlign
                            //                                            .center,
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding:const  EdgeInsets.only(
                            //                                        left: 10,
                            //                                        right: 10,
                            //                                        top: 10,
                            //                                        bottom: 10),
                            //                                    child: Container(
                            //                                      height: 35,
                            //                                      width: 50,
                            //                                      decoration: BoxDecoration(
                            //                                          color: Colors.grey[300],
                            //                                          borderRadius: BorderRadius.circular(4.0)
                            //                                      ),
                            //                                      child: Center(
                            //                                        child: Text(
                            //                                          product.productName,
                            //                                          textAlign: TextAlign
                            //                                              .center,
                            //                                        ),
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding:const EdgeInsets.only(
                            //                                        left: 10,
                            //                                        right: 10,
                            //                                        top: 10,
                            //                                        bottom: 10),
                            //                                    child: Container(
                            //                                      height: 35,
                            //                                      width: 50,
                            //                                      decoration: BoxDecoration(
                            //                                          color: Colors.grey[300],
                            //                                          borderRadius: BorderRadius.circular(4.0)
                            //                                      ),
                            //                                      child: Center(
                            //                                        child: Text(
                            //                                          product.category,
                            //                                          textAlign: TextAlign
                            //                                              .center,
                            //                                        ),
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding: const EdgeInsets.only(
                            //                                        left: 10,
                            //                                        right: 10,
                            //                                        top: 10,
                            //                                        bottom: 10),
                            //                                    child: Container(
                            //                                      height: 35,
                            //                                      decoration: BoxDecoration(
                            //                                          color: Colors.grey[300],
                            //                                          borderRadius: BorderRadius.circular(4.0)
                            //                                      ),
                            //                                      child: Center(
                            //                                        child: Text(
                            //                                          product.subCategory,
                            //                                          textAlign: TextAlign
                            //                                              .center,
                            //                                        ),
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding: const EdgeInsets.only(
                            //                                        left: 10,
                            //                                        right: 10,
                            //                                        top: 10,
                            //                                        bottom: 10),
                            //                                    child: Container(
                            //                                      height: 35,
                            //                                      decoration: BoxDecoration(
                            //                                          color: Colors.grey[300],
                            //                                          borderRadius: BorderRadius.circular(4.0)
                            //                                      ),
                            //                                      child: Center(
                            //                                        child: Text(
                            //                                          product.price.toString(),
                            //                                          textAlign: TextAlign
                            //                                              .center,
                            //                                        ),
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding: const EdgeInsets.only(
                            //                                        left: 10,
                            //                                        right: 10,
                            //                                        top: 10,
                            //                                        bottom: 10),
                            //                                    child: Container(
                            //                                      height: 35,
                            //                                      decoration: BoxDecoration(
                            //                                          color: Colors.grey[300],
                            //                                          borderRadius: BorderRadius.circular(4.0)
                            //                                      ),
                            //                                      child: Center(
                            //                                        child: Text(
                            //                                          product.quantity
                            //                                              .toString(),
                            //                                          textAlign: TextAlign
                            //                                              .center,
                            //                                        ),
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding: const EdgeInsets.only(
                            //                                        left: 10,
                            //                                        right: 10,
                            //                                        top: 10,
                            //                                        bottom: 10),
                            //                                    child: Container(
                            //                                      height: 35,
                            //                                      decoration: BoxDecoration(
                            //                                          color: Colors.grey[300],
                            //                                          borderRadius: BorderRadius.circular(4.0)
                            //                                      ),
                            //                                      child: Center(
                            //                                        child: Text(
                            //                                          '${product.price *
                            //                                              product.quantity}',
                            //                                          textAlign: TextAlign
                            //                                              .center,
                            //                                        ),
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                                TableCell(
                            //                                  child: Padding(
                            //                                    padding: const EdgeInsets
                            //                                        .symmetric(vertical: 20),
                            //                                    // Add padding top and bottom
                            //                                    child: InkWell(
                            //                                      onTap: () {
                            //                                        _deleteProduct(product);
                            //                                      },
                            //                                      child: const Icon(
                            //                                        Icons
                            //                                            .remove_circle_outline,
                            //                                        size: 18,
                            //                                        color: Colors.blue,
                            //                                      ),
                            //                                    ),
                            //                                  ),
                            //                                ),
                            //                              ],
                            //                            ),
                            //                          ],
                            //                        );
                            //                      },
                            //                    ),
                            //                    Row(
                            //                      children: [
                            //                        Padding(
                            //                          padding: const EdgeInsets.only(
                            //                              left: 30, top: 20),
                            //                          child: OutlinedButton(
                            //                            onPressed: () {
                            //                              // List<Product> products = widget.selectedProducts;
                            //                              Product? selectedProduct;
                            //                              if (widget.selectedProducts.isNotEmpty) {
                            //                                for (var selectedProduct in widget.selectedProducts) {
                            //                                  print('----yes');
                            //                                  Map<String, dynamic> data = {
                            //                                    'deliveryLocation': data2['deliveryLocation'],
                            //                                    'ContactName': contactPersonController.text,
                            //                                    'Address': deliveryAddressController.text,
                            //                                    'ContactNumber': contactNumberController.text,
                            //                                    'Comments': commentsController.text,
                            //                                    'date': _selectedDate.toString(),
                            //                                  };
                            //                                  data2 = data;
                            //                                  print(selectedProduct);
                            //                                  Navigator.push(
                            //                                    context,
                            //                                    PageRouteBuilder(
                            //                                      pageBuilder: (context,
                            //                                          animation,
                            //                                          secondaryAnimation) =>
                            //                                          NextPage(
                            //                                            //product: Product(prodId: '', category: '', productName: '', subCategory: '', unit: '', selectedUOM: '', selectedVariation: '', quantity: 0, total: 0, totalamount: 0, tax: '', discount: '', price: 0, imageId: ''),
                            //                                            data: data2,
                            //                                            product: selectedProduct,
                            //                                            inputText: '',
                            //                                            products: products,
                            //                                            subText: 'hii',
                            //                                            selectedProducts: widget.selectedProducts, notselect: 'selectedproduct',),
                            //                                      // NextPage(
                            //                                      //   // selectedProducts: widget.selectedProducts,
                            //                                      //   selectedProducts: widget.selectedProducts,                                                         data: widget.data,
                            //                                      //   inputText: '',
                            //                                      //   subText: '',
                            //                                      //    data: null,
                            //                                      //    products: products,
                            //                                      //   product: selectedProduct),
                            //                                      transitionDuration:
                            //                                      const Duration(
                            //                                          milliseconds: 200),
                            //                                      transitionsBuilder: (
                            //                                          context,
                            //                                          animation,
                            //                                          secondaryAnimation,
                            //                                          child) {
                            //                                        return FadeTransition(
                            //                                          opacity: animation,
                            //                                          child: child,
                            //                                        );
                            //                                      },
                            //                                    ),
                            //                                  );
                            //                                }
                            //                              } else {
                            //                                selectedProduct = null;
                            //                              }
                            //
                            //
                            //                              // context.go(
                            //                              //   '/dasbaord/Orderspage/addproduct/addparts/addbutton/saveproducts',
                            //                              //   extra: {
                            //                              //     'selectedProducts': products,
                            //                              //     'data': data2,
                            //                              //   },
                            //                              // );
                            //
                            //                            },
                            //                            style: OutlinedButton.styleFrom(
                            //                              backgroundColor: Colors
                            //                                  .blue,
                            //                              // Blue background color
                            //                              //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
                            //                              shape: RoundedRectangleBorder(
                            //                                borderRadius: BorderRadius
                            //                                    .circular(
                            //                                    5), // Optional: Square corners
                            //                              ),
                            //                              side: BorderSide
                            //                                  .none, // No  outline
                            //                            ),
                            //                            child: const Text(
                            //                              '+ Add Products',
                            //                              style: TextStyle(
                            //                                  color: Colors.white),
                            //                            ),
                            //                          ),
                            //                        ),
                            //                      ],
                            //                    ),
                            //                    Padding(
                            //                      padding: const EdgeInsets.only(top: 10,),
                            //                      child: Container(
                            //                        // Space above/below the border
                            //                        height: 1, // Border height
                            //                        color: Colors.grey,// Border color
                            //                      ),
                            //                    ),
                            //                    Padding(
                            //                      padding: const EdgeInsets.only(top: 8,left: 755,bottom: 10),
                            //                      child: Row(
                            //                        children: [
                            //                          const SizedBox(width: 10), // add some space between the line and the text
                            //                          SizedBox(
                            //                            width: 220,
                            //                            child: Container(
                            //                              decoration: BoxDecoration(
                            //                                border: Border.all(color: Colors.blue),
                            //                              ),
                            //                              child: Padding(
                            //                                padding: const EdgeInsets.only(
                            //                                  top: 10,
                            //                                  bottom: 10,
                            //                                  left: 5,
                            //                                  right: 5,
                            //                                ),
                            //                                child: RichText(
                            //                                  text: TextSpan(
                            //                                    children: [
                            //                                      const TextSpan(
                            //                                        text: '         ', // Add a space character
                            //                                        style: TextStyle(
                            //                                          fontSize: 10, // Set the font size to control the width of the gap
                            //                                        ),
                            //                                      ),
                            //                                      const TextSpan(
                            //                                        text: 'Total',
                            //                                        style: TextStyle(
                            //                                          fontWeight: FontWeight.bold,
                            //                                          color: Colors.blue,
                            //                                        ),
                            //                                      ),
                            //                                      const TextSpan(
                            //                                        text: '             ', // Add a space character
                            //                                        style: TextStyle(
                            //                                          fontSize: 10, // Set the font size to control the width of the gap
                            //                                        ),
                            //                                      ),
                            //                                      const TextSpan(
                            //                                        text: '₹',
                            //                                        style: TextStyle(
                            //                                          color: Colors.black,
                            //                                        ),
                            //                                      ),
                            //                                      TextSpan(
                            //                                        text: data2['totalAmount'] = _total.toString(),
                            //                                        style: const TextStyle(
                            //                                          color: Colors.black,
                            //                                        ),
                            //                                      ),
                            //                                    ],
                            //                                  ),
                            //                                ),
                            //                              ),
                            //                            ),
                            //                          ),
                            //                        ],
                            //                      ),
                            //                    )
                            //                  ],
                            //                ),
                            //              ),
                            //            ),
                            //          ),
                            //        ),
                            //      ],
                            //    ),
                            Padding(
                              padding: const EdgeInsets.only(left: 150, top: 50,right: 100,bottom: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.81,
                                child: Container(
                                  width: maxWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10, left: 30),
                                        child: Text(
                                          'Add Products',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(top: 5, bottom: 5),
                                          child: SizedBox(
                                            height: 34,
                                            child: Row(
                                              children: [
                                                // headers
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "SN",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'Product Name',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "Category",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "Sub Category",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "Price",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "QTY",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      "Total Amount",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 80,right: 5),
                                                  child: Center(
                                                    child: Text("  ",
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 90,right: 5),
                                                  child: Center(
                                                    child: Text("  ",
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
                                        itemCount: widget.selectedProducts.length,
                                        itemBuilder: (context, index) {
                                          Product product = widget.selectedProducts[index];
                                          return Table(
                                            border: TableBorder.all(color: Colors.grey),
                                            children: [
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, top: 15, bottom: 5),
                                                      child: Center(
                                                        child: Text(
                                                          (index + 1).toString(),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, top: 10, bottom: 10),
                                                      child: Container(
                                                        height: 35,
                                                        width: 150,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(4.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            product.productName,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, top: 10, bottom: 10),
                                                      child: Container(
                                                        height: 35,
                                                        width: 150,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(4.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            product.category,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, top: 10, bottom: 10),
                                                      child: Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(4.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            product.subCategory,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, top: 10, bottom: 10),
                                                      child: Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(4.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            product.price.toString(),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, top: 10, bottom: 10),
                                                      child: Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(4.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            product.quantity.toString(),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 10, right: 10, top: 10, bottom: 10),
                                                      child: Container(
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(4.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${product.price * product.quantity}',
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                                      child: InkWell(
                                                        onTap: () {
                                                          _deleteProduct(product);
                                                        },
                                                        child: const Icon(
                                                          Icons.remove_circle_outline,
                                                          size: 18,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30, top: 20),
                                            child: OutlinedButton(
                                              onPressed: () {
                                                // List<Product> products = widget.selectedProducts;
                                                Product? selectedProduct;
                                                if (widget.selectedProducts.isNotEmpty) {
                                                  for (var selectedProduct in widget.selectedProducts) {
                                                    print('----yes');
                                                    Map<String, dynamic> data = {
                                                      'deliveryLocation': data2['deliveryLocation'],
                                                      'ContactName': contactPersonController.text,
                                                      'Address': deliveryAddressController.text,
                                                      'ContactNumber': contactNumberController.text,
                                                      'Comments': commentsController.text,
                                                      'date': _selectedDate.toString(),
                                                    };
                                                    data2 = data;
                                                    print(selectedProduct);
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                            animation,
                                                            secondaryAnimation) =>
                                                            NextPage(
                                                              //product: Product(prodId: '', category: '', productName: '', subCategory: '', unit: '', selectedUOM: '', selectedVariation: '', quantity: 0, total: 0, totalamount: 0, tax: '', discount: '', price: 0, imageId: ''),
                                                              data: data2,
                                                              product: selectedProduct,
                                                              inputText: '',
                                                              products: products,
                                                              subText: 'hii',
                                                              selectedProducts: widget.selectedProducts, notselect: 'selectedproduct',),
                                                        // NextPage(
                                                        //   // selectedProducts: widget.selectedProducts,
                                                        //   selectedProducts: widget.selectedProducts,                                                         data: widget.data,
                                                        //   inputText: '',
                                                        //   subText: '',
                                                        //    data: null,
                                                        //    products: products,
                                                        //   product: selectedProduct),
                                                        transitionDuration:
                                                        const Duration(
                                                            milliseconds: 200),
                                                        transitionsBuilder: (
                                                            context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  selectedProduct = null;
                                                }


                                                // context.go(
                                                //   '/dasbaord/Orderspage/addproduct/addparts/addbutton/saveproducts',
                                                //   extra: {
                                                //     'selectedProducts': products,
                                                //     'data': data2,
                                                //   },
                                                // );

                                              },
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                // Blue background color
                                                //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5), // Optional: Square corners
                                                ),
                                                side: BorderSide.none, // No  outline
                                              ),
                                              child: const Text(
                                                '+ Add Products',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                          // Space above/below the border
                                          height: 1, // Border height
                                          color: Colors.grey, // Border color
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 25 ,top: 5,bottom: 5),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 15,right: 10,top: 2,bottom: 2),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.blue),
                                              borderRadius: BorderRadius.circular(3),
                                              color:  Colors.white,
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
                                                        text:  'Total',
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
                                                        data2['totalAmount'] =_total.toString(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  )
                                                  // Text(
                                                  //   'Total',
                                                  //   style: TextStyle(
                                                  //     fontSize: 16,
                                                  //     fontWeight: FontWeight.bold,
                                                  //   ),
                                                  // ),
                                                  // SizedBox(width: 16.0),
                                                  // Text(
                                                  //   data2['totalAmount'] =_total.toString(),
                                                  //   style: const TextStyle(
                                                  //     color: Colors.black,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Padding(
                                      //   padding:  EdgeInsets.only(top: 8, left:1100.w, bottom: 10,right: 50),
                                      //   child: Row(
                                      //     children: [
                                      //       const SizedBox(width: 10), // add some space between the line and the text
                                      //       SizedBox(
                                      //         width: 220,
                                      //         child: Container(
                                      //           decoration: BoxDecoration(
                                      //             border: Border.all(color: Colors.blue),
                                      //           ),
                                      //           child: Padding(
                                      //             padding: const EdgeInsets.only(
                                      //               top: 10,
                                      //               bottom: 10,
                                      //               left: 5,
                                      //               right: 5,
                                      //             ),
                                      //             child: RichText(
                                      //               text: TextSpan(
                                      //                 children: [
                                      //                   const TextSpan(
                                      //                     text: '       ', // Add a space character
                                      //                     style: TextStyle(
                                      //                       fontSize: 10, // Set the font size to control the width of the gap
                                      //                     ),
                                      //                   ),
                                      //                   const TextSpan(
                                      //                     text: 'Total',
                                      //                     style: TextStyle(
                                      //                       fontWeight: FontWeight.bold,
                                      //                       color: Colors.blue,
                                      //                     ),
                                      //                   ),
                                      //                   const TextSpan(
                                      //                     text: '           ', // Add a space character
                                      //                     style: TextStyle(
                                      //                       fontSize: 10, // Set the font size to control the width of the gap
                                      //                     ),
                                      //                   ),
                                      //                   const TextSpan(
                                      //                     text: '₹',
                                      //                     style: TextStyle(
                                      //                       color: Colors.black,
                                      //                     ),
                                      //                   ),
                                      //                   TextSpan(
                                      //                     text: data2['totalAmount'] = _total.toString(),
                                      //                     style: const TextStyle(
                                      //                       color: Colors.black,
                                      //                     ),
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Handle date selection
    }
  }
}