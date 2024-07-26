import 'dart:convert';
import 'dart:html';
import 'dart:math';
// import 'dart:io' as io;

import 'package:btb/fifthpage/Edit.dart';
import 'package:btb/fourthpage/orderspage%20order.dart';
import 'package:btb/screen/login.dart';
import 'package:btb/sprint%202%20order/firstpage.dart';
import 'package:btb/thirdpage/dashboard.dart';
import 'package:btb/thirdpage/productclass.dart' as ord;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../main.dart';

void main(){
  runApp(ProductForm1(product: null, prodId: '', priceText: '', productText: '', selectedvalue2: '', discountText: '', selectedValue: '', selectedValue1: '', selectedValue3: '', imagePath: null, displayData: {}));
}

class ProductForm1 extends StatefulWidget {
  const ProductForm1({
    super.key,
    required this.product,
    required this.prodId,
    required this.priceText,
    required this.productText,
    required this.selectedvalue2,
    required this.discountText,
    required this.selectedValue,
    required this.selectedValue1,
    required this.selectedValue3,
    required this.imagePath,
    required this.displayData,
  });

  final ord.Product? product;
  final String? priceText;
  final Map displayData;
  final String? productText;
  final String? prodId;
  final String? selectedvalue2;
  final String? discountText;
  final String? selectedValue;
  final String? selectedValue1;
  final String? selectedValue3;

  final Uint8List? imagePath;
  @override
  State<ProductForm1> createState() => _ProductForm1State();
}

class _ProductForm1State extends State<ProductForm1> {
  String? _textInput;
  String? _priceInput;
  String? discountInput;
  String storeImage = '';
  String? imageId = '';
  var result;
  List<ord.Product> selectedProductList = [];
  String token = window.sessionStorage["token"] ?? " ";
  final ProId = TextEditingController();
  String searchText = ''; // Variable to store search text
  final ProCat = TextEditingController();
  String? pickedImagePath;
  int selectedIndex = -1;
  bool isOrdersSelected = false;
  bool isImageBase64 = false;
  Uint8List? imageStore;
  List<ord.Product> productList = [];
  TextEditingController product1NameController = TextEditingController();
  TextEditingController product1DescriptionController = TextEditingController();
  TextEditingController product1PriceController = TextEditingController();
  bool isEditing = false;
  Uint8List? storeImageBytes1;
  String? errorMessage;
  final prodId1Controller = TextEditingController();
  final productNameController = TextEditingController();
  final categoryController = TextEditingController();
  final subCategoryController = TextEditingController();
  final prodIdController = TextEditingController();
  final CategoryController = TextEditingController();
  final taxController = TextEditingController();
  final unitController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final imageIdContoller = TextEditingController();
  bool areRequiredFieldsFilled() {
    return productNameController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        taxController.text.isNotEmpty &&
        unitController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        discountController.text.isNotEmpty;
  }

  Future<void> _newData() async {
    print('Token: $token');
    if (searchText.isNotEmpty) {
      await fetchData(searchText, 'category');
    }
    else if(searchText.isEmpty) {
      await fetchProducts();
    }
      else
  {
      setState(() {
        productList = [];
      });
    }
  }

  Future<void> fetchData(String productName, String category) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/search_by_productname/$productName'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = jsonDecode(responseBody);
        if (jsonData != null) {
          if (jsonData is List) {
            final List<dynamic> jsonDataList = jsonData;
            final List<ord.Product> products = jsonDataList
                .map<ord.Product>((item) => ord.Product.fromJson(item))
                .toList();

            // Limit the number of products to 10
            final limitedProducts = products.take(10).toList();

            setState(() {
              productList = limitedProducts;
            });
          } else if (jsonData is Map) {
            final List<dynamic>? jsonDataList = jsonData['body'];
            if (jsonDataList != null) {
              final List<ord.Product> products = jsonDataList
                  .map<ord.Product>((item) => ord.Product.fromJson(item))
                  .toList();

              // Limit the number of products to 10
              final limitedProducts = products.take(10).toList();

              setState(() {
                productList = limitedProducts;
              });
            } else {
              setState(() {
                productList = []; // Initialize with an empty list
              });
            }
          } else {
            setState(() {
              productList = []; // Initialize with an empty list
            });
          }
        } else {
          setState(() {
            productList = []; // Initialize with an empty list
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future fetchImage(String imageId) async {
    print('---------inside Image Fetch Api---------');
    String url =
        'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/view/$imageId';
    print('-------------imageUrl--------------');
    print(imageId);
    print(url);
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      try {
        setState(() {
          print('------type-----');
          print(response.bodyBytes);
          print(response.runtimeType);
          storeImageBytes1 = response.bodyBytes;
          print('--storeImageBytes1--');
          print(storeImageBytes1);
        });
      } catch (e) {
        print('-------------');
        print('Error:$e');
      }
    }
  }

  @override
  void dispose() {
    product1NameController.dispose();
    product1DescriptionController.dispose();
    product1PriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    if (widget.product != null) {
      productNameController.text = widget.product!.productName;
      categoryController.text = widget.product!.category;
      prodIdController.text = widget.product!.prodId;
      subCategoryController.text = widget.product!.subCategory;
      CategoryController.text = widget.product!.category;
      taxController.text = widget.product!.tax;
      unitController.text = widget.product!.unit;
      priceController.text = widget.product!.price.toString();
      discountController.text = widget.product!.discount;
      imageIdContoller.text = widget.product!.imageId;
      isEditing = false;
      loadImage(widget.product!.imageId);
      print('------Prodid------');
      print(prodIdController.text);

      //}
    } else {
      print(widget.displayData['price']);
      print(widget.discountText);
      priceController.text = widget.priceText!;
      discountController.text = widget.discountText!;
      productNameController.text = widget.productText!;
      unitController.text = widget.selectedvalue2!;
      taxController.text = widget.selectedValue3!;
      categoryController.text = widget.selectedValue!;
      prodIdController.text = widget.prodId!;
      subCategoryController.text = widget.selectedValue1!;
      loadImage(widget.displayData['imageId'] ?? "");
      print("----imagePath-----");
      print("---imagename----");
      print(priceController.text);
      print(taxController.text);
      print(discountController.text);
      print(widget.displayData['imageId'] ?? " ");
    }
  }

  bool isBase64(String str) {
    const base64Pattern = r'^[A-Za-z0-9+/]+={0,2}$';
    final regex = RegExp(base64Pattern);
    return regex.hasMatch(str);
  }

  void searchSelect(String productName) async {
    // print(token);
    try {
      // Make an HTTP request to fetch data from the API
      final response = await http.get(
        Uri.parse(
            'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/search_by_productname/$productName'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        //print(token);
        // Parse the response body
        final jsonData = jsonDecode(response.body);
        // Convert the JSON data into a list of Product objects
        final List<ord.Product> products = jsonData
            .map<ord.Product>((item) => ord.Product.fromJson(item))
            .toList();
        // Update the state to reflect the fetched products
        setState(() {
          productList = products;
        });
      } else {
        // Handle error if the request was not successful
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error: $error');
    }
  }

  void handleTextFormFieldTap() async {
    String productName = 'ProductName';
    String category = 'category';
    await fetchData(productName, category);
  }

  Future<void> checkimage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      pickedImagePath = pickedImage.path;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image selected")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image selection cancelled")),
      );
    }
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse(
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster',
      ),
      headers: {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          if (jsonData is List) {
            final products =
            jsonData.map((item) => ord.Product.fromJson(item)).toList();
            setState(() {
              productList = products;
              productList.sort((a, b) => a.productName
                  .toLowerCase()
                  .compareTo(b.productName.toLowerCase()));
            });
          } else if (jsonData is Map) {
            if (jsonData.containsKey('body')) {
              final products = jsonData['body']
                  .map((item) => ord.Product.fromJson(item))
                  .toList();
              setState(() {
                productList = products;
                productList.sort((a, b) => a.productName
                    .toLowerCase()
                    .compareTo(b.productName.toLowerCase()));
              });
            } else {
              setState(() {
                productList = []; // Initialize with an empty list
              });
            }
          } else {
            setState(() {
              productList = []; // Initialize with an empty list
            });
          }
        } else {
          setState(() {
            productList = []; // Initialize with an empty list
          });
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar:
        AppBar(
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
              child:
              Align(
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
        body: LayoutBuilder(
            builder: (context, constraints) {
              double maxHeight = constraints.maxHeight;
              double maxWidth = constraints.maxWidth;
//

              // For web view
              return Stack(
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
                                    builder: (context) => Dashboard()),
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
                              context.go('/:products/Orderspage');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Orderspage()),
                              );
                              setState(() {
                                isOrdersSelected = false;
                                // Handle button press19
                              });
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
                  Container(
                    margin: const EdgeInsets.only(
                      top: 60,
                      left: 200,
                    ),
                    width:250,
                    height: 980,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 5),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Search product',
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.search_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                              onChanged: (value) {
                                token = window.sessionStorage["token"] ?? " ";
                                setState(() {
                                  searchText = value; // Update searchText
                                });
                                _newData();
                                // fetchImage(); // Fetch data
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: maxHeight * 0.83,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              final Product = productList[index];
                              bool isSelected = Product.productName ==
                                  productNameController.text;
                              productList.sort((a, b) {
                                if (a.productName ==
                                    productNameController.text) {
                                  return -1; // selected product name comes first
                                } else if (b.productName ==
                                    productNameController.text) {
                                  return 1; // selected product name comes first
                                } else {
                                  final aIsNumber = a.productName[0]
                                      .contains(RegExp(r'[0-90]'));
                                  final bIsNumber = b.productName[0]
                                      .contains(RegExp(r'[0-90]'));

                                  if (aIsNumber && !bIsNumber) {
                                    return 1;
                                  } else if (!aIsNumber && bIsNumber) {
                                    return -1;
                                  } else {
                                    return a.productName
                                        .compareTo(b.productName);
                                  }
                                }
                              });
                              return GestureDetector(
                                onTap: () {
                                //  context.go('/dasbaord/productpage/ontap');
                                  setState(() {
                                    productNameController.text =
                                        Product.productName;
                                    prodIdController.text = Product.prodId;
                                    print(prodIdController.text);
                                    categoryController.text = Product.category;
                                    subCategoryController.text =
                                        Product.subCategory;
                                    taxController.text = Product.tax;
                                    unitController.text = Product.unit;
                                    priceController.text =
                                        Product.price.toString();
                                    discountController.text = Product.discount;
                                    imageIdContoller.text = Product.imageId;
                                    print('---iamde');
                                    widget.displayData['imageId'] =
                                        imageIdContoller.text;
                                    print(imageIdContoller.text);
                                    fetchImage(productList[index].imageId);
                                  });
                                },
                                child: Container(
                                  decoration: isSelected
                                      ? BoxDecoration(
                                      color: Colors
                                          .lightBlue[100]) // selected color
                                      : null,
                                  child: ListTile(
                                    title: Text(
                                      '${Product.productName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text('${Product.category}'),
                                    tileColor: isSelected
                                        ? Colors.lightBlue[100]
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 490),
                  //   child: Container(
                  //     margin: const EdgeInsets.symmetric(
                  //         horizontal: 10), // Space above/below the border
                  //     width: 3, // Border height
                  //     color: Colors.grey[100], // Border color
                  //   ),
                  // ),
                  Row(
                    children: [
                      storeImageBytes1 != null
                          ? Container(
                        margin:  EdgeInsets.only(
                          top: 20,
                          left: maxWidth * 0.35,
                        ),
                        //image container controller
                        width: maxWidth * 0.2,
                        height: maxHeight *0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.memory(storeImageBytes1!),
                      )
                          : Container(
                        margin:  EdgeInsets.only(
                          top: 20,
                          left: maxWidth * 0.45,
                        ),
                        //image container controller
                        width: maxWidth * 0.15,
                        height: maxHeight * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('No Image Found.'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFirstWidget(
                            context), // Use the ProductForm widget here
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
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
                                context.go('/dasbaord/productpage/:product');
                                Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                      ProductPage(product: null),
                                ));
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           ProductPage(product: null)),
                                // );
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                'Product List',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: OutlinedButton(
                                onPressed: () {
                                  // context.go(
                                  //     '${PageName.dashboardRoute ?? ''}/${PageName.subpage2 ?? ''}/${PageName.subpage2Main ?? ''}/${PageName.subsubpage2Main ?? ''}');
                                  // fetchImage(storeImage!);
                                  print('---- image path-----');
                                  print(storeImageBytes1);
                                  print(priceController.text);
                                  print(discountController.text);
                                  print(subCategoryController.text);
                                  print(categoryController.text);
                                  print(unitController.text);
                                  print(taxController.text);
                                  print(productNameController.text);
                                  print('hii');
                                  print(widget.displayData['imageId'] ?? "");
                                  print(imageIdContoller.text);
                                  final inputText = categoryController.text;
                                  final subText = subCategoryController.text;
                                  final unitText = unitController.text;
                                  final taxText = taxController.text;
                                  final prodText = prodIdController.text;

                                  if (storeImageBytes1 != null &&
                                      productNameController.text.isNotEmpty &&
                                      priceController.text.isNotEmpty &&
                                      discountController.text.isNotEmpty) {
                                    _textInput = productNameController.text;
                                    _priceInput = priceController.text;
                                    discountInput = discountController.text;
                                    context.go('/dashboard/productpage/ontap/Edit', extra: {
                                      'prodId': prodText ?? '',
                                      'textInput': _textInput ?? '',
                                      'priceInput': _priceInput ?? '',
                                      'discountInput': discountInput ?? '',
                                      'inputText': inputText ?? '',
                                      'subText': subText ?? '',
                                      'unitText': unitText ?? '',
                                      'taxText': taxText ?? '',
                                      'imagePath': storeImageBytes1 ?? '',
                                      'imageId': widget.displayData['imageId']?? imageIdContoller.text?? '',
                                      'productData': {}, // or pass the actual product data
                                   });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditOrder(
                                          prodId: prodText,
                                          // product: null,
                                          textInput: _textInput,
                                          priceInput: _priceInput,
                                          discountInput: discountInput,
                                          inputText: inputText,
                                          subText: subText,
                                          unitText: unitText,
                                          taxText: taxText,
                                          imagePath: storeImageBytes1,
                                          imageId:
                                          widget.displayData['imageId'] ??
                                              imageIdContoller.text ??
                                              "",
                                          // imageId: widget.product?.imageId ??
                                          //     widget.displayData['imageId'] ??
                                          //     imageIdContoller.text ??
                                          //     "",
                                          productData: {},
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Handle case when imagePath is null or other required fields are empty
                                    print(
                                        'Error: Image path is null or other required fields are empty.');
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
                                child: Text(
                                  isEditing ? 'Edit' : 'Edit',
                                  style: const TextStyle(
                                    fontSize: 18,
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
                  Padding(
                    padding:  EdgeInsets.only(top: 0, left: 450),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10), // Space above/below the border
                      height: constraints.maxHeight,
                      // width: 1500,
                      width: 2,// Border height
                      color: Colors.grey[300], // Border color
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> checkSave() async {
    if (!areRequiredFieldsFilled()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Please fill in all required fields and select an image")),
        );
      }
      return;
    }

    final productData = {
      "productName": productNameController.text,
      "category": categoryController.text,
      "subCategory": subCategoryController.text,
      "tax": taxController.text,
      "unit": unitController.text,
      "price": int.parse(priceController.text),
      "discount": discountController.text,
    };

    const productUrl =
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/update_productmaster';

    final productResponse = await http.put(
      Uri.parse(productUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: json.encode(productData),
    );

    if (productResponse.statusCode == 200) {
      final responseData = json.decode(productResponse.body);

      if (responseData.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product: error")),
        );
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text("Your message")),
        );

        // Create a new product with the image
        final selectedProduct = ord.Product(
          productName: productNameController.text,
          category: categoryController.text,
          subCategory: subCategoryController.text,
          tax: taxController.text,
          unit: unitController.text,
          price: int.parse(priceController.text),
          discount: discountController.text,
          imageId: imageIdContoller.text,
          prodId: '', selectedUOM: '', selectedVariation: '', quantity: 0,total: 0,totalamount: 0, totalAmount: 0.0, qty: 0,
        );

        // Add the selected product to the list
        selectedProductList.add(selectedProduct);

        // Navigate to the next page with the selectedProductList
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add product")),
      );
    }
  }

  @override
  Widget _buildFirstWidget(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
            SizedBox(width: 10,),
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
              double maxHeight = constraints.maxHeight;
              double maxWidth = constraints.maxWidth;
//


              // For larger screens (like web view)
              return Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  top: 120,
                  right: 125,

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Product  Name',
                            style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
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
                            child: TextFormField(
                              controller: productNameController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                enabled: isEditing,
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                                filled: true,
                                hintText: 'Enter product Name',
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
                                if (value != null && value.trim().isEmpty) {
                                  return 'Please enter a product name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Category',
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border:
                                    Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: TextFormField(
                                    controller: categoryController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabled: isEditing,
                                      border: InputBorder.none,
                                      hintText: 'Enter Category',
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Sub Category',
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border:
                                    Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: TextFormField(
                                    controller: subCategoryController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabled: isEditing,
                                      border: InputBorder.none,
                                      hintText: 'Enter Sub Category',
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Tax',
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border:
                                    Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: TextFormField(
                                    controller: taxController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabled: isEditing,
                                      border: InputBorder.none,
                                      hintText: 'Enter tax',
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Unit',
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border:
                                    Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: TextFormField(
                                    controller: unitController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabled: isEditing,
                                      border: InputBorder.none,
                                      hintText: 'Enter Unit',
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Price ',
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border:
                                    Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          10), // limits to 10 digits
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabled: isEditing,
                                      border: InputBorder.none,
                                      hintText: 'Enter Price',
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Discount',
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2),
                                    border:
                                    Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: TextFormField(
                                    controller: discountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                          10), // limits to 10 digits
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      enabled: isEditing,
                                      border: InputBorder.none,
                                      // fillColor: isEditing
                                      //     ? Colors.white
                                      //     : Colors.grey[100],
                                      fillColor: Colors.white,
                                      hintText: 'Enter Discount',
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                                  // TextFormField(
                                  //   enabled: isEditing,
                                  //   controller: discountController,
                                  //   decoration: InputDecoration(
                                  //     fillColor: Colors.white,
                                  //     contentPadding:
                                  //         EdgeInsets.symmetric(horizontal: 10),
                                  //     border: InputBorder.none,
                                  //     filled: true,
                                  //     hintText: 'Enter Discount',
                                  //   ),
                                  // ),
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
                        //     productNameController.clear();
                        //     categoryController.clear();
                        //     subCategoryController.clear();
                        //     taxController.clear();
                        //     unitController.clear();
                        //     priceController.clear();
                        //     discountController.clear();
                        //   },
                        //   style: OutlinedButton.styleFrom(
                        //     backgroundColor:
                        //         Colors.grey[400], // Blue background color
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius:
                        //           BorderRadius.circular(5), // Rounded corners
                        //     ),
                        //     side: BorderSide.none, // No outline
                        //   ),
                        //   child: Text(
                        //     'Cancel',
                        //     style: TextStyle(
                        //       fontSize: 15, // Increase font size if desired
                        //       // Bold text
                        //       color: Colors.indigo[900], // White text color
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 16),
                        // OutlinedButton(
                        //   onPressed: () {
                        //     print('-------saveTo');
                        //     token = window.sessionStorage["token"] ?? " ";
                        //     print("token");
                        //     print(token);
                        //     if (!areRequiredFieldsFilled()) {
                        //       if (mounted) {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           const SnackBar(
                        //               content: Text(
                        //                   "Please fill in all required fields")),
                        //         );
                        //       }
                        //     } else {
                        //       checkSave();
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text("success")),
                        //       );
                        //     }
                        //   },
                        //   child: Text(
                        //     "Save",
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        //   style: OutlinedButton.styleFrom(
                        //     backgroundColor: Colors.blue,
                        //     // Blue background color
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius:
                        //           BorderRadius.circular(5), // Rounded corners
                        //     ),
                        //     side: BorderSide.none, // No outline
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              );
            }
          // else {
          //   // For smaller screens (like mobile view)
          //   return Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const SizedBox(height: 16),
          //         const Text(
          //           'Product Name*',
          //         ),
          //         const SizedBox(height: 8),
          //         TextFormField(
          //           decoration: InputDecoration(
          //             enabled: isEditing,
          //             filled: true,
          //             fillColor: Colors.white,
          //             hintText: 'Enter product name',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(4),
          //               borderSide: BorderSide(color: Colors.blue[100]!),
          //             ),
          //             contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 10),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         const Text('Category*',
          //             style: TextStyle(
          //                 fontSize: 16, fontWeight: FontWeight.bold)),
          //         const SizedBox(height: 8),
          //         TextFormField(
          //           decoration: InputDecoration(
          //             enabled: isEditing,
          //             filled: true,
          //             fillColor: Colors.white,
          //             hintText: 'Enter category',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(4),
          //               borderSide: BorderSide(color: Colors.blue[100]!),
          //             ),
          //             contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 10),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         const Text('Sub Category',
          //             style: TextStyle(
          //                 fontSize: 16, fontWeight: FontWeight.bold)),
          //         const SizedBox(height: 8),
          //         TextFormField(
          //           decoration: InputDecoration(
          //             enabled: isEditing,
          //             filled: true,
          //             fillColor: Colors.white,
          //             hintText: 'Enter Sub category',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(4),
          //               borderSide: BorderSide(color: Colors.blue[100]!),
          //             ),
          //             contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 10),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         const Text('Tax*',
          //             style: TextStyle(
          //                 fontSize: 16, fontWeight: FontWeight.bold)),
          //         const SizedBox(height: 8),
          //         TextFormField(
          //           decoration: InputDecoration(
          //             filled: true,
          //             enabled: isEditing,
          //             fillColor: isEditing ? Colors.white : Colors.grey[100],
          //             hintText: 'Enter tax',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(4),
          //               borderSide: BorderSide(color: Colors.blue[100]!),
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(4),
          //               borderSide: BorderSide(color: Colors.blue[100]!),
          //             ),
          //             disabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(4),
          //               borderSide:
          //               BorderSide(color: Colors.grey[500]!, width: 2),
          //             ),
          //             contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 10),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         const Text('Unit*',
          //             style: TextStyle(
          //                 fontSize: 16, fontWeight: FontWeight.bold)),
          //         const SizedBox(height: 8),
          //         TextFormField(
          //           decoration: InputDecoration(
          //             filled: true,
          //             enabled: isEditing,
          //             fillColor: Colors.white,
          //             hintText: 'Enter Unit',
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(4),
          //               borderSide: BorderSide(color: Colors.blue[100]!),
          //             ),
          //             contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 10),
          //           ),
          //         ),
          //         const SizedBox(height: 16),
          //         const Text('Price*',
          //             style: TextStyle(
          //                 fontSize: 16, fontWeight: FontWeight.bold)),
          //         const SizedBox(height: 8),
          //         TextFormField(
          //           enabled: isEditing,
          //           controller: priceController,
          //           keyboardType: TextInputType.number,
          //           inputFormatters: [
          //             FilteringTextInputFormatter.digitsOnly,
          //             LengthLimitingTextInputFormatter(
          //                 10), // limits to 10 digits
          //           ],
          //           decoration: InputDecoration(
          //             fillColor: Colors.white,
          //             contentPadding:
          //             const EdgeInsets.symmetric(horizontal: 10),
          //             border: InputBorder.none,
          //             filled: true,
          //             hintText: 'Enter Price',
          //             errorText: errorMessage,
          //           ),
          //           onChanged: (value) {
          //             if (value.isNotEmpty && !isNumeric(value)) {
          //               setState(() {
          //                 errorMessage = 'Please enter numbers only';
          //               });
          //             } else {
          //               setState(() {
          //                 errorMessage = null;
          //               });
          //             }
          //           },
          //         ),
          //         // TextFormField(
          //         //   decoration: InputDecoration(
          //         //     filled: true,
          //         //     enabled: isEditing,
          //         //     fillColor: Colors.white,
          //         //     hintText: 'Enter Price',
          //         //     border: OutlineInputBorder(
          //         //       borderRadius: BorderRadius.circular(4),
          //         //       borderSide: BorderSide(color: Colors.blue[100]!),
          //         //     ),
          //         //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
          //         //   ),
          //         // ),
          //         const SizedBox(height: 16),
          //         const Text('Discount*',
          //             style: TextStyle(
          //                 fontSize: 16, fontWeight: FontWeight.bold)),
          //         const SizedBox(height: 8),
          //
          //         // TextFormField(
          //         //   decoration: InputDecoration(
          //         //     filled: true,
          //         //     enabled: isEditing,
          //         //     fillColor: Colors.white,
          //         //     hintText: 'Enter Discount',
          //         //     border: OutlineInputBorder(
          //         //       borderRadius: BorderRadius.circular(4),
          //         //       borderSide: BorderSide(color: Colors.blue[100]!),
          //         //     ),
          //         //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
          //         //   ),
          //         // ),
          //         const SizedBox(height: 16),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.end,
          //           children: [
          //             OutlinedButton(
          //               onPressed: () {
          //                 // Implement cancel button action
          //                 productNameController.clear();
          //                 categoryController.clear();
          //                 subCategoryController.clear();
          //                 taxController.clear();
          //                 unitController.clear();
          //                 priceController.clear();
          //                 discountController.clear();
          //               },
          //               style: OutlinedButton.styleFrom(
          //                 backgroundColor:
          //                 Colors.grey[400], // Blue background color
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius:
          //                   BorderRadius.circular(5), // Rounded corners
          //                 ),
          //                 side: BorderSide.none, // No outline
          //               ),
          //               child: const Text(
          //                 'Cancel',
          //                 style: TextStyle(
          //                   fontSize: 18, // Increase font size if desired
          //                   fontWeight: FontWeight.bold, // Bold text
          //                   color: Colors.white, // White text color
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(width: 16),
          //             OutlinedButton(
          //               onPressed: () {
          //                 print('-------saveTo');
          //                 token = window.sessionStorage["token"] ?? " ";
          //                 print("token");
          //                 print(token);
          //                 if (!areRequiredFieldsFilled()) {
          //                   if (mounted) {
          //                     ScaffoldMessenger.of(context).showSnackBar(
          //                       const SnackBar(
          //                           content: Text(
          //                               "Please fill in all required fields")),
          //                     );
          //                   }
          //                 } else {
          //                   checkSave();
          //                   // filePicker();
          //                 }
          //               },
          //               style: OutlinedButton.styleFrom(
          //                 backgroundColor: Colors.blue,
          //                 // Blue background color
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius:
          //                   BorderRadius.circular(5), // Rounded corners
          //                 ),
          //                 side: BorderSide.none, // No outline
          //               ),
          //               child: const Text(
          //                 'Save',
          //                 style: TextStyle(
          //                   fontSize: 18, // Increase font size if desired
          //                   fontWeight: FontWeight.bold, // Bold text
          //                   color: Colors.white, // White text color
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   );
          // }
        ),
      ),
    );
  }


  bool isNumeric(String value) {
    return double.tryParse(value) != null;
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
  } // last edited
}
// import 'dart:convert';
// import 'dart:html';
// // import 'dart:io' as io;
//
// import 'package:btb/fifthpage/Edit.dart';
// import 'package:btb/fourthpage/orderspage%20order.dart';
// import 'package:btb/thirdpage/dashboard.dart';
// import 'package:btb/thirdpage/productclass.dart' as ord;
// import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// import '../main.dart';
//
// void main(){
//   runApp(ProductForm1(product: null, prodId: '', priceText: '', productText: '', selectedvalue2: '', discountText: '', selectedValue: '', selectedValue1: '', selectedValue3: '', imagePath: null, displayData: {}));
// }
//
// class ProductForm1 extends StatefulWidget {
//   const ProductForm1({
//     super.key,
//     required this.product,
//     required this.prodId,
//     required this.priceText,
//     required this.productText,
//     required this.selectedvalue2,
//     required this.discountText,
//     required this.selectedValue,
//     required this.selectedValue1,
//     required this.selectedValue3,
//     required this.imagePath,
//     required this.displayData,
//   });
//
//   final ord.Product? product;
//   final String? priceText;
//   final Map displayData;
//   final String? productText;
//   final String? prodId;
//   final String? selectedvalue2;
//   final String? discountText;
//   final String? selectedValue;
//   final String? selectedValue1;
//   final String? selectedValue3;
//
//   final Uint8List? imagePath;
//   @override
//   State<ProductForm1> createState() => _ProductForm1State();
// }
//
// class _ProductForm1State extends State<ProductForm1> {
//   String? _textInput;
//   String? _priceInput;
//   String? discountInput;
//   String storeImage = '';
//   String? imageId = '';
//   var result;
//   List<ord.Product> selectedProductList = [];
//   String token = window.sessionStorage["token"] ?? " ";
//   final ProId = TextEditingController();
//   String searchText = ''; // Variable to store search text
//   final ProCat = TextEditingController();
//   String? pickedImagePath;
//   int selectedIndex = -1;
//   bool isOrdersSelected = false;
//   bool isImageBase64 = false;
//   Uint8List? imageStore;
//   List<ord.Product> productList = [];
//   TextEditingController product1NameController = TextEditingController();
//   TextEditingController product1DescriptionController = TextEditingController();
//   TextEditingController product1PriceController = TextEditingController();
//   bool isEditing = false;
//   Uint8List? storeImageBytes1;
//   String? errorMessage;
//   final prodId1Controller = TextEditingController();
//   final productNameController = TextEditingController();
//   final categoryController = TextEditingController();
//   final subCategoryController = TextEditingController();
//   final prodIdController = TextEditingController();
//   final CategoryController = TextEditingController();
//   final taxController = TextEditingController();
//   final unitController = TextEditingController();
//   final priceController = TextEditingController();
//   final discountController = TextEditingController();
//   final imageIdContoller = TextEditingController();
//   bool areRequiredFieldsFilled() {
//     return productNameController.text.isNotEmpty &&
//         categoryController.text.isNotEmpty &&
//         taxController.text.isNotEmpty &&
//         unitController.text.isNotEmpty &&
//         priceController.text.isNotEmpty &&
//         discountController.text.isNotEmpty;
//   }
//
//   Future<void> _newData() async {
//     print('Token: $token');
//     if (searchText.isNotEmpty) {
//       await fetchData(searchText, 'category');
//     } else {
//       setState(() {
//         productList = [];
//       });
//     }
//   }
//
//   Future<void> fetchData(String productName, String category) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/search_by_productname/$productName'),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $token'
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final responseBody = response.body;
//         final jsonData = jsonDecode(responseBody);
//         if (jsonData != null) {
//           if (jsonData is List) {
//             final List<dynamic> jsonDataList = jsonData;
//             final List<ord.Product> products = jsonDataList
//                 .map<ord.Product>((item) => ord.Product.fromJson(item))
//                 .toList();
//
//             // Limit the number of products to 10
//             final limitedProducts = products.take(10).toList();
//
//             setState(() {
//               productList = limitedProducts;
//             });
//           } else if (jsonData is Map) {
//             final List<dynamic>? jsonDataList = jsonData['body'];
//             if (jsonDataList != null) {
//               final List<ord.Product> products = jsonDataList
//                   .map<ord.Product>((item) => ord.Product.fromJson(item))
//                   .toList();
//
//               // Limit the number of products to 10
//               final limitedProducts = products.take(10).toList();
//
//               setState(() {
//                 productList = limitedProducts;
//               });
//             } else {
//               setState(() {
//                 productList = []; // Initialize with an empty list
//               });
//             }
//           } else {
//             setState(() {
//               productList = []; // Initialize with an empty list
//             });
//           }
//         } else {
//           setState(() {
//             productList = []; // Initialize with an empty list
//           });
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//   }
//
//   Future fetchImage(String imageId) async {
//     print('---------inside Image Fetch Api---------');
//     String url =
//         'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/view/$imageId';
//     print('-------------imageUrl--------------');
//     print(imageId);
//     print(url);
//     final response = await http.get(
//       Uri.parse(url),
//     );
//     if (response.statusCode == 200) {
//       try {
//         setState(() {
//           print('------type-----');
//           print(response.bodyBytes);
//           print(response.runtimeType);
//           storeImageBytes1 = response.bodyBytes;
//           print('--storeImageBytes1--');
//           print(storeImageBytes1);
//         });
//       } catch (e) {
//         print('-------------');
//         print('Error:$e');
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     product1NameController.dispose();
//     product1DescriptionController.dispose();
//     product1PriceController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//     if (widget.product != null) {
//       productNameController.text = widget.product!.productName;
//       categoryController.text = widget.product!.category;
//       prodIdController.text = widget.product!.prodId;
//       subCategoryController.text = widget.product!.subCategory;
//       CategoryController.text = widget.product!.category;
//       taxController.text = widget.product!.tax;
//       unitController.text = widget.product!.unit;
//       priceController.text = widget.product!.price.toString();
//       discountController.text = widget.product!.discount;
//       imageIdContoller.text = widget.product!.imageId;
//       isEditing = false;
//       loadImage(widget.product!.imageId);
//       print('------Prodid------');
//       print(prodIdController.text);
//
//       //}
//     } else {
//       print(widget.displayData['price']);
//       print(widget.discountText);
//       priceController.text = widget.priceText!;
//       discountController.text = widget.discountText!;
//       productNameController.text = widget.productText!;
//       unitController.text = widget.selectedvalue2!;
//       taxController.text = widget.selectedValue3!;
//       categoryController.text = widget.selectedValue!;
//       subCategoryController.text = widget.selectedValue1!;
//       loadImage(widget.displayData['imageId'] ?? "");
//       print("----imagePath-----");
//       print("---imagename----");
//       print(priceController.text);
//       print(taxController.text);
//       print(discountController.text);
//       print(widget.displayData['imageId'] ?? " ");
//     }
//   }
//
//   bool isBase64(String str) {
//     const base64Pattern = r'^[A-Za-z0-9+/]+={0,2}$';
//     final regex = RegExp(base64Pattern);
//     return regex.hasMatch(str);
//   }
//
//   void searchSelect(String productName) async {
//     // print(token);
//     try {
//       // Make an HTTP request to fetch data from the API
//       final response = await http.get(
//         Uri.parse(
//             'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/search_by_productname/$productName'),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $token'
//         },
//       );
//
//       // Check if the request was successful
//       if (response.statusCode == 200) {
//         //print(token);
//         // Parse the response body
//         final jsonData = jsonDecode(response.body);
//         // Convert the JSON data into a list of Product objects
//         final List<ord.Product> products = jsonData
//             .map<ord.Product>((item) => ord.Product.fromJson(item))
//             .toList();
//         // Update the state to reflect the fetched products
//         setState(() {
//           productList = products;
//         });
//       } else {
//         // Handle error if the request was not successful
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       // Handle any errors that occur during the process
//       print('Error: $error');
//     }
//   }
//
//   void handleTextFormFieldTap() async {
//     String productName = 'ProductName';
//     String category = 'category';
//     await fetchData(productName, category);
//   }
//
//   Future<void> checkimage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       maxWidth: 150,
//     );
//
//     if (pickedImage != null) {
//       pickedImagePath = pickedImage.path;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Image selected")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Image selection cancelled")),
//       );
//     }
//   }
//
//
//
//   Future<void> fetchProducts() async {
//     final response = await http.get(
//       Uri.parse(
//         'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster',
//       ),
//       headers: {
//         "Content-type": "application/json",
//         "Authorization": 'Bearer $token'
//       },
//     );
//
//     if (response.statusCode == 200) {
//       try {
//         final jsonData = jsonDecode(response.body);
//         if (jsonData != null) {
//           if (jsonData is List) {
//             final products =
//                 jsonData.map((item) => ord.Product.fromJson(item)).toList();
//             setState(() {
//               productList = products;
//               productList.sort((a, b) => a.productName
//                   .toLowerCase()
//                   .compareTo(b.productName.toLowerCase()));
//             });
//           } else if (jsonData is Map) {
//             if (jsonData.containsKey('body')) {
//               final products = jsonData['body']
//                   .map((item) => ord.Product.fromJson(item))
//                   .toList();
//               setState(() {
//                 productList = products;
//                 productList.sort((a, b) => a.productName
//                     .toLowerCase()
//                     .compareTo(b.productName.toLowerCase()));
//               });
//             } else {
//               setState(() {
//                 productList = []; // Initialize with an empty list
//               });
//             }
//           } else {
//             setState(() {
//               productList = []; // Initialize with an empty list
//             });
//           }
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
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: Colors.white,
//           // Set background color to white
//           elevation: 4.0,
//           shadowColor: Colors.black,
//           // Set shadow color to black
//           actions: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//             SizedBox(width: 10,),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 35),
//                 child: IconButton(
//                   icon: const Icon(Icons.account_circle),
//                   onPressed: () {
//                     // Handle user icon press
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//               // For web view
//               return Stack(
//                 children: [
//                   Align(
//                     // Added Align widget for the left side menu
//                     alignment: Alignment.topLeft,
//                     child: Container(
//                       height: 1400,
//                       width: 200,
//                       color: const Color(0xFFF7F6FA),
//                       padding: const EdgeInsets.only(left: 20, top: 30),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextButton.icon(
//                             onPressed: () {
//                               context.go(
//                                   '/addproduct/dashboard');
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Dashboard()),
//                               );
//                             },
//                             icon: Icon(Icons.dashboard,
//                                 color: Colors.indigo[900]),
//                             label: Text(
//                               'Home',
//                               style: TextStyle(color: Colors.indigo[900]),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {
//                               setState(() {
//                                 isOrdersSelected = false;
//                                 // Handle button press19
//                               });
//                             },
//                             icon: Icon(Icons.image_outlined,
//                                 color: isOrdersSelected
//                                     ? Colors.blueAccent
//                                     : Colors.blueAccent),
//                             label: const Text(
//                               'Products',
//                               style: TextStyle(color: Colors.blueAccent),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //       builder: (context) => Dashboard()),
//                               // );
//                               // setState(() {
//                               //   isOrdersSelected = false;
//                               //   // Handle button press19
//                               // });
//                             },
//                             icon:
//                                 Icon(Icons.warehouse, color: Colors.blue[900]),
//                             label: Text(
//                               'Orders',
//                               style: TextStyle(
//                                 color: Colors.indigo[900],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.fire_truck_outlined,
//                                 color: Colors.blue[900]),
//                             label: Text(
//                               'Delivery',
//                               style: TextStyle(color: Colors.indigo[900]),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.document_scanner_rounded,
//                                 color: Colors.blue[900]),
//                             label: Text(
//                               'Invoice',
//                               style: TextStyle(color: Colors.indigo[900]),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.payment_outlined,
//                                 color: Colors.blue[900]),
//                             label: Text(
//                               'Payment',
//                               style: TextStyle(color: Colors.indigo[900]),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.backspace_sharp,
//                                 color: Colors.blue[900]),
//                             label: Text(
//                               'Return',
//                               style: TextStyle(color: Colors.indigo[900]),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           TextButton.icon(
//                             onPressed: () {},
//                             icon: Icon(Icons.insert_chart,
//                                 color: Colors.blue[900]),
//                             label: Text(
//                               'Reports',
//                               style: TextStyle(color: Colors.indigo[900]),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(
//                       top: 70,
//                       left: 200,
//                     ),
//                     width: 300,
//                     height: 986,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         SizedBox(
//                           height: 50,
//                           width: 60,
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15, right: 15, bottom: 15),
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                 hintText: 'Search product',
//                                 contentPadding: EdgeInsets.all(8),
//                                 border: OutlineInputBorder(),
//                                 prefixIcon: Icon(
//                                   Icons.search_outlined,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               onChanged: (value) {
//                                 token = window.sessionStorage["token"] ?? " ";
//                                 setState(() {
//                                   searchText = value; // Update searchText
//                                 });
//                                 _newData();
//                                 // fetchImage(); // Fetch data
//                               },
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Container(
//                           height: 780,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: ListView.builder(
//                             itemCount: productList.length,
//                             itemBuilder: (context, index) {
//                               final Product = productList[index];
//                               bool isSelected = Product.productName ==
//                                   productNameController.text;
//                               productList.sort((a, b) {
//                                 if (a.productName ==
//                                     productNameController.text) {
//                                   return -1; // selected product name comes first
//                                 } else if (b.productName ==
//                                     productNameController.text) {
//                                   return 1; // selected product name comes first
//                                 } else {
//                                   final aIsNumber = a.productName[0]
//                                       .contains(RegExp(r'[0-90]'));
//                                   final bIsNumber = b.productName[0]
//                                       .contains(RegExp(r'[0-90]'));
//
//                                   if (aIsNumber && !bIsNumber) {
//                                     return 1;
//                                   } else if (!aIsNumber && bIsNumber) {
//                                     return -1;
//                                   } else {
//                                     return a.productName
//                                         .compareTo(b.productName);
//                                   }
//                                 }
//                               });
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     productNameController.text =
//                                         Product.productName;
//                                     prodIdController.text = Product.prodId;
//                                     print(prodIdController.text);
//                                     categoryController.text = Product.category;
//                                     subCategoryController.text =
//                                         Product.subCategory;
//                                     taxController.text = Product.tax;
//                                     unitController.text = Product.unit;
//                                     priceController.text =
//                                         Product.price.toString();
//                                     discountController.text = Product.discount;
//                                     imageIdContoller.text = Product.imageId;
//                                     print('---iamde');
//                                     widget.displayData['imageId'] =
//                                         imageIdContoller.text;
//                                     print(imageIdContoller.text);
//                                     fetchImage(productList[index].imageId);
//                                   });
//                                 },
//                                 child: Container(
//                                   decoration: isSelected
//                                       ? BoxDecoration(
//                                           color: Colors
//                                               .lightBlue[100]) // selected color
//                                       : null,
//                                   child: ListTile(
//                                     title: Text(
//                                       '${Product.productName}',
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     subtitle: Text('${Product.category}'),
//                                     tileColor: isSelected
//                                         ? Colors.lightBlue[100]
//                                         : null,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 490),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 10), // Space above/below the border
//                       width: 3, // Border height
//                       color: Colors.grey[100], // Border color
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       storeImageBytes1 != null
//                           ? Container(
//                               margin: const EdgeInsets.only(
//                                 top: 20,
//                                 left: 600,
//                               ),
//                               //image container controller
//                               width: 300,
//                               height: 300,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Image.memory(storeImageBytes1!),
//                             )
//                           : Container(
//                               margin: const EdgeInsets.only(
//                                 top: 20,
//                                 left: 600,
//                               ),
//                               //image container controller
//                               width: 300,
//                               height: 300,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: const Text('No Image Found.'),
//                             ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _buildFirstWidget(
//                             context), // Use the ProductForm widget here
//                       ),
//                     ],
//                   ),
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 200),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         color: Colors.white,
//                         height: 60,
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(
//                                   Icons.arrow_back), // Back button icon
//                               onPressed: () {
//                                 context.go('/dasbaord/productpage/:product');
//                                 Navigator.of(context).push(PageRouteBuilder(
//                                   pageBuilder: (context, animation,
//                                           secondaryAnimation) =>
//                                       ProductPage(product: null),
//                                 ));
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //       builder: (context) =>
//                                 //           ProductPage(product: null)),
//                                 // );
//                               },
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.only(left: 30),
//                               child: Text(
//                                 'Product List',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             Spacer(),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 30),
//                               child: OutlinedButton(
//                                 onPressed: () {
//                                   // context.go(
//                                   //     '${PageName.dashboardRoute ?? ''}/${PageName.subpage2 ?? ''}/${PageName.subpage2Main ?? ''}/${PageName.subsubpage2Main ?? ''}');
//                                   // fetchImage(storeImage!);
//                                   print('---- image path-----');
//                                   print(storeImageBytes1);
//                                   print(priceController.text);
//                                   print(discountController.text);
//                                   print(subCategoryController.text);
//                                   print(categoryController.text);
//                                   print(unitController.text);
//                                   print(taxController.text);
//                                   print(productNameController.text);
//                                   print(widget.displayData['imageId'] ?? "");
//                                   final inputText = categoryController.text;
//                                   final subText = subCategoryController.text;
//                                   final unitText = unitController.text;
//                                   final taxText = taxController.text;
//                                   final prodText = prodIdController.text;
//
//                                   if (storeImageBytes1 != null &&
//                                       productNameController.text.isNotEmpty &&
//                                       priceController.text.isNotEmpty &&
//                                       discountController.text.isNotEmpty) {
//                                     _textInput = productNameController.text;
//                                     _priceInput = priceController.text;
//                                     discountInput = discountController.text;
//                                     context.go('/dashboard/productpage/ontap/Edit', extra: {
//                                       'prodId': prodText ?? '',
//                                       'textInput': _textInput ?? '',
//                                       'priceInput': _priceInput ?? '',
//                                       'discountInput': discountInput ?? '',
//                                       'inputText': inputText ?? '',
//                                       'subText': subText ?? '',
//                                       'unitText': unitText ?? '',
//                                       'taxText': taxText ?? '',
//                                       'imagePath': storeImageBytes1 ?? '',
//                                       'imageId': widget.displayData['imageId']?? imageIdContoller.text?? '',
//                                       'productData': {}, // or pass the actual product data
//                                     });
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => EditOrder(
//                                           prodId: prodText,
//                                           // product: null,
//                                           textInput: _textInput,
//                                           priceInput: _priceInput,
//                                           discountInput: discountInput,
//                                           inputText: inputText,
//                                           subText: subText,
//                                           unitText: unitText,
//                                           taxText: taxText,
//                                           imagePath: storeImageBytes1,
//                                           imageId:
//                                               widget.displayData['imageId'] ??
//                                                   imageIdContoller.text ??
//                                                   "",
//                                           // imageId: widget.product?.imageId ??
//                                           //     widget.displayData['imageId'] ??
//                                           //     imageIdContoller.text ??
//                                           //     "",
//                                           productData: {},
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     // Handle case when imagePath is null or other required fields are empty
//                                     print(
//                                         'Error: Image path is null or other required fields are empty.');
//                                   }
//                                 },
//                                 style: OutlinedButton.styleFrom(
//                                   backgroundColor: Colors
//                                       .blueAccent, // Button background color
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                         5), // Rounded corners
//                                   ),
//                                   side: BorderSide.none, // No outline
//                                 ),
//                                 child: Text(
//                                   isEditing ? 'Edit' : 'Edit',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 43, left: 200),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 10), // Space above/below the border
//                       height: 3, // Border height
//                       color: Colors.grey[100], // Border color
//                     ),
//                   ),
//                 ],
//               );
//             }
//         ),
//       ),
//     );
//   }
//
//   final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
//
//   Future<void> checkSave() async {
//     if (!areRequiredFieldsFilled()) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text(
//                   "Please fill in all required fields and select an image")),
//         );
//       }
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
//
//     const productUrl =
//         'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/update_productmaster';
//
//     final productResponse = await http.put(
//       Uri.parse(productUrl),
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': 'Bearer $token'
//       },
//       body: json.encode(productData),
//     );
//
//     if (productResponse.statusCode == 200) {
//       final responseData = json.decode(productResponse.body);
//
//       if (responseData.containsKey("error")) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to add product: error")),
//         );
//       } else {
//         scaffoldMessengerKey.currentState?.showSnackBar(
//           const SnackBar(content: Text("Your message")),
//         );
//
//         // Create a new product with the image
//         final selectedProduct = ord.Product(
//           productName: productNameController.text,
//           category: categoryController.text,
//           subCategory: subCategoryController.text,
//           tax: taxController.text,
//           unit: unitController.text,
//           price: int.parse(priceController.text),
//           discount: discountController.text,
//           imageId: imageIdContoller.text,
//           prodId: '', selectedUOM: '', selectedVariation: '', quantity: 0,total: 0,totalamount: 0, totalAmount: 0.0, qty: 0,
//         );
//
//         // Add the selected product to the list
//         selectedProductList.add(selectedProduct);
//
//         // Navigate to the next page with the selectedProductList
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to add product")),
//       );
//     }
//   }
//
//   @override
//   Widget _buildFirstWidget(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           actions: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//             SizedBox(width: 10,),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 35),
//                 child: IconButton(
//                   icon: const Icon(Icons.account_circle),
//                   onPressed: () {
//                     // Handle user icon press
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: LayoutBuilder(
//           builder: (context, constraints) {
//             if (constraints.maxWidth > 600) {
//               // For larger screens (like web view)
//               return Padding(
//                 padding: const EdgeInsets.only(
//                   left: 90,
//                   top: 120,
//                   right: 125,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Text(
//                             'Product  Name',
//                             style: TextStyle(
//                                 color: Colors.indigo[900],
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(2),
//                               border: Border.all(color: Colors.blue[100]!),
//                             ),
//                             child: TextFormField(
//                               controller: productNameController,
//                               decoration: InputDecoration(
//                                 fillColor: Colors.white,
//                                 enabled: isEditing,
//                                 contentPadding:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 border: InputBorder.none,
//                                 filled: true,
//                                 hintText: 'Enter product Name',
//                                 errorText: errorMessage,
//                               ),
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp("[a-zA-Z0-9 ]")),
//                                 // Allow only letters, numbers, and single space
//                                 FilteringTextInputFormatter.deny(
//                                     RegExp(r'^\s')),
//                                 // Disallow starting with a space
//                                 FilteringTextInputFormatter.deny(
//                                     RegExp(r'\s\s')),
//                                 // Disallow multiple spaces
//                               ],
//                               validator: (value) {
//                                 if (value != null && value.trim().isEmpty) {
//                                   return 'Please enter a product name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   'Category',
//                                   style: TextStyle(
//                                       color: Colors.indigo[900],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(2),
//                                     border:
//                                         Border.all(color: Colors.blue[100]!),
//                                   ),
//                                   child: TextFormField(
//                                     controller: categoryController,
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       enabled: isEditing,
//                                       border: InputBorder.none,
//                                       hintText: 'Enter Category',
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   'Sub Category',
//                                   style: TextStyle(
//                                       color: Colors.indigo[900],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(2),
//                                     border:
//                                         Border.all(color: Colors.blue[100]!),
//                                   ),
//                                   child: TextFormField(
//                                     controller: subCategoryController,
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       enabled: isEditing,
//                                       border: InputBorder.none,
//                                       hintText: 'Enter Sub Category',
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   'Tax',
//                                   style: TextStyle(
//                                       color: Colors.indigo[900],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(2),
//                                     border:
//                                         Border.all(color: Colors.blue[100]!),
//                                   ),
//                                   child: TextFormField(
//                                     controller: taxController,
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       enabled: isEditing,
//                                       border: InputBorder.none,
//                                       hintText: 'Enter tax',
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   'Unit',
//                                   style: TextStyle(
//                                       color: Colors.indigo[900],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(2),
//                                     border:
//                                         Border.all(color: Colors.blue[100]!),
//                                   ),
//                                   child: TextFormField(
//                                     controller: unitController,
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       enabled: isEditing,
//                                       border: InputBorder.none,
//                                       hintText: 'Enter Unit',
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   'Price ',
//                                   style: TextStyle(
//                                       color: Colors.indigo[900],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(2),
//                                     border:
//                                         Border.all(color: Colors.blue[100]!),
//                                   ),
//                                   child: TextFormField(
//                                     controller: priceController,
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       LengthLimitingTextInputFormatter(
//                                           10), // limits to 10 digits
//                                     ],
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       enabled: isEditing,
//                                       border: InputBorder.none,
//                                       hintText: 'Enter Price',
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                     ),
//                                     onChanged: (value) {
//                                       if (value.isNotEmpty &&
//                                           !isNumeric(value)) {
//                                         setState(() {
//                                           errorMessage =
//                                               'Please enter numbers only';
//                                         });
//                                       } else {
//                                         setState(() {
//                                           errorMessage = null;
//                                         });
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Text(
//                                   'Discount',
//                                   style: TextStyle(
//                                       color: Colors.indigo[900],
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(2),
//                                     border:
//                                         Border.all(color: Colors.blue[100]!),
//                                   ),
//                                   child: TextFormField(
//                                     controller: discountController,
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       LengthLimitingTextInputFormatter(
//                                           10), // limits to 10 digits
//                                     ],
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       enabled: isEditing,
//                                       border: InputBorder.none,
//                                       // fillColor: isEditing
//                                       //     ? Colors.white
//                                       //     : Colors.grey[100],
//                                       fillColor: Colors.white,
//                                       hintText: 'Enter Discount',
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                     ),
//                                     onChanged: (value) {
//                                       if (value.isNotEmpty &&
//                                           !isNumeric(value)) {
//                                         setState(() {
//                                           errorMessage =
//                                               'Please enter numbers only';
//                                         });
//                                       } else {
//                                         setState(() {
//                                           errorMessage = null;
//                                         });
//                                       }
//                                     },
//                                   ),
//                                   // TextFormField(
//                                   //   enabled: isEditing,
//                                   //   controller: discountController,
//                                   //   decoration: InputDecoration(
//                                   //     fillColor: Colors.white,
//                                   //     contentPadding:
//                                   //         EdgeInsets.symmetric(horizontal: 10),
//                                   //     border: InputBorder.none,
//                                   //     filled: true,
//                                   //     hintText: 'Enter Discount',
//                                   //   ),
//                                   // ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         // OutlinedButton(
//                         //   onPressed: () {
//                         //     productNameController.clear();
//                         //     categoryController.clear();
//                         //     subCategoryController.clear();
//                         //     taxController.clear();
//                         //     unitController.clear();
//                         //     priceController.clear();
//                         //     discountController.clear();
//                         //   },
//                         //   style: OutlinedButton.styleFrom(
//                         //     backgroundColor:
//                         //         Colors.grey[400], // Blue background color
//                         //     shape: RoundedRectangleBorder(
//                         //       borderRadius:
//                         //           BorderRadius.circular(5), // Rounded corners
//                         //     ),
//                         //     side: BorderSide.none, // No outline
//                         //   ),
//                         //   child: Text(
//                         //     'Cancel',
//                         //     style: TextStyle(
//                         //       fontSize: 15, // Increase font size if desired
//                         //       // Bold text
//                         //       color: Colors.indigo[900], // White text color
//                         //     ),
//                         //   ),
//                         // ),
//                         SizedBox(width: 16),
//                         // OutlinedButton(
//                         //   onPressed: () {
//                         //     print('-------saveTo');
//                         //     token = window.sessionStorage["token"] ?? " ";
//                         //     print("token");
//                         //     print(token);
//                         //     if (!areRequiredFieldsFilled()) {
//                         //       if (mounted) {
//                         //         ScaffoldMessenger.of(context).showSnackBar(
//                         //           const SnackBar(
//                         //               content: Text(
//                         //                   "Please fill in all required fields")),
//                         //         );
//                         //       }
//                         //     } else {
//                         //       checkSave();
//                         //       ScaffoldMessenger.of(context).showSnackBar(
//                         //         const SnackBar(content: Text("success")),
//                         //       );
//                         //     }
//                         //   },
//                         //   child: Text(
//                         //     "Save",
//                         //     style: TextStyle(color: Colors.white),
//                         //   ),
//                         //   style: OutlinedButton.styleFrom(
//                         //     backgroundColor: Colors.blue,
//                         //     // Blue background color
//                         //     shape: RoundedRectangleBorder(
//                         //       borderRadius:
//                         //           BorderRadius.circular(5), // Rounded corners
//                         //     ),
//                         //     side: BorderSide.none, // No outline
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               // For smaller screens (like mobile view)
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Product Name*',
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         enabled: isEditing,
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: 'Enter product name',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                           borderSide: BorderSide(color: Colors.blue[100]!),
//                         ),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Category*',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         enabled: isEditing,
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: 'Enter category',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                           borderSide: BorderSide(color: Colors.blue[100]!),
//                         ),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Sub Category',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         enabled: isEditing,
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: 'Enter Sub category',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                           borderSide: BorderSide(color: Colors.blue[100]!),
//                         ),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Tax*',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         filled: true,
//                         enabled: isEditing,
//                         fillColor: isEditing ? Colors.white : Colors.grey[100],
//                         hintText: 'Enter tax',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                           borderSide: BorderSide(color: Colors.blue[100]!),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                           borderSide: BorderSide(color: Colors.blue[100]!),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                           borderSide:
//                               BorderSide(color: Colors.grey[500]!, width: 2),
//                         ),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Unit*',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         filled: true,
//                         enabled: isEditing,
//                         fillColor: Colors.white,
//                         hintText: 'Enter Unit',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                           borderSide: BorderSide(color: Colors.blue[100]!),
//                         ),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text('Price*',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       enabled: isEditing,
//                       controller: priceController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(
//                             10), // limits to 10 digits
//                       ],
//                       decoration: InputDecoration(
//                         fillColor: Colors.white,
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 10),
//                         border: InputBorder.none,
//                         filled: true,
//                         hintText: 'Enter Price',
//                         errorText: errorMessage,
//                       ),
//                       onChanged: (value) {
//                         if (value.isNotEmpty && !isNumeric(value)) {
//                           setState(() {
//                             errorMessage = 'Please enter numbers only';
//                           });
//                         } else {
//                           setState(() {
//                             errorMessage = null;
//                           });
//                         }
//                       },
//                     ),
//                     // TextFormField(
//                     //   decoration: InputDecoration(
//                     //     filled: true,
//                     //     enabled: isEditing,
//                     //     fillColor: Colors.white,
//                     //     hintText: 'Enter Price',
//                     //     border: OutlineInputBorder(
//                     //       borderRadius: BorderRadius.circular(4),
//                     //       borderSide: BorderSide(color: Colors.blue[100]!),
//                     //     ),
//                     //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                     //   ),
//                     // ),
//                     const SizedBox(height: 16),
//                     const Text('Discount*',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//
//                     // TextFormField(
//                     //   decoration: InputDecoration(
//                     //     filled: true,
//                     //     enabled: isEditing,
//                     //     fillColor: Colors.white,
//                     //     hintText: 'Enter Discount',
//                     //     border: OutlineInputBorder(
//                     //       borderRadius: BorderRadius.circular(4),
//                     //       borderSide: BorderSide(color: Colors.blue[100]!),
//                     //     ),
//                     //     contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                     //   ),
//                     // ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         OutlinedButton(
//                           onPressed: () {
//                             // Implement cancel button action
//                             productNameController.clear();
//                             categoryController.clear();
//                             subCategoryController.clear();
//                             taxController.clear();
//                             unitController.clear();
//                             priceController.clear();
//                             discountController.clear();
//                           },
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor:
//                                 Colors.grey[400], // Blue background color
//                             shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.circular(5), // Rounded corners
//                             ),
//                             side: BorderSide.none, // No outline
//                           ),
//                           child: const Text(
//                             'Cancel',
//                             style: TextStyle(
//                               fontSize: 18, // Increase font size if desired
//                               fontWeight: FontWeight.bold, // Bold text
//                               color: Colors.white, // White text color
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         OutlinedButton(
//                           onPressed: () {
//                             print('-------saveTo');
//                             token = window.sessionStorage["token"] ?? " ";
//                             print("token");
//                             print(token);
//                             if (!areRequiredFieldsFilled()) {
//                               if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text(
//                                           "Please fill in all required fields")),
//                                 );
//                               }
//                             } else {
//                               checkSave();
//                               // filePicker();
//                             }
//                           },
//                           style: OutlinedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             // Blue background color
//                             shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.circular(5), // Rounded corners
//                             ),
//                             side: BorderSide.none, // No outline
//                           ),
//                           child: const Text(
//                             'Save',
//                             style: TextStyle(
//                               fontSize: 18, // Increase font size if desired
//                               fontWeight: FontWeight.bold, // Bold text
//                               color: Colors.white, // White text color
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//
//   bool isNumeric(String value) {
//     return double.tryParse(value) != null;
//   }
//
//   void loadImage(String imageUrl) {
//     try {
//       fetchImage(imageUrl);
//       // Debugging information
//       print('Image loaded successfully');
//     } catch (e) {
//       // Handle error
//       print('Error loading image: $e');
//     }
//   } // last edited
// }
