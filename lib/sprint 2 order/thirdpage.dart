import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/sprint%202%20order/secondpage.dart';
import 'package:btb/thirdpage/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../fourthpage/orderspage order.dart';
import '../screen/login.dart';
import '../thirdpage/dashboard.dart';
import 'firstpage.dart';
import 'fourthpage.dart';
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OrderPage3(data: {}),
  ));
}
class OrderPage3 extends StatefulWidget {
  // final String subText;
  // final String inputText;
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
  //Map itemsData;
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
                productList = products.take(10).toList();
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
                            width: maxWidth,
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
                                      child:  TextField(
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
                    //buildSearchAndTable(),

                    // child: buildSearchFieldAndDataTable(),

                    // call in the last editing work complete if
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
      width: 1500,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 30,
                top: 10,
                bottom: 10,
              ),
              child: SizedBox(
                height: 20,
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 45,right: 50),
                        child: Text(
                          'Product Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left:75,right: 45),
                        child: Text(
                          "Category",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 55,right: 60),
                        child: Text(
                          "Sub Category",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 85,right: 25),
                        child: Text(
                          "Price",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                      padding: EdgeInsets.only(left: 95,right: 0),
                      child: Text(
                        "QTY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 75,right: 25),
                        child: Text(
                          "Total Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Text("  ",
                        ),
                      ),
                    ),
                  ],
                ),
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
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(
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

                              // context.go(
                              //   '/dasbaord/Orderspage/addproduct/addparts/addbutton',
                              //   extra: {
                              //     'product': Provider.of<ProductProvider>(context, listen: false).product,
                              //     'data': Provider.of<ProductProvider>(context, listen: false).data,
                              //     'inputText': Provider.of<ProductProvider>(context, listen: false).inputText,
                              //     'subText': Provider.of<ProductProvider>(context, listen: false).subText,
                              //   },
                              // );
                              // context.go(
                              //   '/dasbaord/Orderspage/addproduct/addparts/addbutton',
                              //   extra: {
                              //     'product': Provider.of<ProductProvider>(context, listen: false).product,
                              //     'data': data1,
                              //     'inputText': '',
                              //     'subText': '',
                              //   },
                              // );

                              // context.read<ExtraDataProvider>().setExtraData({
                              //                                  'product': Product,
                              //                                  'data': data1,
                              //                                  'inputText': '',
                              //                                  'subText': '',
                              //                                });

                              // context.go(
                              //   '/dasbaord/Orderspage/addproduct/addparts/addbutton:data',
                              //   extra: {
                              //     'product': Product,
                              //     'data': data1,
                              //     'inputText': '',
                              //     'subText': '',
                              //   },
                              // );
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
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (context, animation, secondaryAnimation) =>
                              //         NextPage(
                              //           selectedProducts: const [],
                              //           product: Product,
                              //           data: data1,
                              //           inputText: '',
                              //           subText: '', products: const [], notselect: '',
                              //         ),
                              //     settings:  RouteSettings(
                              //       name: '/dasbaord/Orderspage/addproduct/addparts/addbutton:data',
                              //       arguments: {
                              //         'product': Product,
                              //         'data': data1,
                              //         'inputText': '',
                              //         'subText': '',
                              //       },
                              //     ),
                              //     transitionDuration: const Duration(milliseconds: 200),
                              //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              //       return FadeTransition(
                              //         opacity: animation,
                              //         child: child,
                              //       );
                              //     },
                              //   ),
                              // );
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
                    const Dashboard(

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
              onPressed: () {},
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

  // Widget buildProductListTitle() {
  //   return
  //     Positioned(
  //     left: 200,
  //     top: 1,
  //     right: 0,
  //     height: kToolbarHeight,
  //     child: Row(
  //       children: [
  //         IconButton(
  //           icon: const Icon(Icons.arrow_back), // Back button icon
  //           onPressed: () {
  //             context.go('/dasbaord/Orderspage/addproduct/arrowback');
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => OrdersSecond()),
  //             );
  //           },
  //         ),
  //         const Padding(
  //           padding: EdgeInsets.only(left: 30),
  //           child: Text(
  //             'Go back',
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textAlign: TextAlign.left,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
//
// // import 'package:btb/sprint2/nexttext.dart';
// //import 'package:btb/sprint2/orderpage4.dart';
// //import 'package:btb/eighth%20page/fourthpage%20sprint%202.dart';
// import 'package:btb/sprint%202%20order/secondpage.dart';
// import 'package:btb/thirdpage/productclass.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
//
// import '../fourthpage/orderspage order.dart';
// import '../thirdpage/dashboard.dart';
// import 'firstpage.dart';
// import 'fourthpage.dart';
//
// // void main() {
// //   runApp(const MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     home: OrderPage3(data: {}),
// //   ));
// // }
//
// class OrderPage3 extends StatefulWidget {
//   // final String subText;
//   // final String inputText;
//
//
//   final Map<String, dynamic> data;
//
//   const OrderPage3({super.key, required this.data,});
//
//   @override
//   OrderPage3State createState() => OrderPage3State();
// }
//
// class OrderPage3State extends State<OrderPage3> {
//   List<Product> products = [];
//   double _total = 0;
//   String? dropdownValue1 = 'Filter I';
//   bool isOrdersSelected = false;
//   List<Product> productList = [];
//   String? dropdownValue2 = 'Filter II';
//   String token = window.sessionStorage["token"] ?? " ";
//   String _searchText = '';
//   String? _selectedValue1;
//   //Map itemsData;
//   String? _selectedValue;
//   final String _category = '';
//   final String _subCategory = '';
//   int startIndex = 0;
//   int currentPage = 1;
//   Timer? _searchDebounceTimer;
//   Map<String, dynamic> data1 = {};
//   List<Product> filteredProducts = [];
//   List<Product> selectedProducts = [];
//   List<String> variationList = ['Select', 'Variation 1', 'Variation 2'];
//   String selectedVariation = 'Select';
//
//   List<String> uomList = ['Select', 'UOM 1', 'UOM 2'];
//   String selectedUOM = 'Select';
//
//   @override
//   void initState() {
//     super.initState();
//     //_selectedValue1 = widget.subText;
//     data1 = widget.data;
//     print('-------selectlist');
//     print(data1);
//     fetchProducts(page: currentPage);
//   }
//
//   Future<void> fetchProducts({int? page}) async {
//     final response = await http.get(
//       Uri.parse(
//         'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster?startIndex=$startIndex&limit=20',
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
//         if (jsonData is List) {
//           final products =
//           jsonData.map((item) => Product.fromJson(item)).toList();
//           if (mounted) {
//             setState(() {
//               if (currentPage == 1) {
//                 productList = products.take(5).toList();
//               } else {
//                 productList.addAll(products);
//               }
//               startIndex += 20;
//               currentPage++;
//             });
//           }
//         } else if (jsonData is Map) {
//           final products =
//           jsonData['body'].map((item) => Product.fromJson(item)).toList();
//           if (mounted) {
//             setState(() {
//               if (currentPage == 1) {
//                 productList = products;
//               } else {
//                 productList.addAll(products);
//               }
//               startIndex += 20;
//               currentPage++;
//             });
//           }
//         } else {
//           if (mounted) {
//             setState(() {
//               productList = []; // Initialize with an empty list
//             });
//           }
//         }
//       } catch (e) {
//         print('Error decoding JSON: $e');
//       }
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   void loadMoreData() {
//     fetchProducts(page: currentPage);
//   }
//
//   @override
//   void dispose() {
//     _searchDebounceTimer
//         ?.cancel(); // Cancel the timer when the widget is disposed
//     super.dispose();
//   }
//
//   void _onSearchTextChanged(String text) {
//     if (_searchDebounceTimer != null) {
//       _searchDebounceTimer!.cancel(); // Cancel the previous timer
//     }
//     _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
//       setState(() {
//         _searchText = text;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFFFFFFF),
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: const Color(0xFFFFFFFF),
//           // Set background color to white
//           elevation: 4.0,
//           shadowColor: const Color(0xFFFFFFFF),
//           // Set shadow color to black
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 15),
//               child: IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 35),
//               child: IconButton(
//                 icon: const Icon(Icons.account_circle),
//                 onPressed: () {
//                   // Handle user icon press
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: Stack(
//           children: [
//             buildSideMenu(),
//
//             buildSearchAndTable(),
//             // child: buildSearchFieldAndDataTable(),
//
//             buildProductListTitle(),
//             // call in the last editing work complete if
//           ],
//         ),
//       ),
//     );
//   }
//
//   //
//   // Widget buildMenuItem(String imagePath, String label) {
//   //   return Column(
//   //     children: [
//   //       TextButton.icon(
//   //         onPressed: () {
//   //           // Handle button press
//   //         },
//   //         icon: Image.asset(
//   //           imagePath,
//   //           width: 24, // Adjust width and height as needed
//   //           height: 24,
//   //         ),
//   //         label: Text(label),
//   //       ),
//   //       SizedBox(height: 28),
//   //     ],
//   //   );
//   // }
//
//   Widget buildMainContent() {
//     return Center(
//       child: Card(
//         elevation: 2.0,
//         child: Container(
//           height: 500,
//           width: 1200,
//           padding: const EdgeInsets.only(top: 80),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 1),
//               buildSearchField(),
//               const SizedBox(height: 8),
//               buildDataTable(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchAndTable() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 150),
//       child: Container(
//         height: 550,
//         width: 1480,
//         // padding: EdgeInsets.only(),
//         margin: const EdgeInsets.only(left: 320, right: 100),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(5),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: const Offset(0, 8),
//               )
//             ]),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildSearchField(),
//             const SizedBox(height: 8),
//             buildDataTable(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSearchField() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 1480,
//                 height: 50,
//                 color: Colors.blue[900],
//
//                 child: const Padding(
//                   padding: EdgeInsets.only(left: 30, top: 10),
//                   child: Text(
//                     'Search Products',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ), // Set background color here
//               ),
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(
//                   left: 30,
//                   right: 800,
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(color: Colors.blue[100]!),
//                   ),
//                   child: SizedBox(
//                     height: 35,
//                     width: 400,
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 12.0),
//                         border: InputBorder.none,
//                         filled: true,
//                         fillColor: Colors.white,
//                         prefixIcon: Icon(Icons.search_outlined),
//                         hintText: 'Search for Products',
//                       ),
//                       onChanged: _onSearchTextChanged,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDataTable() {
//     filteredProducts = productList
//         .where((Product) => Product.productName
//         .toLowerCase()
//         .contains(_searchText.toLowerCase()))
//         .where((Product) => _category.isEmpty || Product.category == _category)
//         .where((Product) =>
//     _subCategory.isEmpty || Product.subCategory == _subCategory)
//         .toList();
//
//     return SizedBox(
//       height: 350,
//       width: 1390,
//       child: Card(
//         child: Column(
//           children: [
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.only(),
//               child: DataTable(
//                 border: TableBorder.all(
//                   color: Colors.grey,
//                   width: 2,
//                 ),
//                 // decoration: BoxDecoration(
//                 //   border: Border.all(color: Colors.blue, width: 1),
//                 // ),
//
//                 headingRowHeight: 50,
//                 columns: [
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 25, right: 29),
//                       child: const Text(
//                         'Product Name',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 40, right: 35),
//                       child: const Text(
//                         'Category',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//
//                         // color: Colors.blue[900],
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 25, right: 10),
//                       child: const Text(
//                         'Sub Category',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 25, right: 15),
//                       child: const Text(
//                         'Price',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 25, right: 10),
//                       child: const Text(
//                         'QTY',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 30, right: 10),
//                       child: const Text(
//                         'Total Amount',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       padding: const EdgeInsets.only(left: 25, right: 0),
//                       child: const Text(
//                         '  ',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: filteredProducts.map((Product) {
//                   return DataRow.byIndex(
//                     index: filteredProducts.indexOf(Product),
//                     cells: [
//                       DataCell(
//                         Container(
//                           height: 35,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                           ),
//                           child: Center(
//                             child: Text(
//                               Product.productName,
//                               style: const TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
//                           child: Container(
//                             height: 35,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                             ),
//                             child: Center(
//                               child: Text(
//                                 Product.category,
//                                 style: const TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
//                           child: Container(
//                             height: 35,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                             ),
//                             child: Center(
//                               child: Text(
//                                 Product.subCategory,
//                                 style: const TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
//                           child: Container(
//                             height: 35,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                             ),
//                             child: Center(
//                               child: Text(
//                                 Product.price.toString(),
//                                 style: TextStyle(color: Colors.blue[900]),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
//                           child: Container(
//                             height: 35,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                             ),
//                             child: Center(
//                               child: TextFormField(
//                                 autofocus: true, // Add this line
//                                 initialValue: '', // Add this line
//                                 onChanged: (value) {
//                                   setState(() {
//                                     Product.quantity = int.tryParse(value) ?? 0;
//                                     Product.total =
//                                         (Product.price * Product.quantity) as double;
//                                     _calculateTotal();
//                                   });
//                                 },
//                                 decoration: const InputDecoration(
//                                   border:
//                                   InputBorder.none, // Hide the underline
//                                   contentPadding: EdgeInsets.only(
//                                       bottom: 12), // Remove the padding
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
//                           child: Container(
//                             height: 35,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                             ),
//                             child: Center(
//                               child: Text(
//                                 Product.total.toString(),
//                                 style: TextStyle(color: Colors.blue[900]),
//                               ),
//                               // Adjust the spacing as needed
//                             ),
//                           ),
//                         ),
//                       ),
//                       DataCell(
//                         IconButton(
//                           icon: const Icon(
//                             Icons.add_circle_rounded,
//                             color: Colors.blue,
//                           ),
//                           onPressed: () {
//                             print('slected');
//                             print(selectedProducts);
//                             if (Product.quantity == null || Product.quantity == 0) {
//                               // Show a popup to fill the quantity field
//                               showDialog(
//                                 context: context,
//                                 builder: (context) => AlertDialog(
//                                   title: const Text('Error'),
//                                   content: const Text('Please fill the quantity field'),
//                                   actions: [
//                                     TextButton(
//                                       child: const Text('OK'),
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             } else {
//                               context.go(
//                                 '/dasbaord/Orderspage/addproduct/addparts/addbutton',
//                                 extra: {
//                                   'product': Product,
//                                   'data': data1,
//                                   'inputText': '',
//                                   'subText': '',
//
//                                 },
//                               );
//                               Navigator.push(
//                                 context,
//                                 PageRouteBuilder(
//                                   pageBuilder: (context, animation, secondaryAnimation) =>
//                                       NextPage(
//                                         product: Product,
//                                         data: data1,
//                                         inputText: '',
//                                         subText: '', products: [], selectedProducts: [], notselect: 'selectedproduct',
//                                       ),
//                                   transitionDuration: const Duration(milliseconds: 200),
//                                   transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                                     return FadeTransition(
//                                       opacity: animation,
//                                       child: child,
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildSideMenu() {
//     return Align(
//       // Added Align widget for the left side menu
//       alignment: Alignment.topLeft,
//       child: Container(
//         height: 1400,
//         width: 200,
//         color: const Color(0xFFF7F6FA),
//         padding: const EdgeInsets.only(left: 20, top: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextButton.icon(
//               onPressed: () {
//                 context.go('/Orderspage/create/dasbaord');
//                 // context.go('${PageName.dashboardRoute}');
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (context, animation, secondaryAnimation) =>
//                     const Dashboard(
//
//                     ),
//                     transitionDuration: const Duration(milliseconds: 200),
//                     transitionsBuilder:
//                         (context, animation, secondaryAnimation, child) {
//                       return FadeTransition(
//                         opacity: animation,
//                         child: child,
//                       );
//                     },
//                   ),
//                 );
//               },
//               icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
//               label: Text(
//                 'Home',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {
//                 context.go('/dasbaord/Orderspage/create/productpage/:product');
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (context, animation, secondaryAnimation) =>
//                     const ProductPage(
//                       product: null,
//                     ),
//                     transitionDuration: const Duration(milliseconds: 200),
//                     transitionsBuilder:
//                         (context, animation, secondaryAnimation, child) {
//                       return FadeTransition(
//                         opacity: animation,
//                         child: child,
//                       );
//                     },
//                   ),
//                 );
//               },
//               icon: Icon(Icons.image_outlined, color: Colors.indigo[900]),
//               label: Text(
//                 'Products',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             TextButton.icon(
//               onPressed: () {
//                 context.go('/Create/Orderspage');
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder: (context, animation, secondaryAnimation) =>
//                     const Orderspage(),
//                     transitionDuration: const Duration(milliseconds: 200),
//                     transitionsBuilder:
//                         (context, animation, secondaryAnimation, child) {
//                       return FadeTransition(
//                         opacity: animation,
//                         child: child,
//                       );
//                     },
//                   ),
//                 );
//                 setState(() {
//                   isOrdersSelected = false;
//                   // Handle button press19
//                 });
//               },
//               icon: Icon(Icons.warehouse,
//                   color:
//                   isOrdersSelected ? Colors.blueAccent : Colors.blueAccent),
//               label: const Text(
//                 'Orders',
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.fire_truck_outlined, color: Colors.blue[900]),
//               label: Text(
//                 'Delivery',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon:
//               Icon(Icons.document_scanner_rounded, color: Colors.blue[900]),
//               label: Text(
//                 'Invoice',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.payment_outlined, color: Colors.blue[900]),
//               label: Text(
//                 'Payment',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.backspace_sharp, color: Colors.blue[900]),
//               label: Text(
//                 'Return',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
//               label: Text(
//                 'Reports',
//                 style: TextStyle(color: Colors.indigo[900]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildProductListTitle() {
//     return Positioned(
//       left: 203,
//       right: 0,
//       top: 1,
//       height: kToolbarHeight,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back), // Back button icon
//               onPressed: () {
//                 context.go('/dasbaord/Orderspage/addproduct/arrowback');
//                  Navigator.push(
//                      context,
//                     MaterialPageRoute(
//                       builder: (context) => OrdersSecond()),
//                 );
//               },
//             ),
//             const Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 30),
//                 child: Text(
//                   'Go back',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _calculateTotal() {
//     double total = 0;
//     for (var product in products) {
//       total += product.total;
//     }
//     setState(() {
//       _total = total;
//     });
//   }
// }

//thirdpage old copy

