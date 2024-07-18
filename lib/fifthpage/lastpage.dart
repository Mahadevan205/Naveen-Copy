// import 'dart:convert';
// import 'dart:html';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(SearchList());
// }
//
// class SearchList extends StatefulWidget {
//   const SearchList({super.key});
//
//   @override
//   State<SearchList> createState() => _SearchListState();
// }
//
// class _SearchListState extends State<SearchList> {
//   String token = window.sessionStorage["token"] ?? " ";
//   final orderId = TextEditingController();
//   final TextEditingController addressLine1Controller = TextEditingController();
//   final TextEditingController addressLine2Controller = TextEditingController();
//   final TextEditingController availableController = TextEditingController();
//   final TextEditingController faxController = TextEditingController();
//   final TextEditingController supplierController = TextEditingController();
//   final TextEditingController outstandingController = TextEditingController();
//   final TextEditingController telController = TextEditingController();
//   final TextEditingController typeController = TextEditingController();
//   final TextEditingController commentsController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController creditLimitController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();
//   final TextEditingController totalAmountController = TextEditingController();
//   final TextEditingController invoiceNoController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//   final TextEditingController taxController = TextEditingController();
//   final TextEditingController descriptionContoller = TextEditingController();
//   final TextEditingController partController = TextEditingController();
//   final TextEditingController qtyController = TextEditingController();
//   final TextEditingController rateController = TextEditingController();
//   final TextEditingController snoController = TextEditingController();
//   final TextEditingController uomContoller = TextEditingController();
//   final TextEditingController glgroupContoller = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   String searchText = '';
//   List<Create> searchList = [];
//   Future<void> fetchData(String orderId, String supplier) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId'),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer ${token}'
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('----------------');
//         final responseBody = response.body;
//         if (responseBody != null) {
//           final jsonData = jsonDecode(responseBody);
//           print(responseBody);
//           if (jsonData != null) {
//             if (jsonData is List) {
//               final List<dynamic> jsonDataList = jsonData;
//               if (jsonDataList != null) {
//                 final List<Create> products = jsonDataList
//                     .map<Create>((item) => Create.fromJson(item))
//                     .toList();
//
//                 setState(() {
//                   searchList = products;
//                   print('------inside Search Product Item--------');
//                   print(jsonData);
//                 });
//               } else {
//                 setState(() {
//                   searchList = []; // Initialize with an empty list
//                 });
//               }
//             } else if (jsonData is Map) {
//               final List<dynamic>? jsonDataList = jsonData['body'];
//               if (jsonDataList != null) {
//                 final List<Create> products = jsonDataList
//                     .map<Create>((item) => Create.fromJson(item))
//                     .toList();
//
//                 setState(() {
//                   searchList = products;
//                 });
//               } else {
//                 setState(() {
//                   searchList = []; // Initialize with an empty list
//                 });
//               }
//             } else {
//               setState(() {
//                 searchList = []; // Initialize with an empty list
//               });
//             }
//           } else {
//             setState(() {
//               searchList = []; // Initialize with an empty list
//             });
//           }
//         } else {
//           setState(() {
//             searchList = []; // Initialize with an empty list
//           });
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//   }
//
//   Future<void> _newData() async {
//     print('Token: $token');
//     if (searchText.isNotEmpty) {
//       await fetchData(searchText, 'supplier');
//     } else {
//       setState(() {
//         searchList = [];
//       });
//     }
//   }
//
//   void searchSelect(String orderId) async {
//     // print(token);
//     try {
//       // Make an HTTP request to fetch data from the API
//       final response = await http.get(
//         Uri.parse(
//             'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId'),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer ${token}'
//         },
//       );
//
//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         //print(token);
//         // Parse the response body
//         final jsonData = jsonDecode(response.body);
//         // Convert the JSON data into a list of Product objects
//         final List<Create> products =
//             jsonData.map<Create>((item) => Create.fromJson(item)).toList();
//         // Update the state to reflect the fetched products
//         setState(() {
//           searchList = products;
//         });
//       } else {
//         // Handle error if the request was not successful
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       // Handle any errors that occur during the process
//       print('Error: $error');
//     }
//     // void imageCorrect(String filename) async {
//     //   try {
//     //     // Make an HTTP request to fetch data from the API
//     //     final response = await http.get(
//     //       Uri.parse(
//     //           'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/view/image1.png'),
//     //       headers: {
//     //         "Content-Type": "application/json",
//     //         'Authorization': 'Bearer ${token}'
//     //       },
//     //     );
//     //     // Check if the request was successful
//     //     if (response.statusCode == 200) {
//     //       //print(token);
//     //       // Parse the response body
//     //       final jsonData = jsonDecode(response.body);
//     //       // Convert the JSON data into a list of Product objects
//     //       final List<Product> products =
//     //           jsonData.map<Product>((item) => Product.fromJson(item)).toList();
//     //       // Update the state to reflect the fetched products
//     //       setState(() {
//     //         productList = products;
//     //       });
//     //     } else {
//     //       // Handle error if the request was not successful
//     //       throw Exception('Failed to load data');
//     //     }
//     //   } catch (error) {
//     //     // Handle any errors that occur during the process
//     //     print('Error: $error');
//     //   }
//     // }
//   }
//
//   double _calculateTotalAmount() {
//     return widget.selectedProducts.fold(
//       0,
//       (previousValue, product) =>
//           previousValue +
//           (product.price * product.quantity) +
//           (product.taxAmount ?? 0) +
//           (product.amount ?? 0),
//     );
//   }
//
//   double _calculateAmount() {
//     return widget.selectedProducts.fold(
//       0,
//       (previousValue, product) =>
//           previousValue +
//           (product.price * product.quantity) +
//           (product.taxAmount ?? 0) +
//           (product.amount ?? 0),
//     );
//   }
//
//   double _calculateTotalTax() {
//     return widget.selectedProducts.fold(
//       0,
//       (previousValue, product) =>
//           previousValue +
//           (product.price * product.quantity) * (product.taxRate / 100),
//     );
//     // double totalTax = 0;
//     // for (Product product in widget.selectedProducts) {
//     //   double price = product.price;
//     //   double quantity = product.quantity.toDouble();
//     //   double taxRate = double.tryParse(product.tax) ?? 0;
//     //
//     //   if (price != null && quantity != null && taxRate != null) {
//     //     totalTax += (price * quantity) * (taxRate / 100);
//     //   } else {
//     //     print(
//     //         'Invalid value encountered: price=$price, quantity=$quantity, taxRate=$taxRate');
//     //   }
//     // }
//     // return totalTax;
//   }
//
//   void handleTextFormFieldTap() async {
//     String orderId = 'orderId';
//     String supplier = 'supplier';
//     await fetchData(orderId, supplier);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: Colors.white,
//           actions: [
//             IconButton(
//               icon: Icon(Icons.notifications),
//               onPressed: () {
//                 // Handle notification icon press
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.account_circle),
//               onPressed: () {
//                 // Handle user icon press
//               },
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
//                   padding: EdgeInsets.only(left: 20, top: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.dashboard, color: Colors.blue[900]),
//                         label: Text('Home'),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.warehouse_outlined,
//                             color: Colors.blue[900]),
//                         label: Text('Orders'),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.fire_truck_outlined,
//                             color: Colors.blue[900]),
//                         label: Text('Delivery'),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.document_scanner_rounded,
//                             color: Colors.blue[900]),
//                         label: Text('Invoice'),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.payment_outlined,
//                             color: Colors.blue[900]),
//                         label: Text('Payment'),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.backspace_sharp,
//                             color: Colors.blue[900]),
//                         label: Text('Return'),
//                       ),
//                       SizedBox(height: 20),
//                       TextButton.icon(
//                         onPressed: () {},
//                         icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
//                         label: Text('Reports'),
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
//                   padding: const EdgeInsets.only(left: 170),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     color: Colors.white,
//                     child: Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.arrow_back), // Back button icon
//                           onPressed: () {
//                             // Implement back button action
//                           },
//                         ),
//                         Text(
//                           'Parts Order List',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 30),
//                           child: OutlinedButton(
//                             onPressed: () {},
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.blueAccent, // Button background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(5), // Rounded corners
//                               ),
//                               side: BorderSide.none, // No outline
//                             ),
//                             child: Text(
//                               '+ Vehicle order',
//                               style: TextStyle(
//                                 fontSize: 12,
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
//               Container(
//                 margin: EdgeInsets.only(
//                   top: 40,
//                   left: 200,
//                 ),
//                 width: 300,
//                 height: 1750,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(),
//                           hintText: 'Search Product',
//                           prefix: Padding(
//                             padding: const EdgeInsets.only(
//                               bottom: 5,
//                               left: 1,
//                             ),
//                             child: Icon(
//                               Icons.search_rounded,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 9,
//                             vertical: 15,
//                           ),
//                         ),
//                         onChanged: (value) {
//                           token = window.sessionStorage["token"] ?? " ";
//                           setState(() {
//                             searchText = value;
//                           });
//                           _newData();
//                           print(orderId);
//                           // setState(() {
//                           //   searchText = value; // Update searchText
//                           // });
//                           // fetchData(searchText, "category"); // Fetch data
//                         },
//                       ),
//                     ),
//                     Container(
//                       height: 1780, // set the height of the container
//                       decoration: BoxDecoration(
//                         color: Colors
//                             .white, // set the background color to a light grey
//                         border: Border.all(
//                             color: Colors
//                                 .grey), // set the border color to a darker grey
//                         borderRadius: BorderRadius.circular(
//                             5), // round the corners of the container
//                       ),
//                       child: ListView.builder(
//                         itemCount: searchList.length,
//                         itemBuilder: (context, index) {
//                           final Create = searchList[index];
//                           print('---------index----------');
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 addressLine2Controller.text =
//                                     Create.addressLine2;
//                                 addressLine1Controller.text =
//                                     Create.addressLine1;
//                                 availableController.text =
//                                     Create.availableCredit.toString();
//                                 faxController.text = Create.fax.toString();
//                                 supplierController.text = Create.supplier;
//                                 outstandingController.text =
//                                     Create.outstandingAmount.toString();
//                                 commentsController.text = Create.comments;
//                                 creditLimitController.text =
//                                     Create.creditLimit.toString();
//                                 telController.text = Create.tel.toString();
//                                 glgroupContoller.text = Create.glGroup;
//                                 typeController.text = Create.type;
//                                 nameController.text = Create.name;
//                                 phoneController.text = Create.phone.toString();
//                                 outstandingController.text =
//                                     Create.outstandingAmount.toString();
//                                 dateController.text = Create.orderDate;
//                                 // notesController.text = Create.notes;
//                                 // totalAmountController.text = Create.totalAmount;
//                                 // amountController.text = Create.amount;
//                                 // taxController.text = Create.tax;
//
//                                 // final TextEditingController qtyController = TextEditingController();
//                                 // final TextEditingController rateController = TextEditingController();
//                                 // final TextEditingController snoController = TextEditingController();
//                                 // final TextEditingController uomContoller = TextEditingController();
//                                 // imageIdContoller.text = Product.imageId;
//                                 // fetchImage(productList[index].imageId);
//                               });
//
//                               // print(
//                               //   'Product Name: ${Product.productName},  Category: ${Product.category}, subCategory: ${Product.subCategory}, unit : ${Product.unit}, tax: ${Product.tax}, discount : ${Product.discount}, price: ${Product.price}');
//                             },
//                             child: Container(
//                               margin: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border.all(color: Colors.grey),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: ListTile(
//                                 title: Text('OrderId # ${Create.orderId}'),
//                                 subtitle: Text('Category: ${Create.supplier}'),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Expanded(
//               //   child: productList.isEmpty
//               //       ? Center(
//               //     child: Text('No products found'),
//               //   )
//               //       : ListView.builder(
//               //     itemCount: productList.length,
//               //     itemBuilder: (context, index) {
//               //       return ListTile(
//               //         title: Text(
//               //             'Product ID: ${productList[index].productId}'),
//               //         subtitle: Text(
//               //             'Category: ${productList[index].category}'),
//               //       );
//               //     },
//               //   ),
//               // ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 600, top: 100),
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
//                         height: 100,
//                         width: 1400,
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white, // Container background color
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment
//                                   .spaceBetween, // Spacing between elements
//                               children: [
//                                 // First Field and TextFormField
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(bottom: 15),
//                                       child: Text(
//                                         'Supplier',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 30,
//                                       width: 350,
//                                       child: TextFormField(
//                                         controller: supplierController,
//                                         decoration: InputDecoration(
//                                           hintText: '',
//                                           contentPadding: EdgeInsets.all(8),
//                                           border: InputBorder.none,
//                                           enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Change this color to adjust the bottom border color
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ), // Second Field and TextFormField
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(bottom: 15),
//                                       child: Text(
//                                         'Order Group',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 30,
//                                       width: 150,
//                                       child: TextFormField(
//                                         controller: typeController,
//                                         decoration: InputDecoration(
//                                           hintText: '',
//                                           contentPadding: EdgeInsets.all(8),
//                                           border: InputBorder.none,
//                                           enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Change this color to adjust the bottom border color
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//
//                                 // Text and Dropdown
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(bottom: 15),
//                                       child: Text(
//                                         'GL Group',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 30,
//                                       width: 150,
//                                       child: TextFormField(
//                                         controller: glgroupContoller,
//                                         decoration: InputDecoration(
//                                           hintText: '',
//                                           contentPadding: EdgeInsets.all(8),
//                                           border: InputBorder.none,
//                                           enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Change this color to adjust the bottom border color
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 // Text and Date Field
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(bottom: 15),
//                                       child: Text(
//                                         'Date',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 30,
//                                       width: 150,
//                                       child: TextFormField(
//                                         controller: dateController,
//                                         decoration: InputDecoration(
//                                           hintText: '',
//                                           contentPadding: EdgeInsets.all(8),
//                                           border: InputBorder.none,
//                                           enabledBorder: UnderlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors
//                                                     .white), // Change this color to adjust the bottom border color
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
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
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 600, top: 250),
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
//                         width: 1000,
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
//                                 'Invoicing Details',
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
//                                       const EdgeInsets.only(left: 30, top: 10),
//                                   child: Text(
//                                     'Address',
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: const EdgeInsets.symmetric(
//                                       vertical:
//                                           10), // Space above/below the border
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
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 30),
//                                           child: Text(
//                                             'Name',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
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
//                                               controller: nameController,
//                                               decoration: InputDecoration(
//                                                 hintText: '',
//                                                 contentPadding:
//                                                     EdgeInsets.all(8),
//                                                 border: InputBorder.none,
//                                                 enabledBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .white), // Change this color to adjust the bottom border color
//                                                 ),
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
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 30),
//                                           child: Text(
//                                             'Phone',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
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
//                                               controller: phoneController,
//                                               decoration: InputDecoration(
//                                                 hintText: '',
//                                                 contentPadding:
//                                                     EdgeInsets.all(8),
//                                                 border: InputBorder.none,
//                                                 enabledBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .white), // Change this color to adjust the bottom border color
//                                                 ),
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
//                               padding:
//                                   const EdgeInsets.only(left: 14, bottom: 20),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 30),
//                                           child: Text(
//                                             'Address Line 1',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
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
//                                               controller:
//                                                   addressLine1Controller,
//                                               decoration: InputDecoration(
//                                                 hintText: '',
//                                                 contentPadding:
//                                                     EdgeInsets.all(8),
//                                                 border: InputBorder.none,
//                                                 enabledBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .white), // Change this color to adjust the bottom border color
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 30),
//                                           child: Text(
//                                             'Fax',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
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
//                                               controller: faxController,
//                                               decoration: InputDecoration(
//                                                 hintText: '',
//                                                 contentPadding:
//                                                     EdgeInsets.all(8),
//                                                 border: InputBorder.none,
//                                                 enabledBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .white), // Change this color to adjust the bottom border color
//                                                 ),
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
//
//                             // Third row with "Address Line 2" and "Tel"
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 14, bottom: 20),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 30),
//                                           child: Text(
//                                             'Address Line 2',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
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
//                                               controller:
//                                                   addressLine2Controller,
//                                               decoration: InputDecoration(
//                                                 hintText: '',
//                                                 contentPadding:
//                                                     EdgeInsets.all(8),
//                                                 border: InputBorder.none,
//                                                 enabledBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .white), // Change this color to adjust the bottom border color
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 30),
//                                           child: Text(
//                                             'Tel',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
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
//                                               controller: telController,
//                                               decoration: InputDecoration(
//                                                 hintText: '',
//                                                 contentPadding:
//                                                     EdgeInsets.all(8),
//                                                 border: InputBorder.none,
//                                                 enabledBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors
//                                                           .white), // Change this color to adjust the bottom border color
//                                                 ),
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
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 1601, top: 250),
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
//                                 'Comment',
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
//                                           controller: commentsController,
//                                           decoration: InputDecoration(
//                                             hintText: '',
//                                             contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                     horizontal: 5,
//                                                     vertical: 70),
//                                             border: InputBorder.none,
//                                             enabledBorder: UnderlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: Colors
//                                                       .white), // Change this color to adjust the bottom border color
//                                             ),
//                                           ),
//                                         ),
//                                         // TextFormField(
//                                         //   controller: commentsController,
//                                         //   decoration: InputDecoration(
//                                         //     border: OutlineInputBorder(),
//                                         //     contentPadding:
//                                         //         EdgeInsets.symmetric(
//                                         //       horizontal: 5,
//                                         //       vertical: 70,
//                                         //     ),
//                                         //   ),
//                                         // ),
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
//                     padding: const EdgeInsets.only(left: 600, top: 800),
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
//                         height: 100,
//                         width: 1400,
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white, // Container background color
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment
//                               .spaceBetween, // Spacing between elements
//                           children: [
//                             // First Field and TextFormField
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   child: Text(
//                                     'Credit Limit',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                   width: 350,
//                                   child: TextFormField(
//                                     controller: creditLimitController,
//                                     decoration: InputDecoration(
//                                       hintText: '',
//                                       contentPadding: EdgeInsets.all(8),
//                                       border: InputBorder.none,
//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors
//                                                 .white), // Change this color to adjust the bottom border color
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 5),
//                                   child: Text(
//                                     'Outstanding',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                   width: 350,
//                                   child: TextFormField(
//                                     controller: outstandingController,
//                                     decoration: InputDecoration(
//                                       hintText: '',
//                                       contentPadding: EdgeInsets.all(8),
//                                       border: InputBorder.none,
//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors
//                                                 .white), // Change this color to adjust the bottom border color
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 15),
//                                   child: Text(
//                                     'Available',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                   width: 350,
//                                   child: TextFormField(
//                                     controller: availableController,
//                                     decoration: InputDecoration(
//                                       hintText: '',
//                                       contentPadding: EdgeInsets.all(8),
//                                       border: InputBorder.none,
//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors
//                                                 .white), // Change this color to adjust the bottom border color
//                                       ),
//                                     ),
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
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 300, top: 950),
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
//                         width: 1400,
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
//                             Container(
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 10), // Space above/below the border
//                               height: 1, // Border height
//                               color: Colors.grey, // Border color
//                             ),
//                             Container(
//                               constraints: BoxConstraints(
//                                 maxHeight: MediaQuery.of(context).size.height -
//                                     500, // Adjust this value as needed
//                               ),
//                               child: SingleChildScrollView(
//                                 child: Table(
//                                   border: TableBorder.all(
//                                     color: Colors.grey,
//                                     width: 2.0,
//                                   ),
//                                   columnWidths: {
//                                     0: FlexColumnWidth(0.5),
//                                     1: FlexColumnWidth(4),
//                                     2: FlexColumnWidth(1),
//                                     3: FlexColumnWidth(1),
//                                     4: FlexColumnWidth(1),
//                                     5: FlexColumnWidth(1),
//                                     6: FlexColumnWidth(1),
//                                     7: FlexColumnWidth(1),
//                                     // Add more columns here for other product properties
//                                   },
//                                   children: [
//                                     TableRow(
//                                       children: [
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the first column to 50
//                                             child: Center(
//                                               child: Text(
//                                                 'SN',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .center, // set the alignment of the text to center
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the second column to 50
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 10, top: 15),
//                                               child: Text(
//                                                 'Description',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .left, // set the alignment of the text to left
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the third column to 50
//                                             child: Center(
//                                               child: Text(
//                                                 'Part #',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .right, // set the alignment of the text to right
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the fourth column to 50
//                                             child: Center(
//                                               child: Text(
//                                                 'UOM',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .center, // set the alignment of the text to center
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the fifth column to 50
//                                             child: Center(
//                                               child: Text(
//                                                 'QTY',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .center, // set the alignment of the text to center
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the sixth column to 50
//                                             child: Center(
//                                               child: Text(
//                                                 'Rate',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .center, // set the alignment of the text to center
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the seventh column to 50
//                                             child: Center(
//                                               child: Text(
//                                                 'Amount',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .center, // set the alignment of the text to center
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TableCell(
//                                           child: SizedBox(
//                                             height: 50,
//                                             // set the height of the first cell in the seventh column to 50
//                                             child: Center(
//                                               child: Text(
//                                                 'Edit',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                                 textAlign: TextAlign
//                                                     .center, // set the alignment of the text to center
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     ...widget.selectedProducts
//                                         .asMap()
//                                         .entries
//                                         .map((entry) {
//                                       int index = entry.key;
//                                       Product product = entry.value;
//                                       return TableRow(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 8),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 // set the height of the second cell in the first column to 30
//                                                 child: Center(
//                                                   child: Text(
//                                                       (index + 1).toString(),
//                                                       textAlign:
//                                                           TextAlign.center),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 8),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 // set the height of the second cell in the second column to 30
//                                                 child: Center(
//                                                   child: Text(
//                                                       product.productName,
//                                                       textAlign:
//                                                           TextAlign.center),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 8),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 // set the height of the second cell in the first column to 30
//                                                 child: Center(
//                                                   child: Text(product.category,
//                                                       textAlign:
//                                                           TextAlign.center),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 8),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 // set the height of the second cell in the first column to 30
//                                                 child: Center(
//                                                   child: Text(
//                                                       product.selectedUOM,
//                                                       textAlign:
//                                                           TextAlign.center),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 8),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 // set the height of the second cell in the first column to 30
//                                                 child: Center(
//                                                   child: Text(
//                                                       product.quantity
//                                                           .toString(),
//                                                       textAlign:
//                                                           TextAlign.center),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 8),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 // set the height of the second cell in the first column to 30
//                                                 child: Center(
//                                                   child: Text(
//                                                       product.price
//                                                           .toStringAsFixed(2),
//                                                       textAlign:
//                                                           TextAlign.center),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 5, vertical: 8),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 child: Center(
//                                                   child: Text(
//                                                     '${product.price * product.quantity}',
//                                                     // Calculate rate * quantity
//                                                     textAlign: TextAlign.center,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 6),
//                                             child: TableCell(
//                                               child: SizedBox(
//                                                 height: 50,
//                                                 // set the height of the first cell in the seventh column to 50
//                                                 child: Center(
//                                                   child: Container(
//                                                     decoration: BoxDecoration(
//                                                       color: Colors.red,
//                                                       shape: BoxShape.circle,
//                                                     ),
//                                                     child: IconButton(
//                                                       onPressed: () {
//                                                         _deleteProduct(product);
//                                                       },
//                                                       icon: Icon(
//                                                         Icons.delete,
//                                                         color: Colors.white,
//                                                       ),
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           // Add other TableCells here for other product properties
//                                         ],
//                                       );
//                                     }).toList(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 30, top: 30),
//                                   child: ElevatedButton(
//                                     onPressed: addProduct,
//                                     child: Text('Add Parts'),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 10), // Space above/below the border
//                               height: 1, // Border height
//                               color: Colors.grey, // Border color
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(right: 50, top: 20),
//                               child: Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: Text(
//                                   'Amount: ${amountController.text}',
//                                   style: TextStyle(fontSize: 20),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(right: 50, top: 10),
//                               child: Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: Text(
//                                   'Tax: ${taxController.text}',
//                                   style: TextStyle(fontSize: 20),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(right: 50, top: 10),
//                               child: Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: Text(
//                                   'Total Amount: ${formatter.format(parseFormattedString(totalAmountController.text) + parseFormattedString(taxController.text))}',
//                                   style: TextStyle(
//                                       color: Colors.blue, fontSize: 20),
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
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 600, top: 1450),
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
//                         width: 1400,
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
//                                 'Office Use:',
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.symmetric(
//                                 vertical: 10,
//                               ), // Space above/below the border
//                               height: 1, // Border height
//                               color: Colors.grey, // Border color
//                             ),
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 30, top: 30),
//                                   child: Text(
//                                     'NOTES:',
//                                     style: TextStyle(fontSize: 15),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                                 width: 1350,
//                                 height: 200,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 30,
//                                     top: 10,
//                                   ),
//                                   child: TextFormField(
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       contentPadding: EdgeInsets.symmetric(
//                                         horizontal: 15,
//                                         vertical: 70,
//                                       ),
//                                     ),
//                                   ),
//                                 ))
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
// }
//
// class Create {
//   final String addressLine1;
//   final String addressLine2;
//   final double? availableCredit;
//   final String comments;
//   final double? creditLimit;
//   final String? fax;
//   final String glGroup;
//   final String name;
//   final String orderDate;
//   final double? outstandingAmount;
//   final String? phone;
//   final String supplier;
//   final String? tel;
//   final String type;
//   final double? amount;
//   final double? tax;
//   final double? totalAmount;
//   final String? notes;
//   final String? orderId;
//
//   Create({
//     required this.addressLine1,
//     required this.addressLine2,
//     required this.availableCredit,
//     required this.comments,
//     required this.creditLimit,
//     required this.fax,
//     required this.glGroup,
//     required this.name,
//     required this.orderDate,
//     required this.outstandingAmount,
//     required this.phone,
//     required this.supplier,
//     required this.tel,
//     required this.type,
//     required this.amount,
//     required this.tax,
//     required this.totalAmount,
//     required this.notes,
//     required this.orderId,
//   });
//
//   factory Create.fromJson(Map<String, dynamic> json) {
//     return Create(
//       addressLine1: json['addressLine1'] ?? '',
//       addressLine2: json['addressLine2'] ?? '',
//       availableCredit: json['available']?.toDouble(),
//       comments: json['comments'] ?? '',
//       creditLimit: json['creditLimit']?.toDouble(),
//       fax: json['fax'],
//       glGroup: json['glGroup'] ?? '',
//       name: json['name'] ?? '',
//       orderDate: json['orderDate'] ?? '',
//       outstandingAmount: json['outstanding']?.toDouble(),
//       phone: json['phone'],
//       supplier: json['supplier'] ?? '',
//       tel: json['tel'],
//       type: json['type'] ?? '',
//       amount: json['amount']?.toDouble(),
//       tax: json['tax']?.toDouble(),
//       totalAmount: json['totalAmount']?.toDouble(),
//       notes: json['notes'],
//       orderId: json['orderId'],
//     );
//   }
// }
