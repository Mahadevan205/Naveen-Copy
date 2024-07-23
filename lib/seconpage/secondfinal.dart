import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:math';
import 'package:btb/screen/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../fourthpage/orderspage order.dart';
import '../sprint 2 order/firstpage.dart';
import '../thirdpage/dashboard.dart';

void main() {
  runApp(const SecondPage(
  ));
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key,});


  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? pickedImagePath;
  String token = window.sessionStorage["token"] ?? " ";
  String? imagePath;
  io.File? selectedImage;
  bool isOrdersSelected = false;
  String? errorMessage;
  bool purchaseOrderError = false;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController imageIdController = TextEditingController();
  final List<String> list = ['Select', 'Select 1', 'Select 2', 'Select 3'];
  String dropdownValue = 'Select';
  final List<String> list1 = ['Select', '12%', '18%', '28%', '10%'];
  String? selectedDropdownItem;
  String dropdownValue1 = 'Select';
  String imageName = '';
  List<Uint8List> selectedImages = [];
  String storeImage = '';
  final List<String> list2 = ['Select', 'PCS', 'NOS', 'PKT'];
  String dropdownValue2 = 'Select';
  final List<String> list3 = ['Select', 'Yes', 'No'];
  String dropdownValue3 = 'Select';
  final _validate = GlobalKey<FormState>();
  var result;
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  bool isHomeSelected = false;

  // Function to check if all required fields are filled
  bool areRequiredFieldsFilled() {
    return productNameController.text.isNotEmpty &&
        dropdownValue != 'Select' &&
        // dropdownValue3 != 'Select' &&
        dropdownValue1 != 'Select' &&
        dropdownValue2 != 'Select' &&
        dropdownValue3 != 'Select' &&
        priceController.text.isNotEmpty &&
        discountController.text.isNotEmpty &&
        selectedImages.isNotEmpty;
  }

  Future<void> filePicker() async {
    result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
    } else {
      setState(() {
        selectedImages.clear(); // Clear previous selections
      });
      for (var element in result!.files) {
        setState(() {
          imageIdController.text = element.name;
          storeImage = element.name;
          // Post api call.
          uploadImage(element.name); // Pass image bytes to uploadImage
          selectedImages.add(element.bytes!);
        });
        // Store the image data
      }
    }
  }

  Future<void> uploadImage(String name) async {
    String url =
        'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/upload';
    try {
      if (result != null) {
        for (var element in result!.files) {
          // Prepare the multipart request
          var request = http.MultipartRequest('POST', Uri.parse(url));

          // Add the file to the request
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            element.bytes!,
            filename: element.name,
          ));

          // Send the request
          var streamedResponse = await request.send();
          // Get the response
          var response = await http.Response.fromStream(streamedResponse);

          // Check if the request was successful
          if (response.statusCode == 200) {
            print('Image uploaded successfully!');
            print(response.body);
          } else {
            print(
                'Failed to upload image. Status code: ${response.statusCode}');
          }
        }
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void checkSave(
      String ProductName,
      String category,
      String subCategory,
      String tax,
      String unit,
      double price,
      String discount,
      String imageId,
      ) async {
    if (!areRequiredFieldsFilled()) {
      // if (imagePath == null || selectedImage == null) {
      if (mounted) {
        if (productNameController.text.isEmpty &&
            dropdownValue == 'Select' &&
            // dropdownValue3 != 'Select' &&
            dropdownValue1 == 'Select' &&
            dropdownValue2 == 'Select' &&
            dropdownValue3 == 'Select' &&
            priceController.text.isEmpty &&
            discountController.text.isEmpty &&
            selectedImages.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Fill all required Fields")),
          );
        } else if (productNameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Enter Product Name")),
          );
        } else if (dropdownValue == 'Select') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select Category")),
          );
        } else if (dropdownValue1 == 'Select') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select Tax")),
          );
        } else if (dropdownValue2 == 'Select') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select Unit")),
          );
        } else if (dropdownValue3 == 'Select') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select Sub Category")),
          );
        } else if (dropdownValue3 == 'Select') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select Tax")),
          );
        } else if (priceController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Enter Price")),
          );
        } else if (discountController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Enter Discount")),
          );
        } else if (discountController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Enter Discount")),
          );
        } else if (selectedImages.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Select Image")),
          );
        }
      } else {
        checkSave(
          productNameController.text,
          dropdownValue,
          dropdownValue3,
          dropdownValue1,
          dropdownValue2,
          double.parse(priceController.text.toString()),
          discountController.text,
          storeImage,
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              icon: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 25,
              ),
              title: const Text("Success"),
              content: const Padding(
                padding: EdgeInsets.only(left: 26),
                child: Text("Product added successfully"),
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProductPage(product: null),
                        transitionDuration: const Duration(milliseconds: 200),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
      // }
      return;
    }

    final productData = {
      "productName": productNameController.text,
      "category": dropdownValue,
      "subCategory": dropdownValue3,
      "tax": dropdownValue1,
      "unit": dropdownValue2,
      "price": double.parse(priceController.text),
      "discount": discountController.text,
      "imageId": storeImage,
    };
    print('---------productData------');
    print(productData);
    const url =
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/add_productmaster';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: json.encode(productData),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product: error")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product addedss successfully")),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("please pick image")),
        );
        if (pickedImagePath != null) {
          final imageResponse = await http.post(
            Uri.parse(
                'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/upload'),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token'
            },
            body: json.encode({
              "imagePath": pickedImagePath,
              "productName": productNameController.text,
              // "category": categoryController.text,
              // additional data if needed
            }),
          );
          if (imageResponse.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image uploaded successfully")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to upload image")),
            );
          }
        }
        // if (imagePath == null || selectedImage == null) {
        //   print('--------if condition-------');
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Please Pick Image")),
        //   );
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Product added successfully")),
        //   );
        //   // subsubPage1
        //   // Navigator.push(
        //   //   context,
        //   //   MaterialPageRoute(builder: (context) => ProductPage(product: null)),
        //   // );
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar:
        AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFFFFFF),
          title: Image.asset("images/Final-Ikyam-Logo.png"),
          // Set background color to white
          elevation: 2.0,
          shadowColor: const Color(0xFFFFFFFF),
          // Set shadow color to black
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Handle notification icon press
                  },
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 35),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.account_circle),
                    onSelected: (value) {
                      if (value == 'logout') {
                        context.go('/');
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                            const LoginScr(
                            ),
                            transitionDuration:
                            const Duration(milliseconds: 200),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ];
                    },
                    offset: Offset(0, 40), // Adjust the offset to display the menu below the icon
                  ),
                ),
              ),
            ),
          ],
        ),
        body:
        LayoutBuilder(
          builder: (context, constraints){
            double maxWidth = constraints.maxWidth;
            double maxHeight = constraints.maxHeight;
            return Stack(children: [
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(left: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.white,
                    height: 60,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.arrow_back), // Back button icon
                          onPressed: () {
                            context.go(
                                '/dasbaord/productpage/:product');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                const ProductPage(product: null),
                                transitionDuration:
                                const Duration(milliseconds: 200),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            'Add New Product',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 43, left: 200),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10), // Space above/below the border
                  height: 3, // Border height
                  color: Colors.grey[100], // Border color
                ),
              ),
              Row(
                children: [
                  Align(
                    // Added Align widget for the left side menu
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 1400,
                      width: 200,
                      color: const Color(0xFFF7F6FA),
                      padding: const EdgeInsets.only(left: 20, top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              context.go(
                                  '/addproduct/dashboard');
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  const Dashboard(
                                  ),
                                  transitionDuration:
                                  const Duration(milliseconds: 200),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.dashboard,
                                color: Colors.indigo[900]),
                            label: Text(
                              'Home',
                              style: TextStyle(color: Colors.indigo[900]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                isOrdersSelected = false;
                                // Handle button press19
                              });
                            },
                            icon: Icon(Icons.image_outlined,
                                color: isOrdersSelected
                                    ? Colors.blueAccent
                                    : Colors.blueAccent),
                            label: const Text(
                              'Products',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {
                              context.go('/Secondpage/orderspage');
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  const Orderspage(),
                                  transitionDuration:
                                  const Duration(milliseconds: 200),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.warehouse,
                                color: Colors.blue[900]),
                            label: Text(
                              'Orders',
                              style: TextStyle(
                                color: Colors.indigo[900],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.fire_truck_outlined,
                                color: Colors.blue[900]),
                            label: Text(
                              'Delivery',
                              style: TextStyle(color: Colors.indigo[900]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.document_scanner_rounded,
                                color: Colors.blue[900]),
                            label: Text(
                              'Invoice',
                              style: TextStyle(color: Colors.indigo[900]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.payment_outlined,
                                color: Colors.blue[900]),
                            label: Text(
                              'Payment',
                              style: TextStyle(color: Colors.indigo[900]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.backspace_sharp,
                                color: Colors.blue[900]),
                            label: Text(
                              'Return',
                              style: TextStyle(color: Colors.indigo[900]),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.insert_chart,
                                color: Colors.blue[900]),
                            label: Text(
                              'Reports',
                              style: TextStyle(color: Colors.indigo[900]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('---imagePath---');
                      print(imagePath);
                      print(selectedImage);
                      filePicker();
                    },
                    child: Card(
                      margin: EdgeInsets.only(left: maxWidth * 0.08, top: maxHeight * 0.27,bottom: maxHeight * 0.3),

                      child: Flex(
                        direction: Axis.vertical, // use vertical direction
                        children: [
                          Flexible(
                            flex: 2, // take up 3 parts of the available space
                            child: Container(
                              width: maxWidth * 0.3,
                              height: maxHeight * 1.2,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (selectedImages.isNotEmpty)
                                    for (var imageBytes in selectedImages)
                                      Flexible(
                                        child: Image.memory(
                                          imageBytes,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  Icon(Icons.cloud_upload_outlined,
                                      color: Colors.blue[900], size: 50),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Click to upload image',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'PNG, JPG or GIF Recommended size below 1MB',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.only(left: maxWidth * 0.08, top: maxHeight * 0.2,right: maxWidth * 0.1),
                      // margin: const EdgeInsets.only(
                      //   top: 120,
                      //   left: 60,
                      //   right: 150,
                      //   bottom: 50,
                      // ),
                      color: Colors.white,
                      elevation: 0.0,
                      child: Form(
                        key: _validate,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Name field
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Align(
                                    alignment: Alignment(-1.0,-0.3),
                                    child: RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Product Name ',
                                            style: TextStyle(
                                              color: Colors.grey, // Set the product name to black color
                                            ),
                                          ),
                                          TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                              color: Colors.red, // Set the asterisk to red color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(color: Colors.blue[100]!),
                                    ),
                                    child: Align(
                                      alignment: const Alignment(0.1, 0.0),
                                      child: SizedBox(
                                        height: 40,
                                        width: constraints.maxWidth * 0.5,
                                        child: TextFormField(
                                          controller: productNameController,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                            border: InputBorder.none,
                                            filled: true,
                                            hintText: 'Enter product name',
                                            errorText: errorMessage,
                                          ),
                                          validator: (value) {
                                            if (value != null && value.trim().isEmpty) {
                                              return 'Please enter a product name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 5),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Category field
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: const  Alignment(-1.0,-0.3),
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Category ',
                                                  style: TextStyle(
                                                    color: Colors.grey, // Set the product name to black color
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red, // Set the asterisk to red color
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.blue[100]!),
                                          ),
                                          child: SizedBox(
                                            height: 50,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: DropdownButton<String>(
                                                value: dropdownValue,
                                                icon: Icon(Icons.arrow_drop_down),
                                                iconSize: 24, // Size of the icon
                                                elevation: 16,
                                                style: const TextStyle(color: Colors.black),
                                                underline: Container(), // We don't need the default underline since we're using a custom border
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    dropdownValue = value!;
                                                  });
                                                },
                                                items: list.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Sub Category field
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: const Alignment(-1.0,-0.3),
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Sub Category ',
                                                  style: TextStyle(
                                                    color: Colors.grey, // Set the product name to black color
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red, // Set the asterisk to red color
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color:
                                            Colors.blue[100]!),
                                          ),
                                          child: SizedBox(
                                            height: 50,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: DropdownButton<String>(
                                                value: dropdownValue3,
                                                icon: Icon(
                                                    Icons.arrow_drop_down),
                                                iconSize: 24,
                                                // Size of the icon
                                                elevation: 16,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                underline: Container(),
                                                // We don't need the default underline since we're using a custom border
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    dropdownValue3 = value!;
                                                  });
                                                },
                                                items: list3.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                isExpanded: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment:  const Alignment(-1.0,-0.3),
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Tax ',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .grey, // Set the product name to black color
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .red, // Set the asterisk to red color
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.blue[100]!),
                                          ),
                                          child: SizedBox(
                                            height: 50,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: SizedBox(
                                              height: 40,
                                               width: constraints.maxWidth * 0.5,
                                                child: DropdownButton<String>(
                                                  value: dropdownValue1,
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 24,
                                                  // Size of the icon
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  underline: Container(),
                                                  // We don't need the default underline since we're using a custom border
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      dropdownValue1 = value!;
                                                    });
                                                  },
                                                  items: list1.map<
                                                      DropdownMenuItem<
                                                          String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  isExpanded: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: const Alignment(-1.0,-0.3),
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Unit ',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .grey, // Set the product name to black color
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .red, // Set the asterisk to red color
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.blue[100]!),
                                          ),
                                          child: SizedBox(
                                            height: 50,

                                            child: Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: SizedBox(
                                              height: 40,
                                              width: constraints.maxWidth * 0.5,
                                                child: DropdownButton<String>(
                                                  value: dropdownValue2,
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 24,
                                                  // Size of the icon
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  underline: Container(),
                                                  // We don't need the default underline since we're using a custom border
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      dropdownValue2 = value!;
                                                    });
                                                  },
                                                  items: list2.map<
                                                      DropdownMenuItem<
                                                          String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  isExpanded: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                         alignment:const Alignment(-1.0,-0.3),
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Price ',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .grey, // Set the product name to black color
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .red, // Set the asterisk to red color
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(2),
                                            border: Border.all(
                                                color: Colors.blue[100]!),
                                          ),
                                          child: TextFormField(
                                            controller: priceController,
                                            keyboardType:
                                            TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              // limits to 10 digits
                                            ],
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              border: InputBorder.none,
                                              filled: true,
                                              hintText: 'Enter Price',
                                              errorText: errorMessage,
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty &&
                                                  !isNumeric(value)) {
                                                setState(() {
                                                  errorMessage =
                                                  'Please enter numbers only';
                                                });
                                              } else {
                                                setState(() {
                                                  errorMessage = null;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                         alignment: const Alignment(-1.0,-0.3),
                                          child: RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Discount ',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .grey, // Set the product name to black color
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .red, // Set the asterisk to red color
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(2),
                                            border: Border.all(
                                                color: Colors.blue[100]!),
                                          ),
                                          child: TextFormField(
                                            controller: discountController,
                                            keyboardType:
                                            TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              // limits to 10 digits
                                            ],
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              border: InputBorder.none,
                                              filled: true,
                                              hintText: 'Enter Discount',
                                              errorText: errorMessage,
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty &&
                                                  !isNumeric(value)) {
                                                setState(() {
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "Please enter decimal number only")),
                                                  );
                                                });
                                              } else {
                                                setState(() {
                                                  errorMessage = null;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40,),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment(0.8,0.7),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        dropdownValue = 'Select';
                                        dropdownValue3 = 'Select';
                                        dropdownValue1 = 'Select';
                                        dropdownValue2 = 'Select';
                                        productNameController.clear();
                                        priceController.clear();
                                        selectedImages.clear();
                                        imageIdController.clear();
                                        discountController.clear();
                                        setState(() {});

                                        // Optionally, display a message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text("Form cleared")),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors
                                            .grey[400], // Blue background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                        ),
                                        side: BorderSide.none, // No outline
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 15,
                                          // Increase font size if desired
                                          // Bold text
                                          color: Colors
                                              .indigo[900], // White text color
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Align(alignment: Alignment.bottomLeft,
                                    child: OutlinedButton(
                                      // onPressed: () {
                                      //   print('--------------');
                                      //   print(productNameController.text);
                                      //   print('-------saveTo');
                                      //   token =
                                      //       window.sessionStorage["token"] ?? " ";
                                      //   print("token");
                                      //   print(token);
                                      //   if (!areRequiredFieldsFilled()) {
                                      //     // if (imagePath == null ||
                                      //     //     selectedImage == null) {
                                      //     if (mounted) {
                                      //       ScaffoldMessenger.of(context)
                                      //           .showSnackBar(
                                      //         const SnackBar(
                                      //             content: Text(
                                      //                 "Please fill all required fields")),
                                      //       );
                                      //     }
                                      //     // }
                                      //   } else {
                                      //     checkSave(
                                      //       productNameController.text,
                                      //       dropdownValue,
                                      //       dropdownValue3,
                                      //       dropdownValue1,
                                      //       dropdownValue2,
                                      //       double.parse(
                                      //           priceController.text.toString()),
                                      //       // Ensure this is a valid integer
                                      //       discountController.text,
                                      //       storeImage,
                                      //       // imageIdController.text,
                                      //     );
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(
                                      //       const SnackBar(
                                      //           content: Text(
                                      //               "Product added successfully")),
                                      //     );
                                      //   }
                                      //   // filePicker();
                                      // },
                                      onPressed: () {
                                        print('--------------');
                                        // print(productNameController.text);
                                        print('-------saveTo');
                                        token =
                                            window.sessionStorage["token"] ?? " ";
                                        print("token");
                                        print(token);
                                        if (!areRequiredFieldsFilled()) {
                                          if (mounted) {
                                            if (productNameController
                                                .text.isEmpty &&
                                                dropdownValue == 'Select' &&
                                                // dropdownValue3 != 'Select' &&
                                                dropdownValue1 == 'Select' &&
                                                dropdownValue2 == 'Select' &&
                                                dropdownValue3 == 'Select' &&
                                                priceController.text.isEmpty &&
                                                discountController.text.isEmpty &&
                                                selectedImages.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Fill all required Fields")),
                                              );
                                            } else if (productNameController
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Enter Product Name")),
                                              );
                                            } else if (dropdownValue ==
                                                'Select') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Select Category")),
                                              );
                                            } else if (dropdownValue1 ==
                                                'Select') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Select Tax")),
                                              );
                                            } else if (dropdownValue2 ==
                                                'Select') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Select Unit")),
                                              );
                                            } else if (dropdownValue3 ==
                                                'Select') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Select Sub Category")),
                                              );
                                            } else if (dropdownValue3 ==
                                                'Select') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Select Tax")),
                                              );
                                            } else if (priceController
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Enter Price")),
                                              );
                                            } else if (discountController
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Enter Discount")),
                                              );
                                            } else if (selectedImages.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Please Select Image")),
                                              );
                                            }
                                          }
                                        }else{
                                          checkSave(
                                            productNameController.text,
                                            dropdownValue,
                                            dropdownValue3,
                                            dropdownValue1,
                                            dropdownValue2,
                                            double.parse(
                                                priceController.text.toString()),
                                            discountController.text,
                                            storeImage,
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape:
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            5))),
                                                icon: const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.green,
                                                  size: 25,
                                                ),
                                                title: const Text("Success"),
                                                content: const Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 26),
                                                  child: Text(
                                                      "Product added successfully"),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("OK"),
                                                    onPressed: () {
                                                      context.go('/dasbaord/productpage/ontap');
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) =>
                                                          const ProductPage(
                                                              product: null),
                                                          transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                              200),
                                                          transitionsBuilder:
                                                              (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                            return FadeTransition(
                                                              opacity: animation,
                                                              child: child,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        // Blue background color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                        ),
                                        side: BorderSide.none, // No outline
                                      ),
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
          }
        )
      ); // Use the ProductForm widget here

  }
}

bool isNumeric(String value) {
  return double.tryParse(value) != null;
}

customerFieldDecoration(
    {required String hintText, required bool error, Function? onTap}) {
  return InputDecoration(
    constraints: BoxConstraints(maxHeight: error == true ? 50 : 30),
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 11),
    border:
    const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    counterText: '',
    contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff9FB3C8))),
    focusedBorder:
    const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  );
}
