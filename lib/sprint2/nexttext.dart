// // next_page.dart
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:btb/sprint2/orderpage5.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:btb/sprint2/product.dart';
//
// import 'fifthpage.dart';
// class NextPage extends StatefulWidget {
//   final Product product;
//
//   const NextPage({required this.product});
//
//   @override
//   State<NextPage> createState() => _NextPageState();
// }
//
// class _NextPageState extends State<NextPage> {
//   List<Product> products = [];
//   final _scrollController = ScrollController();
//   double _total = 0;
//   String? dropdownValue1 = 'Filter I';
//   bool isOrdersSelected = false;
//   List<Product> productList = [];
//   String? dropdownValue2 = 'Filter II';
//   String token = window.sessionStorage["token"] ?? " ";
//   String _searchText = '';
//   String _category = '';
//   int _quantity = 0;
//   String _subCategory = '';
//   int startIndex = 0;
//   int currentPage = 1;
//   Timer? _searchDebounceTimer;
//   List<Product> filteredProducts = [];
//   List<Product> selectedProducts = [];
//   List<Map<String, dynamic>> savedProducts = [];
//   List<String> variationList = ['Select', 'Variation 1', 'Variation 2'];
//   String selectedVariation = 'Select';
//   List<String> uomList = ['Select', 'UOM 1', 'UOM 2'];
//   String selectedUOM = 'Select';
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
//     _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
//       setState(() {
//         _searchText = text;
//       });
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts(page: currentPage);
//     products.add(widget.product);
//     _calculateTotal();
//   }
//
//   void _addProduct(Product product) {
//     setState(() {
//       products.add(product);
//       _calculateTotal();
//     });
//   }
//   void _saveProducts() {
//     savedProducts = products.map((product) {
//       return {
//         'productName': product.productName,
//         'category': product.category,
//         'subCategory': product.subCategory,
//         'selectedUOM': product.selectedUOM,
//         'selectedVariation': product.selectedVariation,
//         'quantity': product.quantity,
//         'total': product.total,
//       };
//     }).toList();
//
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => OredrPage5(savedProducts: savedProducts)),
//     // );
//   }
//   void _handleAddButtonPress(Product product) {
//     Product newProduct = Product(
//       productName: product.productName,
//       category: product.category,
//       subCategory: product.subCategory,
//       selectedUOM: product.selectedUOM,
//       selectedVariation: product.selectedVariation,
//       discount: product.discount,
//       proId: product.proId,
//       price: product.price,
//       tax: product.tax,
//       unit: product.unit,
//       quantity: product.quantity,
//       total: product.total,
//       totalamount: product.totalamount,
//     );
//     _addProduct(newProduct);
//   }
//
//
//   void _deleteProduct(int index) {
//     setState(() {
//       products.removeAt(index);
//       _calculateTotal();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Image.asset("images/Final-Ikyam-Logo.png"),
//         backgroundColor: Color(0xFFFFFFFF),
//         // Set background color to white
//         elevation: 4.0,
//         shadowColor: Color(0xFFFFFFFF),
//         // Set shadow color to black
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 30),
//             child: IconButton(
//               icon: Icon(Icons.notifications),
//               onPressed: () {
//                 // Handle notification icon press
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 100),
//             child: IconButton(
//               icon: Icon(Icons.account_circle),
//               onPressed: () {
//                 // Handle user icon press
//               },
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         controller: _scrollController,
//         child: Stack(
//           children: [
//             buildSideMenu(),
//             buildSearchAndTable(),
//             buildProductListTitle(),
//             buildresultTable(),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget buildMainContent() {
//     return Center(
//       child: Container(
//         height: double.infinity,
//         padding: const EdgeInsets.only(top: 80),
//         width: MediaQuery
//             .of(context)
//             .size
//             .width * 0.8,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 1111),
//             buildresultTable(),
//             const SizedBox(height: 1111,),
//             buildSearchField(),
//             const SizedBox(height: 1151),
//             buildDataTable(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchAndTable() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 650),
//       child: Container(
//         height: 500,
//         width: 1480,
//         // padding: EdgeInsets.only(),
//         margin: const EdgeInsets.only(left: 320, right: 100),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(5),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: const Offset(0, 8),
//               )
//             ]),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             buildSearchField(),
//             const SizedBox(height: 30),
//             buildDataTable(),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget buildresultTable(){
//     return  Padding(
//       padding: const EdgeInsets.only(top: 150),
//       child: Container(
//         height: 350,
//         width: 1480,
//         // padding: EdgeInsets.only(),
//         margin: const EdgeInsets.only(left: 320, right: 100),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(5),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: const Offset(0, 8),
//               )
//             ]),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildSearchField1(),
//             const SizedBox(height: 1),
//             Padding(
//               padding: const EdgeInsets.only(top: 6),
//               child:SingleChildScrollView(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey, width: 1), // Add this line
//                   ),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical, // Add this line
//                     child: DataTable(
//                       horizontalMargin: 0, // Add this line
//                       columns: [
//                     DataColumn(
//                     label: Container(
//                     padding: EdgeInsets.only(left: 50, right: 80),
//                     child: Text(
//                       'Product Name',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                   DataColumn(
//                     label: Container(
//                       padding: EdgeInsets.only(left: 30, right: 40),
//                       child: Text(
//                         'Brand',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//
//                         // color: Colors.blue[900],
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: EdgeInsets.only(left: 30, right: 40),
//                       child: Text(
//                         'Category',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//
//                         // color: Colors.blue[900],
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: EdgeInsets.only(left: 60, right: 80),
//                       child: Text(
//                         'Sub Category',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: EdgeInsets.only(left: 50, right: 60),
//                       child: Text(
//                         'Price',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: EdgeInsets.only(left: 60, right: 60),
//                       child: Text(
//                         'QTY',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: EdgeInsets.only(left: 20, right: 35),
//                       child: Text(
//                         'Total Amount',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ), DataColumn(
//                           label: Container(
//                             padding: EdgeInsets.only(left: 20, right: 35),
//                             child: Text(
//                               'action',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                       rows: products.take(3).map((product) { // Add this line
//                         int index = products.indexOf(product);
//                         return DataRow(
//                           cells: [
//                             DataCell(Text('${product.productName}')),
//                             DataCell(Text('${product.category}')),
//                             DataCell(Text('${product.subCategory}')),
//                             DataCell(Text('${product.selectedUOM}')),
//                             DataCell(Text('${product.selectedVariation}')),
//                             DataCell(Text('${product.quantity}')),
//                             DataCell(Text('${product.total}')),
//                             DataCell(
//                               IconButton(
//                                 onPressed: () {
//                                   _deleteProduct(index);
//                                 },
//                                 icon: const Icon(Icons.delete),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 50),
//             Padding(
//               padding: const EdgeInsets.only(top: 100,left:900,),
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.blue), // Simple border with color
//                 ),
//                 child: Text('Total: $_total'),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   Widget buildDataTable1() {
//     filteredProducts = productList
//         .where((Product) =>
//        Product.productName
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
//         SingleChildScrollView(
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.only(right: 10),
//               child: DataTable(
//                 border: TableBorder.all(color: Colors.grey, width: 2),
//                 // decoration: BoxDecoration(
//                 //   border: Border.all(color: Colors.blue, width: 1),
//                 // ),
//                 headingRowHeight: 50,
//                 columns: [
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 15, right: 15),
//                       child: const Text(
//                         'Product Name',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 25, right: 25),
//                       child: const Text(
//                         'Category',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//
//                         // color: Colors.blue[900],
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 38, right: 38),
//                       child: const Text(
//                         'Sub Category',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 30, right: 30),
//                       child: const Text(
//                         'Price',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       child: const Text(
//                         'QTY',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       child: const Text(
//                         'Total Amount',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 20, right: 20),
//                       child: const Text(
//                         '  ',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: filteredProducts.map((Product) {
//                   return DataRow.byIndex(
//                     index: filteredProducts.indexOf(Product),
//                     //   color: MaterialStateColor.resolveWith((states) => Colors.grey),
//                     cells: [
//                       DataCell(
//                         Container(
//                           padding:const  EdgeInsets.only(left: 15, right: 10),
//                           child: Text(
//                             Product
//                                 .productName,
//                             // Change this line to convert the int value to a String
//                             style: TextStyle(color: Colors.blue[900]),
//                           ),
//                           color: Colors.grey,
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             top: 5,
//                             bottom: 5,
//                           ),
//                           child: Container(
//                             child: DropdownButtonFormField<String>(
//                               value: Product.selectedUOM,
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                               ),
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   Product.selectedUOM = newValue!;
//                                 });
//                               },
//                               items: uomList
//                                   .map<DropdownMenuItem<String>>((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(
//                                     value,
//                                     style: const TextStyle(fontSize: 8),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, bottom: 5),
//                           child: Container(
//                             child: DropdownButtonFormField<String>(
//                               value: Product.selectedVariation,
//                               decoration: const InputDecoration(
//                                 border: OutlineInputBorder(),
//                               ),
//                               onChanged: (String? newValue) {
//                                 setState(() {
//                                   Product.selectedVariation = newValue!;
//                                 });
//                               },
//                               items: variationList
//                                   .map<DropdownMenuItem<String>>((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: SizedBox(
//                                     child: Text(
//                                       value,
//                                       style: const TextStyle(fontSize: 8),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Container(
//                           padding: const EdgeInsets.only(left: 27, right: 23),
//                           child: Text(
//                             Product.price.toString(),
//                             style: TextStyle(color: Colors.blue[900]),
//                           ),
//                         ),
//                       ),
//                       DataCell(Container(
//                         padding: const EdgeInsets.only(left: 27, right: 23),
//                         child: TextFormField(
//                           onChanged: (value) {
//                             setState(() {
//                               Product.quantity = int.tryParse(value) ?? 0;
//                               Product.total = Product.price * Product.quantity;
//                               _calculateTotal();
//                             });
//                           },
//                         ),
//                       )),
//                       DataCell(Container(
//                         padding: const EdgeInsets.only(left: 27, right: 23),
//                         child: Row(
//                           children: [
//                             Text(
//                               Product.total.toString(),
//                               style: TextStyle(color: Colors.blue[900]),
//                             ),
//                           ],
//                         ),
//                       )),
//                       DataCell(
//                         InkWell(
//                           onTap: () {
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 onPressed: () {
//                                 },
//                                 icon: const Icon(
//                                   Icons.remove,
//                                   color: Colors.white,
//                                   size: 15,
//                                 ),
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget buildSearchField1() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 1310,
//                 height: 50,
//                 child: const Padding(
//                   padding:  EdgeInsets.only(left: 30, top: 10),
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
//                 child: const Padding(
//                   padding:  EdgeInsets.only(left: 30, top: 10),
//                   child: Text(
//                     'Search Products',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//                 color: Colors.blue[900], // Set background color here
//               ),
//               const SizedBox(height: 15),
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
//                     decoration: const InputDecoration(
//                       contentPadding:
//                       EdgeInsets.symmetric(horizontal: 1, vertical: 8.0),
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
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDataTable() {
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
//               headingRowHeight: 50,
//               columns: [
//                 DataColumn(
//                   label: Container(
//                     padding: EdgeInsets.only(left: 50, right: 80),
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
//                     padding: EdgeInsets.only(left: 30, right: 40),
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
//                     padding: EdgeInsets.only(left: 60, right: 80),
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
//                     padding: EdgeInsets.only(left: 50, right: 60),
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
//                     padding: EdgeInsets.only(left: 60,right: 60),
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
//                     padding: EdgeInsets.only(left: 40, right: 70),
//                     child: Text(
//                       'Total Amount',
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
//                         padding: EdgeInsets.only(left: 50, right: 60),
//                         child: Text(
//                           Product
//                               .productName,
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
//                 DataCell(
//                       Container(
//                         padding: EdgeInsets.only(left: 27, right: 23),
//                         child: TextFormField(
//                           initialValue: _quantity.toString(),
//                           onChanged: (value) {
//                             setState(() {
//                               _quantity = int.tryParse(value) ?? 0;
//                                             Product.quantity = _quantity;
//                                             Product.total = Product.price * Product.quantity;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     DataCell(
//                       Row(
//                         children: [
//                           Text(
//                             Product.total.toString(),
//                             style: TextStyle(color: Colors.blue[900]),
//                           ),
//                           SizedBox(width: 20), // Adjust the spacing as needed
//                           IconButton(
//                                 onPressed: () {
//                         _handleAddButtonPress(Product);
//                         _scrollController.jumpTo(0);
//                         setState(() {
//                           _quantity = 0;
//                            Product.quantity = 0;
//                            Product.total = 0;// Reset the quantity to 0
//                         });
//                       },
//                       icon: Icon(Icons.add_box),
//                     ),
//                         ],
//                       ),
//                     )
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
//         height: 1400,
//         width: 200,
//         color: Color(0xFFF7F6FA),
//         padding: EdgeInsets.only(left: 20, top: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextButton.icon(
//               onPressed: () {
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
//
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
//             Padding(
//               padding: const EdgeInsets.only(top: 20, left: 1000),
//               child: Builder(
//                 builder: (context) {
//                   return OutlinedButton(
//                     onPressed: (){
//                       if (products.isNotEmpty) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => FifthPage(
//                               selectedProducts: products, // Pass the entire products list
//                             ),
//                           ),
//                         );
//                       } else {
//                         print("No products selected");
//                       }
//                       // print('button clicked');
//                       // _handleAddButtonPress1(selectedProducts)
//                       print('----Nothing else----');
//                       print(products);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       side: BorderSide.none,
//                     ),
//                     child: const Text(
//                       "Save",
//                       style: TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                   );
//                 },
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
