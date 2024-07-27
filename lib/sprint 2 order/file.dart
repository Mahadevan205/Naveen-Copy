// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// //
// //
// // void main(){
// //   runApp(MaterialApp(home: DeliveryLocation(),));
// // }
// //
// //
// // class DeliveryLocation extends StatefulWidget {
// //   const DeliveryLocation({Key? key}) : super(key: key);
// //
// //   @override
// //   _DeliveryLocationState createState() => _DeliveryLocationState();
// // }
// //
// // class _DeliveryLocationState extends State<DeliveryLocation> {
// //   final TextEditingController deliveryaddressController =
// //   TextEditingController();
// //   final TextEditingController ContactPersonController =
// //   TextEditingController();
// //   final TextEditingController ContactNumberController =
// //   TextEditingController();
// //   final TextEditingController CommentsController = TextEditingController();
// //
// //   String? _selectedDeliveryLocation;
// //   final List<String> list = [
// //     'Select Delivery Location',
// //     'Location 1',
// //     'Location 2',
// //     'Location 3'
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(),
// //       body:
// //       Padding(
// //         padding: const EdgeInsets.only(left: 50, top: 50, right: 100),
// //         child: Container(
// //           height: 380,
// //           width: 2100,
// //           padding: const EdgeInsets.all(2),
// //           decoration: BoxDecoration(
// //             border: Border.all(color: Colors.grey, width: 2),
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           child: Stack(
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.only(left: 30, top: 10),
// //                     child: Text(
// //                       'Delivery Location',
// //                       style: TextStyle(
// //                         fontSize: 18.0,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                   Text(
// //                     'Address',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w400,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.only(left: 30, right: 30),
// //                     child: Row(
// //                       children: [
// //
// //                         Expanded(
// //                           child: Container(
// //                             height: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //
// //                         Expanded(
// //                           child: Container(
// //                             height: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
// //                           child: Container(
// //                             height: 350,
// //                             width: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                         Expanded(
// //                           child: Container(
// //                             height: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //
// //     );
// //
// //   }
// // }
//
// // for all screens without documents and edit screens
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // void main(){
// //   runApp(MaterialApp(
// //     home:TableExample() ,
// //   ));
// // }
// //
// //
// // class TableExample extends StatelessWidget {
// //   final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
// //   @override
// //   Widget build(BuildContext context) {
// //     TableRow row1 = TableRow(
// //       children: [
// //         TableCell(
// //           child: Padding(
// //             padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
// //             child: Text('Delivery Location'),
// //           ),
// //         ),
// //         TableCell(
// //           child: Text(''),
// //         ),
// //       ],
// //     );
// //
// //     TableRow row2 = TableRow(
// //       children: [
// //         TableCell(
// //           child: Padding(
// //             padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
// //             child: Text('Address'),
// //           ),
// //         ),
// //         TableCell(
// //           child: Padding(
// //             padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
// //             child: Text('Comments'),
// //           ),
// //         ),
// //       ],
// //     );
// //     TableRow row3 = TableRow(
// //       children: [
// //         TableCell(
// //           child: Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(
// //                 flex: 3,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Padding(
// //                       padding:  EdgeInsets.only(left: 30,top: 10),
// //                       child: Text('Select Delivery Location'),
// //                     ),
// //                     SizedBox(height: 10,),
// //                     Padding(
// //                       padding:  EdgeInsets.only(left: 30),
// //                       child: SizedBox(
// //                         width: 400,
// //                         height: 40,
// //                         child: DropdownButtonFormField<String>(
// //                         //  value: _selectedDeliveryLocation,
// //                           decoration: InputDecoration(
// //                             filled: true,
// //                             fillColor: Colors.grey.shade200,
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(5.0),
// //                               borderSide: BorderSide.none,
// //                             ),
// //                             hintText: 'Select Location',
// //                             contentPadding:const EdgeInsets.symmetric(
// //                                 horizontal: 8, vertical: 8),
// //                           ),
// //                           onChanged: (String? value) {
// //                             // setState(() {
// //                             //   _selectedDeliveryLocation = value!;
// //                             // });
// //                           },
// //                           items: list.map<DropdownMenuItem<String>>((String value) {
// //                             return DropdownMenuItem<String>(
// //                               value: value,
// //                               child: Text(value),
// //                             );
// //                           }).toList(),
// //                           isExpanded: true,
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(height: 20),
// //                     Padding(
// //                       padding:  EdgeInsets.only(left: 30),
// //                       child: Text('Delivery Address'),
// //                     ),
// //                     SizedBox(height: 10,),
// //                     Padding(
// //                       padding:  EdgeInsets.only(left: 30),
// //                       child: SizedBox(
// //                         width: 400,
// //                         child: TextField(
// //                           //controller: deliveryaddressController,
// //                           decoration: InputDecoration(
// //                             filled: true,
// //                             fillColor:Colors.grey.shade200,
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(5.0),
// //                               borderSide: BorderSide.none,
// //                             ),
// //                             hintText: 'Enter Your Address',
// //                           ),
// //                           maxLines: 3,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(width: 30),
// //               Expanded(
// //                 flex: 3,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 10),
// //                       child: const Text('Contact Person'),
// //                     ),
// //                     SizedBox(height: 10,),
// //                     SizedBox(
// //                       width: 290,
// //                       height: 40,
// //                       child: TextField(
// //                         //controller: ContactPersonController,
// //                         decoration: InputDecoration(
// //                           filled: true,
// //                           fillColor: Colors.grey.shade200,
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(5.0),
// //                             borderSide: BorderSide.none,
// //                           ),
// //                           hintText: 'Contact Person Name',
// //                           contentPadding: const EdgeInsets.symmetric(
// //                               horizontal: 8, vertical: 8),
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(height: 20),
// //                     const Text('Contact Number'),
// //                     SizedBox(height: 10,),
// //                     SizedBox(
// //                       width: 290,
// //                       height: 40,
// //                       child: TextField(
// //                         //controller: ContactNumberController,
// //                         keyboardType:
// //                         TextInputType.number,
// //                         inputFormatters: [
// //                           FilteringTextInputFormatter
// //                               .digitsOnly,
// //                           LengthLimitingTextInputFormatter(
// //                               10),
// //                           // limits to 10 digits
// //                         ],
// //                         decoration: InputDecoration(
// //                           filled: true,
// //                           fillColor: Colors.grey.shade200,
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(5.0),
// //                             borderSide: BorderSide.none,
// //                           ),
// //                           hintText: 'Contact Person Number',
// //                           contentPadding: const EdgeInsets.symmetric(
// //                               horizontal: 8, vertical: 8),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         TableCell(
// //           child: Expanded(
// //             flex: 3,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text('    '),
// //                 Padding(
// //                   padding: const EdgeInsets.only(right: 10,left: 10,bottom: 5),
// //                   child: SizedBox(
// //                     height: 250,
// //                     child: TextField(
// //                       // controlleCommentsController,
// //                       decoration: InputDecoration(
// //                           filled: true,
// //                           fillColor: Colors.grey.shade200,
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(5.0),
// //                             borderSide: BorderSide.none,
// //                           ),
// //                           hintText: 'Enter Your Comments'
// //
// //
// //                       ),
// //                       maxLines: 5,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //
// //     return Scaffold(
// //       body:
// //       Padding(
// //         padding: const EdgeInsets.only(left: 250,right: 100,top: 250),
// //         child: Container(
// //             decoration: BoxDecoration(
// //                     border: Border.all(color: Color(0xFFB2C2D3)),
// //              borderRadius: BorderRadius.circular(3.5), // Set border radius here
// //           ),
// //           child: Table(
// //             border: TableBorder.all(color: Color(0xFFB2C2D3)),
// //
// //             columnWidths: {
// //               0: FlexColumnWidth(2),
// //               1: FlexColumnWidth(1.4),
// //             },
// //             children: [
// //               row1,
// //               row2,
// //               row3,
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// //
// //
// // void main(){
// //   runApp(MaterialApp(home: DeliveryLocation(),));
// // }
// //
// //
// // class DeliveryLocation extends StatefulWidget {
// //   const DeliveryLocation({Key? key}) : super(key: key);
// //
// //   @override
// //   _DeliveryLocationState createState() => _DeliveryLocationState();
// // }
// //
// // class _DeliveryLocationState extends State<DeliveryLocation> {
// //   final TextEditingController deliveryaddressController =
// //   TextEditingController();
// //   final TextEditingController ContactPersonController =
// //   TextEditingController();
// //   final TextEditingController ContactNumberController =
// //   TextEditingController();
// //   final TextEditingController CommentsController = TextEditingController();
// //
// //   String? _selectedDeliveryLocation;
// //   final List<String> list = [
// //     'Select Delivery Location',
// //     'Location 1',
// //     'Location 2',
// //     'Location 3'
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(),
// //       body:
// //       Padding(
// //         padding: const EdgeInsets.only(left: 50, top: 50, right: 100),
// //         child: Container(
// //           height: 380,
// //           width: 2100,
// //           padding: const EdgeInsets.all(2),
// //           decoration: BoxDecoration(
// //             border: Border.all(color: Colors.grey, width: 2),
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           child: Stack(
// //             children: [
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.only(left: 30, top: 10),
// //                     child: Text(
// //                       'Delivery Location',
// //                       style: TextStyle(
// //                         fontSize: 18.0,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                   Text(
// //                     'Address',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w400,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.only(left: 30, right: 30),
// //                     child: Row(
// //                       children: [
// //
// //                         Expanded(
// //                           child: Container(
// //                             height: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //
// //                         Expanded(
// //                           child: Container(
// //                             height: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
// //                           child: Container(
// //                             height: 350,
// //                             width: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                         Expanded(
// //                           child: Container(
// //                             height: 1,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //
// //     );
// //
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// void main(){
//   runApp(MaterialApp(
//     home:TableExample() ,
//   ));
// }
// class TableExample extends StatelessWidget {
//   final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
//   @override
//   Widget build(BuildContext context) {
//     TableRow row1 = TableRow(
//       children: [
//         const TableCell(
//           child: Padding(
//             padding: EdgeInsets.only(left: 30,top: 10,bottom: 10),
//             child: Text('Delivery Location'),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.only(left
//                 : 140),
//             child: Row(
//               children: [
//                 const Text(
//                   'Order Date',
//                   style: TextStyle(
//                     fontSize: 16,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 DecoratedBox(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Container(
//                     height: 35,
//                     width: 175,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(1),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: TextFormField(
//                       // enabled: isEditing,
//                       // controller: CreatedDateController,
//                       readOnly: true,
//                       decoration: InputDecoration(
//                         suffixIcon: Padding(
//                           padding: const EdgeInsets.only(right: 20),
//                           child: IconButton(
//                             icon: const Icon(Icons.calendar_month),
//                             iconSize: 20,
//                             onPressed: () {
//                               //   _showDatePicker(context);
//                             },
//                           ),
//                         ),
//                         // hintText: _selectedDate != null
//                         //     ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
//                         //     : 'Select Date',
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         border: InputBorder.none,
//                         filled: true,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//
//     TableRow row2 = const TableRow(
//       children: [
//         TableCell(
//           child: Padding(
//             padding: EdgeInsets.only(left: 30,top: 10,bottom: 10),
//             child: Text('Address'),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
//             child: Text('Comments'),
//           ),
//         ),
//       ],
//     );
//     TableRow row3 = TableRow(
//       children: [
//         TableCell(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding:  EdgeInsets.only(left: 30,top: 10),
//                       child: Text('Select Delivery Location'),
//                     ),
//                     const SizedBox(height: 10,),
//                     Padding(
//                       padding:  const EdgeInsets.only(left: 30),
//                       child: SizedBox(
//                         width: 400,
//                         height: 40,
//                         child: DropdownButtonFormField<String>(
//                           //  value: _selectedDeliveryLocation,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.grey.shade200,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: BorderSide.none,
//                             ),
//                             hintText: 'Select Location',
//                             contentPadding:const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 8),
//                           ),
//                           onChanged: (String? value) {
//                             // setState(() {
//                             //   _selectedDeliveryLocation = value!;
//                             // });
//                           },
//                           items: list.map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           isExpanded: true,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Padding(
//                       padding:  EdgeInsets.only(left: 30),
//                       child: Text('Delivery Address'),
//                     ),
//                     const SizedBox(height: 10,),
//                     Padding(
//                       padding:  const EdgeInsets.only(left: 30),
//                       child: SizedBox(
//                         width: 400,
//                         child: TextField(
//                           //controller: deliveryaddressController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor:Colors.grey.shade200,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: BorderSide.none,
//                             ),
//                             hintText: 'Enter Your Address',
//                           ),
//                           maxLines: 3,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 30),
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: Text('Contact Person'),
//                     ),
//                     const SizedBox(height: 10,),
//                     SizedBox(
//                       width: 290,
//                       height: 40,
//                       child: TextField(
//                         //controller: ContactPersonController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             borderSide: BorderSide.none,
//                           ),
//                           hintText: 'Contact Person Name',
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 8),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text('Contact Number'),
//                     const SizedBox(height: 10,),
//                     SizedBox(
//                       width: 290,
//                       height: 40,
//                       child: TextField(
//                         //controller: ContactNumberController,
//                         keyboardType:
//                         TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter
//                               .digitsOnly,
//                           LengthLimitingTextInputFormatter(
//                               10),
//                           // limits to 10 digits
//                         ],
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             borderSide: BorderSide.none,
//                           ),
//                           hintText: 'Contact Person Number',
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         TableCell(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('    '),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 10,left: 10,bottom: 5),
//                       child: SizedBox(
//                         height: 250,
//                         child: TextField(
//                           // controlleCommentsController,
//                           decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.grey.shade200,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 borderSide: BorderSide.none,
//                               ),
//                               hintText: 'Enter Your Comments'
//
//
//                           ),
//                           maxLines: 5,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//
//     return Scaffold(
//       body:
//       Padding(
//         padding: const EdgeInsets.only(left: 250,right: 100,top: 250),
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFFB2C2D3)),
//             borderRadius: BorderRadius.circular(3.5), // Set border radius here
//           ),
//           child: Table(
//             border: TableBorder.all(color: const Color(0xFFB2C2D3)),
//
//             columnWidths: {
//               0: const FlexColumnWidth(2),
//               1: const FlexColumnWidth(1.4),
//             },
//             children: [
//               row1,
//               row2,
//               row3,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'File Upload and Download',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: UploadPage(),
//     );
//   }
// }
//
// class UploadPage extends StatefulWidget {
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   final Dio _dio = Dio();
//   String? _fileName;
//   String? _filePath;
//
//
//
//   Future<void> _pickFile() async {
//     // Request storage permission
//     var status = await Permission.storage.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Storage permission is required to pick a file.'),
//       ));
//       return;
//     }
//
//     // Pick a file
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _fileName = result.files.single.name;
//         _filePath = result.files.single.path;
//       });
//     }
//   }
//
//
//
//   Future<void> _uploadFile() async {
//     if (_filePath == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('No file selected to upload.'),
//       ));
//       return;
//     }
//
//     try {
//       FormData formData = FormData.fromMap({
//         'file': await MultipartFile.fromFile(_filePath!, filename: _fileName),
//       });
//
//       // Replace 'https://example.com/upload' with your upload URL
//       final response = await _dio.post('https://example.com/upload', data: formData);
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('File uploaded successfully: ${response.data}'),
//       ));
//
//       // Navigate to the download page with the file URL
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DownloadPage(fileUrl: 'https://example.com/sample.pdf'), // Replace with your file URL
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error uploading file: $e'),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload File'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_fileName != null ? 'Selected file: $_fileName' : 'No file selected'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickFile,
//               child: Text('Pick File'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _uploadFile,
//               child: Text('Upload File'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DownloadPage extends StatefulWidget {
//   final String fileUrl;
//
//   DownloadPage({required this.fileUrl});
//
//   @override
//   _DownloadPageState createState() => _DownloadPageState();
// }
//
// class _DownloadPageState extends State<DownloadPage> {
//   final Dio _dio = Dio();
//
//   Future<void> _downloadFile() async {
//     try {
//       // Check storage permission
//       var status = await Permission.storage.request();
//       if (!status.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Storage permission is required to download the file.'),
//         ));
//         return;
//       }
//
//       // Get the download directory
//       Directory? downloadDir = Directory('/storage/emulated/0/Download');
//       if (!downloadDir.existsSync()) {
//         downloadDir = await getExternalStorageDirectory();
//       }
//
//       // Download the file
//       final filePath = '${downloadDir?.path}/sample.pdf'; // Adjust the file name if needed
//       await _dio.download(widget.fileUrl, filePath);
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('File downloaded successfully to $filePath'),
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error downloading file: $e'),
//       ));
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _downloadFile(); // Start the download when the page is opened
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Download PDF'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Downloading...'),
//           ],
//         ),
//       ),
//     );
//   }
// }


// main.dart
// main.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'File Upload and Download',
//       home: UploadScreen(),
//       routes: {
//         '/download': (context) => DownloadScreen(),
//       },
//     );
//   }
// }
//
// class FileService with ChangeNotifier {
//   List<File> _files = [];
//
//   List<File> get files => _files;
//
//   Future<void> uploadFile() async {
//     final file = await FilePicker.platform.pickFiles(type: FileType.any);
//     if (file!= null) {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/${file.names}';
//       await File(file.paths as String).copy(filePath);
//       _files.add(File(filePath));
//       notifyListeners();
//     }
//   }
//
//   Future<void> downloadFile(File file) async {
//     final directory = await getExternalStorageDirectory();
//     final filePath = '${directory?.path}/${file.path.split('/').last}';
//     await file.copy(filePath);
//   }
// }
//
// class UploadScreen extends StatefulWidget {
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }
//
// class _UploadScreenState extends State<UploadScreen> {
//   FileService _fileService = FileService();
//   final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _navigatorKey,
//       appBar: AppBar(
//         title: Text('Upload File'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await _fileService.uploadFile();
//             _navigatorKey.currentState?.pushNamed('/download');
//           },
//           child: Text('Upload File'),
//         ),
//       ),
//     );
//   }
// }
//
// class DownloadScreen extends StatefulWidget {
//   @override
//   _DownloadScreenState createState() => _DownloadScreenState();
// }
//
// class _DownloadScreenState extends State<DownloadScreen> {
//   FileService _fileService = FileService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Download File'),
//       ),
//       body: ListView.builder(
//         itemCount: _fileService.files.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_fileService.files[index].path.split('/').last),
//             trailing: IconButton(
//               icon: Icon(Icons.download),
//               onPressed: () async {
//                 await _fileService.downloadFile(_fileService.files[index]);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('File downloaded')),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Download',
      home: DownloadScreen(),
    );
  }
}

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download File'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final url = 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster';
            final response = await html.HttpRequest.request(url, responseType: 'blog');
            final blob = response.response;
            final anchor = html.AnchorElement(href: html.Url.createObjectUrl(blob));
            anchor.download = 'file.pdf';
            anchor.click();
            html.Url.revokeObjectUrl(anchor.href ?? '');
          },
          child: Text('Download File'),
        ),
      ),
    );
  }
}