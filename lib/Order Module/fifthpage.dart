import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/screen/login.dart';
import 'package:btb/Order%20Module/firstpage.dart';
import 'package:btb/Order%20Module/fourthpage.dart';
import 'package:btb/Order%20Module/sixthpage.dart';
import 'package:btb/widgets/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import '../screen/dashboard.dart';



class FifthPage extends StatefulWidget {
  final List<Product> selectedProducts;
  final Map<String, dynamic> data;
  final String select;


  const FifthPage(
      {super.key, required this.selectedProducts,
        required this.select,

        required this.data});

  @override
  State<FifthPage> createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  List<Product> products = [];
  final dummyProducts = '';
  Timer? _searchDebounceTimer;
  double _total = 0.0;
  String _searchText = '';
  late Future<List<detail>> futureOrders;
  String searchQuery = '';
  final String _category = '';
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  bool isOrdersSelected = false;
  List<Product> selectedProducts = [];
  final TextEditingController commentsController = TextEditingController();

  final TextEditingController totalAmountController = TextEditingController();
  List<detail>filteredData= [];

  final TextEditingController totalController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  List<Product> showProducts = [];
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  bool _isRefreshed = false;
  DateTime? _selectedDate;
  late TextEditingController _dateController;
  final String _subCategory = '';
  Map<String, dynamic> data2 = {};
  int startIndex = 0;
  List<Product> filteredProducts = [];
  int currentPage = 1;
  List<dynamic> detailJson =[];
  String? dropdownValue1 = 'Filter I';
  List<Product> productList = [];
  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Filter II';
  String status= '';
  String selectDate ='';

  void onSearchTextChanged(String text) {
    if (_searchDebounceTimer != null) {
      _searchDebounceTimer!.cancel(); // Cancel the previous timer
    }
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = text;
      });
    });
  }
  //
  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    futureOrders = fetchOrders() as Future<List<detail>>;

    commentsController.text = widget.data['Comments'] ?? '';
    deliveryAddressController.text = widget.data['Address'] ?? '';
    contactNumberController.text = widget.data['ContactNumber'] ?? '';
    contactPersonController.text = widget.data['ContactName'] ?? '';
    print('------------dadf');

    _calculateTotal();
    _selectedDate = DateTime.now();
    _dateController.text = _selectedDate != null ? DateFormat.yMd().format(_selectedDate!) : '';
    print(widget.data);
    print('-hello');
    data2 = Map.from(widget.data);
    // totalAmountController.text = data2['totalAmount'];
    print(widget.selectedProducts);
    // print(showProducts);
  }


  Future<List<detail>> fetchOrders() async {
    final response = await http.get(
      Uri.parse(
          'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster'),
      headers: {
        'Authorization': 'Bearer $token',
        // Add the token to the Authorization header
      },
    );
    if (response.statusCode == 200) {
      detailJson = json.decode(response.body);
      List<detail> filteredData = detailJson.map((json) => detail.fromJson(json)).toList();
      if (_searchText.isNotEmpty) {
        print(_searchText);
        filteredData = filteredData.where((detail) => detail.orderId!.toLowerCase().contains(_searchText.toLowerCase())).toList();
      }
      return filteredData;
    } else {
      throw Exception('Failed to load orders');
    }
  }



  void _calculateTotal() {
    _total = 0.0;
    for (var product in widget.selectedProducts) {
      _total += product.total; // Add the total of each product to _total
    }
    setState(() {

    });
  }


  Future<void> callApi() async {

    List<Map<String, dynamic>> items = [];

    for (int i = 0; i < widget.selectedProducts.length; i++) {
      Product product = widget.selectedProducts[i];
      items.add({
        "productName": product.productName,
        "category": product.category,
        "subCategory": product.subCategory,
        "price": product.price,
        "qty": product.quantity,
        "totalAmount": (product.price * product.quantity),
      });
    }

    final url = 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/add_order_master';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    final body = {
      "orderDate": data2['date'],
      "deliveryLocation": data2['deliveryLocation'],
      "deliveryAddress":  deliveryAddressController.text,
      "contactPerson": contactPersonController.text,
      "contactNumber": contactNumberController.text,
      "comments":  commentsController.text,
      "total": data2['totalAmount'],
      "items": items,
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      print('API call successful');
      final responseData = json.decode(response.body);

      // Add null checks and error handling
      String orderId;
      try {
        orderId = responseData['id'];
      } catch (e) {
        print('Error parsing orderId: $e');
        orderId = ''; // or some default value
      }

      detail details;
      try {
        details = detail(
          orderId: orderId,
          orderDate: data2['date'],
          total: double.parse(data2['totalAmount']),
          status: '', // Initialize status as empty string
          deliveryStatus: '', // Initialize delivery status as empty string
          referenceNumber: '', items: [], // Initialize reference number as empty string
        );
      } catch (e) {
        print('Error creating detail object: $e');
        details = detail(orderId: '', orderDate: '', total: 0, status: '', deliveryStatus: '', referenceNumber: '', items: []); // or some default value
      }

      if (details != null) {
         context.go('/Placed_Order_List', extra: {
           'product': details,
           'item': items,
           'body': body,
           'itemsList': items,
           'orderDetails': filteredData.map((detail) => OrderDetail(
             orderId: detail.orderId,
             orderDate: detail.orderDate, items: [],
             // Add other fields as needed
           )).toList(),
         });
        // context.go('/Place_Order/Order_List', extra: {
        //   'product': details,
        //   'item': items,
        //   'body': body,
        //   'itemsList': items,
        // });

        Future<void> navigateToNextPage() async {
          // Call the API to fetch the orders
          final orders = await fetchOrders();

          // Update filteredData with the latest data
          setState(() {
            filteredData = orders.where((element) {
              final matchesSearchText= element.orderId!.toLowerCase().contains(searchQuery.toLowerCase());
              print('-----');
              print(element.orderDate);
              String orderYear = '';
              if (element.orderDate.contains('/')) {
                final dateParts = element.orderDate.split('/');
                if (dateParts.length == 3) {
                  orderYear = dateParts[2]; // Extract the year
                }
              }
              // final orderYear = element.orderDate.substring(5,9);
              if (status.isEmpty && selectDate.isEmpty) {
                return matchesSearchText; // Include all products that match the search text
              }
              if(status == 'Status' && selectDate == 'SelectYear'){
                return matchesSearchText;
              }
              if(status == 'Status' &&  selectDate.isEmpty)
              {
                return matchesSearchText;
              }
              if(selectDate == 'SelectYear' &&  status.isEmpty)
              {
                return matchesSearchText;
              }
              if (status == 'Status' && selectDate.isNotEmpty) {
                return matchesSearchText && orderYear == selectDate; // Include all products
              }
              if (status.isNotEmpty && selectDate == 'SelectYear') {
                return matchesSearchText && element.status == status;// Include all products
              }
              if (status.isEmpty && selectDate.isNotEmpty) {
                return matchesSearchText && orderYear == selectDate; // Include all products
              }

              if (status.isNotEmpty && selectDate.isEmpty) {
                return matchesSearchText && element.status == status;// Include all products
              }
              return matchesSearchText &&
                  (element.status == _category && element.orderDate == selectDate);
              //  return false;
            }).toList();
          });

          // Navigate to the next page
          // Navigator.push(
          //   context,
          //   PageRouteBuilder(
          //     pageBuilder: (context, animation, secondaryAnimation) => SixthPage(
          //       product: details,
          //       item: items,
          //       body: body,
          //       itemsList: items,
          //       orderDetails: filteredData.map((detail) => OrderDetail(
          //         orderId: detail.orderId,
          //         orderDate: detail.orderDate, items: [],
          //         // Add other fields as needed
          //       )).toList(),
          //     ),
          //   ),
          // );
        }
        navigateToNextPage();
      } else {
        print('Failed to create detail object, not navigating to SixthPage');
      }
    } else {
      print('API call failed with status code ${response.statusCode}');
    }
  }


  void _deleteProduct(Product product) {
    setState(() {
      widget.selectedProducts.remove(product);
      _calculateTotal();
    });
  }

  @override
  void dispose() {
    _searchDebounceTimer
        ?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          body:
          LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;

                TableRow row1 = const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30,top: 10,bottom: 10),
                        child: Text('Delivery Location',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),),
                      ),
                    ),
                    TableCell(
                      child: Text(''),
                    ),
                  ],
                );

                TableRow row2 = const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30,top: 10,bottom: 10),
                        child: Text('Address'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                        child: Text('Comments'),
                      ),
                    ),
                  ],
                );
                TableRow row3 = TableRow(
                  children: [
                    TableCell(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:  EdgeInsets.only(left: 30,top: 10),
                                  child: Text('Select Delivery Location'),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding:  const EdgeInsets.only(left: 30),
                                  child: SizedBox(
                                    width: maxWidth * 0.35,
                                    height: 40,
                                    child: DropdownButtonFormField<String>(
                                      value: data2['deliveryLocation'],
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: 'Select Location',
                                        contentPadding:const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                      ),
                                      onChanged: (String? value) {
    setState(() {
                               data2['deliveryLocation'] = value!;
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
                                const SizedBox(height: 20),
                                const Padding(
                                  padding:  EdgeInsets.only(left: 30),
                                  child: Text('Delivery Address'),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding:  const EdgeInsets.only(left: 30),
                                  child: SizedBox(
                                    width: maxWidth * 0.35,
                                    child: TextField(
                                      controller: deliveryAddressController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: 'Enter Your Address',
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('Contact Person'),
                                ),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: SizedBox(
                                    width: maxWidth * 0.2,
                                    height: 40,
                                    child: TextField(
                                      controller: contactPersonController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: 'Contact Person Name',
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text('Contact Number'),
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: SizedBox(
                                    width: maxWidth * 0.2,
                                    height: 40,
                                    child: TextField(
                                      controller: contactNumberController,
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
                                        fillColor: Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: 'Contact Person Number',
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('    '),
                        Padding(
                          padding: const EdgeInsets.only(right: 10,left: 10,bottom: 5),
                          child: SizedBox(
                            height: 250,
                            child: TextField(
                              controller: commentsController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Enter Your Comments'


                              ),
                              maxLines: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                )

                    ),
                  ],
                );

                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 1200,
                        width: 200,
                        color: const Color(0xFFF7F6FA),
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextButton.icon(
                              onPressed: () {
                                // context
                                //     .go('${PageName.main}/${PageName.subpage1Main}');
                                context.go('/PlaceOrder/Add_Product/Create_Order/Orders/Home');
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation, secondaryAnimation) =>
                                //     const DashboardPage(
                                //
                                //     ),
                                //     transitionDuration:
                                //     const Duration(milliseconds: 200),
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
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
                                    '/PlaceOrder/Add_Product/Create_Order/Orders/Products');
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation, secondaryAnimation) =>
                                //     const ProductPage(
                                //       product: null,
                                //     ),
                                //     transitionDuration:
                                //     const Duration(milliseconds: 200),
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
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
                               // context.go('/BeforplacingOrder/Orderspage');
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder: (context, animation,
                                //         secondaryAnimation) =>
                                //     const Orderspage(),
                                //     transitionDuration: const Duration(
                                //         milliseconds: 200),
                                //     transitionsBuilder:
                                //         (context, animation, secondaryAnimation,
                                //         child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
                                // setState(() {
                                //   isOrdersSelected = false;
                                //   // Handle button press19
                                // });
                              },
                              icon: const Icon(Icons.warehouse,
                                  color: Colors.blueAccent),
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
                              onPressed: () {
                                context.go('/PlaceOrder/Add_Product/Create_Order/Orders/Return');
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation, secondaryAnimation) =>
                                //     const Returnpage(),
                                //     transitionDuration:
                                //     const Duration(milliseconds: 200),
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
                              },
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
                      ),
                    ),
                    Positioned(
                      left: 200,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0,bottom: 5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.white,
                                height: 40,
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 30,top: 10),
                                      child: Text(
                                        'Create Order',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 100,top: 10),
                                      child: OutlinedButton(
                                        onPressed: () async {
                                          await callApi();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent, // Button background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5), // Rounded corners
                                          ),
                                          side: BorderSide.none, // No outline
                                        ),
                                        child: const Text(
                                          'Create Order',
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
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5), // Space above/below the border
                              height: 2,
                              // width: 1000,
                              width: constraints.maxWidth,// Border height
                              color: Colors.grey[300], // Border color
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Container(
                                width: maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: 50,right: maxWidth * 0.085),
                                      child: const Text((' Order Date')),
                                    ),
                                    Padding(
                                      padding:  const EdgeInsets.only( top:10),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFEBF3FF), width: 1),
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child: Container(
                                          height: 39,
                                          width: maxWidth *0.13,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _dateController,
                                                  // Replace with your TextEditingController
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    suffixIcon: Padding(
                                                      padding: const EdgeInsets.only(right: 20),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 2, left: 10),
                                                        child: IconButton(
                                                          icon: const Padding(
                                                            padding: EdgeInsets.only(bottom: 16),
                                                            child: Icon(Icons.calendar_month),
                                                          ),
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            // _showDatePicker(context);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    hintText: '        Select Date',
                                                    fillColor: Colors.grey.shade200,
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 8),
                                                    border: InputBorder.none,
                                                    filled: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                              ),
                            ),
                            //SizedBox(height: 20.h),
                            Padding(
                              padding: const EdgeInsets.only(left: 150,right: 100,top: 50),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFB2C2D3)),
                                  borderRadius: BorderRadius.circular(3.5), // Set border radius here
                                ),
                                child: Table(
                                  border: TableBorder.all(color: const Color(0xFFB2C2D3)),

                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1.4),
                                  },
                                  children: [
                                    row1,
                                    row2,
                                    row3,
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 150, top: 50,right: 100,bottom: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.81,
                                child: Container(
                                  width: maxWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFB2C2D3), width: 2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10, left: 30),
                                      child: Text(
                                        'Add Products',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: maxWidth,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xFFB2C2D3)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                                        child: Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(1),
                                            1: FlexColumnWidth(2.7),
                                            2: FlexColumnWidth(2),
                                            3: FlexColumnWidth(1.8),
                                            4: FlexColumnWidth(2),
                                            5: FlexColumnWidth(1),
                                            6: FlexColumnWidth(2),
                                            7: FlexColumnWidth(1),

                                          },
                                          children: const [
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        'SN',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        'Product Name',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        'Category',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        'Sub Category',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        'Price',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        'QTY',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        'Total Amount',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Center(
                                                      child: Text(
                                                        '    ',
                                                        style: TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: widget.selectedProducts.length,
                                      itemBuilder: (context, index) {
                                        Product product = widget.selectedProducts[index];
                                        return Table(
                                          border: TableBorder.all(color: const Color(0xFFB2C2D3)),
                                          columnWidths: const {
                                            0: FlexColumnWidth(1),
                                            1: FlexColumnWidth(2.7),
                                            2: FlexColumnWidth(2),
                                            3: FlexColumnWidth(1.8),
                                            4: FlexColumnWidth(2),
                                            5: FlexColumnWidth(1),
                                            6: FlexColumnWidth(2),
                                            7: FlexColumnWidth(1),

                                          },
                                          children: [
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 15, bottom: 5),
                                                    child: Center(
                                                      child: Text(
                                                        (index + 1).toString(),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 10, bottom: 10),
                                                    child: Container(
                                                      height: 35,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          product.productName,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 10, bottom: 10),
                                                    child: Container(
                                                      height: 35,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          product.category,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 10, bottom: 10),
                                                    child: Container(
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          product.subCategory,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 10, bottom: 10),
                                                    child: Container(
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          product.price.toString(),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 10, bottom: 10),
                                                    child: Container(
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          product.quantity.toString(),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10, right: 10, top: 10, bottom: 10),
                                                    child: Container(
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${product.price * product.quantity}',
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _deleteProduct(product);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove_circle_outline,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30, top: 20),
                                          child: OutlinedButton(
                                            onPressed: () {
                                              // List<Product> products = widget.selectedProducts;
                                              Product? selectedProduct;
                                              if (widget.selectedProducts.isNotEmpty) {
                                                for (var selectedProduct in widget.selectedProducts) {
                                                  print('----yes');
                                                  Map<String, dynamic> data = {
                                                    'deliveryLocation': data2['deliveryLocation'],
                                                    'ContactName': contactPersonController.text,
                                                    'Address': deliveryAddressController.text,
                                                    'ContactNumber': contactNumberController.text,
                                                    'Comments': commentsController.text,
                                                    'date': _selectedDate.toString(),
                                                  };
                                                  data2 = data;
                                                  print(selectedProduct);
                                                  context.go('/Add_Product/PlaceOrder/Placed_Order_List', extra: {
                                                    'products': products,
                                                    'selectedProducts': selectedProducts,
                                                    'selectedProduct': selectedProduct,
                                                    'data2': data2,
                                                    'subText': 'hii',
                                                    'inputText': '',
                                                    'notselect': 'selectedproduct',
                                                  });

                                                  // Navigator.push(
                                                  //   context,
                                                  //   PageRouteBuilder(
                                                  //     pageBuilder: (context,
                                                  //         animation,
                                                  //         secondaryAnimation) =>
                                                  //         NextPage(
                                                  //           //product: Product(prodId: '', category: '', productName: '', subCategory: '', unit: '', selectedUOM: '', selectedVariation: '', quantity: 0, total: 0, totalamount: 0, tax: '', discount: '', price: 0, imageId: ''),
                                                  //           data: data2,
                                                  //           product: selectedProduct,
                                                  //           inputText: '',
                                                  //           products: products,
                                                  //           subText: 'hii',
                                                  //           selectedProducts: widget.selectedProducts,
                                                  //           notselect: 'selectedproduct',),
                                                  //     // NextPage(
                                                  //     //   // selectedProducts: widget.selectedProducts,
                                                  //     //   selectedProducts: widget.selectedProducts,                                                         data: widget.data,
                                                  //     //   inputText: '',
                                                  //     //   subText: '',
                                                  //     //    data: null,
                                                  //     //    products: products,
                                                  //     //   product: selectedProduct),
                                                  //     transitionDuration:
                                                  //     const Duration(
                                                  //         milliseconds: 200),
                                                  //     transitionsBuilder: (
                                                  //         context,
                                                  //         animation,
                                                  //         secondaryAnimation,
                                                  //         child) {
                                                  //       return FadeTransition(
                                                  //         opacity: animation,
                                                  //         child: child,
                                                  //       );
                                                  //     },
                                                  //   ),
                                                  // );
                                                }
                                              } else {
                                                selectedProduct = null;
                                              }


                                            },
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              // Blue background color
                                              //  minimumSize: MaterialStateProperty.all(Size(200, 50)),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5), // Optional: Square corners
                                              ),
                                              side: BorderSide.none, // No  outline
                                            ),
                                            child: const Text(
                                              '+ Add Products',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        // Space above/below the border
                                        height: 1, // Border height
                                        color: const Color(0xFFB2C2D3), // Border color
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:9,bottom: 9),
                                      child: Align(
                                        alignment: const Alignment(0.74,0.8),
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 15,right: 10,top: 2,bottom: 2),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.blue),
                                            borderRadius: BorderRadius.circular(3),
                                            color:  Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 15,top: 15,left: 10,right: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RichText(text:
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text:  'Total',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue
                                                        // fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                      text: '  ₹',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                      data2['totalAmount'] =_total.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ),
                                                // Text(
                                                //   'Total',
                                                //   style: TextStyle(
                                                //     fontSize: 16,
                                                //     fontWeight: FontWeight.bold,
                                                //   ),
                                                // ),
                                                // SizedBox(width: 16.0),
                                                // Text(
                                                //   data2['totalAmount'] =_total.toString(),
                                                //   style: const TextStyle(
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                buildDataTable(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Padding(
                                    //   padding:  EdgeInsets.only(top: 8, left:1100.w, bottom: 10,right: 50),
                                    //   child: Row(
                                    //     children: [
                                    //       const SizedBox(width: 10), // add some space between the line and the text
                                    //       SizedBox(
                                    //         width: 220,
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             border: Border.all(color: Colors.blue),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: const EdgeInsets.only(
                                    //               top: 10,
                                    //               bottom: 10,
                                    //               left: 5,
                                    //               right: 5,
                                    //             ),
                                    //             child: RichText(
                                    //               text: TextSpan(
                                    //                 children: [
                                    //                   const TextSpan(
                                    //                     text: '       ', // Add a space character
                                    //                     style: TextStyle(
                                    //                       fontSize: 10, // Set the font size to control the width of the gap
                                    //                     ),
                                    //                   ),
                                    //                   const TextSpan(
                                    //                     text: 'Total',
                                    //                     style: TextStyle(
                                    //                       fontWeight: FontWeight.bold,
                                    //                       color: Colors.blue,
                                    //                     ),
                                    //                   ),
                                    //                   const TextSpan(
                                    //                     text: '           ', // Add a space character
                                    //                     style: TextStyle(
                                    //                       fontSize: 10, // Set the font size to control the width of the gap
                                    //                     ),
                                    //                   ),
                                    //                   const TextSpan(
                                    //                     text: '₹',
                                    //                     style: TextStyle(
                                    //                       color: Colors.black,
                                    //                     ),
                                    //                   ),
                                    //                   TextSpan(
                                    //                     text: data2['totalAmount'] = _total.toString(),
                                    //                     style: const TextStyle(
                                    //                       color: Colors.black,
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    )

                  ],
                );

              }
          )


      ),
    );
  }

  Widget buildDataTable() {
    return LayoutBuilder(builder: (context, constraints){
      double right = constraints.maxWidth;

      return FutureBuilder<List<detail>>(
        future: futureOrders,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            filteredData = snapshot.data!.where((element) {
              final matchesSearchText= element.orderId!.toLowerCase().contains(searchQuery.toLowerCase());
              print('-----');
              print(element.orderDate);
              String orderYear = '';
              if (element.orderDate.contains('/')) {
                final dateParts = element.orderDate.split('/');
                if (dateParts.length == 3) {
                  orderYear = dateParts[2]; // Extract the year
                }
              }
              // final orderYear = element.orderDate.substring(5,9);
              if (status.isEmpty && selectDate.isEmpty) {
                return matchesSearchText; // Include all products that match the search text
              }
              if(status == 'Status' && selectDate == 'SelectYear'){
                return matchesSearchText;
              }
              if(status == 'Status' &&  selectDate.isEmpty)
              {
                return matchesSearchText;
              }
              if(selectDate == 'SelectYear' &&  status.isEmpty)
              {
                return matchesSearchText;
              }
              if (status == 'Status' && selectDate.isNotEmpty) {
                return matchesSearchText && orderYear == selectDate; // Include all products
              }
              if (status.isNotEmpty && selectDate == 'SelectYear') {
                return matchesSearchText && element.status == status;// Include all products
              }
              if (status.isEmpty && selectDate.isNotEmpty) {
                return matchesSearchText && orderYear == selectDate; // Include all products
              }

              if (status.isNotEmpty && selectDate.isEmpty) {
                return matchesSearchText && element.status == status;// Include all products
              }
              return matchesSearchText &&
                  (element.status == _category && element.orderDate == selectDate);
              //  return false;
            }).toList();

            // Print the details in the console
            filteredData.forEach((detail) {
              print('Status: ${detail.status}');
              print('Order ID: ${detail.orderId}');
              print('Created Date: ${detail.orderDate}');
              print('Reference Number: ${detail.referenceNumber}');
              print('Total Amount: ${detail.total}');
              print('Delivery Status: ${detail.deliveryStatus}');
              print('------------------------');
            });

            // Return an empty Container to not show anything in the UI
            return Container();
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      // Handle date selection
    }
  }
}

