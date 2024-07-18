import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'package:btb/screen/login.dart';
import 'package:btb/thirdpage/dashboard.dart';
import 'package:btb/thirdpage/thirdpage%201.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../thirdpage/productdata.dart';
void main(){
  runApp(const EditOrder(textInput: '', priceInput: '', productData: {}, prodId: '', discountInput: '', inputText: '', subText: '', unitText: '', taxText: '', imagePath: null, imageId: ''));
}
class EditOrder extends StatefulWidget {
  final String? textInput;
  final String? priceInput;
  final Map productData;
  final String? discountInput;
  final String inputText;
  final String prodId;
  final String subText;
  final String unitText;
  final String taxText;
  final Uint8List? imagePath;
  final String imageId;
  const EditOrder({
    super.key,
    required this.textInput,
    required this.priceInput,
    required this.productData,
    required this.prodId,
    required this.discountInput,
    required this.inputText,
    required this.subText,
    required this.unitText,
    required this.taxText,
    required this.imagePath,
    required this.imageId,
  });
  @override
  State<EditOrder> createState() => _EditOrderState();
}
class _EditOrderState extends State<EditOrder> {
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
  final List<String> list1 = ['select', '12', '18', '28', '10'];
  String? selectedDropdownItem;
  Uint8List? storeImageBytes1;
  String dropdownValue1 = 'select';
  String imageName = '';
  List<Uint8List> selectedImages = [];
  String storeImage = '';
  final List<String> list2 = ['select', 'PCS', 'NOS', 'PKT'];
  String dropdownValue2 = 'select';
  final List<String> list3 = ['select', 'Yes', 'No'];
  String dropdownValue3 = 'select';
  List<ProductData> selectedProductList = [];
  final _validate = GlobalKey<FormState>();
  var result;
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController imageIdContoller = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController prodIdController = TextEditingController();
  bool isHomeSelected = false;
  String? _selectedValue;
  String? _selectedValue1;
  String? _selectedValue2;
  String? _selectedValue3;
  String updatedImageName = '';
  @override
  void initState() {
    super.initState();
    _selectedValue = widget.inputText;
    _selectedValue1 = widget.subText;
    _selectedValue2 = widget.unitText;
    _selectedValue3 = widget.taxText;
    priceController.text = widget.priceInput!;
    discountController.text = widget.discountInput!;
    productNameController.text = widget.textInput!;
    storeImageBytes1 = widget.imagePath;
    prodIdController.text = widget.prodId;
    // print(_selectedValue);
    // print(_selectedValue2);
    // print(_selectedValue3);
    // print(_selectedValue1);
    // print(priceController.text);
    // print(discountController.text);
    // print(prodIdController.text);
    // print('-----imageName----');
    // print(widget.imageId);
    // print(storeImage);
    // print(widget.imagePath);
    // print('-----imagepath');
    loadImage(widget.imageId);
  }
  void loadImage(String imageUrl) {
    try {
      fetchImage(imageUrl);
      // Debugging information
      print('Image loaded successfully');
    } catch (e) {
      // Handle error
      print('Error loading image: $e');
    }
  }// Function to check if all required fields are filled
  bool areRequiredFieldsFilled() {
    return productNameController.text.isNotEmpty &&
        _selectedValue != 'Select' &&
        _selectedValue1 != 'Select' &&
        _selectedValue2 != 'select' &&
        _selectedValue3 != 'select' &&
        priceController.text.isNotEmpty &&
        discountController.text.isNotEmpty;
  }
  Future<void> filePicker() async {
    result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      print("No file selected");
    } else {
      setState(() {
        selectedImages.clear(); // Clear previous selections
      });
      for (var element in result!.files) {
        setState(() {
          print('jiiii');
          print(element.name);
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

  void fetchImage(String imageId) async {
    print('----img-----');
    print(storeImage);
    String url =
        'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/view/$imageId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        setState(() {
          storeImageBytes1 = response.bodyBytes;
        });
      } catch (e) {
        print('-------------');
        print('Error:$e');
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all required fields")),
        );
      }
      return;
    }
    final productData = {
      "prodId": prodIdController.text,
      "productName": productNameController.text,
      "category": _selectedValue,
      "subCategory": _selectedValue1,
      "tax": _selectedValue3,
      "unit": _selectedValue2,
      "price": double.parse(priceController.text),
      "discount": discountController.text,
      "imageId": storeImage == "" ? widget.imageId : storeImage,
    };
    print('---------productData------');
    print(widget.imageId);
    print(storeImage);
    print('-----imageid-------');
    print(imageId);
    print(productData);
    print(storeImage);
    print('----prodid');
    print(prodIdController.text);

    const url =
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/update_productmaster';
    final response = await http.put(
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
          const SnackBar(content: Text("Product added successfully")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Image.asset("images/Final-Ikyam-Logo.png"),
          backgroundColor:
          const Color(0xFFFFFFFF), // Set background color to white
          elevation: 4.0,
          shadowColor: const Color(0xFFFFFFFF), // Set shadow color to black
          actions: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification icon press
                },
              ),
            ),
            const SizedBox(width: 10,),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 35),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (value) {
                    if (value == 'logout') {
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
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;

            double maxWidth = constraints.maxWidth;
            double maxHeight = constraints.maxHeight;
            // For web view
            return Stack(children: [
              Padding(
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
                          print('prodId');
                          print(prodIdController.text);
                           storeImage = '';
                          uploadImage(storeImage);
                          // fetchImage(storeImage);
                          widget.productData['imageId'] = storeImage == ""
                              ? widget.imageId
                              : storeImage;

                          context.go('/Edit_Product', extra: {
                            'displayData': widget.productData,
                            'imagePath': storeImageBytes1!,
                            'product': null,
                            'productText': widget.textInput!,
                            'selectedValue': widget.inputText,
                            'selectedValue1': widget.subText,
                            'selectedValue3': widget.taxText,
                            'selectedvalue2': widget.unitText,
                            'priceText': widget.priceInput!,
                            'discountText': widget.discountInput!,
                            'prodId': prodIdController.text,

                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductForm1(
                                  displayData: widget.productData,
                                  imagePath: storeImageBytes1!,
                                  product: null,
                                  productText: widget.textInput!,
                                  selectedValue: widget.inputText,
                                  selectedValue1: widget.subText,
                                  selectedValue3: widget.taxText,
                                  selectedvalue2: widget.unitText,
                                  priceText: widget.priceInput!,
                                  discountText: widget.discountInput!,
                                  prodId: prodIdController.text,
                                ),
                              ));
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: const Alignment(0.7,0.7),
                        child: OutlinedButton(
                          onPressed: () {
                            _selectedValue = widget.inputText;
                            _selectedValue1 = widget.subText;
                            _selectedValue2 = widget.unitText;
                            _selectedValue3 = widget.taxText;
                            productNameController.text = widget.textInput!;
                            priceController.text = widget.priceInput!;
                            discountController.text = widget.discountInput!;
                            selectedImages.clear();

                            storeImageBytes1 = widget.imagePath;
                            print(storeImageBytes1);
                            print('---wel');
                            print(widget.imageId);
                            loadImage(widget.imageId);
                            //uploadImage(widget.imageId);
                                   },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                            Colors.grey[400], // Blue background color
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
                              color: Colors.indigo[900], // White text color
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      Align(
                        alignment: const Alignment(0.0,0.7),
                        child: OutlinedButton(
                          onPressed: () {
                            print(storeImage);
                            token = window.sessionStorage["token"] ?? " ";
                            if (!areRequiredFieldsFilled()) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please fill in all required fields")),
                                );
                              }
                            } else {
                              checkSave(
                                productNameController.text,
                                _selectedValue!, // Replace with actual value
                                _selectedValue1!, // Replace with actual value
                                _selectedValue3!, // Replace with actual value
                                _selectedValue2!, // Replace with actual value
                                double.parse(
                                    priceController.text.toString()),
                                discountController.text,
                                storeImage,
                              );
                              uploadImage(storeImage);
                              // fetchImage(storeImage);
                              widget.productData['imageId'] =
                              storeImage == ""
                                  ? widget.imageId
                                  : storeImage;
                              widget.productData['productName'] =
                                  productNameController.text;
                              widget.productData['category'] =
                                  _selectedValue;
                              widget.productData['subCategory'] =
                                  _selectedValue1;
                              widget.productData['tax'] = _selectedValue3;
                              widget.productData['unit'] = _selectedValue2;
                              widget.productData['price'] =
                                  priceController.text;
                              widget.productData['discount'] =
                                  discountController.text;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Product updated successfully")),
                              );
                              // context.go(
                              //     '${PageName.subsubpage2Main}/${PageName.subpage2Main}');
                              //router maha dev
                              context.go('/dashboard/productpage/ontap/Edit/Update1', extra: {
                                'displayData':  widget.productData,
                                'product': null,
                                'imagePath': null,
                                'productText': widget.productData['productName'],
                                'selectedValue': widget.productData['category'],
                                'selectedValue1': widget.productData['subCategory'],
                                'selectedValue3': widget.productData['tax'],
                                'selectedvalue2': widget.productData['unit'],
                                'priceText': widget.productData['price'],
                                'discountText': widget.productData['discount'],
                                'prodId': widget.prodId,
                              });
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                    ProductForm1(
                                      displayData: widget.productData,
                                      product: null,
                                      imagePath: null,
                                      // imageName: widget.product!.imageId,
                                      productText:
                                      widget.productData['productName'],
                                      selectedValue:
                                      widget.productData['category'],
                                      selectedValue1:
                                      widget.productData['subCategory'],
                                      selectedValue3: widget.productData['tax'],
                                      selectedvalue2:
                                      widget.productData['unit'],
                                      priceText: widget.productData['price'],
                                      discountText:
                                      widget.productData['discount'],
                                      prodId: widget.prodId,
                                    ),
                              ));
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors
                                .blueAccent, // Button background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5), // Rounded corners
                            ),
                            side: BorderSide.none, // No outline
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 200),
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
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()),
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => Dashboard()),
                              // );
                              // setState(() {
                              //   isOrdersSelected = false;
                              //   // Handle button press19
                              // });
                            },
                            icon:
                            Icon(Icons.warehouse, color: Colors.blue[900]),
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
                  //old image copy
                  // GestureDetector(
                  //   onTap: () {
                  //     print('---imagePath---');
                  //     print(imagePath);
                  //     print(selectedImage);
                  //     filePicker();
                  //   },
                  //   child: Card(
                  //     margin: EdgeInsets.only(left: maxWidth * 0.08, top: maxHeight * 0.27,bottom: maxHeight * 0.29),
                  //     child: Flex(
                  //       direction: Axis.vertical,
                  //       children: [
                  //         Flexible(
                  //           flex: 4,
                  //           child: Container(
                  //             width: maxWidth * 0.3,
                  //             height: maxHeight * 1.2,
                  //             decoration: BoxDecoration(
                  //               color: Colors.grey[300],
                  //               borderRadius: BorderRadius.circular(4),
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 if (selectedImages.isEmpty) ...[
                  //                   widget.imagePath != null
                  //                       ? SizedBox(
                  //                     width: 250,
                  //                     height: 200,
                  //                     child: Image.memory(widget.imagePath!),
                  //                   )
                  //                       : const Text("Image is Null"),
                  //                 ] else ...[
                  //                   for (var imageBytes in selectedImages)
                  //                     Image.memory(
                  //                       imageBytes,
                  //                       fit: BoxFit.cover,
                  //                       width: 300, // Adjust as needed
                  //                       height: 300, // Adjust as needed
                  //                     ),
                  //                 ],
                  //                 Icon(Icons.cloud_upload_outlined, color: Colors.blue[900], size: 50),
                  //                 const SizedBox(height: 8),
                  //                 const Text(
                  //                   'Click to upload image',
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //                 const SizedBox(height: 8),
                  //                 const Text(
                  //                   'PNG, JPG, or GIF Recommended size below 1MB',
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(fontSize: 12),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      print('---imagePath---');
                      print(imagePath);
                      print(selectedImage);
                      filePicker();
                    },
                    child: Card(
                      margin: EdgeInsets.only(left: maxWidth * 0.08, top: maxHeight * 0.27, bottom: maxHeight * 0.29),
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Container(
                              width: maxWidth * 0.3,
                              height: maxHeight * 1.2,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (selectedImages.isEmpty)...[
                                    widget.imagePath!= null
                                        ? Image.memory(widget.imagePath!)
                                        : const Text("Image is Null"),
                                  ] else...[
                                    for (var imageBytes in selectedImages)
                                      Image.memory(
                                        imageBytes,
                                        fit: BoxFit.cover,
                                        width: 300, // Adjust as needed
                                        height: 300, // Adjust as needed
                                      ),
                                  ],
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined, color: Colors.blue[900], size: 50),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Click to upload image',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'PNG, JPG, or GIF Recommended size below 1MB',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
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
                      margin: EdgeInsets.only(left: maxWidth * 0.08, top: maxHeight * 0.15,right: maxWidth * 0.1),
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
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Product Name ',
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
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                          color: Colors.blue[100]!),
                                    ),
                                    child: TextFormField(
                                      // LAST ONE
                                      //initialValue: widget.textInput,
                                      controller: productNameController,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        border: InputBorder.none,
                                        filled: true,
                                        hintText: 'Enter product name',
                                        errorText: errorMessage,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z0-9 ]")),
                                        // Allow only letters, numbers, and single space
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'^\s')),
                                        // Disallow starting with a space
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s\s')),
                                        // Disallow multiple spaces
                                      ],
                                      validator: (value) {
                                        if (value != null &&
                                            value.trim().isEmpty) {
                                          return 'Please enter a product name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
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
                                              child:
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedValue,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedValue =
                                                      newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    widget.inputText,
                                                    'Select 1',
                                                    'Select 2',
                                                    'Select 3'
                                                  ].map<
                                                      DropdownMenuItem<
                                                          String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down), // Custom icon
                                                  iconSize:
                                                  24, // Custom icon size
                                                  isExpanded:
                                                  true, // Ensures the dropdown fills the width
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
                                Flexible(
                                  flex: 2,
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
                                                  text: 'Sub Category ',
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
                                              child:
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedValue1,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedValue1 =
                                                      newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    widget.subText,
                                                    'Yes    ',
                                                    'No     '
                                                  ].map<
                                                      DropdownMenuItem<
                                                          String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down), // Custom icon
                                                  iconSize:
                                                  24, // Custom icon size
                                                  isExpanded:
                                                  true, // Ensures the dropdown fills the width
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
                                              child:
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedValue3,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedValue3 =
                                                      newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    widget.taxText,
                                                    '12%    ',
                                                    '18%    ',
                                                    '20%    ',
                                                    '10%    '
                                                  ].map<
                                                      DropdownMenuItem<
                                                          String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down), // Custom icon
                                                  iconSize:
                                                  24, // Custom icon size
                                                  isExpanded:
                                                  true, // Ensures the dropdown fills the width
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
                                              child:
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: _selectedValue2,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _selectedValue2 =
                                                      newValue!;
                                                    });
                                                  },
                                                  items: <String>[
                                                    widget.unitText,
                                                    'NOS   ',
                                                    'PCS   ',
                                                    'PKD    '
                                                  ].map<
                                                      DropdownMenuItem<
                                                          String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                  icon: const Icon(Icons
                                                      .arrow_drop_down), // Custom icon
                                                  iconSize:
                                                  24, // Custom icon size
                                                  isExpanded:
                                                  true, // Ensures the dropdown fills the width
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
                                            // initialValue:
                                            //     widget.discountInput,
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
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // OutlinedButton(
                                //   onPressed: () {
                                //     dropdownValue = 'Select';
                                //     dropdownValue3 = 'select';
                                //     dropdownValue1 = 'select';
                                //     dropdownValue2 = 'select';
                                //     productNameController.clear();
                                //     // // //dropdownValue.clear();
                                //     // // // subCategoryController.clear();
                                //     // // // taxController.clear();
                                //     // //unitController.clear();
                                //     priceController.clear();
                                //     selectedImages.clear();
                                //     imageIdController.clear();
                                //     discountController.clear();
                                //     setState(() {});
                                //
                                //     // Optionally, display a message
                                //     ScaffoldMessenger.of(context)
                                //         .showSnackBar(
                                //       const SnackBar(
                                //           content: Text("Form cleared")),
                                //     );
                                //   },
                                //   style: OutlinedButton.styleFrom(
                                //     backgroundColor: Colors
                                //         .grey[400], // Blue background color
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(
                                //           5), // Rounded corners
                                //     ),
                                //     side: BorderSide.none, // No outline
                                //   ),
                                //   child: Text(
                                //     'Cancel',
                                //     style: TextStyle(
                                //       fontSize: 15,
                                //       // Increase font size if desired
                                //       // Bold text
                                //       color: Colors
                                //           .indigo[900], // White text color
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(width: 16),
                                // OutlinedButton(
                                //   onPressed: () {
                                //     // checkSave(
                                //     //   productNameController.text,
                                //     //   dropdownValue,
                                //     //   dropdownValue3,
                                //     //   dropdownValue1,
                                //     //   dropdownValue2,
                                //     //   double.parse(priceController.text.toString()),
                                //     //   // Ensure this is a valid integer
                                //     //   discountController.text,
                                //     //   storeImage,
                                //     //   // imageIdController.text,
                                //     // );
                                //     print('--------------');
                                //     print(productNameController.text);
                                //     print('-------saveTo');
                                //     token =
                                //         window.sessionStorage["token"] ?? " ";
                                //     print("token");
                                //     print(token);
                                //     if (!areRequiredFieldsFilled()) {
                                //       // if (imagePath == null ||
                                //       //     selectedImage == null) {
                                //       if (mounted) {
                                //         ScaffoldMessenger.of(context)
                                //             .showSnackBar(
                                //           const SnackBar(
                                //               content: Text(
                                //                   "Please fill in all required fields")),
                                //         );
                                //       }
                                //       // }
                                //     } else {
                                //       checkSave(
                                //         productNameController.text,
                                //         dropdownValue,
                                //         dropdownValue3,
                                //         dropdownValue1,
                                //         dropdownValue2,
                                //         double.parse(
                                //             priceController.text.toString()),
                                //         // Ensure this is a valid integer
                                //         discountController.text,
                                //         storeImage,
                                //         // imageIdController.text,
                                //       );
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(
                                //         const SnackBar(
                                //             content: Text(
                                //                 "Product added successfully")),
                                //       );
                                //     }
                                //     // filePicker();
                                //   },
                                //   child: Text(
                                //     "Save",
                                //     style: TextStyle(
                                //         color: Colors.white, fontSize: 15),
                                //   ),
                                //   style: OutlinedButton.styleFrom(
                                //     backgroundColor: Colors.blue,
                                //     // Blue background color
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(
                                //           5), // Rounded corners
                                //     ),
                                //     side: BorderSide.none, // No outline
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
          },
        ), // Use the ProductForm widget here
      ),
    );
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
