// import 'dart:convert';
// import 'dart:html';
// import 'dart:io' as io;
// import 'package:btb/thirdpage/thirdpage.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:btb/seconpage/image_picker_service.dart';
// import 'package:btb/seconpage/product_form.dart';
// import 'package:image_picker/image_picker.dart'; // Import the ProductForm widget
//
// class SecondPage extends StatefulWidget {
//   @override
//   State<SecondPage> createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   String? pickedImagePath;
//   String token = window.sessionStorage["token"] ?? " ";
//   String? imagePath;
//   io.File? selectedImage;
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   final TextEditingController subCategoryController = TextEditingController();
//   final TextEditingController taxController = TextEditingController();
//   final TextEditingController unitController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController discountController = TextEditingController();
//
//   // Function to check if all required fields are filled
//   bool areRequiredFieldsFilled() {
//     return productNameController.text.isNotEmpty &&
//         categoryController.text.isNotEmpty &&
//         taxController.text.isNotEmpty &&
//         unitController.text.isNotEmpty &&
//         priceController.text.isNotEmpty &&
//         discountController.text.isNotEmpty &&
//         imagePath != null;
//   }
//
//   void _openGallery() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       maxWidth: 150,
//     );
//     if (pickedImage != null) {
//       setState(() {
//         selectedImage = pickedImage == null ? null : io.File(pickedImage.path);
//         imagePath = pickedImage.path;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Image selected")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Image selection cancelled")),
//       );
//     }
//   }
//
//   void checkSave(
//     String ProductName,
//     String category,
//     String subCategory,
//     String tax,
//     String unit,
//     int price,
//     String discount,
//   ) async {
//     if (!areRequiredFieldsFilled()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill in all required fields")),
//       );
//       return;
//     }
//
//     final productData = {
//       "productName": productNameController.text,
//       "category": categoryController.text,
//       "subCategory": subCategoryController.text,
//       "tax": taxController.text,
//       "unit": unitController.text,
//       "price": int.parse(priceController.text),
//       "discount": discountController.text,
//     };
//     final url =
//         'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/add_productmaster';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': 'Bearer ${token}'
//       },
//       body: json.encode(productData),
//     );
//
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//
//       if (responseData.containsKey("error")) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to add product: error")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Product added successfully")),
//         );
//         if (pickedImagePath != null) {
//           final imageResponse = await http.post(
//             Uri.parse(
//                 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/upload'),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer ${token}'
//             },
//             body: json.encode({
//               "imagePath": pickedImagePath,
//               "productName": productNameController.text,
//               "category": categoryController.text,
//               // additional data if needed
//             }),
//           );
//
//           if (imageResponse.statusCode == 200) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Image uploaded successfully")),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Failed to upload image")),
//             );
//           }
//         }
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ProductList()),
//         );
//       }
//       // } else {
//       //   // Add logging to understand why the request failed
//       //   debugPrint(
//       //       'Failed to add product. Status code: ${productResponse.statusCode}');
//       //   debugPrint('Response body: ${productResponse.body}');
//       //
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     const SnackBar(content: Text("Failed to add product")),
//       //   );
//       // }
//     }
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
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             if (constraints.maxWidth > 600) {
//               // For web view
//               return Stack(
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: _openGallery,
//                         child: Container(
//                           margin: EdgeInsets.only(
//                             top: 20,
//                             left: 290,
//                           ),
//                           width: 500,
//                           height: 450,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.cloud_upload,
//                                   color: Colors.blue[900], size: 40),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Click to upload image',
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'SVG, PNG, JPG, or GIF Recommended size (1000px * 1248px)',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: ProductForm(), // Use the ProductForm widget here
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: EdgeInsets.only(
//                         left: 200, // Adjust left padding
//                         right: 120, // Adjust right padding
//                       ),
//                       color: Colors.white,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back), // Back button icon
//                             onPressed: () {
//                               // Implement back button action
//                             },
//                           ),
//                           Text(
//                             'Add New Product',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Spacer(),
//                           OutlinedButton(
//                             onPressed: () {
//                               productNameController.clear();
//                               categoryController.clear();
//                               subCategoryController.clear();
//                               taxController.clear();
//                               unitController.clear();
//                               priceController.clear();
//                               discountController.clear();
//
//                               // Optionally, display a message
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Form cleared")),
//                               );
//                             },
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.grey[400], // Button background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(5), // Rounded corners
//                               ),
//                               side: BorderSide.none, // No outline
//                             ),
//                             child: Text(
//                               'Cancel',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           OutlinedButton(
//                             onPressed: () {
//                               token = window.sessionStorage["token"] ?? " ";
//                               print("token");
//                               print(token);
//                               if (!areRequiredFieldsFilled()) {
//                                 if (mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             "Please fill in all required fields")),
//                                   );
//                                 }
//                               } else {
//                                 checkSave(
//                                   productNameController.text,
//                                   categoryController.text,
//                                   subCategoryController.text,
//                                   taxController.text,
//                                   unitController.text,
//                                   int.parse(priceController.text),
//                                   // Ensure this is a valid integer
//                                   discountController.text,
//                                 );
//                               }
//                             },
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.blue, // Button background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(5), // Rounded corners
//                               ),
//                               side: BorderSide.none, // No outline
//                             ),
//                             child: Text(
//                               'Save2',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Align(
//                     // Added Align widget for the left side menu
//                     alignment: Alignment.topLeft,
//                     child: Container(
//                       padding: EdgeInsets.only(left: 20, top: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon:
//                                 Icon(Icons.dashboard, color: Colors.blue[900]),
//                             label: Text('Home'),
//                           ),
//                           SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.warehouse_outlined,
//                                 color: Colors.blue[900]),
//                             label: Text('Orders'),
//                           ),
//                           SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.fire_truck_outlined,
//                                 color: Colors.blue[900]),
//                             label: Text('Delivery'),
//                           ),
//                           SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.document_scanner_rounded,
//                                 color: Colors.blue[900]),
//                             label: Text('Invoice'),
//                           ),
//                           SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.payment_outlined,
//                                 color: Colors.blue[900]),
//                             label: Text('Payment'),
//                           ),
//                           SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.backspace_sharp,
//                                 color: Colors.blue[900]),
//                             label: Text('Return'),
//                           ),
//                           SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.insert_chart,
//                                 color: Colors.blue[900]),
//                             label: Text('Reports'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               // For mobile view
//               return Stack(
//                 children: [
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           ImagePickerService().openImagePicker(context);
//                           print('Open file picker');
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(top: 20),
//                           width: double.infinity,
//                           height: 200,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.cloud_upload,
//                                   color: Colors.blue[900], size: 40),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Click to upload image',
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'SVG, PNG, JPG, or GIF Recommended size (1000px * 1248px)',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child:
//                                 ProductForm(), // Use the ProductForm widget here
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       color: Colors.white,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back), // Back button icon
//                             onPressed: () {
//                               // Implement back button action
//                             },
//                           ),
//                           Expanded(
//                             child: Text(
//                               'Add New Product',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           OutlinedButton(
//                             onPressed: () {
//                               productNameController.clear();
//                               categoryController.clear();
//                               subCategoryController.clear();
//                               taxController.clear();
//                               unitController.clear();
//                               priceController.clear();
//                               discountController.clear();
//
//                               // Optionally, display a message
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Form cleared")),
//                               );
//                             },
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.grey[400], // Button background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(5), // Rounded corners
//                               ),
//                               side: BorderSide.none, // No outline
//                             ),
//                             child: Text(
//                               'Cancel',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           OutlinedButton(
//                             onPressed: () {
//                               // Implement save button action
//                             },
//                             style: OutlinedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.blue, // Button background color
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(5), // Rounded corners
//                               ),
//                               side: BorderSide.none, // No outline
//                             ),
//                             child: Text(
//                               'Save',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
