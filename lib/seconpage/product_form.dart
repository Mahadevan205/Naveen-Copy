// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'package:btb/thirdpage/thirdpage.dart';
// import '../thirdpage/thirdpage.dart';
//
// class ProductForm extends StatefulWidget {
//   @override
//   State<ProductForm> createState() => _ProductFormState();
// }
//
// class _ProductFormState extends State<ProductForm> {
//   String token = '';
//   String? pickedImagePath;
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
//         discountController.text.isNotEmpty;
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
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > 600) {
//           // For larger screens (like web view)
//           return Padding(
//             padding: const EdgeInsets.only(
//               left: 180,
//               top: 220,
//               right: 250,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Text('Product  Name*'),
//                     ),
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4),
//                           border: Border.all(color: Colors.blue[100]!),
//                         ),
//                         child: TextFormField(
//                           controller: productNameController,
//                           decoration: InputDecoration(
//                             fillColor: Colors.white,
//                             contentPadding:
//                                 EdgeInsets.symmetric(horizontal: 10),
//                             border: InputBorder.none,
//                             filled: true,
//                             hintText: 'Enter product name',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('Category*'),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: Colors.blue[100]!),
//                               ),
//                               child: TextFormField(
//                                 controller: categoryController,
//                                 decoration: InputDecoration(
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 10),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   hintText: 'Enter Category',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('Sub Category*'),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: Colors.blue[100]!),
//                               ),
//                               child: TextFormField(
//                                 controller: subCategoryController,
//                                 decoration: InputDecoration(
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 10),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   hintText: 'Enter Sub Category',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('Tax*'),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: Colors.blue[100]!),
//                               ),
//                               child: TextFormField(
//                                 controller: taxController,
//                                 decoration: InputDecoration(
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 10),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   hintText: 'Enter tax',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('Unit*'),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: Colors.blue[100]!),
//                               ),
//                               child: TextFormField(
//                                 controller: unitController,
//                                 decoration: InputDecoration(
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 10),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   hintText: 'Enter Unit',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('Price *'),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: Colors.blue[100]!),
//                               ),
//                               child: TextFormField(
//                                 controller: priceController,
//                                 decoration: InputDecoration(
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 10),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   hintText: 'Enter Price',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Text('Discount'),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                                 border: Border.all(color: Colors.blue[100]!),
//                               ),
//                               child: TextFormField(
//                                 controller: discountController,
//                                 decoration: InputDecoration(
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 10),
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   hintText: 'Enter Discount',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     OutlinedButton(
//                       onPressed: () {
//                         productNameController.clear();
//                         categoryController.clear();
//                         subCategoryController.clear();
//                         taxController.clear();
//                         unitController.clear();
//                         priceController.clear();
//                         discountController.clear();
//
//                         // Optionally, display a message
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Form cleared")),
//                         );
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor:
//                             Colors.grey[400], // Blue background color
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(5), // Rounded corners
//                         ),
//                         side: BorderSide.none, // No outline
//                       ),
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 18, // Increase font size if desired
//                           fontWeight: FontWeight.bold, // Bold text
//                           color: Colors.white, // White text color
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     OutlinedButton(
//                       onPressed: () {
//                         token = window.sessionStorage["token"] ?? " ";
//                         print("token");
//                         print(token);
//                         if (!areRequiredFieldsFilled()) {
//                           if (mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text(
//                                       "Please fill in all required fields")),
//                             );
//                           }
//                         } else {
//                           checkSave(
//                             productNameController.text,
//                             categoryController.text,
//                             subCategoryController.text,
//                             taxController.text,
//                             unitController.text,
//                             int.parse(priceController
//                                 .text), // Ensure this is a valid integer
//                             discountController.text,
//                           );
//                         }
//                       },
//                       child: Text("SaveTo"),
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.blue, // Blue background color
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(5), // Rounded corners
//                         ),
//                         side: BorderSide.none, // No outline
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         } else {
//           // For smaller screens (like mobile view)
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 16),
//                 Text(
//                   'Product Name*',
//                 ),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'Enter product name',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.blue[100]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Category*',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'Enter category',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.blue[100]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Sub Category',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'Enter Sub category',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.blue[100]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Tax*',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'Enter tax',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.blue[100]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Unit*',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'Enter Unit',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.blue[100]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Price*',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'Enter Price',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.blue[100]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Discount*',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.white,
//                     hintText: 'Enter Discount',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(4),
//                       borderSide: BorderSide(color: Colors.blue[100]!),
//                     ),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     OutlinedButton(
//                       onPressed: () {
//                         // Implement cancel button action
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor:
//                             Colors.grey[400], // Blue background color
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(5), // Rounded corners
//                         ),
//                         side: BorderSide.none, // No outline
//                       ),
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 18, // Increase font size if desired
//                           fontWeight: FontWeight.bold, // Bold text
//                           color: Colors.white, // White text color
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 16),
//                     OutlinedButton(
//                       onPressed: () {
//                         token = window.sessionStorage["token"] ?? " ";
//                         print("token");
//                         print(token);
//                         if (!areRequiredFieldsFilled()) {
//                           if (mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text(
//                                       "Please fill in all required fields")),
//                             );
//                           }
//                         } else {
//                           checkSave(
//                             productNameController.text,
//                             categoryController.text,
//                             subCategoryController.text,
//                             taxController.text,
//                             unitController.text,
//                             int.parse(priceController
//                                 .text), // Ensure this is a valid integer
//                             discountController.text,
//                           );
//                         }
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.blue, // Blue background color
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(5), // Rounded corners
//                         ),
//                         side: BorderSide.none, // No outline
//                       ),
//                       child: Text(
//                         'SaveTo',
//                         style: TextStyle(
//                           fontSize: 18, // Increase font size if desired
//                           fontWeight: FontWeight.bold, // Bold text
//                           color: Colors.white, // White text color
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }
