import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:btb/Return%20Module/return%20module%20design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Product Module/Product Screen.dart';
import '../screen/dashboard.dart';
import '../screen/login.dart';
import '../Order Module/add productmaster sample.dart';
import '../Order Module/firstpage.dart';
import '../widgets/productclass.dart';


class ReturnImage extends StatefulWidget {
  final List<dynamic> orderDetails;
  List<String> storeImages = [];
  List<String> imageSizeStrings = [];
  final Map<String, dynamic> orderDetailsMap;


  ReturnImage({super.key,required this.orderDetails, required this.storeImages, required this.imageSizeStrings,required this.orderDetailsMap});

  @override
  _ReturnImageState createState() => _ReturnImageState();
}

class _ReturnImageState extends State<ReturnImage> {
  //List<String>? _selectedProduct = ['select a reason'];
  String? _selectedProduct;
  String storeImage = '';
  var result;
  String imageId = '';
  bool isOrdersSelected = false;
  String imageSizeString ='';
  //String _imageSizeStrings ='';
  List<Uint8List> selectedImages = [];
  final TextEditingController imagenameController = TextEditingController();
  final TextEditingController imageIdController = TextEditingController();
  String? imagePath;
  String token = window.sessionStorage["token"] ?? " ";
  io.File? selectedImage;
  List<Order> _orders = [];
  //final List<Order> _orders = widget.orderDetails.map((item) => Order.fromJson(item)).toList();


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
          print(widget.storeImages); //this one
          // Calculate image size in KB or MB
          int imageSizeInBytes = element.bytes!.length;
          double imageSizeInKB = imageSizeInBytes / 1024;
          double imageSizeInMB = imageSizeInKB / 1024;


          if (imageSizeInMB > 1) {
            imageSizeString = '${imageSizeInMB.toStringAsFixed(2)} MB';
          } else {
            imageSizeString = '${imageSizeInKB.toStringAsFixed(2)} KB';
          }

          print('Image size: $imageSizeString');
          imagenameController.text = element.name;
          print('name');
          print(imagenameController.text);

          if (widget.imageSizeStrings != null && widget.imageSizeStrings.isNotEmpty) {
            widget.imageSizeStrings.add(imageSizeString);

          } else {
            widget.imageSizeStrings = [imageSizeString];
          }
          print('image size');
          print(widget.imageSizeStrings);

          // Post api call.
          uploadImage(element.name); // Pass image bytes to uploadImage
          selectedImages.add(element.bytes!);
        });
      }
    }
  }

  Future<Uint8List> fetchImageFromApi(String imageId) async {
    final url = 'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/v1_aws_s3_bucket/view/${imageId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Image fetched: $imageId'); // Print image id
      print('Image size: ${response.bodyBytes.length * 0.001} bytes');


      return response.bodyBytes; // Return the image data as Uint8List




    } else {
      throw Exception('Failed to load image');
    }
  }


  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<Product> products = (jsonDecode(response.body) as List)
          .map((jsonProduct) => Product.fromJson(jsonProduct))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> printImageId() async {
    List<Product> allProducts = await fetchAllProducts();

    Order selectedOrder = _orders.firstWhere((order) => order.productName == _selectedProduct);

    Product matchingProduct = allProducts.firstWhere((product) => product.productName == selectedOrder.productName);


    setState(() {
      imageId = matchingProduct.imageId;
    });
    if (matchingProduct!= null) {
      print('Image ID: ${matchingProduct.imageId}');

    } else {
      print('No matching product found');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('return image fi');
    print(widget.storeImages);
    print(widget.imageSizeStrings);
    print(widget.orderDetails);
    // print(widget.orderDetails['productName']);
    print(widget.orderDetailsMap['totalAmount2']);

    _orders = widget.orderDetails.map((item) => Order.fromJson(item)).toList();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:
        AppBar(
          automaticallyImplyLeading: false,
          leading: null,
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
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ];
                    },
                    offset: const Offset(0, 40), // Adjust the offset to display the menu below the icon
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
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
                          // context
                          //     .go('${PageName.main}/${PageName.subpage1Main}');
                          context.go('/Dashboard');
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation,
                                  secondaryAnimation) =>
                              const DashboardPage(
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
                          // context.go('${PageName.dashboardRoute}');
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => Dashboard()),
                          // );
                          // Navigator.pushReplacementNamed(
                          //     context, PageName.dashboardRoute);
                          // context
                          //     .go('${PageName.main} / ${PageName.subpage1Main}');
                        },
                        icon: Icon(
                            Icons.dashboard, color: Colors.indigo[900]),
                        label: Text(
                          'Home',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {
                          context.go('/Product_List');
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation,
                                  secondaryAnimation) =>
                              const ProductPage(
                                product: null,
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
                        icon: Icon(Icons.image_outlined,
                            color: Colors.indigo[900]),
                        label: Text(
                          'Products',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation,
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
                        label:  Text(
                          'Orders',
                          style: TextStyle(
                            color: Colors.blue[900],
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
                        onPressed: () {
                          setState(() {
                            isOrdersSelected = false;
                            // Handle button press19
                          });
                        },
                        icon: Icon(Icons.backspace_sharp,
                            color: isOrdersSelected
                                ? Colors.blueAccent
                                : Colors.blueAccent),
                        label: const Text(
                          'Return',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                            Icons.insert_chart, color: Colors.blue[900]),
                        label: Text(
                          'Reports',
                          style: TextStyle(color: Colors.indigo[900]),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          icon:
                          const Icon(Icons.arrow_back), // Back button icon
                          onPressed: () {
                            context.go('/Order_Return');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                    CreateReturn(orderDetailsMap: const {}, storeImage: '', imageSizeStrings: const [], storeImages: const [], orderDetails: const [],imageSizeString: '',),
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
                            'Order Return',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12, right: 130),
                            child: OutlinedButton(
                              onPressed: () {
                                if(imageIdController.text.isNotEmpty){
                                  print('---test');
                                  //  print(storeImage);
                                  print('dddd');
                                 // List<String> tempStoreImages = [...widget.storeImages];
                                  // widget.storeImages = _selectedProduct as List<String>;
                                //  widget.storeImages.add(_selectedProduct as String);
                                  widget.storeImages = [...widget.storeImages, _selectedProduct as String];
                                  print(widget.storeImages);
                                  print(_selectedProduct);
                                  print(widget.imageSizeStrings);
                                  // print(imageIdController);


                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                          CreateReturn(
                                            storeImage: 'hi',
                                            imageSizeString: imagenameController.text,
                                            imageSizeStrings: widget.imageSizeStrings,
                                            storeImages: widget.storeImages,
                                            orderDetails: widget.orderDetails,
                                            orderDetailsMap: widget.orderDetailsMap,),
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
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Please Pick Image")));
                                }

                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                Colors.blueAccent,
                                // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      5), // Rounded corners
                                ),
                                side: BorderSide.none, // No outline
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                ),
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
                      vertical: 10),
                  // Space above/below the border
                  height: 3, // Border height
                  color: Colors.grey[100], // Border color
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('---imagePath---');
                  filePicker();
                },
                child: Padding(
                  padding:  EdgeInsets.only(left: size* 0.35,top: size * 0.075,bottom: size * 0.1,right:
                  size *0.3),
                  child: Card(
                    //margin: EdgeInsets.only(left: maxWidth * 0.08, top: maxHeight * 0.27,bottom: maxHeight * 0.3),
                    child: Container(
                      width:size,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //in this place u need to show in the ui
                          if (selectedImages.isNotEmpty)
                            for (var imageBytes in selectedImages)
                              Expanded(
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
                ),
              ),
              //SizedBox(height: 60,),
              Padding(
                  padding:  EdgeInsets.only(top: 450,left: size * 0.34,right: size*0.3),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const SizedBox(height: 40,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Product'),
                              const SizedBox(height: 10,),
                              SizedBox(height: 40,
                                width: size,

                                child:DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                      borderSide: const BorderSide(color: Colors.blue), // Set border color here
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(color: Colors.blue), // Set focused border color here
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(color: Colors.blue), // Set enabled border color here
                                    ),
                                    hintText: 'select a reason',
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    suffixIcon: const Icon(Icons.arrow_drop_down_circle_rounded,color: Colors.blueAccent,), // Add arrow down icon here
                                  ),
                                  icon: Container(),
                                  value: _selectedProduct,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedProduct = newValue as String;
                                      // widget.storeImages = [_selectedProduct as String];
                                      // widget.storeImages.add(_selectedProduct as String);
                                      if (_selectedProduct != null) {
                                        //printImageId(); // Call the printImageId function
                                      }
                                    });
                                  },
                                  items: widget.orderDetails.map((item) {
                                    return DropdownMenuItem(
                                      value: item['productName'],
                                      child: Text(item['productName'] ?? 'Unknown Product'),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                  )
              )
            ]
        )
    );
  }
}

