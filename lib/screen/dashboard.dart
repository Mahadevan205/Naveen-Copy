import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/Return%20Module/return%20first%20page.dart';
import 'package:btb/widgets/pagination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:btb/widgets/productclass.dart';
import '../../screen/login.dart';
import '../Order Module/firstpage.dart';
import '../Product Module/Create Product.dart';
import '../Product Module/Product Screen.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key,});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isHomeSelected = false;
  Timer? _searchDebounceTimer;
  String _searchText = '';
  DateTime? _selectedDate;
  late TextEditingController _dateController;
  int startIndex = 0;
  late Future<List<Dashboard1>> futureOrders;
  bool _hasShownPopup = false;
  List<Product> filteredProducts = [];
  String status='';
  String selectDate='';
  String deliverystatus = '';
  String? dropdownValue1 = 'Delivery Status';
  String searchQuery = '';
  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Select Year';
  late Future<DashboardCounts> futureDashboardCounts;
  //Naveen code
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalItems = 0;
  int totalPages = 0;
  bool isLoading = false;
  List<Dashboard1> productList = [];
  List<Dashboard1> _filteredData = [];

  Future<void> fetchProducts(int? page, int? itemsPerPage) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/dashboard/get_all_dashboard?page=$page&limit=$itemsPerPage',
        ),
        headers: {
          "Content-type": "application/json",
          "Authorization": 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = jsonDecode(responseBody);
        print(jsonData);

        List<Dashboard1> products = [];

        if (jsonData is List) {
          products = jsonData.map((item) => Dashboard1.fromJson(item)).toList();
        } else if (jsonData is Map && jsonData.containsKey('body')) {
          products = (jsonData['body'] as List).map((item) => Dashboard1.fromJson(item)).toList();
        }

        print('products: $products');

        int totalCount = products.length; // Initialize total count

        print('Current Page: $page');
        setState(() {
          productList = products;
          print('productList: $productList');

          // Calculate the total pages using the total count
          totalPages = (totalCount / itemsPerPage!).ceil();
          print('Total Pages: $totalPages');
          _filterAndPaginateProducts();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error message to the user
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  void _updateSearch(String searchText) {
    setState(() {
      _searchText = searchText;
      currentPage = 1;  // Reset to first page when searching
      _filterAndPaginateProducts();
      // _clearSearch();
    });
  }
  void _goToPreviousPage() {
    print("previos");

    if (currentPage > 1) {
      if(_filteredData.length > itemsPerPage) {
        setState(() {
          currentPage--;
        });
      }
    }
  }
  void _goToNextPage() {
    print('nextpage');

    if (currentPage < totalPages) {
      if(_filteredData.length > itemsPerPage) {
        setState(() {
          currentPage++;

        });
      }
    }
  }
  void _filterAndPaginateProducts() {

    _filteredData = productList.where((product) {

      final matchesSearchText= product.orderId.toLowerCase().contains(_searchText.toLowerCase());
      print('-----');
      print(product.createdDate);
      String orderYear = '';
      if (product.createdDate.contains('-')) {
        final dateParts = product.createdDate.split('-');
        if (dateParts.length == 3) {
          orderYear = dateParts[0]; // Extract the year
        }
      }
      if (status.isEmpty && selectDate.isEmpty) {
        return matchesSearchText; // Include all products that match the search text
      }
      if(status == 'Delivery Status' && selectDate == 'Select Year'){
        return matchesSearchText;
      }
      if(status == 'Delivery Status' &&  selectDate.isEmpty)
      {
        return matchesSearchText;
      }
      if(selectDate == 'Select Year' &&  status.isEmpty)
      {
        return matchesSearchText;
      }
      if (status == 'Delivery Status' && selectDate.isNotEmpty) {
        return matchesSearchText && orderYear == selectDate; // Include all products
      }
      if (status.isNotEmpty && selectDate == 'Select Year') {
        return matchesSearchText && product.deliveryStatus == status;// Include all products
      }
      if (status.isEmpty && selectDate.isNotEmpty) {
        return matchesSearchText && orderYear == selectDate; // Include all products
      }

      if (status.isNotEmpty && selectDate.isEmpty) {
        return matchesSearchText && product.deliveryStatus == status;// Include all products
      }
      return matchesSearchText &&
          (product.deliveryStatus == status && orderYear == selectDate);
      //  return false;
    }).toList();
    setState(() {
      print('fileterpaginate');
      print(_filteredData);
      currentPage = 1;
    });

  }


  @override
  void initState() {
    super.initState();
    futureDashboardCounts = _getDashboardCounts();
    _dateController = TextEditingController();
    _selectedDate = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    _dateController.text = formattedDate;
    fetchProducts( currentPage,itemsPerPage);
  }

  Future<DashboardCounts> _getDashboardCounts() async {
    final response = await http.get(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/dashboard/get_dashboard_counts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return DashboardCounts.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load dashboard counts');
    }
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

                      child: WillPopScope(
                              onWillPop: () async {
                        // Prevent the popup from appearing when navigating back
                        return false;
                      },

                         child:  PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (value) {
                    if (!_hasShownPopup) {
                      _hasShownPopup = true;
                      if (value == 'logout') {
                        window.sessionStorage.remove('token');
                        context.go('/');
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const LoginScr(),
                            transitionDuration: const Duration(milliseconds: 50),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      }
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
              ),
            ],
          ),
          body: LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;
                return  Stack(
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
                                setState(() {
                                  isHomeSelected = false;
                                  // Handle button press19
                                });
                              },
                              icon: Icon(Icons.dashboard,
                                  color: isHomeSelected
                                      ? Colors.blueAccent
                                      : Colors.blueAccent),
                              label: const Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {

                                context.go('/Products');
                             //    Navigator.of(context).push(
                             //      PageRouteBuilder(
                             //        pageBuilder: (context, animation, secondaryAnimation) =>
                             //            ProductPage(
                             //              product: null,
                             //            ),
                             //      ),
                             //
                             //    );
                             //    GoRouter.of(context).go('/Home/Products', extra: (context) {
                             //         return ProductPage(product: null);
                             //       });

                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     path: '/dashboard/productpage/:product',
                                //     builder: (context) => ProductPage(
                                //       product: null,
                                //     ),
                                //   ),
                                // );
                                // Navigator.pushNamed(
                                //   context,
                                //   '/dashboard/productpage/:product',
                                //   arguments: {'product': null},
                                // );
                                // Navigator.push(
                                //      context,
                                //      PageRouteBuilder(
                                //        pageBuilder: (context, animation, secondaryAnimation) => ProductPage(
                                //          product: null,
                                //        ),
                                //    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                //       return FadeTransition(
                                //         opacity: animation,
                                //         child: child,
                                //       );
                                //     },
                                //     settings: RouteSettings(name: '/dashboard/productpage/:product'), // Add a named route
                                //   ),
                                // );
                              },
                              icon:
                              Icon(Icons.image_outlined, color: Colors.indigo[900]),
                              label: Text(
                                'Products',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                context.go('/Orders');
                               // Navigator.pushNamed(context, '/:Orders');
                              //   context.go('/:Orders');
                              // //  context.go('/dasbaord/Orderspage');
                              //   Navigator.of(context).push(PageRouteBuilder(
                              //     pageBuilder: (context, animation,
                              //         secondaryAnimation) =>
                              //         Orderspage(),
                              //   ));
                              },
                              icon: Icon(Icons.warehouse_outlined,
                                  color: Colors.indigo[900]),
                              label: Text(
                                'Orders',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                              },
                              icon: Icon(Icons.fire_truck_outlined,
                                  color: Colors.blue[900]),
                              label: Text(
                                'Delivery',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                              },
                              icon: Icon(Icons.document_scanner_rounded,
                                  color: Colors.blue[900]),
                              label: Text(
                                'Invoice',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                              },
                              icon:
                              Icon(Icons.payment_outlined, color: Colors.blue[900]),
                              label: Text(
                                'Payment',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                context.go('/:Home/:Return');
                               // context.go('/dashboard/return/:return');
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, secondaryAnimation) =>
                                    const Returnpage(),
                                    transitionDuration:
                                    const Duration(milliseconds: 50),
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
                              icon:
                              Icon(Icons.backspace_sharp, color: Colors.blue[900]),
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
                      left: 100,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                color: Colors.white,
                                height: 60,
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Text(
                                        'Dashboard',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 80),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          context.go('/Add_Product');
                                          // Navigator.push(
                                          //   context,
                                          //   PageRouteBuilder(
                                          //     pageBuilder:
                                          //         (context, animation, secondaryAnimation) =>
                                          //     const SecondPage(),
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
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                          Colors.blueAccent, // Button background color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5), // Rounded corners
                                          ),
                                          side: BorderSide.none, // No outline
                                        ),
                                        child: const Text(
                                          'Create',
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
                              margin: const EdgeInsets.only(left: 100), // Space above/below the border
                              height: 2,
                              // width: 1000,
                              width: constraints.maxWidth,// Border height
                              color: Colors.grey[300], // Border color
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:10,right: 100),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFFEBF3FF), width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF418CFC)
                                              .withOpacity(0.16), // 0.2 * 0.8 = 0.16
                                          spreadRadius: 0,
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: 39,
                                      width: maxWidth *0.13,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withOpacity(1), // Opacity is 1, fully opaque
                                        borderRadius: BorderRadius.circular(4),
                                      ),
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
                                                        //  _showDatePicker(context);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                hintText: '  Select Date',
                                                fillColor: Colors.white,
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
                            ),
                            Padding(
                              padding:  const EdgeInsets.only(left: 150,right: 100,top: 30),
                              child: SizedBox(
                                width:  maxWidth,
                                child: Column(
                                  children: [
                                    FutureBuilder(
                                        future: futureDashboardCounts,
                                        builder: (context, snapshot){
                                          if(snapshot.hasData){
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Card(
                                                  margin:  const EdgeInsets.only(left: 1, top: 20,),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  color: Colors.white,
                                                  elevation: 2, // equivalent to the boxShadow in the original code
                                                  child: Container(
                                                    // height: 140,
                                                    width: maxWidth * 0.15,
                                                    padding: const EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.blue.withOpacity(0.1),
                                                          spreadRadius: 3,
                                                          blurRadius: 7,
                                                          offset: const Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 8),
                                                          child: Image.asset(
                                                            "images/open.png",
                                                            width: 35, // Set your desired width
                                                            height: 35,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 10),
                                                          child: Text('${snapshot.data!.openOrders}',
                                                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            'Open Orders',
                                                            style:
                                                            TextStyle(fontSize: 12, color: Colors.grey),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:20),
                                                  child: Card(
                                                    // margin:  EdgeInsets.only(left: 600, top: 150),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    color: Colors.white, // Set the color to white
                                                    elevation: 2, // equivalent to the boxShadow in the original code
                                                    child: Container(
                                                      // height: 140,
                                                      width: maxWidth * 0.15,
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.blue.withOpacity(0.1),
                                                            spreadRadius: 3,
                                                            blurRadius: 7,
                                                            offset: const Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 3),
                                                            child: Image.asset(
                                                              "images/file.png",
                                                              width: 35,
                                                              height: 35,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: Text('${snapshot.data!.openInvoices}',
                                                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              'Open Invoices',
                                                              style:
                                                              TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20),
                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    color: Colors.white, // Set the color to white
                                                    elevation: 2, // equivalent to the boxShadow in the original code
                                                    child: Container(
                                                      // height: 140,
                                                      width: maxWidth * 0.15,
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.blue.withOpacity(0.1),
                                                            spreadRadius: 3,
                                                            blurRadius: 7,
                                                            offset: const Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 5),
                                                            child: Image.asset(
                                                              "images/dash.png",
                                                              width: 35,
                                                              height: 35,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: Text( '₹ ${snapshot.data!.availableCreditLimit}',
                                                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              'Available Credit Limit',
                                                              style:
                                                              TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:20,),
                                                  child: Card(

                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    color: Colors.white, // Set the color to white
                                                    elevation: 2, // equivalent to the boxShadow in the original code
                                                    child: Container(
                                                      // height: 140,
                                                      width: maxWidth * 0.15,
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.blue.withOpacity(0.1),
                                                            spreadRadius: 3,
                                                            blurRadius: 7,
                                                            offset: const Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 1),
                                                            child: Image.asset(
                                                              "images/nk1.png",
                                                              width: 35,
                                                              height: 35,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: Text('${snapshot.data!.orderCompleted}',
                                                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              'Order Completed',
                                                              style:
                                                              TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],

                                            );
                                          }else{
                                            return Text('No data found');
                                          }
                                        }),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 1, top: 50,right: 1),
                                        child: Container(
                                          height: 750,
                                          width: maxWidth ,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: SizedBox(

                                           //width: maxWidth * 0.8,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                buildSearchField1(),
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: buildDataTable1(),

                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:100),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      PaginationControls(
                                                        currentPage: currentPage,
                                                        totalPages: totalPages,
                                                        // onFirstPage: _goToFirstPage,
                                                        onPreviousPage: _goToPreviousPage,
                                                        onNextPage: _goToNextPage,
                                                        // onLastPage: _goToLastPage,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
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

  Widget buildSearchField1() {
    double maxWidth1 = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context,constraints){
      return
        ConstrainedBox(
          constraints: BoxConstraints(
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: maxWidth1 * 0.315,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[100]!),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search_outlined),
                        ),
                        onChanged: _updateSearch,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: maxWidth1 * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Filter I',
                            ),
                            value: dropdownValue1,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue1 = newValue;
                                status = newValue ??'';
                                _filterAndPaginateProducts();
                              });
                            },
                            items: <String>['Delivery Status',
                              'Not Started',
                              'Completed',]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: maxWidth1 * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Filter II',
                            ),
                            value: dropdownValue2,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectDate = newValue ??'';
                                dropdownValue2 = newValue;
                                _filterAndPaginateProducts();
                              });
                            },
                            items: <String>['Select Year', '2023', '2024', '2025']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
    });
  }

  Widget buildDataTable1() {
    var _mediaQuery = MediaQuery.of(context).size.width;

    if (_filteredData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 250, left: 500),
        child: Center(
          child: Text('No products found'),
        ),
      );
    }
    return  Column(
      children: [
        Container(
          width: _mediaQuery * 0.82,
          color: const Color(0xFFF7F7F7),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child:
            DataTable(
              headingRowHeight: 40,
              columns: [
                DataColumn(label: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text('Status',style:TextStyle( color: Colors.indigo[900],   fontSize: 15,
                        fontWeight: FontWeight.bold,),),
                    ))),
                DataColumn(label: Container(child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('Order ID',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                      fontWeight: FontWeight.bold),),
                ))),
                DataColumn(label: Container(child: Text('Created Date',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                    fontWeight: FontWeight.bold),))),
                DataColumn(label: Container(child: Text('Reference Number',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                    fontWeight: FontWeight.bold),))),
                DataColumn(label: Container(child: Text('Total Amount',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                    fontWeight: FontWeight.bold),))),
                DataColumn(label: Container(child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text('Delivery Status',style:  TextStyle(
                      color: Colors.indigo[900],
                      fontSize: 15,
                      fontWeight: FontWeight.bold),),
                ))),
              ],
              rows:  _filteredData.skip((currentPage - 1) * itemsPerPage)
                  .take(itemsPerPage)
                  .map((dashboard){
                final isSelected = false;
                return DataRow(
                    color: MaterialStateColor.resolveWith(
                            (states) => isSelected ? Colors.grey[200]! : Colors.white),
                    cells: [
                      DataCell(
                          Container(
                              child: Text(dashboard.status, style: TextStyle(fontSize: 15,color:isSelected ? Colors.deepOrange[200] : const Color(0xFFFFB315) ,),))),
                      DataCell(Container( child: Text(dashboard.orderId))),
                      DataCell(Container( child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(dashboard.createdDate),
                      ))),
                      DataCell(Container(child: Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(dashboard.referenceNumber.toString()),
                      ))),
                      DataCell(Container(child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(dashboard.totalAmount.toString()),
                      ))),
                      DataCell(Container(child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(dashboard.deliveryStatus.toString()),
                      ))),
                    ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class Dashboard {
  String dashBoardId;
  String status;
  String orderId;
  String createdDate;
  int referenceNumber;
  int totalAmount;
  String deliveryStatus;

  Dashboard({
    required this.dashBoardId,
    required this.status,
    required this.orderId,
    required this.createdDate,
    required this.referenceNumber,
    required this.totalAmount,
    required this.deliveryStatus,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      dashBoardId: json['dashBoardId'],
      status: json['status'],
      orderId: json['orderId'],
      createdDate: json['createdDate'],
      referenceNumber: json['referenceNumber'],
      totalAmount: json['totalAmount'],
      deliveryStatus: json['deliveryStatus'],
    );
  }
}


class Dashboard1 {
  final String dashBoardId;
  final String status;
  final String orderId;
  final String createdDate;
  final int referenceNumber;
  final int totalAmount;
  final String deliveryStatus;

  Dashboard1({
    required this.dashBoardId,
    required this.status,
    required this.orderId,
    required this.createdDate,
    required this.referenceNumber,
    required this.totalAmount,
    required this.deliveryStatus,
  });

  factory Dashboard1.fromJson(Map<String, dynamic> json) {
    return Dashboard1(
      dashBoardId: json['dashBoardId'] ?? '',
      status: json['status'] ?? '',
      orderId: json['orderId'] ?? '',
      createdDate: json['createdDate'] ?? '',
      referenceNumber: json['referenceNumber'] != null ? int.parse(json['referenceNumber'].toString()) : 0,
      totalAmount: json['totalAmount'] != null ? int.parse(json['totalAmount'].toString()) : 0,
      deliveryStatus: json['deliveryStatus'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Dashboard1('
        'dashBoardId: $dashBoardId, '
        'status: $status, '
        'orderId: $orderId,'
        ' createdDate: $createdDate, '
        'referenceNumber: $referenceNumber,'
        ' totalAmount: $totalAmount, '
        'deliveryStatus: $deliveryStatus)';
  }
}


class DashboardCounts {
  final int openOrders;

  final int openInvoices;
  final int availableCreditLimit;
  final int orderCompleted;

  DashboardCounts({required this.openOrders, required this.openInvoices, required this.availableCreditLimit, required this.orderCompleted});

  factory DashboardCounts.fromJson(Map<String, dynamic> json) {
    return DashboardCounts(
      openOrders: json['Open Orders'],
      openInvoices: json['Open Invoices'],
      availableCreditLimit: json['Available Credit Limit'],
      orderCompleted: json['Order Completed'],
    );
  }
}

 


