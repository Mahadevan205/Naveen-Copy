import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/sprint%202%20order/thirdpage.dart';
import 'package:btb/thirdpage/productclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Product Module/Product Screen.dart';
import '../dashboard.dart';
import 'firstpage.dart';
void main() {
  runApp(const OrdersSecond());
}
class OrdersSecond extends StatefulWidget {
  const OrdersSecond({super.key});
  @override
  State<OrdersSecond> createState() => _OrdersSecondState();
}
class _OrdersSecondState extends State<OrdersSecond> {
  Timer? _searchDebounceTimer;
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  String? _selectedDeliveryLocation;
  String _searchText = '';
  final String _category = '';
  final deliveryLocationController = TextEditingController();
  final ContactPersonController = TextEditingController();
  final deliveryaddressController = TextEditingController();
  final ContactNumberController = TextEditingController();
  final CommentsController = TextEditingController();
  DateTime? _selectedDate;
  late TextEditingController _dateController;
  bool isOrdersSelected = false;
  List<Product> selectedProducts = [];
  Map<String, dynamic> data2 = {};
  final String _subCategory = '';
  int startIndex = 0;
  List<Product> filteredProducts = [];
  int currentPage = 1;
  String? dropdownValue1 = 'Filter I';
  List<Product> productList = [];
  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Filter II';
  // void _onSearchTextChanged(String text) {
  //   if (_searchDebounceTimer != null) {
  //     _searchDebounceTimer!.cancel(); // Cancel the previous timer
  //   }
  //   _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
  //     setState(() {
  //       _searchText = text;
  //     });
  //   });
  // }
  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat.yMd().format(_selectedDate!);
    fetchProducts(page: currentPage);
  }
  Future<void> fetchProducts({int? page}) async {
    final response = await http.get(
      Uri.parse(
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster?startIndex=$startIndex&limit=20',
      ),
      headers: {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          final products =
          jsonData.map((item) => Product.fromJson(item)).toList();
          if (mounted) {
            setState(() {
              if (currentPage == 1) {
                productList = products.take(7).toList();
              } else {
                productList.addAll(products);
              }
              startIndex += 20;
              currentPage++;
            });
          }
        } else if (jsonData is Map) {
          final products =
          jsonData['body'].map((item) => Product.fromJson(item)).toList();
          if (mounted) {
            setState(() {
              if (currentPage == 1) {
                productList = products;
              } else {
                productList.addAll(products);
              }
              startIndex += 20;
              currentPage++;
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
  void dispose() {
    _searchDebounceTimer
        ?.cancel(); // Cancel the timer when the widget is disposed
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double containerWidth = screenWidth * 0.4;
    double containerHeight = screenHeight * 0.9;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          title: Image.asset("images/Final-Ikyam-Logo.png"),
          // Set background color to white
          elevation: 2.0,
          shadowColor: const Color(0xFFFFFFFF),
          // Set shadow color to black
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification icon press
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 35),
              child: IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // Handle user icon press
                },
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;
              double maxHeight = constraints.maxHeight;
              return Row (
                children: [
                  Container(
                    width: 200,
                    height: constraints.maxHeight,
                    color: const Color(0xFFF7F6FA),
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          // Added Align widget for the left side menu
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 18,),
                              TextButton.icon(
                                onPressed: () {
                                  context
                                      .go('/Orderspage/dasbaord');
                                  // context.go('${PageName.dashboardRoute}');
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
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
                                  // );
                                  // Navigator.pushReplacementNamed(
                                  //     context, PageName.dashboardRoute);
                                  // context
                                  //     .go('${PageName.main} / ${PageName.subpage1Main}');
                                },
                                icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
                                label: Text(
                                  'Home',
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton.icon(
                                onPressed: () {
                                  context.go(
                                      '/dasbaord/Orderspage/productpage/:product');

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
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
                                  // context.go('${PageName.main}/${PageName.subpage1Main}');

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
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
                                  setState(() {
                                    isOrdersSelected = false;
                                    // Handle button press19
                                  });
                                },
                                icon: Icon(Icons.warehouse,
                                    color: isOrdersSelected
                                        ? Colors.blueAccent
                                        : Colors.blueAccent),
                                label: const Text(
                                  'Orders',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
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
                                icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
                                label: Text(
                                  'Reports',
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          //create order
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                color: Colors.white,
                                height: 60,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back), // Back button icon
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                            const Orderspage(),
                                            transitionDuration: const Duration(milliseconds: 200),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                        'Create Order',
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
                          //horizandal line
                          Padding(
                            padding: const EdgeInsets.only(top: 35, left: 0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 3,
                              color: Colors.grey[100],
                            ),
                          ),
                          //date
                          Align(
                            alignment: const Alignment(0.72,0.8),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF418CFC).withOpacity(0.16),
                                          spreadRadius: 0,
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: 39,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: TextFormField(
                                        controller: _dateController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 2, left: 10),
                                              child: IconButton(
                                                icon: const Padding(
                                                  padding: EdgeInsets.only(bottom: 16),
                                                  child: Icon(Icons.calendar_month),
                                                ),
                                                iconSize: 20,
                                                onPressed: () {
                                                  _showDatePicker(context);
                                                },
                                              ),
                                            ),
                                          ),
                                          hintText: _selectedDate != null
                                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                                              : 'Select Date',
                                          fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                          border: InputBorder.none,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //delivery location
                          Padding(
                            padding: const EdgeInsets.only(top: 200,left: 0.8 * 100 ,right: 180),
                            child: Container(
                              height: containerHeight * 0.59,
                              // padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:  EdgeInsets.only(left: 30,top: 10),
                                    child: Text(
                                      'Delivery Location',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Divider(color: Colors.grey),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.only(left: 30,bottom: 5),
                                        child: Text(
                                          'Address',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right:360),
                                        child: Text(
                                          'Comments',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1.0,
                                    height: 1.0,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:  EdgeInsets.only(left: 30),
                                              child: Text('Select Delivery Location'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 30),
                                              child: SizedBox(
                                                width: maxWidth * 0.35,
                                                child: DropdownButtonFormField<String>(
                                                  value: _selectedDeliveryLocation,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                  ),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _selectedDeliveryLocation = value!;
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
                                            const SizedBox(height: 20.0),
                                            const Padding(
                                              padding:  EdgeInsets.only(left: 30),
                                              child: Text('Delivery Address'),
                                            ),
                                            const SizedBox(height: 10,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 30),
                                              child: SizedBox(
                                                width: maxWidth *0.35,
                                                child: TextField(
                                                  controller: deliveryaddressController,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'Address Details',
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 30.0),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Contact Person'),
                                            SizedBox(
                                              width: maxWidth * 0.2,
                                              child: TextField(
                                                controller: ContactPersonController,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: 'Contact Person Name',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            const Text('Contact Number'),
                                            const SizedBox(height: 10,),
                                            SizedBox(
                                              width: maxWidth* 0.2,
                                              child: TextField(
                                                controller: ContactNumberController,
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
                                                  filled: true,
                                                  fillColor: Colors.grey[200],
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  hintText: 'Contact Person Number',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: maxHeight *0.41,
                                        width: 1,
                                        color: Colors.grey, // Vertical line at the start
                                        margin: EdgeInsets.zero, // Adjust margin if needed
                                      ),
                                      const SizedBox(width: 20.0),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('    '),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: SizedBox(
                                                child: TextField(
                                                  controller: CommentsController,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'Enter your comments',
                                                  ),
                                                  maxLines: 5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 650,left: 80,right: 180),
                            child: Container(
                              height: maxHeight * 0.25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Add Product',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const Divider(thickness: 1, color: Colors.blue),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(child: Center(child: Text('Product Name'))),
                                      Expanded(child: Center(child: Text('Category'))),
                                      Expanded(child: Center(child: Text('Sub Category'))),
                                      Expanded(child: Center(child: Text('Price'))),
                                      Expanded(child: Center(child: Text('Qty'))),
                                      Expanded(child: Center(child: Text('Amount'))),
                                      Expanded(child: Center(child: Text('TAX'))),
                                      Expanded(child: Center(child: Text('Discount'))),
                                      Expanded(child: Center(child: Text('Total Amount'))),
                                    ],
                                  ),
                                  const  Divider(thickness: 1, color: Colors.blue),
                                  // ListView.builder(
                                  //   itemCount: products.length,
                                  //   itemBuilder: (context, index) {
                                  //     return Padding(
                                  //       padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  //       child: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           Expanded(child: Center(child: Text(products[index]["Product Name"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["Category"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["Sub Category"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["Price"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["Qty"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["Amount"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["TAX"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["Discount"]!))),
                                  //           Expanded(child: Center(child: Text(products[index]["Total Amount"]!))),
                                  //         ],
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
                                  Padding(
                                    padding:const EdgeInsets.only(left: 30),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: SizedBox(
                                        width: maxWidth * 0.25,
                                        // height: 30,
                                        child: OutlinedButton(
                                          // onPressed: () {
                                          //   Map<String, dynamic> data = {
                                          //     'deliveryLocation': _selectedDeliveryLocation,
                                          //     'ContactName': ContactPersonController.text,
                                          //     'Address': deliveryaddressController.text,
                                          //     'ContactNumber': ContactNumberController.text,
                                          //     'Comments': CommentsController.text,
                                          //     'date': _selectedDate.toString(),
                                          //   };
                                          //   context.go(
                                          //       '/dasbaord/Orderspage/addproduct/addparts',
                                          //       extra: data);
                                          //   Navigator.push(
                                          //     context,
                                          //     PageRouteBuilder(
                                          //       pageBuilder: (context, animation,
                                          //           secondaryAnimation) =>
                                          //           OrderPage3(data: data),
                                          //       transitionDuration:
                                          //       const Duration(milliseconds: 200),
                                          //       transitionsBuilder: (context, animation,
                                          //           secondaryAnimation, child) {
                                          //         return FadeTransition(
                                          //           opacity: animation,
                                          //           child: child,
                                          //         );
                                          //       },
                                          //     ),
                                          //   );
                                          // },
                                          onPressed: () {
                                            String validationMessage = validateFields();
                                            if (validationMessage == '') {
                                              Map<String, dynamic> data = {
                                                'deliveryLocation': _selectedDeliveryLocation,
                                                'ContactName': ContactPersonController.text,
                                                'Address': deliveryaddressController.text,
                                                'ContactNumber': ContactNumberController.text,
                                                'Comments': CommentsController.text,
                                                'date': _selectedDate.toString(),
                                              };
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                                      OrderPage3(data: data),
                                                  transitionDuration: const Duration(milliseconds: 200),
                                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(validationMessage),
                                                ),
                                              );
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                            Colors.blue, // Blue background color
                                            //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  5), // Optional: Square corners
                                            ),
                                            side: BorderSide.none, // No  outline
                                          ),
                                          child: const Align(
                                            alignment: Alignment.centerLeft, // Add this line
                                            child: Text(
                                              '+ Add Products',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
  String validateFields() {
    if ( _selectedDeliveryLocation == null || _selectedDeliveryLocation!.isEmpty) {
      return 'Please fill in the delivery location.';
    }
    if (ContactPersonController.text.isEmpty) {
      return 'Please fill in the contact person name.';
    }
    if (deliveryaddressController.text.isEmpty) {
      return 'Please fill in the delivery address.';
    }
    if (ContactNumberController.text.isEmpty) {
      return 'Please fill in the contact number.';
    }
    if (CommentsController.text.isEmpty) {
      return 'Please fill in the comments.';
    }

    return '';
  }
  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
      });
    }
  }
}

