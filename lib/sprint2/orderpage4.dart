// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:btb/sprint2/product.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// // void main() {
// //   runApp(MaterialApp(
// //     home: OrderPage4(),
// //   ));
// // }
//
// class OrderPage4 extends StatefulWidget {
//   final Product product;
//
//   OrderPage4({required this.product});
//
//   @override
//   OrderPage4State createState() => OrderPage4State();
// }
// class OrderPage4State extends State<OrderPage4> {
//   List<Product> products = [];
//   double _total = 0;
//   String? dropdownValue1 = 'Filter I';
//   bool isOrdersSelected = false;
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
//           jsonData.map((item) => Product.fromJson(item)).toList();
//           setState(() {
//             if (currentPage == 1) {
//               productList = products.take(5).toList();
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
//         backgroundColor: Color(0xFFFFFFFF),
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: Color(0xFFFFFFFF),
//           // Set background color to white
//           elevation: 4.0,
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
//               padding: const EdgeInsets.only(right: 100),
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
//               buildSideMenu(),
//
//               buildresultTable(),
//
//               buildSearchAndTable(),
//               // child: buildSearchFieldAndDataTable(),
//
//               buildProductListTitle(),
//               // call in the last editing work complete if
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
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
//   //
//   // Widget buildMainContent() {
//   //   return Center(
//   //     child: Container(
//   //       height: 1000,
//   //       padding: EdgeInsets.only(top: 80),
//   //       width: 1200,
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           SizedBox(height: 1),
//   //           buildSearchField(),
//   //           SizedBox(height: 40),
//   //           buildDataTable(),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget buildSearchAndTable() {
//     return
//       Padding(
//         padding: const EdgeInsets.only(top: 800),
//         child: Container(
//           height: 600,
//           width: 1480,
//           // padding: EdgeInsets.only(),
//           margin: EdgeInsets.only(left: 320, right: 100),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(5),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset: Offset(0, 8),
//                 )
//               ]),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               buildSearchField(),
//               SizedBox(height: 30),
//               buildDataTable(),
//             ],
//           ),
//         ),
//       );
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
//                 width: 1200,
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
//                   right: 800,
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(color: Colors.blue[100]!),
//                   ),
//                   child: SizedBox(
//                     height: 40,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         contentPadding:
//                         EdgeInsets.symmetric(horizontal: 1, vertical: 8.0),
//                         border: InputBorder.none,
//                         filled: true,
//                         fillColor: Colors.white,
//                         prefixIcon: Icon(Icons.search_outlined),
//                         hintText: 'Search for Products',
//                       ),
//                       onChanged: _onSearchTextChanged,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSearchField1() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 1200,
//                 height: 50,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 30, top: 10),
//                   child: Text(
//                     'Selected Products',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//                 color: Colors.blue[600], // Set background color here
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 30,
//                   right: 800,
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(color: Colors.blue[100]!),
//                   ),
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
//
//     return SizedBox(
//       height: 1800, // set the desired height
//       width:
//       1390, // set the desired width// change contianer width in this place
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
//                       'Product Name',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 25, right: 25),
//                     child: Text(
//                       'Category',
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
//                     padding: EdgeInsets.only(left: 38, right: 38),
//                     child: Text(
//                       'Sub Category',
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
//                       'Price',
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
//                       'QTY',
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
//                       'Total Amount',
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
//                       '  ',
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
//                         padding: EdgeInsets.only(left: 15, right: 10),
//                         child: Text('${widget.product.productName}',
//                           // Product
//                           //     .productName,
//                           // Change this line to convert the int value to a String
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
//                       Container(
//                         padding: EdgeInsets.only(left: 27, right: 23),
//                         child: Text(
//                           Product.price.toString(),
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                       ),
//                     ),
//                     DataCell(Container(
//                       padding: EdgeInsets.only(left: 27, right: 23),
//                       child: TextFormField(
//                         onChanged: (value) {
//                           setState(() {
//                             Product.quantity = int.tryParse(value) ?? 0;
//                             Product.total = Product.price * Product.quantity;
//                             _calculateTotal();
//                           });
//                         },
//                       ),
//                     )),
//                     DataCell(Container(
//                       padding: EdgeInsets.only(left: 27, right: 23),
//                       child: Row(
//                         children: [
//                           Text(
//                             Product.total.toString(),
//                             style: TextStyle(color: Colors.blue[900]),
//                           ),
//                         ],
//                       ),
//                     )),
//                     DataCell(
//                       InkWell(
//                         onTap: () {
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               onPressed: () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => FourthPage()),
//                                 // );
//                               },
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
//   Widget buildDataTable1() {
//     filteredProducts = productList
//         .where((Product) =>
//         Product.productName
//             .toLowerCase()
//             .contains(_searchText.toLowerCase()))
//         .where((Product) => _category.isEmpty || Product.category == _category)
//         .where((Product) =>
//     _subCategory.isEmpty || Product.subCategory == _subCategory)
//         .toList();
//
//     return SizedBox(
//       height: 1800, // set the desired height
//       width:
//       1390, // set the desired width// change contianer width in this place
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
//                       'Product Name',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // DataColumn(
//                 //   label: Container(
//                 //     padding: EdgeInsets.only(left: 30, right: 40),
//                 //     child: Text(
//                 //       'Brand',
//                 //       style: TextStyle(
//                 //         color: Colors.black,
//                 //         fontWeight: FontWeight.bold,
//                 //       ),
//                 //
//                 //       // color: Colors.blue[900],
//                 //     ),
//                 //   ),
//                 // ),
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 25, right: 25),
//                     child: Text(
//                       'Category',
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
//                     padding: EdgeInsets.only(left: 38, right: 38),
//                     child: Text(
//                       'Sub Category',
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
//                       'Price',
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
//                       'QTY',
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
//                       'Total Amount',
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
//                       '  ',
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
//                   //   color: MaterialStateColor.resolveWith((states) => Colors.grey),
//                   cells: [
//                     DataCell(
//                       Container(
//                         padding: EdgeInsets.only(left: 15, right: 10),
//                         child: Text(
//                           Product
//                               .productName,
//                           // Change this line to convert the int value to a String
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                         color: Colors.grey,
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
//                       Container(
//                         padding: EdgeInsets.only(left: 27, right: 23),
//                         child: Text(
//                           Product.price.toString(),
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                       ),
//                     ),
//                     DataCell(Container(
//                       padding: EdgeInsets.only(left: 27, right: 23),
//                       child: TextFormField(
//                         onChanged: (value) {
//                           setState(() {
//                             Product.quantity = int.tryParse(value) ?? 0;
//                             Product.total = Product.price * Product.quantity;
//                             _calculateTotal();
//                           });
//                         },
//                       ),
//                     )),
//                     DataCell(Container(
//                       padding: EdgeInsets.only(left: 27, right: 23),
//                       child: Row(
//                         children: [
//                           Text(
//                             Product.total.toString(),
//                             style: TextStyle(color: Colors.blue[900]),
//                           ),
//                         ],
//                       ),
//                     )),
//                     DataCell(
//                       InkWell(
//                         onTap: () {
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                             child: IconButton(
//                               onPressed: () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => FourthPage()),
//                                 // );
//                               },
//                               icon: Icon(
//                                 Icons.remove,
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
//
//   Widget buildresultTable(){
//     return  Padding(
//       padding: const EdgeInsets.only(top: 150),
//       child: Container(
//         height: 600,
//         width: 1480,
//         // padding: EdgeInsets.only(),
//         margin: EdgeInsets.only(left: 320, right: 100),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(5),
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
//             buildSearchField1(),
//             SizedBox(height: 1),
//             buildDataTable1(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSideMenu() {
//     return Align(
//       // Added Align widget for the left side menu
//       alignment: Alignment.topLeft,
//       child: Container(
//         height: 1400,
//         width: 200,
//         color: Color(0xFFF7F6FA),
//         padding: EdgeInsets.only(left: 20, top: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextButton.icon(
//               onPressed: () {
//                 // context.go('${PageName.main}/${PageName.subpage1Main}');
//                 // context.go('${PageName.dashboardRoute}');
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => Dashboard()),
//                 // );
//                 // Navigator.pushReplacementNamed(
//                 //     context, PageName.dashboardRoute);
//                 // context
//                 //     .go('${PageName.main} / ${PageName.subpage1Main}');
//               },
//               icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
//               label: Text(
//                 'Home',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {
//                 // context.go('${PageName.main}/${PageName.subpage1Main}');
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => Orderspage()),
//                 // );
//                 setState(() {
//                   isOrdersSelected = false;
//                   // Handle button press19
//                 });
//               },
//               icon: Icon(Icons.warehouse,
//                   color:
//                   isOrdersSelected ? Colors.blueAccent : Colors.blueAccent),
//               label: Text(
//                 'Orders',
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.fire_truck_outlined, color: Colors.blue[900]),
//               label: Text(
//                 'Delivery',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon:
//               Icon(Icons.document_scanner_rounded, color: Colors.blue[900]),
//               label: Text(
//                 'Invoice',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.payment_outlined, color: Colors.blue[900]),
//               label: Text(
//                 'Payment',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.backspace_sharp, color: Colors.blue[900]),
//               label: Text(
//                 'Return',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
//               label: Text(
//                 'Reports',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildProductListTitle() {
//     return Positioned(
//       left: 203,
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
//             IconButton(
//               icon: Icon(Icons.arrow_back), // Back button icon
//               onPressed: () {
//                 //  Navigator.push(
//                 //      context,
//                 //     MaterialPageRoute(
//                 //       builder: (context) => SecondPage()),
//                 // );
//               },
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 30),
//                 child: Text(
//                   'Go back',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   void _calculateTotal() {
//     double total = 0;
//     for (var product in products) {
//       total += product.total;
//     }
//     setState(() {
//       _total = total;
//     });
//   }
// }
//
