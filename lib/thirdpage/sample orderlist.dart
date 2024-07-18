// import 'package:flutter/material.dart';
//
//
//
// class MyOrderScreen extends StatefulWidget {
//   @override
//   _MyOrderScreenState createState() => _MyOrderScreenState();
// }
//
// class _MyOrderScreenState extends State<MyOrderScreen> {
//   List<Map<String, dynamic>> _orders = []; // Assuming this list is already populated
//   Map<String, dynamic> selectedOrder;
//   List<Map<String, dynamic>> selectedItems = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order List'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: _orders.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _showProductDetails(index);
//                     });
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: ListTile(
//                       title: Text('Order #${_orders[index]['orderId']}'),
//                       subtitle: Text('Order Date: ${_orders[index]['orderDate']}'),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey, width: 1),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 children: [
//                   Row(
//                     children: const [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Center(
//                           child: Text(
//                             "SN",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             'Product Name',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             "Category",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             "Sub Category",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             "Price",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             "QTY",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             "Total Amount",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   selectedItems.isNotEmpty
//                       ? Column(
//                     children: selectedItems.map((item) {
//                       int index = selectedItems.indexOf(item) + 1;
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8.0),
//                               child: Center(child: Text('$index')),
//                             ),
//                             Expanded(
//                               child: Center(child: Text(item['productName'])),
//                             ),
//                             Expanded(
//                               child: Center(child: Text(item['category'])),
//                             ),
//                             Expanded(
//                               child: Center(child: Text(item['subCategory'])),
//                             ),
//                             Expanded(
//                               child: Center(child: Text(item['price'].toString())),
//                             ),
//                             Expanded(
//                               child: Center(child: Text(item['qty'].toString())),
//                             ),
//                             Expanded(
//                               child: Center(child: Text(item['totalAmount'].toString())),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   )
//                       : Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('Select an order to view details'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showProductDetails(int index) {
//     final selectedOrder = _orders[index];
//     setState(() {
//       selectedItems = List<Map<String, dynamic>>.from(selectedOrder['items']);
//     });
//
//     print('Selected Order:');
//     print('Order ID: ${selectedOrder['orderId']}');
//     print('Order Date: ${selectedOrder['orderDate']}');
//     print('Contact Person: ${selectedOrder['contactPerson']}');
//     print('Delivery Location: ${selectedOrder['deliveryLocation']}');
//     print('total: ${selectedOrder['total']}');
//
//     for (var item in selectedItems) {
//       print('Product Name: ${item['productName']}');
//       print('Price: ${item['price']}');
//       print('Quantity: ${item['qty']}');
//       print('Category: ${item['category']}');
//       print('Sub Category: ${item['subCategory']}');
//       print('Total Amount: ${item['totalAmount']}');
//       print('------------------------');
//     }
//   }
// }
