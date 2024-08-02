import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/Order%20Module/secondpage.dart';
import 'package:btb/widgets/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import '../screen/login.dart';
import '../screen/dashboard.dart';
import 'firstpage.dart';
import 'fourthpage.dart';

class OrderPage3 extends StatefulWidget {
  final Map<String, dynamic> data;
  const OrderPage3({super.key, required this.data});
  @override
  OrderPage3State createState() => OrderPage3State();
}

class OrderPage3State extends State<OrderPage3> {
  List<Product> products = [];
  double _total = 0;
  String? dropdownValue1 = 'Filter I';
  bool isOrdersSelected = false;
  List<Product> productList = [];
  String? dropdownValue2 = 'Filter II';
  String token = window.sessionStorage["token"] ?? " ";
  String _searchText = '';
  String? _selectedValue1;
  String? _selectedValue;
  final String _category = '';
  final String _subCategory = '';
  int startIndex = 0;
  int currentPage = 1;
  Timer? _searchDebounceTimer;
  Map<String, dynamic> data1 = {};
  List<Product> filteredProducts = [];
  List<Product> selectedProducts = [];
  List<String> variationList = ['Select', 'Variation 1', 'Variation 2'];
  String selectedVariation = 'Select';

  List<String> uomList = ['Select', 'UOM 1', 'UOM 2'];
  String selectedUOM = 'Select';

  @override
  void initState() {
    super.initState();
    //_selectedValue1 = widget.subText;
    data1 = widget.data;
    print('-------selectlist');
    print(data1);
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
                productList = products.take(9).toList();
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
          if (mounted) {
            setState(() {
              productList = []; // Initialize with an empty list
            });
          }
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
  void loadMoreData() {
    fetchProducts(page: currentPage);
  }

  @override
  void dispose() {
    _searchDebounceTimer
        ?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
  void _onSearchTextChanged(String text) {
    if (_searchDebounceTimer != null) {
      _searchDebounceTimer!.cancel(); // Cancel the previous timer
    }
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = text;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          appBar:
          AppBar(
            leading: null,
            automaticallyImplyLeading: false,
            title: Image.asset("images/Final-Ikyam-Logo.png"),
            backgroundColor: const Color(0xFFFFFFFF),
            // Set background color to white
            elevation: 4.0,
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
                padding: const EdgeInsets.only(top: 7),
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
          body: LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;
                return Stack(
                  children: [
                    buildSideMenu(),
                    Positioned(
                      left: 200,
                      top: 1,
                      right: 0,
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back), // Back button icon
                            onPressed: () {
                              context.go('/dasbaord/Orderspage/addproduct/arrowback');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrdersSecond()),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              'Go back',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 43, left: 200),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10), // Space above/below the border
                        height: 2,
                        // width: 1500,
                        width: constraints.maxWidth,// Border height
                        color: Colors.grey[300], // Border color
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 150,right: 120),
                      child:  Padding(
                        padding: const EdgeInsets.only(top: 120,bottom: 50,left: 150),
                        child: SingleChildScrollView(
                          child: Container(
                            height: 635,
                            width: 1504,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: maxWidth,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                  ),
                                  child:const Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      'Search Products',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 800,left: 30,top: 20,bottom: 20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child:  SizedBox(
                                      height: 40,
                                      width: maxWidth * 0.2,
                                      child:  const TextField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.search),
                                          hintText: 'Search for products',
                                          contentPadding:  EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                    child:
                                    buildDataTable(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
          )
      ),
    );
  }





  Widget buildDataTable() {
    filteredProducts = productList
        .where((Product) => Product.productName
        .toLowerCase()
        .contains(_searchText.toLowerCase()))
        .where((Product) => _category.isEmpty || Product.category == _category)
        .where((Product) =>
    _subCategory.isEmpty || Product.subCategory == _subCategory)
        .toList();

    return SizedBox(
      height: 350,
      width: 1504,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color:  Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5,bottom: 5),
              child: Table(
                // border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(2.3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.8),
                  3: FlexColumnWidth(1.7),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1.5),
                  6:FlexColumnWidth(1),
                  // 8:FlexColumnWidth(2),

                },
                children: const [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            // left: 10,
                            // right: 10,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Center(child: Text('Product Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            // left: 10,
                            // right: 10,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Center(child: Text('Category',style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            // left: 10,
                            // right: 10,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Center(child: Text('Sub Category',style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            // left: 10,
                            // right: 10,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Center(child: Text('Price',style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            // left: 10,
                            // right: 10,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Center(child: Text('QTY',style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            // left: 10,
                            // right: 10,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Center(child: Text('Total Amount',style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
                            // left: 10,
                            // right: 10,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Center(child: Text('        ')),
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
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              Product product = filteredProducts[index];
              return Table(
                border: TableBorder.all(
                    color: Colors.grey),
                // Add this line
                columnWidths: const {
                  0: FlexColumnWidth(2.3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.8),
                  3: FlexColumnWidth(1.7),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1.5),
                  6: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5),
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: Text(
                                product.productName,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5),
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: Text(
                                product.category,
                                textAlign: TextAlign
                                    .center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5),
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: Text(
                                product.subCategory,
                                textAlign: TextAlign
                                    .center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5),
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: Text(
                                product.price.toString(),
                                textAlign: TextAlign
                                    .center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5),
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: TextFormField(
                                autofocus: true,
                                initialValue: '',
                                onChanged: (value){
                                  setState(() {
                                    product.quantity = int.tryParse(value) ?? 0;
                                    product.total = (product.price * product.quantity) as double;
                                    _calculateTotal();
                                  });
                                },
                                decoration: const InputDecoration(
                                    border:
                                    InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 12
                                    )
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding:const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5),
                          child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: Text(
                                product.total.toString(),
                                textAlign: TextAlign
                                    .center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            if (product.quantity == null || product.quantity == 0) {
                              // Show a popup to fill the quantity field
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Please fill the quantity field'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        //  Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              print('---data1');
                              print(Product);
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      NextPage(
                                        selectedProducts: const [],
                                        product: product,
                                        data: data1,
                                        inputText: '',
                                        subText: '', products: const [], notselect: '',
                                      ),
                                  settings: RouteSettings(
                                    name: '/Order_List/Product_List/Add_Products',
                                    arguments: {
                                      'product': Product,
                                      'data': data1,
                                      'inputText': '',
                                      'subText': '',
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildSideMenu() {
    return Align(
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
                context.go('/Orderspage/create/dasbaord');
                // context.go('${PageName.dashboardRoute}');
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const DashboardPage(

                    ),
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
              icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
              label: Text(
                'Home',
                style: TextStyle(color: Colors.indigo[900]),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                context.go('/dasbaord/Orderspage/create/productpage/:product');
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const ProductPage(
                      product: null,
                    ),
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
              icon: Icon(Icons.image_outlined, color: Colors.indigo[900]),
              label: Text(
                'Products',
                style: TextStyle(color: Colors.indigo[900]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
              onPressed: () {
                context.go('/Create/Orderspage');
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const Orderspage(),
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
                setState(() {
                  isOrdersSelected = false;
                  // Handle button press19
                });
              },
              icon: Icon(Icons.warehouse,
                  color:
                  isOrdersSelected ? Colors.blueAccent : Colors.blueAccent),
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
              icon: Icon(Icons.fire_truck_outlined, color: Colors.blue[900]),
              label: Text(
                'Delivery',
                style: TextStyle(color: Colors.indigo[900]),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {},
              icon:
              Icon(Icons.document_scanner_rounded, color: Colors.blue[900]),
              label: Text(
                'Invoice',
                style: TextStyle(color: Colors.indigo[900]),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.payment_outlined, color: Colors.blue[900]),
              label: Text(
                'Payment',
                style: TextStyle(color: Colors.indigo[900]),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                context.go('/dashboard/return/:return');
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                    const Returnpage(),
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
              icon: Icon(Icons.backspace_sharp, color: Colors.blue[900]),
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
    );
  }


  void _calculateTotal() {
    double total = 0;
    for (var product in products) {
      total += product.total;
    }
    setState(() {
      _total = total;
    });
  }
}
