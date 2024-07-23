//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:btb/fourthpage/orderspage%20order.dart';
// import 'package:btb/sprint%202%20order/sixthpage.dart';
// import 'package:btb/thirdpage/productclass.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
//
// import '../thirdpage/dashboard.dart';
// import 'firstpage.dart';
// import 'fourthpage.dart';
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
//     // commentsController.text = widget.data['Comments'];
//     // deliveryAddressController.text = widget.data['Address'];
//     // contactNumberController.text = widget.data['ContactNumber'];
//     // contactPersonController.text = widget.data['ContactName'];
//
//     print('------------dadf');
//
//     _calculateTotal();
//     _selectedDate = DateTime.now();
//     _dateController.text = DateFormat.yMd().format(_selectedDate!);
//     print(widget.data);
//     print('-hello');
//      data2 = widget.data;
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
//       "deliveryAddress":  data2['Address'],
//       "contactPerson": data2['ContactName'],
//       "contactNumber": data2['ContactNumber'],
//       "comments":  data2['Comments'],
//       "total": data2['totalAmount'],
//       "items": items,
//     };
//
//     final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
//
//     if (response.statusCode == 200) {
//       print('API call successful');
//       final responseData = json.decode(response.body);
//       print(responseData);
//       Navigator.push(
//         context,
//         PageRouteBuilder(
//           pageBuilder: (context, animation,
//               secondaryAnimation) =>
//            SixthPage(product: detail(orderId: '',orderDate: '',deliveryStatus: '',status: '',referenceNumber: '',total: 0),),
//           transitionDuration:
//           const Duration(milliseconds: 200),
//           transitionsBuilder: (context, animation,
//               secondaryAnimation, child) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//         ),
//       );
//     } else {
//       print('API call failed with status code ${response.statusCode}');
//     }
//   }
//
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
//         backgroundColor: const Color(0xFFFFFFFF),
//         appBar: AppBar(
//           backgroundColor: const Color(0xFFFFFFFF),
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           // Set background color to white
//           elevation: 2.0,
//           shadowColor: const Color(0xFFFFFFFF),
//           // Set shadow color to black
//           actions: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//             SizedBox(width: 10,),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 35),
//                 child: IconButton(
//                   icon: const Icon(Icons.account_circle),
//                   onPressed: () {
//                     // Handle user icon press
//                   },
//                 ),
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
//                   color: const Color(0xFFF7F6FA),
//                   padding: const EdgeInsets.only(left: 20, top: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextButton.icon(
//                         onPressed: () {
//                           // context
//                           //     .go('${PageName.main}/${PageName.subpage1Main}');
//                           context.go('/Orderspage/placingorder/dasbaord');
//                           Navigator.push(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) =>
//                               const Dashboard(
//
//                               ),
//                               transitionDuration:
//                               const Duration(milliseconds: 200),
//                               transitionsBuilder: (context, animation,
//                                   secondaryAnimation, child) {
//                                 return FadeTransition(
//                                   opacity: animation,
//                                   child: child,
//                                 );
//                               },
//                             ),
//                           );
//
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
//                           context.go(
//                               '/Orderspage/placingorder/productpage:product');
//                           Navigator.push(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) =>
//                               const ProductPage(
//                                 product: null,
//                               ),
//                               transitionDuration:
//                               const Duration(milliseconds: 200),
//                               transitionsBuilder: (context, animation,
//                                   secondaryAnimation, child) {
//                                 return FadeTransition(
//                                   opacity: animation,
//                                   child: child,
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                         icon: Icon(Icons.image_outlined,
//                             color: Colors.indigo[900]),
//                         label: Text(
//                           'Products',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {
//                           context.go('/BeforplacingOrder/Orderspage');
//                           Navigator.push(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder: (context, animation,
//                                   secondaryAnimation) =>
//                               const Orderspage(),
//                               transitionDuration: const Duration(
//                                   milliseconds: 200),
//                               transitionsBuilder:
//                                   (context, animation, secondaryAnimation,
//                                   child) {
//                                 return FadeTransition(
//                                   opacity: animation,
//                                   child: child,
//                                 );
//                               },
//                             ),
//                           );
//                           setState(() {
//                             isOrdersSelected = false;
//                             // Handle button press19
//                           });
//                         },
//                         icon: Icon(Icons.warehouse,
//                             color: isOrdersSelected
//                                 ? Colors.blueAccent
//                                 : Colors.blueAccent),
//                         label: const Text(
//                           'Orders',
//                           style: TextStyle(
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.fire_truck_outlined,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Delivery',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.document_scanner_rounded,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Invoice',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.payment_outlined,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Payment',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.backspace_sharp,
//                             color: Colors.blue[900]),
//                         label: Text(
//                           'Return',
//                           style: TextStyle(color: Colors.indigo[900]),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
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
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     color: Colors.white,
//                     height: 60,
//                     child: Row(
//                       children: [
//                         IconButton(
//                           icon:
//                           const Icon(Icons.arrow_back), // Back button icon
//                           onPressed: () {
//                             context.go(
//                                 '/dasbaord/Orderspage/placeorder/arrowback');
//                             //  Navigator.push(
//                             //      context,
//                             //     MaterialPageRoute(
//                             //       builder: (context) => NextPage(product: , data: data2, inputText: '', subText: '')),
//                             // );
//                           },
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.only(left: 30),
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
//                             onPressed: () async {
//                               await callApi();
//                             },
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor:
//                               Colors.blueAccent, // Button background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(5), // Rounded corners
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
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.only(left: 1250, top: 60),
//                         child: Text(
//                           'Order Date',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 1250, top: 20),
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color(0xFFEBF3FF), width: 1),
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF418CFC)
//                                 .withOpacity(0.16), // 0.2 * 0.8 = 0.16
//                             spreadRadius: 0,
//                             blurRadius: 6,
//                             offset: const Offset(0, 3),
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
//                                 controller: TextEditingController(
//                                     text: data2['date'] != null
//                                         ? DateFormat('dd-MM-yyyy').format(
//                                         DateTime.parse(data2['date']))
//                                         : 'Select Date'),
//                                 // Replace with your TextEditingController
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   suffixIcon: Padding(
//                                     padding: const EdgeInsets.only(right: 20),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 2, left: 10),
//                                       child: IconButton(
//                                         icon: const Padding(
//                                           padding: EdgeInsets.only(bottom: 16),
//                                           child: Icon(Icons.calendar_month),
//                                         ),
//                                         iconSize: 20,
//                                         onPressed: () {
//                                           // _showDatePicker(context);
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   hintText: '        Select Date',
//                                   fillColor: Colors.white,
//                                   contentPadding: const EdgeInsets.symmetric(
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
//                     ],
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 200,left: 300,right: 80),
//                 child: Container(
//                   height: 350,
//                   // padding: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blue),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 30,top: 10),
//                         child: Text(
//                           'Delivery Location',
//                           style: TextStyle(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Divider(color: Colors.grey),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 30,bottom: 5),
//                             child: Text(
//                               'Address',
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 350,bottom: 5),
//                             child: Text(
//                               'Comments',
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         color: Colors.grey,
//                         thickness: 1.0,
//                         height: 1.0,
//                       ),
//                       SizedBox(height: 5.0),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 30),
//                                   child: Text('Select Delivery Location'),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 30),
//                                   child: SizedBox(
//                                     width: 350,
//                                     child: DropdownButtonFormField<String>(
//                                       value: data2['deliveryLocation'],
//                                       decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: Colors.grey[200],
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(5.0),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                       ),
//                                       onChanged: (String? value) {
//                                         setState(() {
//                                           data2['deliveryLocation'] = value!;
//                                         });
//                                       },
//                                       items: list.map<DropdownMenuItem<String>>((String value) {
//                                         return DropdownMenuItem<String>(
//                                           value: value,
//                                           child: Text(value),
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 20.0),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 30),
//                                   child: Text('Delivery Address'),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 30),
//                                   child: SizedBox(
//                                     width: 350,
//                                     child: TextField(
//                                       controller: TextEditingController(
//                                           text: data2['Address']),
//                                       decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: Colors.grey[200],
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(5.0),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                         hintText: 'Address Details',
//                                       ),
//                                       maxLines: 3,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 30.0),
//                           Expanded(
//                             flex: 3,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Contact Person'),
//                                 SizedBox(
//                                   width: 350,
//                                   child: TextField(
//                                     controller: TextEditingController(
//                                         text: data2['ContactName']),
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.grey[200],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                       hintText: 'Contact Person Name',
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 20.0),
//                                 Text('Contact Number'),
//                                 SizedBox(height: 10,),
//                                 SizedBox(
//                                   width: 350,
//                                   child: TextField(
//                                     controller: TextEditingController(
//                                         text: data2['ContactNumber']),
//                                     keyboardType:
//                                     TextInputType.number,
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter
//                                           .digitsOnly,
//                                       LengthLimitingTextInputFormatter(
//                                           10),
//                                       // limits to 10 digits
//                                     ],
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.grey[200],
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(5.0),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                       hintText: 'Contact Person Number',
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 237,
//                             width: 1,
//                             color: Colors.grey, // Vertical line at the start
//                             margin: EdgeInsets.zero, // Adjust margin if needed
//                           ),
//                           SizedBox(width: 20.0),
//                           Expanded(
//                             flex: 3,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('    '),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 10),
//                                   child: SizedBox(
//                                     child: TextField(
//                                       controller: TextEditingController(
//                                           text: data2['Comments']),
//                                       decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: Colors.grey[200],
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(5.0),
//                                           borderSide: BorderSide.none,
//                                         ),
//                                         hintText: 'Enter your comments',
//                                       ),
//                                       maxLines: 5,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 300, top: 670,right: 80),
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey, width: 10),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: SizedBox(
//
//                         width: 1200,
//                         child: SizedBox(
//                           width: 1200,
//
//                           child: Container(
//
//                             width: 1200,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               // Container background color
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Padding(
//                                   padding: EdgeInsets.only(left: 30, top: 10),
//                                   child: Text(
//                                     'Add Parts',
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.grey),
//                                   ),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.grey, width: 1),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                       left: 1,
//                                       right: 1,
//                                       top: 10,
//                                       bottom: 10,
//                                     ),
//                                     child: SizedBox(
//                                       height: 34,
//                                       child: Row(
//                                         children: [
//                                           const Padding(
//                                             padding: EdgeInsets.only(
//                                               left: 38,
//                                               right: 55,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "SN",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(
//                                               left: 55,
//                                               right: 43,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 'Product Name',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(
//                                               left: 38,
//                                               right: 55,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "Category",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(
//                                               left: 15,
//                                               right: 55,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "Sub Category",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(
//                                               left: 25,
//                                               right: 40,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "Price",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(
//                                               left: 50,
//                                               right: 45,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "QTY",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.only(
//                                               left: 60,
//                                               right: 30,
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 "Total Amount",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Center(
//                                             child: Text("  ",
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: widget.selectedProducts.length,
//                                   itemBuilder: (context, index) {
//                                     Product product = widget
//                                         .selectedProducts[index];
//                                     return Table(
//                                       border: TableBorder.all(
//                                           color: Colors.grey),
//                                       // Add this line
//                                       children: [
//                                         TableRow(
//                                           children: [
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 10,
//                                                     right: 10,
//                                                     top: 20,
//                                                     bottom: 5),
//                                                 child: Center(
//                                                   child: Text(
//                                                     (index + 1).toString(),
//                                                     textAlign: TextAlign
//                                                         .center,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 40,
//                                                     right: 50,
//                                                     top: 5,
//                                                     bottom: 5),
//                                                 child: Container(
//                                                   height: 35,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey[300],
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       product.productName,
//                                                       textAlign: TextAlign
//                                                           .center,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 55,
//                                                     right: 35,
//                                                     top: 5,
//                                                     bottom: 5),
//                                                 child: Container(
//                                                   height: 35,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey[300],
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       product.category,
//                                                       textAlign: TextAlign
//                                                           .center,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 60,
//                                                     right: 50,
//                                                     top: 5,
//                                                     bottom: 5),
//                                                 child: Container(
//                                                   height: 35,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey[300],
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       product.subCategory,
//                                                       textAlign: TextAlign
//                                                           .center,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 45,
//                                                     right: 25,
//                                                     top: 5,
//                                                     bottom: 5),
//                                                 child: Container(
//                                                   height: 35,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey[300],
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       product.price
//                                                           .toStringAsFixed(2),
//                                                       textAlign: TextAlign
//                                                           .center,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 50,
//                                                     right: 55,
//                                                     top: 5,
//                                                     bottom: 5),
//                                                 child: Container(
//                                                   height: 35,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey[300],
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       product.quantity
//                                                           .toString(),
//                                                       textAlign: TextAlign
//                                                           .center,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: 35,
//                                                     right: 30,
//                                                     top: 5,
//                                                     bottom: 5),
//                                                 child: Container(
//                                                   height: 35,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey[300],
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '${product.price *
//                                                           product.quantity}',
//                                                       textAlign: TextAlign
//                                                           .center,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             TableCell(
//                                               child: Padding(
//                                                 padding: const EdgeInsets
//                                                     .symmetric(vertical: 20),
//                                                 // Add padding top and bottom
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     _deleteProduct(product);
//                                                   },
//                                                   child: const Icon(
//                                                     Icons
//                                                         .remove_circle_outline,
//                                                     size: 18,
//                                                     color: Colors.blue,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                                 Row(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 30, top: 50),
//                                       child: OutlinedButton(
//                                         onPressed: () {
//                                           // List<Product> products = widget.selectedProducts;
//                                           Product? selectedProduct;
//                                           if (widget.selectedProducts.isNotEmpty) {
//                                             for (var selectedProduct in widget.selectedProducts) {
//                                               print('----yes');
//                                               print(selectedProduct);
//                                               Navigator.push(
//                                                 context,
//                                                 PageRouteBuilder(
//                                                   pageBuilder: (context,
//                                                       animation,
//                                                       secondaryAnimation) =>
//                                                       NextPage(
//                                                         //product: Product(prodId: '', category: '', productName: '', subCategory: '', unit: '', selectedUOM: '', selectedVariation: '', quantity: 0, total: 0, totalamount: 0, tax: '', discount: '', price: 0, imageId: ''),
//                                                           data: data2,
//                                                           product: selectedProduct,
//                                                           inputText: '',
//                                                           products: products,
//                                                           subText: 'hii',
//                                                           selectedProducts: widget.selectedProducts, notselect: 'selectedproduct',),
//                                                   // NextPage(
//                                                   //   // selectedProducts: widget.selectedProducts,
//                                                   //   selectedProducts: widget.selectedProducts,                                                         data: widget.data,
//                                                   //   inputText: '',
//                                                   //   subText: '',
//                                                   //    data: null,
//                                                   //    products: products,
//                                                   //   product: selectedProduct),
//                                                   transitionDuration:
//                                                   const Duration(
//                                                       milliseconds: 200),
//                                                   transitionsBuilder: (
//                                                       context,
//                                                       animation,
//                                                       secondaryAnimation,
//                                                       child) {
//                                                     return FadeTransition(
//                                                       opacity: animation,
//                                                       child: child,
//                                                     );
//                                                   },
//                                                 ),
//                                               );
//                                             }
//                                           } else {
//                                             selectedProduct = null;
//                                           }
//
//
//                                           // context.go(
//                                           //   '/dasbaord/Orderspage/addproduct/addparts/addbutton/saveproducts',
//                                           //   extra: {
//                                           //     'selectedProducts': products,
//                                           //     'data': data2,
//                                           //   },
//                                           // );
//
//                                         },
//                                         style: OutlinedButton.styleFrom(
//                                           backgroundColor: Colors
//                                               .blue,
//                                           // Blue background color
//                                           //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius
//                                                 .circular(
//                                                 5), // Optional: Square corners
//                                           ),
//                                           side: BorderSide
//                                               .none, // No  outline
//                                         ),
//                                         child: const Text(
//                                           '+ Add Products',
//                                           style: TextStyle(
//                                               color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 10,),
//                                   child: Container(
//                                     // Space above/below the border
//                                       height: 2, // Border height
//                                       color: Colors.grey// Border color
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8,left: 850,bottom: 10),
//                                   child: Row(
//                                     children: [
//                                       SizedBox(width: 10), // add some space between the line and the text
//                                       SizedBox(
//                                         width: 220,
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             border: Border.all(color: Colors.blue),
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                               top: 10,
//                                               bottom: 10,
//                                               left: 5,
//                                               right: 5,
//                                             ),
//                                             child: RichText(
//                                               text: TextSpan(
//                                                 children: [
//                                                   const TextSpan(
//                                                     text: '         ', // Add a space character
//                                                     style: TextStyle(
//                                                       fontSize: 10, // Set the font size to control the width of the gap
//                                                     ),
//                                                   ),
//                                                   const TextSpan(
//                                                     text: 'Total',
//                                                     style: TextStyle(
//                                                       fontWeight: FontWeight.bold,
//                                                       color: Colors.blue,
//                                                     ),
//                                                   ),
//                                                   const TextSpan(
//                                                     text: '             ', // Add a space character
//                                                     style: TextStyle(
//                                                       fontSize: 10, // Set the font size to control the width of the gap
//                                                     ),
//                                                   ),
//                                                   const TextSpan(
//                                                     text: '₹',
//                                                     style: TextStyle(
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text: data2['totalAmount'] = _total.toStringAsFixed(2),
//                                                     style: const TextStyle(
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
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
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: SizedBox(
//                         height: 350,
//                         width: 1200,
//                         child: SizedBox(
//                           width: 1200,
//                           height: 350,
//                           child: Card(
//                             color: Colors.white,
//                             child: Container(
//                               height: 350,
//                               width: 1200,
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 // Container background color
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Padding(
//                                     padding: EdgeInsets.only(left: 30, top: 10),
//                                     child: Text(
//                                       'Add Parts',
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.grey),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.grey, width: 1),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 10,
//                                         right: 30,
//                                         top: 10,
//                                         bottom: 10,
//                                       ),
//                                       child: SizedBox(
//                                         height: 34,
//                                         child: Row(
//                                           children: [
//                                             const Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: 38,
//                                                 right: 55,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "SN",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: 55,
//                                                 right: 43,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   'Product Name',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: 38,
//                                                 right: 55,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "Category",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: 15,
//                                                 right: 55,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "Sub Category",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: 25,
//                                                 right: 40,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "Price",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: 50,
//                                                 right: 45,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "QTY",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const Padding(
//                                               padding: EdgeInsets.only(
//                                                 left: 60,
//                                                 right: 30,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   "Total Amount",
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Center(
//                                               child: Text("  ",
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   ListView.builder(
//                                     shrinkWrap: true,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: widget.selectedProducts.length,
//                                     itemBuilder: (context, index) {
//                                       Product product = widget
//                                           .selectedProducts[index];
//                                       return Table(
//                                         border: TableBorder.all(
//                                             color: Colors.grey),
//                                         // Add this line
//                                         children: [
//                                           TableRow(
//                                             children: [
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 10,
//                                                       right: 10,
//                                                       top: 20,
//                                                       bottom: 5),
//                                                   child: Center(
//                                                     child: Text(
//                                                       (index + 1).toString(),
//                                                       textAlign: TextAlign
//                                                           .center,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 40,
//                                                       right: 50,
//                                                       top: 5,
//                                                       bottom: 5),
//                                                   child: Container(
//                                                     height: 35,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[300],
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         product.productName,
//                                                         textAlign: TextAlign
//                                                             .center,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 55,
//                                                       right: 35,
//                                                       top: 5,
//                                                       bottom: 5),
//                                                   child: Container(
//                                                     height: 35,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[300],
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         product.category,
//                                                         textAlign: TextAlign
//                                                             .center,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 60,
//                                                       right: 50,
//                                                       top: 5,
//                                                       bottom: 5),
//                                                   child: Container(
//                                                     height: 35,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[300],
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         product.subCategory,
//                                                         textAlign: TextAlign
//                                                             .center,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 45,
//                                                       right: 25,
//                                                       top: 5,
//                                                       bottom: 5),
//                                                   child: Container(
//                                                     height: 35,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[300],
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         product.price
//                                                             .toStringAsFixed(2),
//                                                         textAlign: TextAlign
//                                                             .center,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 50,
//                                                       right: 55,
//                                                       top: 5,
//                                                       bottom: 5),
//                                                   child: Container(
//                                                     height: 35,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[300],
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         product.quantity
//                                                             .toString(),
//                                                         textAlign: TextAlign
//                                                             .center,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 35,
//                                                       right: 30,
//                                                       top: 5,
//                                                       bottom: 5),
//                                                   child: Container(
//                                                     height: 35,
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.grey[300],
//                                                     ),
//                                                     child: Center(
//                                                       child: Text(
//                                                         '${product.price *
//                                                             product.quantity}',
//                                                         textAlign: TextAlign
//                                                             .center,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               TableCell(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(vertical: 20),
//                                                   // Add padding top and bottom
//                                                   child: InkWell(
//                                                     onTap: () {
//                                                       _deleteProduct(product);
//                                                     },
//                                                     child: const Icon(
//                                                       Icons
//                                                           .remove_circle_outline,
//                                                       size: 18,
//                                                       color: Colors.blue,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                   Row(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 30, top: 50),
//                                         child: OutlinedButton(
//                                           onPressed: () {
//                                             // List<Product> products = widget.selectedProducts;
//                                             Product? selectedProduct;
//                                             if (widget.selectedProducts.isNotEmpty) {
//                                               for (var selectedProduct in widget.selectedProducts) {
//                                                 print('----yes');
//                                                 print(selectedProduct);
//                                                 // Navigator.push(
//                                                 //   context,
//                                                 //   PageRouteBuilder(
//                                                 //     pageBuilder: (context,
//                                                 //         animation,
//                                                 //         secondaryAnimation) =>
//                                                 //         NextPage(
//                                                 //           //product: Product(prodId: '', category: '', productName: '', subCategory: '', unit: '', selectedUOM: '', selectedVariation: '', quantity: 0, total: 0, totalamount: 0, tax: '', discount: '', price: 0, imageId: ''),
//                                                 //           data: data2,
//                                                 //           product: selectedProduct,
//                                                 //           inputText: '',
//                                                 //           products: products,
//                                                 //           subText: 'hii',
//                                                 //           selectedProducts: widget.selectedProducts, notselect: 'selectedproduct',),
//                                                 //     // NextPage(
//                                                 //     //   // selectedProducts: widget.selectedProducts,
//                                                 //     //   selectedProducts: widget.selectedProducts,                                                         data: widget.data,
//                                                 //     //   inputText: '',
//                                                 //     //   subText: '',
//                                                 //     //    data: null,
//                                                 //     //    products: products,
//                                                 //     //   product: selectedProduct),
//                                                 //     transitionDuration:
//                                                 //     const Duration(
//                                                 //         milliseconds: 200),
//                                                 //     transitionsBuilder: (
//                                                 //         context,
//                                                 //         animation,
//                                                 //         secondaryAnimation,
//                                                 //         child) {
//                                                 //       return FadeTransition(
//                                                 //         opacity: animation,
//                                                 //         child: child,
//                                                 //       );
//                                                 //     },
//                                                 //   ),
//                                                 // );
//                                               }
//                                             } else {
//                                               selectedProduct = null;
//                                             }
//
//
//                                             // context.go(
//                                             //   '/dasbaord/Orderspage/addproduct/addparts/addbutton/saveproducts',
//                                             //   extra: {
//                                             //     'selectedProducts': products,
//                                             //     'data': data2,
//                                             //   },
//                                             // );
//
//                                           },
//                                           style: OutlinedButton.styleFrom(
//                                             backgroundColor: Colors
//                                                 .blue,
//                                             // Blue background color
//                                             //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius
//                                                   .circular(
//                                                   5), // Optional: Square corners
//                                             ),
//                                             side: BorderSide
//                                                 .none, // No  outline
//                                           ),
//                                           child: const Text(
//                                             '+ Add Products',
//                                             style: TextStyle(
//                                                 color: Colors.white),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 10,),
//                                     child: Container(
//                                       // Space above/below the border
//                                         height: 2, // Border height
//                                         color: Colors.grey// Border color
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 8,left: 850,bottom: 10),
//                                     child: Row(
//                                       children: [
//                                         SizedBox(width: 10), // add some space between the line and the text
//                                         SizedBox(
//                                           width: 220,
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               border: Border.all(color: Colors.blue),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                 top: 10,
//                                                 bottom: 10,
//                                                 left: 5,
//                                                 right: 5,
//                                               ),
//                                               child: RichText(
//                                                 text: TextSpan(
//                                                   children: [
//                                                     const TextSpan(
//                                                       text: '         ', // Add a space character
//                                                       style: TextStyle(
//                                                         fontSize: 10, // Set the font size to control the width of the gap
//                                                       ),
//                                                     ),
//                                                     const TextSpan(
//                                                       text: 'Total',
//                                                       style: TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         color: Colors.blue,
//                                                       ),
//                                                     ),
//                                                     const TextSpan(
//                                                       text: '             ', // Add a space character
//                                                       style: TextStyle(
//                                                         fontSize: 10, // Set the font size to control the width of the gap
//                                                       ),
//                                                     ),
//                                                     const TextSpan(
//                                                       text: '₹',
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                     TextSpan(
//                                                       text: data2['totalAmount'] = _total.toStringAsFixed(2),
//                                                       style: const TextStyle(
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
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
// }
//
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.grey.shade200,
//         body:
//         Center(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 100, bottom: 50),
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Container(
//                     height: constraints.maxHeight * 0.7,
//                     width: constraints.maxWidth * 0.8,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Container(
//                             width: double.infinity,
//                             padding: EdgeInsets.all(16.0),
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(8.0),
//                                 topRight: Radius.circular(8.0),
//                               ),
//                             ),
//                             child: Text(
//                               'Selected Products',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Divider(color: Colors.grey),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: DataTable(
//                               columnSpacing: 90,
//                               headingRowColor: MaterialStateColor.resolveWith(
//                                       (states) => Colors.white),
//                               headingTextStyle: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold),
//                               columns: [
//                                 DataColumn(label: Text('Product Name')),
//                                 DataColumn(label: Text('Brand')),
//                                 DataColumn(label: Text('Category')),
//                                 DataColumn(label: Text('Sub Category')),
//                                 DataColumn(label: Text('Price')),
//                                 DataColumn(label: Text('QTY')),
//                                 DataColumn(label: Text('Total Amount')),
//                                 DataColumn(label: Text('Action')),
//                               ],
//                               rows: [
//                                 _buildRow(
//                                     'Lenovo LCD Monitor',
//                                     'Lenovo',
//                                     'Monitor',
//                                     'LCD',
//                                     '₹ 5,799.00',
//                                     '0'),
//                                 _buildRow(
//                                     'Acer LCD Monitor',
//                                     'Acer',
//                                     'Monitor',
//                                     'LCD',
//                                     '₹ 6,399.00',
//                                     '0'),
//                                 _buildRow(
//                                     'LG LCD Monitor',
//                                     'LG',
//                                     'Monitor',
//                                     'LCD',
//                                     '₹ 7,999.00',
//                                     '0'),
//                                 _buildRow(
//                                     'Acer LED Monitor',
//                                     'Acer',
//                                     'Monitor',
//                                     'LED',
//                                     '₹ 8,299.00',
//                                     '0'),
//                               ],
//                               border: TableBorder(
//                                 horizontalInside: BorderSide.none,
//                                 verticalInside: BorderSide(
//                                   color: Colors.grey.shade300,
//                                   width: 1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   DataRow _buildRow(String name, String brand, String category, String subCategory,
//       String price, String qty) {
//     return DataRow(cells: [
//       DataCell(Text(name)),
//       DataCell(Text(brand)),
//       DataCell(Text(category)),
//       DataCell(Text(subCategory)),
//       DataCell(Text(price)),
//       DataCell(Text(qty)),
//       DataCell(Text('0')),
//       DataCell(IconButton(
//         icon: Icon(Icons.add_circle, color: Colors.blue.shade900),
//         onPressed: () {},
//       )),
//     ]);
//   }
// }
//

import 'dart:html';

import 'package:btb/fifthpage/create_order.dart';
//import 'package:btb/sprint%202%20order/nextpagesample.dart';
import 'package:btb/sprint%202%20order/seventhpage%20.dart';
import 'package:btb/thirdpage/productclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import '../fourthpage/orderspage order.dart';
import '../thirdpage/dashboard.dart';
import 'fourthpage.dart';
// import 'nextpage123.dart';



void main() {
  runApp(SelectedProductPage(selectedProducts: [],data: {},));
}
class Order {
  final String prodId;

  final String? proId;
  final String productName;
  String subCategory;
  String category;
  final String unit;
  final String tax;
  int qty;
  final String discount;
  final int price;
  String? selectedUOM;
  String? selectedVariation;
  int quantity;
  double total;
  double totalAmount;
  double totalamount;
  final String imageId;

  @override
  String toString() {
    return 'Order{productName: $productName, category: $category, subCategory: $subCategory, price: $price, qty: $qty, totalAmount: $totalAmount}';
  }

  Order({
    required this.prodId,
    required this.category,
    this.proId,
    required this.qty,
    required this.productName,
    required this.totalAmount,
    required this.subCategory,
    required this.unit,
    required this.selectedUOM,
    required this.selectedVariation,
    required this.quantity,
    required this.total,
    required this.totalamount,
    required this.tax,
    required this.discount,
    required this.price,
    required this.imageId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      prodId: json['prodId'] ?? '',
      category: json['category'] ?? '',
      productName: json['productName'] ?? '',
      subCategory: json['subCategory'] ?? '',
      unit: json['unit'] ?? '',
      tax: json['tax'] ?? '',
      totalAmount: (json['totalAmount'] is String ? double.tryParse(json['totalAmount']) : json['totalAmount']) ?? 0.0,
      qty: (json['qty'] is String ? int.tryParse(json['qty']): json['qty'] ?? 0),
      quantity: (json['quantity'] is String ? int.tryParse(json['quantity']) : json['quantity']) ?? 0,
      total: (json['totalamount'] is String ? double.tryParse(json['total']) : json['total']) ?? 0.0,
      totalamount: (json['total'] is String ? double.tryParse(json['totalamount']) : json['totalamount']) ?? 0.0,
      discount: json['discount'] ?? '',
      selectedUOM: json['uom'] ?? 'Select',
      selectedVariation: json['variation'] ?? 'Select',
      price: json['price'] ?? 0,
      imageId: json['imageId'] ?? '',
      proId: json['proId'] ?? '',
    );
  }


  Map<String, dynamic> asMap() {
    return {
      'proId': proId,
      'productName': productName,
      'category': category,
      'subCategory': subCategory,
      'price': price,
      'tax': tax,
      'unit': unit,
      'discount': discount,
      'selectedUOM': selectedUOM,
      'selectedVariation': selectedVariation,
      'quantity': quantity,
      'total': total,
      'totalamount': totalamount,
    };
  }
  Product orderToProduct() {
    return Product(
      prodId: this.prodId,
      price: this.price,
      productName: this.productName,
      proId: this.proId,
      category: this.category,
      subCategory: this.subCategory,
      selectedVariation: this.selectedVariation,
      selectedUOM: this.selectedUOM,
      totalamount: this.totalamount,
      total: this.total,
      tax: this.tax,
      quantity: this.quantity,
      discount: this.discount,
      imageId: this.imageId,
      unit: this.unit,
      totalAmount: this.totalAmount, qty: this.qty,
    );
  }

  Order productToOrder() {
    return Order(
      prodId: this.prodId,
      price: this.price,
      productName: this.productName,
      proId: this.proId,
      category: this.category,
      subCategory: this.subCategory,
      selectedVariation: this.selectedVariation,
      selectedUOM: this.selectedUOM,
      totalamount: this.totalamount,
      total: this.total,
      tax: this.tax,
      quantity: this.quantity,
      discount: this.discount,
      imageId: this.imageId,
      unit: this.unit,
      totalAmount: this.totalAmount,
      qty: this.qty,
    );
  }


}




class SelectedProductPage extends StatefulWidget {
  // final  List<Order> selectedProducts;
  final List<Order> selectedProducts;
  final Map<String, dynamic> data;


  SelectedProductPage({
    required this.selectedProducts,
    required this.data});

  @override
  State<SelectedProductPage> createState() => _SelectedProductPageState();
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  bool isOrdersSelected = false;
  late List<Map<String, dynamic>> items;
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController CreatedDateController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = [];
  List<Order> selectedProducts = [];
  Map<String, dynamic> data2 = {};
  List<Order> itemdetails = [];
  List<Product> productList = []; //updated details
  //List<Map<String, dynamic>> selectedItems = [];
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController  _commentsController = TextEditingController();
  final TextEditingController  _deliveryaddressController = TextEditingController();
  final TextEditingController  _createdDateController = TextEditingController();
  late TextEditingController _dateController;
  String token = window.sessionStorage["token"]?? " ";
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  final TextEditingController ContactPersonController = TextEditingController();


  DateTime? _selectedDate;
  @override

  void initState() {
    super.initState();
    /// widget.selectedProducts;
    print('---selectedproducts');
    print(widget.data);
    print(_createdDateController.text);
    print('--orderdate');
    // print(widget.data['orderDate']);
    widget.data['orderDate'];
    print(widget.data['orderDate']);
    ContactPersonController.text;
    widget.data['contactNumber'];
    widget.data['contactNumber'];
    widget.data['deliveryAddress'];
    widget.data['comments'];
    print(_contactPersonController.text);
    print(widget.data['contactNumber']);
    print(widget.data['comments']);
    print( widget.data['deliveryAddress']);
    // print(_contactPersonController.text);
    print('---contractper');
    print(_contactNumberController.text);

    if (widget.data != null && widget.data['items'] != null) {
      itemdetails = widget.data['items'].map<Order>((item) => Order(
        productName: item['productName'],
        category: item['category'],
        subCategory: item['subCategory'],
        price: item['price'],
        qty: item['qty'],
        tax: '',
        discount: '',
        selectedUOM: '',
        selectedVariation: '',
        quantity: item['qty'],
        unit: '',
        prodId: '',
        proId: '',
        total: item['totalAmount'],
        totalamount: 0.0, // Provide a default value of 0.0 if totalAmount is null
        imageId: '',
        totalAmount: 0.0,
      )).toList();

      // Convert List<Order> to List<Product>
      productList = itemdetails.map((order) => order.orderToProduct()).toList();
    }



    widget.data['orderDate'];
    print(_createdDateController.text);
    _createdDateController.text = widget.data['orderDate'];
    _contactPersonController.text = widget.data['contactPerson'];
    _contactNumberController.text = widget.data['contactNumber'];
    _commentsController.text = widget.data['comments'];
    _deliveryaddressController.text =widget.data['deliveryAddress'];



    print("Selected products in SelectedProductPage: ${widget.selectedProducts}");
    items = widget.selectedProducts.map((order) {
      return {
        'productName': order.productName,
        'category': order.category,
        'subCategory': order.subCategory,
        'price': order.price,
        'qty': order.quantity,
        'totalAmount': order.totalAmount,
      };
    }).toList();



    print(widget.data['items']);
    _dateController = TextEditingController();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat.yMd().format(_selectedDate!);
    _createdDateController.text = widget.data['orderDate'];
    _contactPersonController.text = widget.data['contactPerson'];
    _contactNumberController.text = widget.data['contactNumber'];
    _commentsController.text = widget.data['comments'];
    _deliveryaddressController.text =widget.data['deliveryAddress'];



    // widget.data['items'] = widget.selectedProducts;

  }


  void _updateOrder(Map<String, dynamic> updatedOrder) async {
    final response = await http.put(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/add_update_delete_order_master'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Replace with your API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedOrder),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(responseData['message'])),
      // );

      // Redirect to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeventhPage(selectedProducts: updatedOrder)), // Replace with your next page
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update order.');
    }
  }

  void _onSaveChanges() {

    final updatedOrder = {

      "orderId": widget.data['orderId'],

      "orderDate": _dateController.text,

      "deliveryLocation": widget.data['deliveryLocation'],

      "deliveryAddress": _deliveryaddressController.text,

      "contactPerson": _contactPersonController.text,

      "contactNumber": _contactNumberController.text,

      "comments": _commentsController.text,

      "total": double.parse(widget.data['total']),

      "items": widget.data['items'],

    };



    _updateOrder(updatedOrder);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SeventhPage(selectedProducts: updatedOrder)), // Replace with your next page
    );

  }

  void _deleteProduct(int index) {
    setState(() {
      widget.data['items'].removeAt(index);
    });
    // _calculateTotal(); // need on the last step
  }

  @override
  void dispose() {
    _contactPersonController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFFFFF),
            title: Image.asset("images/Final-Ikyam-Logo.png"),
            // Set background color to white
            elevation: 2.0,
            shadowColor: const Color(0xFFFFFFFF),
            // Set shadow color to black
            actions: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Handle notification icon press
                  },
                ),
              ),
              SizedBox(width: 10,),
              Align(
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
            ],
          ),
          body:
          LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Stack(
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
                                  IconButton(
                                    icon:
                                    const Icon(Icons.arrow_back), // Back button icon
                                    onPressed: () {
                                      context.go(
                                          '/dasbaord/Orderspage/placeorder/arrowback');
                                      //  Navigator.push(
                                      //      context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => NextPage(product: , data: data2, inputText: '', subText: '')),
                                      // );
                                    },
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      'Create Order',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 950),
                                    child: OutlinedButton(
                                      onPressed: ()  {
                                        _onSaveChanges();
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
                                        'Save Changes',
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 43, left: 200),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10), // Space above/below the border
                            height: 2,
                            // width: 1000,
                            width: constraints.maxWidth,// Border height
                            color: Colors.grey[300], // Border color
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 1250, top: 80),
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
                                  width: 258,
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withOpacity(1), // Opacity is 1, fully opaque
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: data2['date'] != null
                                                  ? DateFormat('dd-MM-yyyy').format(
                                                  DateTime.parse(data2['date']))
                                                  : 'Select Date'),
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
                          padding: const EdgeInsets.only(left: 300,top: 200),
                          child: Container(
                            height:  350,
                            width: 1200,
                            // padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
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
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(left: 30,bottom: 5),
                                      child: Text(
                                        'Address',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right:360),
                                      child: Text(
                                        'Comments',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
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
                                const SizedBox(height: 5.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:  EdgeInsets.only(left: 30),
                                            child: Text('Select Delivery Location'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30),
                                            child: SizedBox(
                                              width: 350,
                                              child: DropdownButtonFormField<String>(
                                                value: widget.data['deliveryLocation'],
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    widget.data['deliveryLocation'] = value!;
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
                                          const SizedBox(height: 20.0),
                                          const Padding(
                                            padding:  EdgeInsets.only(left: 30),
                                            child: Text('Delivery Address'),
                                          ),
                                          const SizedBox(height: 10,),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30),
                                            child: SizedBox(
                                              width: 350,
                                              child: TextField(
                                                controller: _deliveryaddressController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: 'Address Details',
                                                ),
                                                maxLines: 3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Contact Person'),
                                          SizedBox(
                                            width: 350,
                                            child: TextField(
                                              controller:_contactPersonController,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintText: 'Contact Person Name',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          const Text('Contact Number'),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                            width: 350,
                                            child: TextField(
                                              controller: _contactNumberController,
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
                                                fillColor: Colors.grey[200],
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintText: 'Contact Person Number',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 250,
                                      width: 1,
                                      color: Colors.grey, // Vertical line at the start
                                      margin: EdgeInsets.zero, // Adjust margin if needed
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('    '),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: SizedBox(
                                              child: TextField(
                                                controller: _commentsController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: 'Enter your comments',
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
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 300, top: 200),
                        //       child: DecoratedBox(
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.grey, width: 10),
                        //           borderRadius: BorderRadius.circular(20),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 5,
                        //               offset: const Offset(0, 3),
                        //             ),
                        //           ],
                        //         ),
                        //         // Left container with multiple form fields
                        //         child: Container(
                        //           width: 798,
                        //           height: 500,
                        //           decoration: const BoxDecoration(
                        //             color: Colors.white,
                        //             // Border to emphasize split
                        //           ),
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 20),
                        //                 child: Text(
                        //                   'Delivery Location',
                        //                   style: TextStyle(
                        //                       fontSize: 20, fontWeight: FontWeight.bold),
                        //                 ),
                        //               ),
                        //               Container(
                        //                 margin: const EdgeInsets.symmetric(
                        //                     vertical: 10), // Space above/below the border
                        //                 height: 1, // Border height
                        //                 color: Colors.grey, // Border color
                        //               ),
                        //               Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   const Padding(
                        //                     padding: EdgeInsets.only(left: 30, top: 10),
                        //                     child: Text(
                        //                       'Address',
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     margin: const EdgeInsets.symmetric(
                        //                         vertical:
                        //                         10), // Space above/below the border
                        //                     height: 1, // Border height
                        //                     color: Colors.grey, // Border color
                        //                   ),
                        //                 ],
                        //               ),
                        //               // First row with "Name" and "Phone"
                        //               Padding(
                        //                 padding: const EdgeInsets.all(16),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child:
                        //                             Text('Select Delivery Location'),
                        //                           ),
                        //                           const SizedBox(
                        //                             height: 10,
                        //                           ),
                        //                           SizedBox(
                        //                             height: 50,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding:
                        //                               const EdgeInsets.only(left: 30),
                        //                               child: Container(
                        //                                 decoration: BoxDecoration(
                        //                                   border: Border.all(
                        //                                       color: Colors.grey,
                        //                                       width: 1),
                        //                                   borderRadius:
                        //                                   BorderRadius.circular(5),
                        //                                 ),
                        //                                 child: DropdownButton<String>(
                        //                                   value:
                        //                                   data2['deliveryLocation'],
                        //                                   icon: const Padding(
                        //                                     padding: EdgeInsets.only(
                        //                                         left: 210),
                        //                                     child: Icon(
                        //                                         Icons.arrow_drop_down),
                        //                                   ),
                        //                                   iconSize: 24,
                        //
                        //                                   elevation: 16,
                        //
                        //                                   style: const TextStyle(
                        //                                       color: Colors.black),
                        //                                   underline: Container(),
                        //                                   // We don't need the default underline since we're using a custom border
                        //                                   onChanged: (String? value) {
                        //                                     setState(() {
                        //                                       data2['deliveryLocation'] =
                        //                                       value!;
                        //                                     });
                        //                                   },
                        //                                   items: list.map<
                        //                                       DropdownMenuItem<
                        //                                           String>>(
                        //                                           (String value) {
                        //                                         return DropdownMenuItem<
                        //                                             String>(
                        //                                           value: value,
                        //                                           child: Text(value),
                        //                                         );
                        //                                       }).toList(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     const SizedBox(width: 32),
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Contact Name'),
                        //                           ),
                        //                           const SizedBox(
                        //                             height: 10,
                        //                           ),
                        //                           SizedBox(
                        //                             height: 50,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 controller: TextEditingController(
                        //                                     text: data2['ContactName']),
                        //                                 // controller: phoneController,
                        //                                 decoration: const InputDecoration(
                        //                                   hintText: 'Contact Person Name',
                        //                                   contentPadding:
                        //                                   EdgeInsets.all(8),
                        //                                   border: OutlineInputBorder(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               // Second row with "Address Line 1" and "Fax"
                        //               Padding(
                        //                   padding:
                        //                   const EdgeInsets.only(left: 14, bottom: 20),
                        //                   child: Row(
                        //                     children: [
                        //                       SizedBox(
                        //                         width: 367, // or any other width you want
                        //                         child: Column(
                        //                           crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                           children: [
                        //                             const Padding(
                        //                               padding: EdgeInsets.only(left: 30),
                        //                               child: Text('Delivery Address'),
                        //                             ),
                        //                             const SizedBox(height: 10),
                        //                             SizedBox(
                        //                               height: 200,
                        //                               child: Padding(
                        //                                 padding: const EdgeInsets.only(
                        //                                     bottom: 15, left: 30),
                        //                                 child: TextFormField(
                        //                                   controller:
                        //                                   TextEditingController(
                        //                                       text: data2['Address']),
                        //                                   //controller: commentsController,
                        //                                   decoration:
                        //                                   const InputDecoration(
                        //                                     border: OutlineInputBorder(),
                        //                                     contentPadding:
                        //                                     EdgeInsets.symmetric(
                        //                                       horizontal: 5,
                        //                                       vertical: 30,
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(width: 16),
                        //                       Row(
                        //                         children: [
                        //                           Padding(
                        //                             padding: const EdgeInsets.only(top:1.0,left:10.0),
                        //                             child: SizedBox(
                        //                               width: 380, // or any other width you want
                        //                               child: Column(
                        //                                 crossAxisAlignment:
                        //                                 CrossAxisAlignment.stretch,
                        //                                 children: [
                        //                                   const Padding(
                        //                                     padding: EdgeInsets.only(
                        //                                         left: 30, top: 10),
                        //                                     child: Text('Contact Number'),
                        //                                   ),
                        //                                   const SizedBox(height: 10),
                        //                                   SizedBox(
                        //                                     height: 50,
                        //                                     child: Padding(
                        //                                       padding: const EdgeInsets.only(
                        //                                           bottom: 15, left: 30),
                        //                                       child: TextFormField(
                        //                                         controller:
                        //                                         TextEditingController(
                        //                                             text: data2[
                        //                                             'ContactNumber']),
                        //                                         //controller: faxController,
                        //                                         decoration:
                        //                                         const InputDecoration(
                        //                                           hintText:
                        //                                           'Contact Person Number',
                        //                                           contentPadding:
                        //                                           EdgeInsets.all(8),
                        //                                           border: OutlineInputBorder(),
                        //                                         ),
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ],
                        //                   )),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 200,left: 300,right: 80),
                        //   child: Container(
                        //     height: 350,
                        //     // padding: EdgeInsets.all(16.0),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.blue),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 30,top: 10),
                        //           child: Text(
                        //             'Delivery Location',
                        //             style: TextStyle(
                        //               fontSize: 18.0,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //         Divider(color: Colors.grey),
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.only(left: 30,bottom: 5),
                        //               child: Text(
                        //                 'Address',
                        //                 style: TextStyle(
                        //                   fontSize: 18.0,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.only(right: 350,bottom: 5),
                        //               child: Text(
                        //                 'Comments',
                        //                 style: TextStyle(
                        //                   fontSize: 18.0,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         Divider(
                        //           color: Colors.grey,
                        //           thickness: 1.0,
                        //           height: 1.0,
                        //         ),
                        //         SizedBox(height: 5.0),
                        //         Row(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Expanded(
                        //               flex: 2,
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: Text('Select Delivery Location'),
                        //                   ),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: SizedBox(
                        //                       width: 350,
                        //                       child: DropdownButtonFormField<String>(
                        //                         value: data2['deliveryLocation'],
                        //                         decoration: InputDecoration(
                        //                           filled: true,
                        //                           fillColor: Colors.grey[200],
                        //                           border: OutlineInputBorder(
                        //                             borderRadius: BorderRadius.circular(5.0),
                        //                             borderSide: BorderSide.none,
                        //                           ),
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
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   SizedBox(height: 20.0),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: Text('Delivery Address'),
                        //                   ),
                        //                   SizedBox(height: 10,),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: SizedBox(
                        //                       width: 350,
                        //                       child: TextField(
                        //                         controller: TextEditingController(
                        //                             text: data2['Address']),
                        //                         decoration: InputDecoration(
                        //                           filled: true,
                        //                           fillColor: Colors.grey[200],
                        //                           border: OutlineInputBorder(
                        //                             borderRadius: BorderRadius.circular(5.0),
                        //                             borderSide: BorderSide.none,
                        //                           ),
                        //                           hintText: 'Address Details',
                        //                         ),
                        //                         maxLines: 3,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(width: 30.0),
                        //             Expanded(
                        //               flex: 3,
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text('Contact Person'),
                        //                   SizedBox(
                        //                     width: 350,
                        //                     child: TextField(
                        //                       controller: TextEditingController(
                        //                           text: data2['ContactName']),
                        //                       decoration: InputDecoration(
                        //                         filled: true,
                        //                         fillColor: Colors.grey[200],
                        //                         border: OutlineInputBorder(
                        //                           borderRadius: BorderRadius.circular(5.0),
                        //                           borderSide: BorderSide.none,
                        //                         ),
                        //                         hintText: 'Contact Person Name',
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   SizedBox(height: 20.0),
                        //                   Text('Contact Number'),
                        //                   SizedBox(height: 10,),
                        //                   SizedBox(
                        //                     width: 350,
                        //                     child: TextField(
                        //                       controller: TextEditingController(
                        //                           text: data2['ContactNumber']),
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
                        //                         hintText: 'Contact Person Number',
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             Container(
                        //               height: 237,
                        //               width: 1,
                        //               color: Colors.grey, // Vertical line at the start
                        //               margin: EdgeInsets.zero, // Adjust margin if needed
                        //             ),
                        //             SizedBox(width: 20.0),
                        //             Expanded(
                        //               flex: 3,
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text('    '),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(right: 10),
                        //                     child: SizedBox(
                        //                       child: TextField(
                        //                         controller: TextEditingController(
                        //                             text: data2['Comments']),
                        //                         decoration: InputDecoration(
                        //                           filled: true,
                        //                           fillColor: Colors.grey[200],
                        //                           border: OutlineInputBorder(
                        //                             borderRadius: BorderRadius.circular(5.0),
                        //                             borderSide: BorderSide.none,
                        //                           ),
                        //                           hintText: 'Enter your comments',
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
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 300, top: 200),
                        //       child: DecoratedBox(
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.grey, width: 10),
                        //           borderRadius: BorderRadius.circular(20),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 5,
                        //               offset: const Offset(0, 3),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Container(
                        //           width: 798,
                        //           height: 500,
                        //           decoration: const BoxDecoration(
                        //             color: Colors.white,
                        //           ),
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 20),
                        //                 child: Text(
                        //                   'Delivery Location',
                        //                   style: TextStyle(
                        //                       fontSize: 20, fontWeight: FontWeight.bold),
                        //                 ),
                        //               ),
                        //               const Divider(color: Colors.grey, height: 20),
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 10),
                        //                 child: Text('Address'),
                        //               ),
                        //               const Divider(color: Colors.grey, height: 20),
                        //               Padding(
                        //                 padding: const EdgeInsets.all(16),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text(
                        //                                 'Select Delivery Location'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 50,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   left: 30),
                        //                               child: Container(
                        //                                 decoration: BoxDecoration(
                        //                                   border: Border.all(
                        //                                       color: Colors.grey,
                        //                                       width: 1),
                        //                                   borderRadius: BorderRadius
                        //                                       .circular(5),
                        //                                 ),
                        //                                 child: DropdownButton<String>(
                        //                                   value: data2['deliveryLocation'],
                        //                                   icon: const Padding(
                        //                                     padding: EdgeInsets.only(
                        //                                         left: 210),
                        //                                     child: Icon(
                        //                                         Icons.arrow_drop_down),
                        //                                   ),
                        //                                   iconSize: 24,
                        //                                   elevation: 16,
                        //                                   style: const TextStyle(
                        //                                       color: Colors.black),
                        //                                   underline: Container(),
                        //                                   onChanged: (String? value) {
                        //                                     setState(() {
                        //                                       data2['deliveryLocation'] =
                        //                                       value!;
                        //                                     });
                        //                                   },
                        //                                   items: list.map<
                        //                                       DropdownMenuItem<String>>((
                        //                                       String value) {
                        //                                     return DropdownMenuItem<
                        //                                         String>(
                        //                                       value: value,
                        //                                       child: Text(value),
                        //                                     );
                        //                                   }).toList(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     const SizedBox(width: 32),
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Contact Name'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 70,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 controller: TextEditingController(
                        //                                     text: data2['ContactName']),
                        //                                 decoration: const InputDecoration(
                        //                                   hintText: 'Contact Person Name',
                        //                                   contentPadding: EdgeInsets.all(
                        //                                       8),
                        //                                   border: OutlineInputBorder(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Padding(
                        //                 padding: const EdgeInsets.all(16),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Delivery Address'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 150,
                        //                             // Increase the height here
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 maxLines: null,
                        //                                 // Allow the TextFormField to expand vertically
                        //                                 expands: true,
                        //                                 // Allow the TextFormField to expand vertically
                        //                                 controller: TextEditingController(
                        //                                     text: data2['Address']),
                        //                                 decoration: const InputDecoration(
                        //                                   border: OutlineInputBorder(),
                        //                                   contentPadding: EdgeInsets.all(
                        //                                       8),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     const SizedBox(width: 16),
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Contact Person'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 150,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 controller: TextEditingController(
                        //                                     text: data2['ContactNumber']),
                        //                                 decoration: const InputDecoration(
                        //                                   hintText: 'Contact Person Name',
                        //                                   contentPadding: EdgeInsets.all(
                        //                                       8),
                        //                                   border: OutlineInputBorder(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 1100, top: 200),
                        //   child: DecoratedBox(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.5),
                        //           spreadRadius: 2,
                        //           blurRadius: 5,
                        //           offset: const Offset(0, 3),
                        //         ),
                        //       ],
                        //     ),
                        //     child: Container(
                        //       width: 400,
                        //       height: 500,
                        //       decoration: const BoxDecoration(
                        //         color: Colors.white,
                        //         // Border to emphasize split
                        //       ),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Padding(
                        //             padding: EdgeInsets.only(left: 30, top: 20),
                        //             child: Text(
                        //               '',
                        //               style: TextStyle(
                        //                   fontSize: 20, fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //           Container(
                        //             margin: const EdgeInsets.symmetric(
                        //                 vertical: 10), // Space above/below the border
                        //             height: 1, // Border height
                        //             color: Colors.grey, // Border color
                        //           ),
                        //           Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 10),
                        //                 child: Text(
                        //                   'Comments',
                        //                 ),
                        //               ),
                        //               Container(
                        //                 margin: const EdgeInsets.symmetric(
                        //                     vertical: 10), // Space above/below the border
                        //                 height: 1, // Border height
                        //                 color: Colors.grey, // Border color
                        //               ),
                        //             ],
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.only(
                        //                 left: 20, top: 30, right: 20),
                        //             child: Row(
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Padding(
                        //                       padding: const EdgeInsets.only(bottom: 10),
                        //                       child: SizedBox(
                        //                         width: 350,
                        //                         height: 200,
                        //                         child: Padding(
                        //                           padding: const EdgeInsets.only(
                        //                             left: 10,
                        //                             top: 10,
                        //                             bottom: 10,
                        //                           ),
                        //                           child: TextFormField(
                        //                             controller: TextEditingController(
                        //                                 text: data2['Comments']),
                        //                             //controller: commentsController,
                        //                             decoration: const InputDecoration(
                        //                               border: OutlineInputBorder(),
                        //                               contentPadding:
                        //                               EdgeInsets.symmetric(
                        //                                 horizontal: 5,
                        //                                 vertical: 70,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [

                            Padding(

                              padding: const EdgeInsets.only(left: 350, top: 750,right: 20),

                              child: SizedBox(

                                width: 1200,

                                child: Card(

                                  color: Colors.white,

                                  child: Container(

                                    decoration: BoxDecoration(

                                      boxShadow: [

                                        BoxShadow(

                                          color: Colors.grey.withOpacity(0.5),

                                          spreadRadius: 2,

                                          blurRadius: 5,

                                          offset: const Offset(0, 3),

                                        ),

                                      ],

                                      color: Colors.white, // Container background color

                                      borderRadius: BorderRadius.circular(2),

                                    ),

                                    child: Column(

                                      mainAxisAlignment: MainAxisAlignment.start,

                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        const Padding(

                                          padding: EdgeInsets.only(left: 30, top: 10),

                                          child: Text(

                                            'Add Parts',

                                            style: TextStyle(

                                                fontSize: 20,

                                                fontWeight: FontWeight.bold,

                                                color: Colors.grey),

                                          ),

                                        ),

                                        SizedBox(height: 10,),

                                        DataTable(

                                            columns: [

                                              DataColumn(label: Text('SN')),

                                              DataColumn(label: Text('Product Name')),

                                              DataColumn(label: Text('Category')),

                                              DataColumn(label: Text('Subcategory')),

                                              DataColumn(label: Text('Price')),

                                              DataColumn(label: Text('Quantity')),

                                              DataColumn(label: Text('Total Amount')),

                                              DataColumn(label: Text('       ')),

                                            ],



                                            rows:
                                            widget.data['items']!= null
                                                ?
                                            List.generate(
                                              widget.data['items'].length,
                                                  (index) {
                                                Map<String, dynamic> item = widget.data['items'][index];
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text('Item ${index + 1}')),
                                                    DataCell(Text(item['productName'])),
                                                    DataCell(Text(item['category'])),
                                                    DataCell(Text(item['subCategory'])),
                                                    DataCell(Text(item['price'].toString())),
                                                    DataCell(Text(item['qty'].toString())),
                                                    DataCell(Text(item['totalAmount'].toString())),
                                                    DataCell(InkWell(
                                                      onTap: (){
                                                        _deleteProduct(index);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove_circle_outline,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                    )),
                                                  ],
                                                );
                                              },
                                            )
                                                : items != null
                                                ? List.generate(
                                              widget.data['items'].length,
                                                  (index) {
                                                Map<String, dynamic> item = widget.data['items'][index];
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text('Item ${index + 1}')),
                                                    DataCell(Text(item['productName'])),
                                                    DataCell(Text(item['category'])),
                                                    DataCell(Text(item['subCategory'])),
                                                    DataCell(Text(item['price'].toString())),
                                                    DataCell(Text(item['qty'].toString())),
                                                    DataCell(Text(item['totalAmount'].toString())),
                                                    DataCell(InkWell(
                                                      onTap: (){
                                                        _deleteProduct(index);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove_circle_outline,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                    )),
                                                  ],
                                                );
                                              },
                                            )

                                                :List.generate(
                                              items.length,
                                                  (index) {
                                                Map<String, dynamic> item = items[index];
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text('Item ${index + 1}')),
                                                    DataCell(Text(item['productName'])),
                                                    DataCell(Text(item['category'])),
                                                    DataCell(Text(item['subCategory'])),
                                                    DataCell(Text(item['price'].toString())),
                                                    DataCell(Text(item['qty'].toString())),
                                                    DataCell(Text(item['totalAmount'].toString())),
                                                    DataCell(InkWell(
                                                      onTap: () {
                                                        _deleteProduct(index);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove_circle_outline,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                    )),
                                                  ],
                                                );
                                              },
                                            )

                                        ),




                                        Padding(

                                          padding: const EdgeInsets.only(top: 10,),

                                          child: Container(

                                            // Space above/below the border

                                              height: 2, // Border height

                                              color: Colors.grey// Border color

                                          ),

                                        ),

                                        Padding(

                                          padding: const EdgeInsets.only(top: 8,left: 850,bottom: 10),

                                          child: Row(

                                            children: [

                                              SizedBox(width: 10), // add some space between the line and the text

                                              SizedBox(

                                                width: 220,

                                                child: Container(

                                                  decoration: BoxDecoration(

                                                    border: Border.all(color: Colors.blue),

                                                  ),

                                                  child: Padding(

                                                    padding: const EdgeInsets.only(

                                                      top: 10,

                                                      bottom: 10,

                                                      left: 5,

                                                      right: 5,

                                                    ),

                                                    child: RichText(

                                                      text: TextSpan(

                                                        children: [

                                                          const TextSpan(

                                                            text: '         ', // Add a space character

                                                            style: TextStyle(

                                                              fontSize: 10, // Set the font size to control the width of the gap

                                                            ),

                                                          ),

                                                          const TextSpan(

                                                            text: 'Total',

                                                            style: TextStyle(

                                                              fontWeight: FontWeight.bold,

                                                              color: Colors.blue,

                                                            ),

                                                          ),

                                                          const TextSpan(

                                                            text: '             ', // Add a space character

                                                            style: TextStyle(

                                                              fontSize: 10, // Set the font size to control the width of the gap

                                                            ),

                                                          ),

                                                          const TextSpan(

                                                            text: '₹',

                                                            style: TextStyle(

                                                              color: Colors.black,

                                                            ),

                                                          ),

                                                          TextSpan(

                                                            text: widget.data['total'],

                                                            style: const TextStyle(

                                                              color: Colors.black,

                                                            ),

                                                          )],

                                                      ),

                                                    ),

                                                  ),

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
                      ],
                    ),
                  ),
                );
              }
          )


      ),
    );
  }
}

