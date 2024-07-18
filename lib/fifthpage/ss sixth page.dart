// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// import 'create order seventh page mahadevan.dart';
//
// //this is a final copy of fourth page
//
// class ProductPage3 extends StatefulWidget {
//   @override
//   _ProductPage3State createState() => _ProductPage3State();
// }
//
// class _ProductPage3State extends State<ProductPage3> {
//   String? dropdownValue1 = 'Filter I';
//   List<Product> productList = [];
//   String? dropdownValue2 = 'Filter II';
//   String token = window.sessionStorage["token"] ?? " ";
//   String _searchText = '';
//   String _category = '';
//   String _subCategory = '';
//   int startIndex = 0;
//   int currentPage = 1;
//   Timer? _searchDebounceTimer;
//   List<Product> filteredProducts = [];
//   List<Product> selectedProducts = [];
//   List<String> variationList = ['Select', 'Variation 1', 'Variation 2'];
//   String selectedVariation = 'Select';
//
//   List<String> uomList = ['Select', 'UOM 1', 'UOM 2'];
//   String selectedUOM = 'Select';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts(page: currentPage);
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
//               jsonData.map((item) => Product.fromJson(item)).toList();
//           setState(() {
//             if (currentPage == 1) {
//               productList = products;
//             } else {
//               productList.addAll(products);
//             }
//             startIndex += 20;
//             currentPage++;
//           });
//         } else if (jsonData is Map) {
//           final products =
//               jsonData['body'].map((item) => Product.fromJson(item)).toList();
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
//   void loadMoreData() {
//     fetchProducts(page: currentPage);
//   }
//
//   @override
//   void dispose() {
//     _searchDebounceTimer
//         ?.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }
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
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: Colors.white,
//           elevation:
//               1.0, // Set elevation to a value greater than 0 to add a shadow
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
//         body: Stack(
//           children: [
//             buildSideMenu(),
//
//             buildSearchAndTable(),
//             // child: buildSearchFieldAndDataTable(),
//
//             buildProductListTitle(), // call in the last editing work complete if
//           ],
//         ),
//       ),
//     );
//   }
//   //
//   // Widget buildMenuItem(String imagePath, String label) {
//   //   return Column(
//   //     children: [
//   //       TextButton.icon(
//   //         onPressed: () {
//   //           // Handle button press
//   //         },
//   //         icon: Image.asset(
//   //           imagePath,
//   //           width: 24, // Adjust width and height as needed
//   //           height: 24,
//   //         ),
//   //         label: Text(label),
//   //       ),
//   //       SizedBox(height: 28),
//   //     ],
//   //   );
//   // }
//
//   Widget buildMainContent() {
//     return Center(
//       child: Container(
//         height: double.infinity,
//         padding: EdgeInsets.only(top: 80),
//         width: MediaQuery.of(context).size.width * 0.8,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 1),
//             buildSearchField(),
//             SizedBox(height: 40),
//             buildDataTable(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchAndTable() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 150),
//       child: Container(
//         height: 850,
//         width: 1480,
//         // padding: EdgeInsets.only(),
//         margin: EdgeInsets.only(left: 280, right: 100),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(1),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: Offset(0, 8),
//               )
//             ]),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildSearchField(),
//             SizedBox(height: 30),
//             buildDataTable(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchField() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 1480,
//                 height: 50,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 30, top: 10),
//                   child: Text(
//                     'Search Products',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//                 color: Colors.blue[900], // Set background color here
//               ),
//               SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 30,
//                   right: 1100,
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(color: Colors.blue[100]!),
//                   ),
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 1, vertical: 8.0),
//                       border: InputBorder.none,
//                       filled: true,
//                       fillColor: Colors.white,
//                       prefixIcon: Icon(Icons.search_outlined),
//                       hintText: 'Search for Products',
//                     ),
//                     onChanged: _onSearchTextChanged,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           // Row(
//           //   children: [
//           //     Expanded(
//           //       child: Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         children: [
//           //           SizedBox(height: 8),
//           //           Padding(
//           //             padding: const EdgeInsets.all(8.0),
//           //             child: Container(
//           //               decoration: BoxDecoration(
//           //                 color: Colors.white,
//           //                 borderRadius: BorderRadius.circular(4),
//           //                 border: Border.all(color: Colors.blue[100]!),
//           //               ),
//           //               child: DropdownButtonFormField<String>(
//           //                 decoration: InputDecoration(
//           //                   contentPadding:
//           //                       EdgeInsets.symmetric(horizontal: 10),
//           //                   border: InputBorder.none,
//           //                   filled: true,
//           //                   fillColor: Colors.white,
//           //                   hintText: 'Filter I',
//           //                 ),
//           //                 value: dropdownValue1,
//           //                 onChanged: (String? newValue) {
//           //                   setState(() {
//           //                     dropdownValue1 = newValue;
//           //                   });
//           //                 },
//           //                 items: <String>['Filter I', 'Option 2', 'Option 3']
//           //                     .map<DropdownMenuItem<String>>((String value) {
//           //                   return DropdownMenuItem<String>(
//           //                     value: value,
//           //                     child: Text(value),
//           //                   );
//           //                 }).toList(),
//           //               ),
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //     SizedBox(width: 16),
//           //     Expanded(
//           //       child: Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         children: [
//           //           SizedBox(height: 8),
//           //           Padding(
//           //             padding: const EdgeInsets.all(8.0),
//           //             child: Container(
//           //               decoration: BoxDecoration(
//           //                 color: Colors.white,
//           //                 borderRadius: BorderRadius.circular(8),
//           //                 border: Border.all(color: Colors.black26),
//           //               ),
//           //               child: DropdownButtonFormField<String>(
//           //                 decoration: InputDecoration(
//           //                   contentPadding:
//           //                       EdgeInsets.symmetric(horizontal: 10),
//           //                   border: InputBorder.none,
//           //                   filled: true,
//           //                   fillColor: Colors.white,
//           //                   hintText: 'Filter II',
//           //                 ),
//           //                 value: dropdownValue2,
//           //                 onChanged: (String? newValue) {
//           //                   setState(() {
//           //                     dropdownValue2 = newValue;
//           //                   });
//           //                 },
//           //                 items: <String>['Filter II', 'Option 2', 'Option 3']
//           //                     .map<DropdownMenuItem<String>>((String value) {
//           //                   return DropdownMenuItem<String>(
//           //                     value: value,
//           //                     child: Text(value),
//           //                   );
//           //                 }).toList(),
//           //               ),
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }
//
//   // Widget buildDataTable() {
//   //   return Container(
//   //     color: Colors.grey[100],
//   //     padding: const EdgeInsets.only(right: 10),
//   //     child: DataTable(
//   //       headingRowHeight: 50,
//   //       columns: [
//   //         DataColumn(
//   //           label: Container(
//   //             padding: EdgeInsets.only(left: 60),
//   //             child: Text(
//   //               'Status',
//   //               style: TextStyle(color: Colors.blue[900]),
//   //             ),
//   //           ),
//   //         ),
//   //         DataColumn(
//   //           label: Container(
//   //             padding: EdgeInsets.only(left: 75),
//   //             child: Text(
//   //               'Order ID',
//   //               style: TextStyle(color: Colors.blue[900]),
//   //             ),
//   //           ),
//   //         ),
//   //         DataColumn(
//   //           label: Container(
//   //             padding: EdgeInsets.only(left: 75),
//   //             child: Text(
//   //               'Created Date',
//   //               style: TextStyle(color: Colors.blue[900]),
//   //             ),
//   //           ),
//   //         ),
//   //         DataColumn(
//   //           label: Container(
//   //             padding: EdgeInsets.only(left: 85),
//   //             child: Text(
//   //               'Reference Number',
//   //               style: TextStyle(color: Colors.blue[900]),
//   //             ),
//   //           ),
//   //         ),
//   //         DataColumn(
//   //           label: Container(
//   //             padding: EdgeInsets.only(left: 95),
//   //             child: Text(
//   //               'Total Amount',
//   //               style: TextStyle(color: Colors.blue[900]),
//   //             ),
//   //           ),
//   //         ),
//   //         DataColumn(
//   //           label: Container(
//   //             padding: EdgeInsets.only(left: 98),
//   //             child: Text(
//   //               'Delivery Status',
//   //               style: TextStyle(color: Colors.blue[900]),
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //       rows: _products
//   //           .where((product) => product.productName
//   //               .toLowerCase()
//   //               .contains(_searchText.toLowerCase()))
//   //           .where(
//   //               (product) => _category.isEmpty || product.category == _category)
//   //           .where((product) =>
//   //               _subCategory.isEmpty || product.subCategory == _subCategory)
//   //           .map(
//   //             (product) => DataRow(
//   //               cells: [
//   //                 DataCell(Text(product.proId)),
//   //                 DataCell(Text(product.productName)),
//   //                 DataCell(Text(product.category)),
//   //                 DataCell(Text(product.subCategory)),
//   //                 DataCell(Text(product.price.toString())),
//   //                 DataCell(Text(product.tax)),
//   //               ],
//   //             ),
//   //           )
//   //           .toList(),
//   //     ),
//   //   );
//   // }
//
//   Widget buildDataTable() {
//     filteredProducts = productList
//         .where((Product) => Product.productName
//             .toLowerCase()
//             .contains(_searchText.toLowerCase()))
//         .where((Product) => _category.isEmpty || Product.category == _category)
//         .where((Product) =>
//             _subCategory.isEmpty || Product.subCategory == _subCategory)
//         .toList();
//
//     return SizedBox(
//       height: 1800, // set the desired height
//       width:
//           1390, // set the desired width// change contianer width in this place
//       child: Column(
//         children: [
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.only(right: 10),
//             child: DataTable(
//               border: TableBorder.all(color: Colors.grey, width: 2),
//               // decoration: BoxDecoration(
//               //   border: Border.all(color: Colors.blue, width: 1),
//               // ),
//               headingRowHeight: 50,
//               columns: [
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 15, right: 15),
//                     child: Text(
//                       'Product No',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 15, right: 300),
//                     child: Text(
//                       'Desc1',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 27, right: 23),
//                     child: Text(
//                       'Price',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//
//                       // color: Colors.blue[900],
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 23, right: 30),
//                     child: Text(
//                       'Order QTY',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 22, right: 25),
//                     child: Text(
//                       'UOM',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 30, right: 30),
//                     child: Text(
//                       'Variation',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 20, right: 20),
//                     child: Text(
//                       'ADD',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               rows: filteredProducts.map((Product) {
//                 return DataRow.byIndex(
//                   index: filteredProducts.indexOf(Product),
//                   cells: [
//                     DataCell(
//                       Container(
//                         padding: EdgeInsets.only(left: 15, right: 15),
//                         child: Text(
//                           Product
//                               .productName, // Change this line to convert the int value to a String
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Container(
//                         padding: EdgeInsets.only(left: 15, right: 300),
//                         child: Text(
//                           Product.category,
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Container(
//                         padding: EdgeInsets.only(left: 27, right: 23),
//                         child: Text(
//                           Product.price.toString(),
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Container(
//                         padding: EdgeInsets.only(left: 23, right: 32),
//                         child: TextField(
//                           //order quanitity
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           top: 5,
//                           bottom: 5,
//                         ),
//                         child: Container(
//                           child: DropdownButtonFormField<String>(
//                             value: Product.selectedUOM,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                             ),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 Product.selectedUOM = newValue!;
//                               });
//                             },
//                             items: uomList
//                                 .map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(
//                                   value,
//                                   style: TextStyle(fontSize: 8),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5, bottom: 5),
//                         child: Container(
//                           child: DropdownButtonFormField<String>(
//                             value: Product.selectedVariation,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                             ),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 Product.selectedVariation = newValue!;
//                               });
//                             },
//                             items: variationList
//                                 .map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: SizedBox(
//                                   child: Text(
//                                     value,
//                                     style: TextStyle(fontSize: 8),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       InkWell(
//                         onTap: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Product added'),
//                               duration: Duration(seconds: 1),
//                             ),
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 15,
//                               ),
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSideMenu() {
//     return Align(
//       // Added Align widget for the left side menu
//       alignment: Alignment.topLeft,
//       child: Container(
//         width: 210,
//         color: Colors.grey[100],
//         padding: EdgeInsets.only(left: 20, top: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.dashboard, color: Colors.blue[900]),
//               label: Text('Home'),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProductPage3()),
//                 );
//               },
//               icon: Icon(Icons.warehouse_outlined, color: Colors.blue[900]),
//               label: Text('Orders'),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.fire_truck_outlined, color: Colors.blue[900]),
//               label: Text('Delivery'),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon:
//                   Icon(Icons.document_scanner_rounded, color: Colors.blue[900]),
//               label: Text('Invoice'),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.payment_outlined, color: Colors.blue[900]),
//               label: Text('Payment'),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.backspace_sharp, color: Colors.blue[900]),
//               label: Text('Return'),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
//               label: Text('Reports'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildProductListTitle() {
//     return Positioned(
//       left: 210,
//       right: 0,
//       top: 1,
//       height: kToolbarHeight,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 30),
//                 child: Text(
//                   'Create Order',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final selectedProductsList = selectedProducts.map((product) {
//                   return {
//                     "productId": product.proId,
//                     "productName": product.productName,
//                     "category": product.category,
//                     "subCategory": product.subCategory,
//                     "price": product.price,
//                     "tax": product.tax,
//                     "unit": product.unit,
//                     "discount": product.discount,
//                     "selectedUOM": product.selectedUOM,
//                     "selectedVariation": product.selectedVariation,
//                     "quantity": 1,
//                   };
//                 }).toList();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Product {
//   final String proId;
//   final String productName;
//   final String category;
//   final String subCategory;
//   final double price;
//   final String tax;
//   final String unit;
//   final String discount;
//   String selectedUOM;
//   String selectedVariation;
//
//   Product({
//     required this.proId,
//     required this.productName,
//     required this.category,
//     required this.subCategory,
//     required this.price,
//     required this.tax,
//     required this.unit,
//     required this.discount,
//     required this.selectedUOM, // Add selectedUOM property
//     required this.selectedVariation, // Add selectedVariation property
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       proId: json['proId'] ?? '',
//       productName: json['productName'] ?? '',
//       category: json['category'] ?? '',
//       subCategory: json['subCategory'] ?? '',
//       price: json['price']?.toDouble() ?? 0.0,
//       tax: json['tax'] ?? '',
//       unit: json['unit'] ?? '',
//       discount: json['discount'] ?? '',
//       selectedUOM: json['uom'] ?? 'Select',
//       selectedVariation: json['variation'] ?? 'Select',
//     );
//   }
// }
