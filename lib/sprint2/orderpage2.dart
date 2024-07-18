// // import 'package:btb/sprint2/orderpage3.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// //
// // void main() {
// //   runApp(const OrderPage2());
// // }
// //
// // class OrderPage2 extends StatefulWidget {
// //   const OrderPage2({super.key});
// //
// //   @override
// //   State<OrderPage2> createState() => _OrderPage2State();
// // }
// //
// // class _OrderPage2State extends State<OrderPage2> {
// //   final List<String> list = ['Customer Name', 'Name 1', 'Name 2', 'Name3'];
// //   String dropdownValue = 'Customer Name';
// //   DateTime? _selectedDate;
// //   late TextEditingController _dateController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _dateController = TextEditingController();
// //     // Initialize _dateController with the current date
// //     _selectedDate = DateTime.now();
// //     _dateController.text = DateFormat.yMd().format(_selectedDate!);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _dateController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: Scaffold(
// //         backgroundColor: const Color(0xFFFFFFFF),
// //         appBar: AppBar(
// //           title: Image.asset("images/Final-Ikyam-Logo.png"),
// //           backgroundColor: const Color(0xFFFFFFFF),
// //           elevation: 4.0,
// //           shadowColor: const Color(0xFFFFFFFF),
// //           actions: [
// //             Padding(
// //               padding: const EdgeInsets.only(right: 30),
// //               child: IconButton(
// //                 icon: const Icon(Icons.notifications),
// //                 onPressed: () {
// //                   // Handle notification icon press
// //                 },
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.only(right: 100),
// //               child: IconButton(
// //                 icon: const Icon(Icons.account_circle),
// //                 onPressed: () {
// //                   // Handle user icon press
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //         body: SingleChildScrollView(
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.start,
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 1450, top: 80),
// //                 child: DecoratedBox(
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
// //                     borderRadius: BorderRadius.circular(10),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: const Color(0xFF418CFC).withOpacity(0.16),
// //                         spreadRadius: 0,
// //                         blurRadius: 6,
// //                         offset: const Offset(0, 3),
// //                       ),
// //                     ],
// //                   ),
// //                   child: Container(
// //                     height: 39,
// //                     width: 258,
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(1),
// //                       borderRadius: BorderRadius.circular(4),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         Expanded(
// //                           child: TextFormField(
// //                             controller: _dateController,
// //                             readOnly: true,
// //                             decoration: const InputDecoration(
// //                               suffixIcon: Padding(
// //                                 padding:  EdgeInsets.only(right: 20),
// //                                 child: Padding(
// //                                   padding:  EdgeInsets.only(top: 2, left: 10),
// //                                   child: IconButton(
// //                                     icon:  Padding(
// //                                       padding: EdgeInsets.only(bottom: 16),
// //                                       child: Icon(Icons.calendar_month),
// //                                     ),
// //                                     iconSize: 20,
// //                                     onPressed: null, // Disable the onPressed event
// //                                   ),
// //                                 ),
// //                               ),
// //                               hintText: '        Select Date',
// //                               fillColor: Colors.white,
// //                               contentPadding:  EdgeInsets.symmetric(horizontal: 8, vertical: 8),
// //                               border: InputBorder.none,
// //                               filled: true,
// //                             ),
// //                           ),
// //                         ),
// //                   ],
// //                 ),
// //                   ),
// //                     ),
// //                 ),
// //
// //                 ],
// //               ),
// //         ),
// //
// //
// //
// //
// //       ),
// //     );
// //   }
// // }
// import 'package:btb/sprint2/orderpage3.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// void main() {
//   runApp(const OrderPage2());
// }
//
// class OrderPage2 extends StatefulWidget {
//   const OrderPage2({super.key});
//
//   @override
//   State<OrderPage2> createState() => _OrderPage2State();
// }
//
// class _OrderPage2State extends State<OrderPage2> {
//   final List<String> list = ['Customer Name', 'Name 1', 'Name 2', 'Name3'];
//   String dropdownValue = 'Customer Name';
//   DateTime? _selectedDate;
//   late TextEditingController _dateController;
//
//   @override
//   void initState() {
//     super.initState();
//     _dateController = TextEditingController();
//     // Initialize _dateController with the current date
//     _selectedDate = DateTime.now();
//     _dateController.text = DateFormat.yMd().format(_selectedDate!);
//   }
//
//   @override
//   void dispose() {
//     _dateController.dispose();
//     super.dispose();
//   }
//
//   // Future<void> _selectDate(BuildContext context) async {
//   //   final DateTime? picked = await showDatePicker(
//   //     context: context,
//   //     initialDate: _selectedDate!,
//   //     firstDate: DateTime(2000),
//   //     lastDate: DateTime(2101),
//   //   );
//   //   if (picked != null && picked != _selectedDate) {
//   //     setState(() {
//   //       _selectedDate = picked;
//   //       _dateController.text = DateFormat.yMd().format(_selectedDate!);
//   //     });
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: const Color(0xFFFFFFFF),
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: const Color(0xFFFFFFFF),
//           elevation: 4.0,
//           shadowColor: const Color(0xFFFFFFFF),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 30),
//               child: IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 100),
//               child: IconButton(
//                 icon: const Icon(Icons.account_circle),
//                 onPressed: () {
//                   // Handle user icon press
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 50, top: 80),
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF418CFC).withOpacity(0.16),
//                         spreadRadius: 0,
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Container(
//                     height: 39,
//                     width: 258,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(1),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: TextFormField(
//                       controller: _dateController,
//                       readOnly: true,
//                       // onTap: () => _selectDate(context),
//                       decoration: const InputDecoration(
//                         suffixIcon: Padding(
//                           padding: EdgeInsets.only(right: 20),
//                           child: Icon(Icons.calendar_month, size: 20),
//                         ),
//                         hintText: '        Select Date',
//                         fillColor: Colors.white,
//                         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                         border: InputBorder.none,
//                         filled: true,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 50, top: 80),
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 10),
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Container(
//                     height: 300,
//                     width: 700,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(4.0),
//                                   child: RichText(
//                                     text: const TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: 'select delivery location ',
//                                           style: TextStyle(
//                                             color: Colors
//                                                 .grey, // Set the product name to black color
//                                           ),
//                                         ),
//                                         TextSpan(
//                                           text: '',
//                                           style: TextStyle(
//                                             color: Colors
//                                                 .red, // Set the asterisk to red color
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius:
//                                       BorderRadius.circular(4),
//                                       border: Border.all(
//                                           color: Colors.blue[100]!),
//                                     ),
//                                     child: SizedBox(
//                                       height: 50,
//                                       width: 300,
//                                       child: Padding(
//                                         padding:
//                                         const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: DropdownButton<String>(
//                                           value: dropdownValue,
//                                           icon: const Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 140),
//                                             child: Icon(
//                                                 Icons.arrow_drop_down),
//                                           ),
//                                           iconSize: 24,
//                                           // Size of the icon
//                                           elevation: 16,
//                                           style: const TextStyle(
//                                               color: Colors.black),
//                                           underline: Container(),
//                                           // We don't need the default underline since we're using a custom border
//                                           onChanged: (String? value) {
//                                             setState(() {
//                                               dropdownValue = value!;
//                                             });
//                                           },
//                                           items: list.map<
//                                               DropdownMenuItem<
//                                                   String>>(
//                                                   (String value) {
//                                                 return DropdownMenuItem<
//                                                     String>(
//                                                   value: value,
//                                                   child: Text(value),
//                                                 );
//                                               }).toList(),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
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
//                     padding: const EdgeInsets.only(left: 150, top: 50),
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
//                       child: Container(
//                         height: 200,
//                         width: 1400,
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white, // Container background color
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Padding(
//                               padding: EdgeInsets.only(left: 30, top: 10),
//                               child: Text(
//                                 'Address',
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 10), // Space above/below the border
//                               height: 1, // Border height
//                               color: Colors.grey, // Border color
//                             ),
//                             Table(
//                               border: TableBorder.all(
//                                   color: Colors.grey, width: 2.0),
//                               columnWidths: const {
//                                 0: FlexColumnWidth(3),
//                                 1: FlexColumnWidth(2),
//                                 2: FlexColumnWidth(2),
//                                 3: FlexColumnWidth(1),
//                                 4: FlexColumnWidth(1),
//                                 5: FlexColumnWidth(1),
//                                 6: FlexColumnWidth(1),
//                                 7: FlexColumnWidth(2),
//                                 8: FlexColumnWidth(2),
//                               },
//                               children: const [
//                                 TableRow(
//                                   children: [
//                                     TableCell(
//                                       child: SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the first column to 50
//                                         child: Center(
//                                           child:  Text(
//                                             'Product Name ',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child:  SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the second column to 50
//                                         child: Center(
//                                           child:  Text(
//                                             'Category',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .left, // set the alignment of the text to left
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child:  SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the third column to 50
//                                         child: Center(
//                                           child:  Text(
//                                             'SubCategory',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .right, // set the alignment of the text to right
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child:  SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the fourth column to 50
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
//                                       child:  SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the fifth column to 50
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
//                                       child:  SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the sixth column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'Amount',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child:  SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the seventh column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'Tax',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child:  SizedBox(
//                                         height:
//                                         50, // set the height of the first cell in the seventh column to 50
//                                         child: Center(
//                                           child: Text(
//                                             'Discount',
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                             textAlign: TextAlign
//                                                 .center, // set the alignment of the text to center
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     TableCell(
//                                       child:  SizedBox(
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
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding:
//                                   const EdgeInsets.only(left: 30, top: 20),
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                  OrderPage3(subText: '', inputText: '', data: {},)),
//                                       );
//                                     },
//                                     child: const Text('Add Parts'),
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
//
//         ),
//       ),
//     );
//   }
// }
