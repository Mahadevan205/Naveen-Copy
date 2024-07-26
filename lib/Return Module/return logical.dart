// // import 'dart:html';
// //
// // //import 'package:btb/return%20sprint/uplod%20image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// // void main() => runApp(const MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       title: 'Order Details',
// //       home: MyCustomForm(),
// //     );
// //   }
// // }
// //
// // class MyCustomForm extends StatefulWidget {
// //   const MyCustomForm({super.key});
// //
// //   @override
// //   State<MyCustomForm> createState() => _MyCustomFormState();
// // }
// //
// // class _MyCustomFormState extends State<MyCustomForm> {
// //   final _controller = TextEditingController();
// //   List<dynamic> _orderDetails = [];
// //   List<dynamic> _items1 = [];
// //   String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkaGFuYXNla2FyIiwiUm9sZXMiOlt7ImF1dGhvcml0eSI6ImRldmVsb3BlciJ9XSwiZXhwIjoxNzIxNjMwNDQ5LCJpYXQiOjE3MjE2MjMyNDl9.xLgmiyPCmi2spO9JrevsL--RWUPlpoThuK_v1tuaD8tqr-vb1uPMSlRgqvQHIXDBzN57kfZNhvvyTHKdWtUqqA';
// //
// //   Future<void> _fetchOrderDetails() async {
// //     final orderId = _controller.text
// //         .trim(); // trim to remove whitespace
// //     final url = orderId.isEmpty
// //         ? 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster/'
// //         : 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';
// //     final response = await http.get(
// //       Uri.parse(url),
// //       headers: {
// //         'Authorization': 'Bearer $token', // Replace with your API key
// //         'Content-Type': 'application/json',
// //       },
// //     );
// //
// //     // final response = await http.get(
// //     //   Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster'),
// //     //   headers: {
// //     //     'Authorization': 'Bearer $token', // Replace with your actual token
// //     //   },
// //     // );
// //
// //     if (response.statusCode == 200) {
// //       final jsonData = jsonDecode(response.body);
// //       print('res');
// //       print(jsonData);
// //       final orderId = _controller.text;
// //       print(orderId);
// //       final orderData = jsonData.firstWhere((order) => order['orderId'] == orderId);
// //       if (orderData != null) {
// //         setState(() {
// //           // _orderDetails = 'Order ID: ${orderData['orderId']}\n'
// //           //    // 'Order Date: ${orderData['orderDate']}\n'
// //           //   //  'Delivery Location: ${orderData['deliveryLocation']}\n'
// //           //    // 'Delivery Address: ${orderData['deliveryAddress']}\n'
// //           //     //'Contact Person: ${orderData['contactPerson']}\n'
// //           //   //  'Contact Number: ${orderData['contactNumber']}\n'
// //           //    // 'Comments: ${orderData['comments']}\n'
// //           //    // 'Total: ${orderData['total']}\n'
// //           //     'Items:\n';
// //           for (var item in orderData['items']) {
// //             _orderDetails += [' (Qty: ${item['qty']}, Productname: ${item['productName']} Total: ${item['totalAmount']},price: ${item['price']},category: ${item['category']} subcategory: ${item['subCategory']})\n'];
// //           }
// //         });
// //       }else {
// //         setState(() {
// //           _orderDetails = ['not found'];
// //         });
// //       }
// //     } else {
// //       setState(() {
// //         _orderDetails = ['Error fetching order details'];
// //       });
// //     }
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Order Details'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             TextField(
// //               controller: _controller,
// //               onEditingComplete: _fetchOrderDetails,
// //               decoration: const InputDecoration(
// //                 labelText: 'Enter order ID (e.g. ORD_01956)',
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: (){
// //                 print('--------');
// //                 print(_orderDetails);
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => NextPage(_orderDetails)),
// //                 );
// //               },
// //               child: const Text('Get Order Details'),
// //             ),
// //             Text('${_orderDetails}'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // class NextPage extends StatefulWidget {
// //     final List<dynamic> orderDetails;
// //
// //     const NextPage(this.orderDetails, {super.key});
// //
// //     @override
// //     State<NextPage> createState() => _NextPageState();
// //   }
// //
// // class _NextPageState extends State<NextPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Next Page'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Container(
// //               width: 300,
// //               height: 300,
// //               decoration: BoxDecoration(
// //                 border: Border.all(),
// //               ),
// //               child: const Center(
// //                 child: Text('Image will be displayed here'),
// //               ),
// //             ),
// //             ListView.builder(
// //               shrinkWrap: true,
// //               itemCount: widget.orderDetails.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text(widget.orderDetails[index]['productName']),
// //                   onTap: () {
// //                     // Handle the tap event here
// //                     print('Tapped on ${widget.orderDetails[index]['productName']}');
// //                   },
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:btb/Return%20Module/return%20image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class MyCustomForm extends StatefulWidget {
//   const MyCustomForm({super.key});
//
//   @override
//   State<MyCustomForm> createState() => _MyCustomFormState();
// }
//
// class _MyCustomFormState extends State<MyCustomForm> {
//   final _controller = TextEditingController();
//   List<dynamic> _orderDetails = [];
//   String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkaGFuYXNla2FyIiwiUm9sZXMiOlt7ImF1dGhvcml0eSI6ImRldmVsb3BlciJ9XSwiZXhwIjoxNzIxNzEyMDE2LCJpYXQiOjE3MjE3MDQ4MTZ9.KAiHZG4xRDm6Md-admrs6SHmwnbt_k4Ij5FDw6CchZHr2HX074dp5eboQCXtzkNPO98AUn7nnBUYEcaDsa5x7Q';
//
//   Future<void> _fetchOrderDetails() async {
//     final orderId = _controller.text.trim();
//     final url = orderId.isEmpty
//         ? 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster/'
//         : 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';
//
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       print('Response: $jsonData');
//       final orderData = jsonData.firstWhere(
//               (order) => order['orderId'] == orderId, orElse: () => null);
//
//       if (orderData != null) {
//         setState(() {
//           _orderDetails = orderData['items'].map((item) => {
//             'productName': item['productName'],
//             'qty': item['qty'],
//             'totalAmount': item['totalAmount'],
//             'price': item['price'],
//             'category': item['category'],
//             'subCategory': item['subCategory']
//           }).toList();
//         });
//       } else {
//         setState(() {
//           _orderDetails = [{'productName': 'not found'}];
//         });
//       }
//     } else {
//       setState(() {
//         _orderDetails = [{'productName': 'Error fetching order details'}];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               onEditingComplete: _fetchOrderDetails,
//               decoration: const InputDecoration(
//                 labelText: 'Enter order ID (e.g. ORD_01956)',
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NextPage(_orderDetails)),
//                 );
//               },
//               child: const Text('Get Order Details'),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _orderDetails.length,
//                 itemBuilder: (context, index) {
//                   final item = _orderDetails[index];
//                   return ListTile(
//                     title: Text(item['productName'] ?? 'Unknown Product'),
//                     subtitle: Text(
//                         'Qty: ${item['qty']}, Total: ${item['totalAmount']}, Price: ${item['price']}'),
//                     onTap: () {
//                       print('Tapped on ${item['productName']}');
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NextpageAPI extends StatefulWidget {
//   const NextpageAPI({super.key});
//
//   @override
//   State<NextpageAPI> createState() => _NextpageAPIState();
// }
//
// class _NextpageAPIState extends State<NextpageAPI> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(
//         'using api to show details'
//       ),),
//
//     );
//   }
// }
//
//
// //     Padding(
// //       padding: const EdgeInsets.only(top: 80,right: 500,left: 500),
// //       child: Column(
// //         children: [
// //                           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: <Widget>[
// //                   Container(
// //
// //                     width: size.width * 0.4, // Adjust width based on screen size
// //                     height: size.width * 0.3, // Adjust height based on screen size
// //
// //                     decoration: BoxDecoration(
// //                       border: Border.all(color: Colors.grey),
// //                       borderRadius: BorderRadius.circular(8.0),
// //                     ),
// //                     child: Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                             Icons.cloud_upload,
// //                             size: size.width * 0.1, // Adjust icon size based on screen size
// //                             color: Colors.blue,
// //                           ),
// //                           SizedBox(height: 16.0),
// //                           Text(
// //                             'Click to upload image',
// //                             style: TextStyle(fontSize: size.width * 0.01), // Adjust font size based on screen size
// //                           ),
// //                           Text(
// //                             'SVG, PNG, JPG, or GIF\nRecommended size (1000px * 1248px)',
// //                             textAlign: TextAlign.center,
// //                             style: TextStyle(fontSize: size.width * 0.010), // Adjust font size based on screen size
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //           SizedBox(height: 40,),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text('Select Product'),
// //               SizedBox(height: 40,
// //               child: DropdownButtonFormField(
// //                 decoration: InputDecoration(
// //                   filled: true,
// //                   fillColor: Colors.grey.shade200,
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(5.0),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   hintText: 'Reason For Return',
// //                 ),
// //                 value: _selectedProduct,
// //                 onChanged: (newValue) {
// //                   setState(() {
// //                     _selectedProduct = newValue as String?;
// //                   });
// //                 },
// //                 items: widget.orderDetails.map((item) {
// //                   return DropdownMenuItem(
// //                     value: item['productName'],
// //                     child: Text(item['productName'] ?? 'Unknown Product'),
// //                   );
// //                 }).toList(),
// //                // underline: null,
// //                 isExpanded: true,
// //               ),
// //               )
// //             ],
// //           )
// //
// //
// //         ],
// //       ),
// //     )
// //       )
// //   ],
// // )
// //     )
//
//
//
// void main() => runApp(MaterialApp(home: MyCustomForm()));
