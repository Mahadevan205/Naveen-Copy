// import 'dart:convert';
// import 'dart:html';
// import 'dart:io' as io;
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:btb/thirdpage/productclass.dart' as ord;
// import '../main.dart';
//
// // void main() {
// //   runApp(EditOrder1(
// //     selectedProduct: null,
// //   ));
// // }
//
// class EditOrder1 extends StatefulWidget {
//   final ord.Product selectedProduct;
//
//   EditOrder1({required this.selectedProduct});
//
//   @override
//   State<EditOrder1> createState() => _EditOrder1State();
// }
//
// class _EditOrder1State extends State<EditOrder1> {
//   String? pickedImagePath;
//   String token = window.sessionStorage["token"] ?? " ";
//   String? imagePath;
//   io.File? selectedImage;
//   bool isOrdersSelected = false;
//   String? errorMessage;
//   bool purchaseOrderError = false;
//
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController discountController = TextEditingController();
//   final TextEditingController imageIdController = TextEditingController();
//   final List<String> list = ['Select', 'Select 1', 'Select 2', 'Select 3'];
//   String dropdownValue = 'Select';
//   final List<String> list1 = ['select', '12', '18', '28', '10'];
//   String? selectedDropdownItem;
//   String dropdownValue1 = 'select';
//   String imageName = '';
//   List<Uint8List> selectedImages = [];
//   String storeImage = '';
//   final List<String> list2 = ['select', 'PCS', 'NOS', 'PKT'];
//   String dropdownValue2 = 'select';
//   final List<String> list3 = ['select', 'Yes', 'No'];
//   String dropdownValue3 = 'select';
//   final _validate = GlobalKey<FormState>();
//   var result;
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();
//   final TextEditingController subCategoryController = TextEditingController();
//   final TextEditingController taxController = TextEditingController();
//   final TextEditingController unitController = TextEditingController();
//   bool isHomeSelected = false;
//
//   // Function to check if all required fields are filled
//   bool areRequiredFieldsFilled() {
//     return productNameController.text.isNotEmpty &&
//         dropdownValue != 'Select' &&
//         dropdownValue3 != 'Select' &&
//         dropdownValue1 != 'select' &&
//         dropdownValue2 != 'select' &&
//         dropdownValue3 != 'select' &&
//         priceController.text.isNotEmpty &&
//         discountController.text.isNotEmpty &&
//         selectedImages.isNotEmpty;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.selectedProduct != null) {
//       productNameController.text = widget.selectedProduct.productName;
//       categoryController.text = widget.selectedProduct.category;
//       subCategoryController.text = widget.selectedProduct.subCategory;
//       taxController.text = widget.selectedProduct.tax.toString();
//       unitController.text = widget.selectedProduct.unit;
//       priceController.text = widget.selectedProduct.price.toString();
//       discountController.text = widget.selectedProduct.discount.toString();
//       imageIdController.text = widget.selectedProduct.imageId;
//       //storeImage = widget.selectedProduct.imagePath;
//       dropdownValue = widget.selectedProduct.category;
//       dropdownValue1 = widget.selectedProduct.tax.toString();
//       dropdownValue2 = widget.selectedProduct.unit;
//       dropdownValue3 = widget.selectedProduct.subCategory;
//       selectedImages = [base64Decode(widget.selectedProduct.imageId)];
//     }
//   }
//   // this is old arerequiredfields
//   // bool areRequiredFieldsFilled() {
//   //   return productNameController.text.isNotEmpty &&
//   //       categoryController.text.isNotEmpty &&
//   //       taxController.text.isNotEmpty &&
//   //       unitController.text.isNotEmpty &&
//   //       priceController.text.isNotEmpty &&
//   //       discountController.text.isNotEmpty &&
//   //       // selectedImage != null &&
//   //       // imagePath == null &&
//   //       imageIdController.text.isNotEmpty;
//   // }
//
//   // List<Uint8List> selectedImages = []; // Store the selected image data
//   // String storeImage = '';
//   Future<void> filePicker() async {
//     result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result == null) {
//       print("No file selected");
//     } else {
//       setState(() {
//         selectedImages.clear(); // Clear previous selections
//       });
//       for (var element in result!.files) {
//         setState(() {
//           print(element.name);
//           imageIdController.text = element.name;
//           storeImage = element.name;
//           // Post api call.
//           uploadImage(element.name); // Pass image bytes to uploadImage
//           selectedImages.add(element.bytes!);
//         });
//         // Store the image data
//       }
//     }
//   }
//
//   Future<void> uploadImage(String name) async {
//     print('---------------');
//     print(name);
//     String url =
//         'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/upload';
//     try {
//       if (result != null) {
//         for (var element in result!.files) {
//           // Prepare the multipart request
//           var request = http.MultipartRequest('POST', Uri.parse(url));
//
//           // Add the file to the request
//           request.files.add(http.MultipartFile.fromBytes(
//             'file',
//             element.bytes!,
//             filename: element.name,
//           ));
//
//           // Send the request
//           var streamedResponse = await request.send();
//           // Get the response
//           var response = await http.Response.fromStream(streamedResponse);
//
//           // Check if the request was successful
//           if (response.statusCode == 200) {
//             print('Image uploaded successfully!');
//             print(response.body);
//           } else {
//             print(
//                 'Failed to upload image. Status code: ${response.statusCode}');
//           }
//         }
//       } else {
//         print('No file selected');
//       }
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
//
//   void checkSave(
//     String ProductName,
//     String category,
//     String subCategory,
//     String tax,
//     String unit,
//     double price,
//     String discount,
//     String imageId,
//   ) async {
//     if (!areRequiredFieldsFilled()) {
//       // if (imagePath == null || selectedImage == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please fill in all required fields")),
//         );
//       }
//       // }
//       return;
//     }
//
//     final productData = {
//       "productName": productNameController.text,
//       "category": dropdownValue,
//       "subCategory": dropdownValue3,
//       "tax": dropdownValue1,
//       "unit": dropdownValue2,
//       "price": double.parse(priceController.text),
//       "discount": discountController.text,
//       "imageId": storeImage,
//     };
//     print('---------productData------');
//     print(productData);
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
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("please pick image")),
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
//               // "category": categoryController.text,
//               // additional data if needed
//             }),
//           );
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
//         if (imagePath == null || selectedImage == null) {
//           print('--------if condition-------');
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Please Pick Image")),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Product added successfully")),
//           );
//           // subsubPage1
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => ProductPage(product: null)),
//           // );
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedProduct = widget.selectedProduct;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Color(0xFFFFFFFF),
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: Color(0xFFFFFFFF), // Set background color to white
//           elevation: 4.0,
//           shadowColor: Color(0xFFFFFFFF), // Set shadow color to black
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
//               padding: const EdgeInsets.only(right: 150),
//               child: IconButton(
//                 icon: Icon(Icons.account_circle),
//                 onPressed: () {
//                   // Handle user icon press
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             if (constraints.maxWidth > 1200) {
//               // For web view
//               return Stack(children: [
//                 Positioned(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 200),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       color: Colors.white,
//                       height: 60,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back), // Back button icon
//                             onPressed: () {
//                               context.go(
//                                   '${PageName.dashboardRoute}/${PageName.subpage2}');
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //       builder: (context) =>
//                               //           ProductPage(product: null)),
//                               // );
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 30),
//                             child: Text(
//                               'Edit',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 1200),
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => SecondPage()),
//                                 // );
//                                 //   cancel button code
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors
//                                     .blueAccent, // Button background color
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       5), // Rounded corners
//                                 ),
//                                 side: BorderSide.none, // No outline
//                               ),
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 70,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(),
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 print('onpressed');
//                                 //update button condition
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => SecondPage()),
//                                 // );
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors
//                                     .blueAccent, // Button background color
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       5), // Rounded corners
//                                 ),
//                                 side: BorderSide.none, // No outline
//                               ),
//                               child: Text(
//                                 'Update',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 43, left: 200),
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 10), // Space above/below the border
//                     height: 3, // Border height
//                     color: Colors.grey[100], // Border color
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Align(
//                       // Added Align widget for the left side menu
//                       alignment: Alignment.topLeft,
//                       child: Container(
//                         height: 1400,
//                         width: 200,
//                         color: Color(0xFFF7F6FA),
//                         padding: EdgeInsets.only(left: 20, top: 30),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextButton.icon(
//                               onPressed: () {
//                                 context.go(
//                                     '${PageName.main}/${PageName.subpage1Main}');
//                               },
//                               icon: Icon(Icons.dashboard,
//                                   color: Colors.indigo[900]),
//                               label: Text(
//                                 'Home',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => Dashboard()),
//                                 // );
//                                 setState(() {
//                                   isOrdersSelected = false;
//                                   // Handle button press19
//                                 });
//                               },
//                               icon: Icon(Icons.warehouse,
//                                   color: isOrdersSelected
//                                       ? Colors.blueAccent
//                                       : Colors.blueAccent),
//                               label: Text(
//                                 'Orders',
//                                 style: TextStyle(
//                                   color: Colors.blueAccent,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.fire_truck_outlined,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Delivery',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.document_scanner_rounded,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Invoice',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.payment_outlined,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Payment',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.backspace_sharp,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Return',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.insert_chart,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Reports',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         print('---imagePath---');
//                         print(imagePath);
//                         print(selectedImage);
//                         filePicker();
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           top: 20,
//                           left: 130,
//                         ),
//                         width: 500,
//                         height: 450,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             for (var imageBytes in selectedImages)
//                               Image.memory(
//                                 imageBytes,
//                                 fit: BoxFit.cover,
//                                 width: 300, // Adjust as needed
//                                 height: 300, // Adjust as needed
//                               ),
//                             Icon(Icons.cloud_upload_outlined,
//                                 color: Colors.blue[900], size: 50),
//                             SizedBox(height: 8),
//                             Text(
//                               'Click to upload image',
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'SVG, PNG, JPG, or GIF Recommended size (1000px * 1248px)',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 180,
//                           top: 220,
//                           right: 250,
//                         ),
//                         child: Form(
//                           key: _validate,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(4.0),
//                                     child: Text('Product  Name*'),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(4),
//                                         border: Border.all(
//                                             color: Colors.blue[100]!),
//                                       ),
//                                       child: TextFormField(
//                                         controller: productNameController,
//                                         decoration: InputDecoration(
//                                           fillColor: Colors.white,
//                                           contentPadding: EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           border: InputBorder.none,
//                                           filled: true,
//                                           hintText: 'Enter product name',
//                                           errorText: errorMessage,
//                                         ),
//                                         inputFormatters: [
//                                           FilteringTextInputFormatter.allow(
//                                               RegExp("[a-zA-Z0-9 ]")),
//                                           // Allow only letters, numbers, and single space
//                                           FilteringTextInputFormatter.deny(
//                                               RegExp(r'^\s')),
//                                           // Disallow starting with a space
//                                           FilteringTextInputFormatter.deny(
//                                               RegExp(r'\s\s')),
//                                           // Disallow multiple spaces
//                                         ],
//                                         validator: (value) {
//                                           if (value != null &&
//                                               value.trim().isEmpty) {
//                                             return 'Please enter a product name';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Category*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 900,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 200),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue = value!;
//                                                     });
//                                                   },
//                                                   items: list.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Sub Category*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 900,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue3,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 220),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue3 = value!;
//                                                     });
//                                                   },
//                                                   items: list3.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Tax*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 700,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue1,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 215),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue1 = value!;
//                                                     });
//                                                   },
//                                                   items: list1.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Unit*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 700,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue2,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 220),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue2 = value!;
//                                                     });
//                                                   },
//                                                   items: list2.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Price *'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: TextFormField(
//                                               controller: priceController,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .digitsOnly,
//                                                 LengthLimitingTextInputFormatter(
//                                                     10),
//                                                 // limits to 10 digits
//                                               ],
//                                               decoration: InputDecoration(
//                                                 fillColor: Colors.white,
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 border: InputBorder.none,
//                                                 filled: true,
//                                                 hintText: 'Enter Price',
//                                                 errorText: errorMessage,
//                                               ),
//                                               onChanged: (value) {
//                                                 if (value.isNotEmpty &&
//                                                     !isNumeric(value)) {
//                                                   setState(() {
//                                                     errorMessage =
//                                                         'Please enter numbers only';
//                                                   });
//                                                 } else {
//                                                   setState(() {
//                                                     errorMessage = null;
//                                                   });
//                                                 }
//                                               },
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Discount'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: TextFormField(
//                                               controller: discountController,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .digitsOnly,
//                                                 LengthLimitingTextInputFormatter(
//                                                     10),
//                                                 // limits to 10 digits
//                                               ],
//                                               decoration: InputDecoration(
//                                                 fillColor: Colors.white,
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 border: InputBorder.none,
//                                                 filled: true,
//                                                 hintText: 'Enter Discount',
//                                                 errorText: errorMessage,
//                                               ),
//                                               onChanged: (value) {
//                                                 if (value.isNotEmpty &&
//                                                     !isNumeric(value)) {
//                                                   setState(() {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                       const SnackBar(
//                                                           content: Text(
//                                                               "Please enter decimal number only")),
//                                                     );
//                                                   });
//                                                 } else {
//                                                   setState(() {
//                                                     errorMessage = null;
//                                                   });
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   // OutlinedButton(
//                                   //   onPressed: () {
//                                   //     dropdownValue = 'Select';
//                                   //     dropdownValue3 = 'select';
//                                   //     dropdownValue1 = 'select';
//                                   //     dropdownValue2 = 'select';
//                                   //     productNameController.clear();
//                                   //     // // //dropdownValue.clear();
//                                   //     // // // subCategoryController.clear();
//                                   //     // // // taxController.clear();
//                                   //     // //unitController.clear();
//                                   //     priceController.clear();
//                                   //     selectedImages.clear();
//                                   //     imageIdController.clear();
//                                   //     discountController.clear();
//                                   //     setState(() {});
//                                   //
//                                   //     // Optionally, display a message
//                                   //     ScaffoldMessenger.of(context)
//                                   //         .showSnackBar(
//                                   //       const SnackBar(
//                                   //           content: Text("Form cleared")),
//                                   //     );
//                                   //   },
//                                   //   style: OutlinedButton.styleFrom(
//                                   //     backgroundColor: Colors
//                                   //         .grey[400], // Blue background color
//                                   //     shape: RoundedRectangleBorder(
//                                   //       borderRadius: BorderRadius.circular(
//                                   //           5), // Rounded corners
//                                   //     ),
//                                   //     side: BorderSide.none, // No outline
//                                   //   ),
//                                   //   child: Text(
//                                   //     'Cancel',
//                                   //     style: TextStyle(
//                                   //       fontSize: 15,
//                                   //       // Increase font size if desired
//                                   //       // Bold text
//                                   //       color: Colors
//                                   //           .indigo[900], // White text color
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   // SizedBox(width: 16),
//                                   // OutlinedButton(
//                                   //   onPressed: () {
//                                   //     // checkSave(
//                                   //     //   productNameController.text,
//                                   //     //   dropdownValue,
//                                   //     //   dropdownValue3,
//                                   //     //   dropdownValue1,
//                                   //     //   dropdownValue2,
//                                   //     //   double.parse(priceController.text.toString()),
//                                   //     //   // Ensure this is a valid integer
//                                   //     //   discountController.text,
//                                   //     //   storeImage,
//                                   //     //   // imageIdController.text,
//                                   //     // );
//                                   //     print('--------------');
//                                   //     print(productNameController.text);
//                                   //     print('-------saveTo');
//                                   //     token =
//                                   //         window.sessionStorage["token"] ?? " ";
//                                   //     print("token");
//                                   //     print(token);
//                                   //     if (!areRequiredFieldsFilled()) {
//                                   //       // if (imagePath == null ||
//                                   //       //     selectedImage == null) {
//                                   //       if (mounted) {
//                                   //         ScaffoldMessenger.of(context)
//                                   //             .showSnackBar(
//                                   //           const SnackBar(
//                                   //               content: Text(
//                                   //                   "Please fill in all required fields")),
//                                   //         );
//                                   //       }
//                                   //       // }
//                                   //     } else {
//                                   //       checkSave(
//                                   //         productNameController.text,
//                                   //         dropdownValue,
//                                   //         dropdownValue3,
//                                   //         dropdownValue1,
//                                   //         dropdownValue2,
//                                   //         double.parse(
//                                   //             priceController.text.toString()),
//                                   //         // Ensure this is a valid integer
//                                   //         discountController.text,
//                                   //         storeImage,
//                                   //         // imageIdController.text,
//                                   //       );
//                                   //       ScaffoldMessenger.of(context)
//                                   //           .showSnackBar(
//                                   //         const SnackBar(
//                                   //             content: Text(
//                                   //                 "Product added successfully")),
//                                   //       );
//                                   //     }
//                                   //     // filePicker();
//                                   //   },
//                                   //   child: Text(
//                                   //     "Save",
//                                   //     style: TextStyle(
//                                   //         color: Colors.white, fontSize: 15),
//                                   //   ),
//                                   //   style: OutlinedButton.styleFrom(
//                                   //     backgroundColor: Colors.blue,
//                                   //     // Blue background color
//                                   //     shape: RoundedRectangleBorder(
//                                   //       borderRadius: BorderRadius.circular(
//                                   //           5), // Rounded corners
//                                   //     ),
//                                   //     side: BorderSide.none, // No outline
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ]);
//             } else if (constraints.maxWidth > 800) {
//               // For web view
//               return Stack(children: [
//                 Positioned(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 200),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       color: Colors.white,
//                       height: 60,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back), // Back button icon
//                             onPressed: () {
//                               // Navigator.push(
//                               //   context,
//                               // //   MaterialPageRoute(
//                               //       builder: (context) =>
//                               //           ProductPage(product: null)),
//                               // );
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 30),
//                             child: Text(
//                               'Edit',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 1350),
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 // cancel button conditon
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => SecondPage()),
//                                 // );
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors
//                                     .blueAccent, // Button background color
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       5), // Rounded corners
//                                 ),
//                                 side: BorderSide.none, // No outline
//                               ),
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 1350),
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 //update button condition
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => SecondPage()),
//                                 // );
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors
//                                     .blueAccent, // Button background color
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       5), // Rounded corners
//                                 ),
//                                 side: BorderSide.none, // No outline
//                               ),
//                               child: Text(
//                                 'Update',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 43, left: 200),
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 10), // Space above/below the border
//                     height: 3, // Border height
//                     color: Colors.grey[100], // Border color
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Align(
//                       // Added Align widget for the left side menu
//                       alignment: Alignment.topLeft,
//                       child: Container(
//                         height: 1400,
//                         width: 200,
//                         color: Color(0xFFF7F6FA),
//                         padding: EdgeInsets.only(left: 20, top: 30),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextButton.icon(
//                               onPressed: () {
//                                 context.go(
//                                     '${PageName.main}/${PageName.subpage1Main}');
//                               },
//                               icon: Icon(Icons.dashboard,
//                                   color: Colors.indigo[900]),
//                               label: Text(
//                                 'Home',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => Dashboard()),
//                                 // );
//                                 setState(() {
//                                   isOrdersSelected = false;
//                                   // Handle button press19
//                                 });
//                               },
//                               icon: Icon(Icons.warehouse,
//                                   color: isOrdersSelected
//                                       ? Colors.blueAccent
//                                       : Colors.blueAccent),
//                               label: Text(
//                                 'Orders',
//                                 style: TextStyle(
//                                   color: Colors.blueAccent,
//                                 ),
//                               ),
//                             ),
//                             // TextButton.icon(
//                             //   onPressed: () {
//                             //     setState(() {
//                             //       isOrderSelected = false;
//                             //       // Handle button press19
//                             //     });
//                             //     context.go(
//                             //         '${PageName.dashboardRoute}/${PageName.subpage2}');
//                             //     Navigator.push(
//                             //       context,
//                             //       MaterialPageRoute(
//                             //           builder: (context) => ProductPage(
//                             //                 product: null,
//                             //               )),
//                             //     );
//                             //   },
//                             //   icon: Icon(Icons.warehouse_outlined,
//                             //       color: Colors.indigo[900]),
//                             //   label: Text(
//                             //     'Orders',
//                             //     style: TextStyle(color: Colors.indigo[900]),
//                             //   ),
//                             // ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.fire_truck_outlined,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Delivery',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.document_scanner_rounded,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Invoice',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.payment_outlined,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Payment',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.backspace_sharp,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Return',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.insert_chart,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Reports',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         print('---imagePath---');
//                         print(imagePath);
//                         print(selectedImage);
//                         filePicker();
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           top: 20,
//                           left: 130,
//                         ),
//                         width: 500,
//                         height: 450,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             for (var imageBytes in selectedImages)
//                               Image.memory(
//                                 imageBytes,
//                                 fit: BoxFit.cover,
//                                 width: 300, // Adjust as needed
//                                 height: 300, // Adjust as needed
//                               ),
//                             Icon(Icons.cloud_upload_outlined,
//                                 color: Colors.blue[900], size: 50),
//                             SizedBox(height: 8),
//                             Text(
//                               'Click to upload image',
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'SVG, PNG, JPG, or GIF Recommended size (1000px * 1248px)',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 180,
//                           top: 220,
//                           right: 250,
//                         ),
//                         child: Form(
//                           key: _validate,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Product Name',
//                                     style: TextStyle(
//                                         color: Colors.indigo[900],
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     '*',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(4),
//                                         border: Border.all(
//                                             color: Colors.blue[100]!),
//                                       ),
//                                       child: TextFormField(
//                                         controller: productNameController,
//                                         decoration: InputDecoration(
//                                           fillColor: Colors.white,
//                                           contentPadding: EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           border: InputBorder.none,
//                                           filled: true,
//                                           hintText: 'Enter product name',
//                                           errorText: errorMessage,
//                                         ),
//                                         inputFormatters: [
//                                           FilteringTextInputFormatter.allow(
//                                               RegExp("[a-zA-Z0-9 ]")),
//                                           // Allow only letters, numbers, and single space
//                                           FilteringTextInputFormatter.deny(
//                                               RegExp(r'^\s')),
//                                           // Disallow starting with a space
//                                           FilteringTextInputFormatter.deny(
//                                               RegExp(r'\s\s')),
//                                           // Disallow multiple spaces
//                                         ],
//                                         validator: (value) {
//                                           if (value != null &&
//                                               value.trim().isEmpty) {
//                                             return 'Please enter a product name';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Category*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 900,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 200),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue = value!;
//                                                     });
//                                                   },
//                                                   items: list.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Sub Category*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 900,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue3,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 220),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue3 = value!;
//                                                     });
//                                                   },
//                                                   items: list3.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Tax*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 700,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue1,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 235),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue1 = value!;
//                                                     });
//                                                   },
//                                                   items: list1.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Unit*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 700,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue2,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 220),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue2 = value!;
//                                                     });
//                                                   },
//                                                   items: list2.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Price *'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: TextFormField(
//                                               controller: priceController,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .digitsOnly,
//                                                 LengthLimitingTextInputFormatter(
//                                                     10),
//                                                 // limits to 10 digits
//                                               ],
//                                               decoration: InputDecoration(
//                                                 fillColor: Colors.white,
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 border: InputBorder.none,
//                                                 filled: true,
//                                                 hintText: 'Enter Price',
//                                                 errorText: errorMessage,
//                                               ),
//                                               onChanged: (value) {
//                                                 if (value.isNotEmpty &&
//                                                     !isNumeric(value)) {
//                                                   setState(() {
//                                                     errorMessage =
//                                                         'Please enter numbers only';
//                                                   });
//                                                 } else {
//                                                   setState(() {
//                                                     errorMessage = null;
//                                                   });
//                                                 }
//                                               },
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Discount'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: TextFormField(
//                                               controller: discountController,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .digitsOnly,
//                                                 LengthLimitingTextInputFormatter(
//                                                     10),
//                                                 // limits to 10 digits
//                                               ],
//                                               decoration: InputDecoration(
//                                                 fillColor: Colors.white,
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 border: InputBorder.none,
//                                                 filled: true,
//                                                 hintText: 'Enter Discount',
//                                                 errorText: errorMessage,
//                                               ),
//                                               onChanged: (value) {
//                                                 if (value.isNotEmpty &&
//                                                     !isNumeric(value)) {
//                                                   setState(() {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                       const SnackBar(
//                                                           content: Text(
//                                                               "Please enter decimal number only")),
//                                                     );
//                                                   });
//                                                 } else {
//                                                   setState(() {
//                                                     errorMessage = null;
//                                                   });
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   // OutlinedButton(
//                                   //   onPressed: () {
//                                   //     dropdownValue = 'Select';
//                                   //     dropdownValue3 = 'Yes';
//                                   //     dropdownValue1 = '12';
//                                   //     dropdownValue2 = 'PCS';
//                                   //     productNameController.clear();
//                                   //     // // //dropdownValue.clear();
//                                   //     // // // subCategoryController.clear();
//                                   //     // // // taxController.clear();
//                                   //     // //unitController.clear();
//                                   //     priceController.clear();
//                                   //     selectedImages.clear();
//                                   //     imageIdController.clear();
//                                   //     discountController.clear();
//                                   //     setState(() {});
//                                   //
//                                   //     // Optionally, display a message
//                                   //     ScaffoldMessenger.of(context)
//                                   //         .showSnackBar(
//                                   //       const SnackBar(
//                                   //           content: Text("Form cleared")),
//                                   //     );
//                                   //   },
//                                   //   style: OutlinedButton.styleFrom(
//                                   //     backgroundColor: Colors
//                                   //         .grey[400], // Blue background color
//                                   //     shape: RoundedRectangleBorder(
//                                   //       borderRadius: BorderRadius.circular(
//                                   //           5), // Rounded corners
//                                   //     ),
//                                   //     side: BorderSide.none, // No outline
//                                   //   ),
//                                   //   child: Text(
//                                   //     'Cancel',
//                                   //     style: TextStyle(
//                                   //       fontSize: 15,
//                                   //       // Increase font size if desired
//                                   //       // Bold text
//                                   //       color: Colors
//                                   //           .indigo[900], // White text color
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   // SizedBox(width: 16),
//                                   // OutlinedButton(
//                                   //   onPressed: () {
//                                   //     // checkSave(
//                                   //     //   productNameController.text,
//                                   //     //   dropdownValue,
//                                   //     //   dropdownValue3,
//                                   //     //   dropdownValue1,
//                                   //     //   dropdownValue2,
//                                   //     //   double.parse(priceController.text.toString()),
//                                   //     //   // Ensure this is a valid integer
//                                   //     //   discountController.text,
//                                   //     //   storeImage,
//                                   //     //   // imageIdController.text,
//                                   //     // );
//                                   //     print('--------------');
//                                   //     print(productNameController.text);
//                                   //     print('-------saveTo');
//                                   //     token =
//                                   //         window.sessionStorage["token"] ?? " ";
//                                   //     print("token");
//                                   //     print(token);
//                                   //     if (!areRequiredFieldsFilled()) {
//                                   //       // if (imagePath == null ||
//                                   //       //     selectedImage == null) {
//                                   //       if (mounted) {
//                                   //         ScaffoldMessenger.of(context)
//                                   //             .showSnackBar(
//                                   //           const SnackBar(
//                                   //               content: Text(
//                                   //                   "Please fill in all required fields")),
//                                   //         );
//                                   //       }
//                                   //       // }
//                                   //     } else {
//                                   //       checkSave(
//                                   //         productNameController.text,
//                                   //         dropdownValue,
//                                   //         dropdownValue3,
//                                   //         dropdownValue1,
//                                   //         dropdownValue2,
//                                   //         double.parse(
//                                   //             priceController.text.toString()),
//                                   //         // Ensure this is a valid integer
//                                   //         discountController.text,
//                                   //         storeImage,
//                                   //         // imageIdController.text,
//                                   //       );
//                                   //     }
//                                   //     // filePicker();
//                                   //   },
//                                   //   child: Text(
//                                   //     "Save",
//                                   //     style: TextStyle(
//                                   //         color: Colors.white, fontSize: 15),
//                                   //   ),
//                                   //   style: OutlinedButton.styleFrom(
//                                   //     backgroundColor: Colors.blue,
//                                   //     // Blue background color
//                                   //     shape: RoundedRectangleBorder(
//                                   //       borderRadius: BorderRadius.circular(
//                                   //           5), // Rounded corners
//                                   //     ),
//                                   //     side: BorderSide.none, // No outline
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ]);
//             } else {
//               // this is my mobile view
//               return Stack(children: [
//                 Positioned(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 200),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       color: Colors.white,
//                       height: 60,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.arrow_back), // Back button icon
//                             onPressed: () {
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //       builder: (context) =>
//                               //           ProductPage(product: null)),
//                               // );
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 30),
//                             child: Text(
//                               'Edit',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 1350),
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 // cancel button condition
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => SecondPage()),
//                                 // );
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors
//                                     .blueAccent, // Button background color
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       5), // Rounded corners
//                                 ),
//                                 side: BorderSide.none, // No outline
//                               ),
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 1350),
//                             child: OutlinedButton(
//                               onPressed: () {
//                                 //update button conditon
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) => SecondPage()),
//                                 // );
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors
//                                     .blueAccent, // Button background color
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       5), // Rounded corners
//                                 ),
//                                 side: BorderSide.none, // No outline
//                               ),
//                               child: Text(
//                                 'Update',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 43, left: 200),
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 10), // Space above/below the border
//                     height: 3, // Border height
//                     color: Colors.grey[100], // Border color
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Align(
//                       // Added Align widget for the left side menu
//                       alignment: Alignment.topLeft,
//                       child: Container(
//                         height: 1400,
//                         width: 200,
//                         color: Color(0xFFF7F6FA),
//                         padding: EdgeInsets.only(left: 20, top: 30),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // TextButton.icon(
//                             //   onPressed: () {
//                             //     setState(() {
//                             //       isHomeSelected = false;
//                             //       // Handle button press19
//                             //     });
//                             //   },
//                             //   icon: Icon(Icons.dashboard,
//                             //       color: isHomeSelected
//                             //           ? Colors.blueAccent
//                             //           : Colors.blueAccent),
//                             //   label: Text(
//                             //     'Home',
//                             //     style: TextStyle(
//                             //       color: Colors.blueAccent,
//                             //     ),
//                             //   ),
//                             // ),
//                             SizedBox(height: 20),
//                             // TextButton.icon(
//                             //   onPressed: () {
//                             //     context.go(
//                             //         '${PageName.dashboardRoute}/${PageName.subpage2}');
//                             //     Navigator.push(
//                             //       context,
//                             //       MaterialPageRoute(
//                             //           builder: (context) => ProductPage(
//                             //                 product: null,
//                             //               )),
//                             //     );
//                             //   },
//                             //   icon: Icon(Icons.warehouse_outlined,
//                             //       color: Colors.indigo[900]),
//                             //   label: Text(
//                             //     'Orders',
//                             //     style: TextStyle(color: Colors.indigo[900]),
//                             //   ),
//                             // ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.fire_truck_outlined,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Delivery',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.document_scanner_rounded,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Invoice',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.payment_outlined,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Payment',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.backspace_sharp,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Return',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             TextButton.icon(
//                               onPressed: () {},
//                               icon: Icon(Icons.insert_chart,
//                                   color: Colors.blue[900]),
//                               label: Text(
//                                 'Reports',
//                                 style: TextStyle(color: Colors.indigo[900]),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         print('---imagePath---');
//                         print(imagePath);
//                         print(selectedImage);
//                         filePicker();
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           top: 20,
//                           left: 130,
//                         ),
//                         width: 500,
//                         height: 450,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             for (var imageBytes in selectedImages)
//                               Image.memory(
//                                 imageBytes,
//                                 fit: BoxFit.cover,
//                                 width: 300, // Adjust as needed
//                                 height: 300, // Adjust as needed
//                               ),
//                             Icon(Icons.cloud_upload_outlined,
//                                 color: Colors.blue[900], size: 50),
//                             SizedBox(height: 8),
//                             Text(
//                               'Click to upload image',
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'SVG, PNG, JPG, or GIF Recommended size (1000px * 1248px)',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                           left: 180,
//                           top: 220,
//                           right: 250,
//                         ),
//                         child: Form(
//                           key: _validate,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Product Name',
//                                     style: TextStyle(
//                                         color: Colors.indigo[900],
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     '*',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(4),
//                                         border: Border.all(
//                                             color: Colors.blue[100]!),
//                                       ),
//                                       child: TextFormField(
//                                         controller: productNameController,
//                                         decoration: InputDecoration(
//                                           fillColor: Colors.white,
//                                           contentPadding: EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           border: InputBorder.none,
//                                           filled: true,
//                                           hintText: 'Enter product name',
//                                           errorText: errorMessage,
//                                         ),
//                                         inputFormatters: [
//                                           FilteringTextInputFormatter.allow(
//                                               RegExp("[a-zA-Z0-9 ]")),
//                                           // Allow only letters, numbers, and single space
//                                           FilteringTextInputFormatter.deny(
//                                               RegExp(r'^\s')),
//                                           // Disallow starting with a space
//                                           FilteringTextInputFormatter.deny(
//                                               RegExp(r'\s\s')),
//                                           // Disallow multiple spaces
//                                         ],
//                                         validator: (value) {
//                                           if (value != null &&
//                                               value.trim().isEmpty) {
//                                             return 'Please enter a product name';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Category*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 900,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 200),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue = value!;
//                                                     });
//                                                   },
//                                                   items: list.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Sub Category*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 900,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue3,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 220),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue3 = value!;
//                                                     });
//                                                   },
//                                                   items: list3.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Tax*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 700,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue1,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 235),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue1 = value!;
//                                                     });
//                                                   },
//                                                   items: list1.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Unit*'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: SizedBox(
//                                               height: 50,
//                                               width: 700,
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: DropdownButton<String>(
//                                                   value: dropdownValue2,
//                                                   icon: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 220),
//                                                     child: const Icon(
//                                                         Icons.arrow_drop_down),
//                                                   ),
//                                                   iconSize: 24,
//                                                   // Size of the icon
//                                                   elevation: 16,
//                                                   style: const TextStyle(
//                                                       color: Colors.black),
//                                                   underline: Container(),
//                                                   // We don't need the default underline since we're using a custom border
//                                                   onChanged: (String? value) {
//                                                     setState(() {
//                                                       dropdownValue2 = value!;
//                                                     });
//                                                   },
//                                                   items: list2.map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Text(value),
//                                                     );
//                                                   }).toList(),
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
//                               SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Price *'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: TextFormField(
//                                               controller: priceController,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .digitsOnly,
//                                                 LengthLimitingTextInputFormatter(
//                                                     10),
//                                                 // limits to 10 digits
//                                               ],
//                                               decoration: InputDecoration(
//                                                 fillColor: Colors.white,
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 border: InputBorder.none,
//                                                 filled: true,
//                                                 hintText: 'Enter Price',
//                                                 errorText: errorMessage,
//                                               ),
//                                               onChanged: (value) {
//                                                 if (value.isNotEmpty &&
//                                                     !isNumeric(value)) {
//                                                   setState(() {
//                                                     errorMessage =
//                                                         'Please enter numbers only';
//                                                   });
//                                                 } else {
//                                                   setState(() {
//                                                     errorMessage = null;
//                                                   });
//                                                 }
//                                               },
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
//                                           padding: const EdgeInsets.all(4.0),
//                                           child: Text('Discount'),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(4),
//                                               border: Border.all(
//                                                   color: Colors.blue[100]!),
//                                             ),
//                                             child: TextFormField(
//                                               controller: discountController,
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               inputFormatters: [
//                                                 FilteringTextInputFormatter
//                                                     .digitsOnly,
//                                                 LengthLimitingTextInputFormatter(
//                                                     10),
//                                                 // limits to 10 digits
//                                               ],
//                                               decoration: InputDecoration(
//                                                 fillColor: Colors.white,
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 border: InputBorder.none,
//                                                 filled: true,
//                                                 hintText: 'Enter Discount',
//                                                 errorText: errorMessage,
//                                               ),
//                                               onChanged: (value) {
//                                                 if (value.isNotEmpty &&
//                                                     !isNumeric(value)) {
//                                                   setState(() {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(
//                                                       const SnackBar(
//                                                           content: Text(
//                                                               "Please enter decimal number only")),
//                                                     );
//                                                   });
//                                                 } else {
//                                                   setState(() {
//                                                     errorMessage = null;
//                                                   });
//                                                 }
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 16),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   // OutlinedButton(
//                                   //   onPressed: () {
//                                   //     dropdownValue = 'Select';
//                                   //     dropdownValue3 = 'Yes';
//                                   //     dropdownValue1 = '12';
//                                   //     dropdownValue2 = 'PCS';
//                                   //     productNameController.clear();
//                                   //     // // //dropdownValue.clear();
//                                   //     // // // subCategoryController.clear();
//                                   //     // // // taxController.clear();
//                                   //     // //unitController.clear();
//                                   //     priceController.clear();
//                                   //     selectedImages.clear();
//                                   //     imageIdController.clear();
//                                   //     discountController.clear();
//                                   //     setState(() {});
//                                   //
//                                   //     // Optionally, display a message
//                                   //     ScaffoldMessenger.of(context)
//                                   //         .showSnackBar(
//                                   //       const SnackBar(
//                                   //           content: Text("Form cleared")),
//                                   //     );
//                                   //   },
//                                   //   style: OutlinedButton.styleFrom(
//                                   //     backgroundColor: Colors
//                                   //         .grey[400], // Blue background color
//                                   //     shape: RoundedRectangleBorder(
//                                   //       borderRadius: BorderRadius.circular(
//                                   //           5), // Rounded corners
//                                   //     ),
//                                   //     side: BorderSide.none, // No outline
//                                   //   ),
//                                   //   child: Text(
//                                   //     'Cancel',
//                                   //     style: TextStyle(
//                                   //       fontSize: 15,
//                                   //       // Increase font size if desired
//                                   //       // Bold text
//                                   //       color: Colors
//                                   //           .indigo[900], // White text color
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   // SizedBox(width: 16),
//                                   // OutlinedButton(
//                                   //   onPressed: () {
//                                   //     // checkSave(
//                                   //     //   productNameController.text,
//                                   //     //   dropdownValue,
//                                   //     //   dropdownValue3,
//                                   //     //   dropdownValue1,
//                                   //     //   dropdownValue2,
//                                   //     //   double.parse(priceController.text.toString()),
//                                   //     //   // Ensure this is a valid integer
//                                   //     //   discountController.text,
//                                   //     //   storeImage,
//                                   //     //   // imageIdController.text,
//                                   //     // );
//                                   //     print('--------------');
//                                   //     print(productNameController.text);
//                                   //     print('-------saveTo');
//                                   //     token =
//                                   //         window.sessionStorage["token"] ?? " ";
//                                   //     print("token");
//                                   //     print(token);
//                                   //     if (!areRequiredFieldsFilled()) {
//                                   //       // if (imagePath == null ||
//                                   //       //     selectedImage == null) {
//                                   //       if (mounted) {
//                                   //         ScaffoldMessenger.of(context)
//                                   //             .showSnackBar(
//                                   //           const SnackBar(
//                                   //               content: Text(
//                                   //                   "Please fill in all required fields")),
//                                   //         );
//                                   //       }
//                                   //       // }
//                                   //     } else {
//                                   //       checkSave(
//                                   //         productNameController.text,
//                                   //         dropdownValue,
//                                   //         dropdownValue3,
//                                   //         dropdownValue1,
//                                   //         dropdownValue2,
//                                   //         double.parse(
//                                   //             priceController.text.toString()),
//                                   //         // Ensure this is a valid integer
//                                   //         discountController.text,
//                                   //         storeImage,
//                                   //         // imageIdController.text,
//                                   //       );
//                                   //     }
//                                   //     // filePicker();
//                                   //   },
//                                   //   child: Text(
//                                   //     "Save",
//                                   //     style: TextStyle(
//                                   //         color: Colors.white, fontSize: 15),
//                                   //   ),
//                                   //   style: OutlinedButton.styleFrom(
//                                   //     backgroundColor: Colors.blue,
//                                   //     // Blue background color
//                                   //     shape: RoundedRectangleBorder(
//                                   //       borderRadius: BorderRadius.circular(
//                                   //           5), // Rounded corners
//                                   //     ),
//                                   //     side: BorderSide.none, // No outline
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ]);
//             }
//           },
//         ), // Use the ProductForm widget here
//       ),
//     );
//   }
// }
//
// bool isNumeric(String value) {
//   if (value == null) {
//     return false;
//   }
//   return double.tryParse(value) != null;
// }
//
// customerFieldDecoration(
//     {required String hintText, required bool error, Function? onTap}) {
//   return InputDecoration(
//     constraints: BoxConstraints(maxHeight: error == true ? 50 : 30),
//     hintText: hintText,
//     hintStyle: const TextStyle(fontSize: 11),
//     border:
//         const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
//     counterText: '',
//     contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
//     enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Color(0xff9FB3C8))),
//     focusedBorder:
//         const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
//   );
// }
