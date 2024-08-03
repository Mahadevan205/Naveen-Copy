
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/widgets/productclass.dart' as ord;
import 'package:btb/Return%20Module/return%20module%20design.dart';
import 'package:btb/Return%20Module/return%20ontap.dart';
import 'package:btb/widgets/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../Product Module/Product Screen.dart';
import '../screen/dashboard.dart';
import '../widgets/pagination.dart';
import '../screen/login.dart';
import '../Order Module/firstpage.dart';
import '../widgets/mycustomscrollbehavior.dart';





class Returnpage extends StatefulWidget {
  const Returnpage({super.key});

  @override
  State<Returnpage> createState() => _ReturnpageState();
}

class _ReturnpageState extends State<Returnpage> {
  Timer? _searchDebounceTimer;
  String _searchText = '';
  String status= '';
  String selectDate ='';
  ord.Product? product;
  ReturnMaster? _isselected;
  final String _category = '';
  bool isOrdersSelected = false;
  DateTime? _selectedDate;
  late Future<void> _futureReturnMasters;
  late TextEditingController _dateController;
  final String _subCategory = '';
  int startIndex = 0;
  List<Product> filteredProducts = [];
  int currentPage = 1;
  String? dropdownValue1 = 'Status';
  late Future<List<detail>> futureOrders;
  List<ReturnMaster> filteredData =[];
  bool _loading = false;
  List<ReturnMaster> productList = [];

  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Select Year';





  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    fetchReturnMasters(currentPage,itemsPerPage);
    //  futureOrders = fetchOrders() as Future<List<detail>>;

  }
  int itemsPerPage = 10;
  int totalItems = 0;
  int totalPages = 0;
  bool isLoading = false;

  Future<void> fetchReturnMasters(int page, int itemsPerPage) async {

    if (isLoading) return;
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse(
          'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/return_master/get_all_returnmaster?page=$page&limit=$itemsPerPage', // Changed limit to 10
        ),
        headers: {
          "Content-type": "application/json",
          "Authorization": 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('json data');
        print(jsonData);
        List<ReturnMaster> products = [];
        if (jsonData != null) {
          if (jsonData is List) {
            products = jsonData.map((item) => ReturnMaster.fromJson(item)).toList();
          } else if (jsonData is Map && jsonData.containsKey('body')) {
            products = (jsonData['body'] as List).map((item) => ReturnMaster.fromJson(item)).toList();
            totalItems = jsonData['totalItems'] ?? 0; // Get the total number of items
          }

          if(mounted){
            setState(() {
              totalPages = (products.length / itemsPerPage).ceil();
              print('pages');
              print(totalPages);
              productList = products;
              print(productList);
              _filterAndPaginateProducts();
            });
          }
        }
      } else {
        throw Exception('Failed to load data');
      }

    } catch (e) {
      print('Error decoding JSON: $e');
      // Optionally, show an error message to the user
    } finally {
      if(mounted){
        setState(() {
          isLoading = false;
        });
      }

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
      if(filteredData.length > itemsPerPage) {
        setState(() {
          currentPage--;
          //  fetchPskioroducts(currentPage, itemsPerPage);
        });
      }
      //fetchProducts(page: currentPage);
      // _filterAndPaginateProducts();
    }
  }
  void _goToNextPage() {
    print('nextpage');

    if (currentPage < totalPages) {
      if(filteredData.length > itemsPerPage) {
        setState(() {
          currentPage++;
          //  fetchProducts(currentPage, itemsPerPage);
        });
        // fetchProducts(page: currentPage);
        //  _filterAndPaginateProducts();
      }
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
        body: LayoutBuilder(
            builder: (context,constraints) {
              double maxWidth = constraints.maxWidth;
              double maxHeight = constraints.maxHeight;
              return
                Stack(
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
                                context.go('/Return/Home');
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation,
                                //         secondaryAnimation) =>
                                //      const DashboardPage(
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
                                context.go('/Return/Products', extra: product);
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation,
                                //         secondaryAnimation) =>
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
                                context.go('/Return/Orders');
                                // context.go('${PageName.main}/${PageName.subpage1Main}');
                                // Navigator.push(
                                //   context,
                                //   PageRouteBuilder(
                                //     pageBuilder:
                                //         (context, animation,
                                //         secondaryAnimation) =>
                                //     const Orderspage(),
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
                              const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  'Return Order List',
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
                                  padding:  EdgeInsets.only(
                                      top: 10, right: maxWidth * 0.069),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context.go('/Return/Create_return');
                                      // Navigator.push(
                                      //   context,
                                      //   PageRouteBuilder(
                                      //     pageBuilder: (context, animation,
                                      //         secondaryAnimation) =>
                                      //         CreateReturn(storeImage: 'even', imageSizeString: '',imageSizeStrings: const [],storeImages: const [],orderDetails: const [],orderDetailsMap: const {},),
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
                                      'Create',
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
                    Padding(
                      padding:  EdgeInsets.only(
                          left: 250, top: 120, right: maxWidth * 0.077,bottom: 10),
                      child: Container(
                        width: maxWidth,
                        height: 800,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue
                                  .withOpacity(0.2), // Light blue shadow
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ScrollConfiguration(
                            behavior: MyCustomScrollBehavior(),
                            child: Scrollbar(
                              thickness: 8,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: maxWidth * 0.792,
                                  // padding: EdgeInsets.only(),
                                  // margin: EdgeInsets.only(left: 400, right: 100),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildSearchField(),
                                      // buildSearchField(),
                                      const SizedBox(height: 30),
                                      buildDataTable(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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

  Widget buildSearchField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            // maxWidth: constraints.maxWidth,
            // maxHeight: constraints.maxHeight,
          ),
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20, // changed from 800 to 20
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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth * 0.27, // 80% of screen width
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue[100]!),
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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.13, // 40% of screen width
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(color: Colors.blue[100]!),
                                ),
                                child:
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Category',
                                  ),
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 25),
                                    child: Icon(Icons.arrow_drop_down_outlined),
                                  ), // default icon
                                  iconSize: 24, // change the size of the icon
                                  value: dropdownValue1,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue1 = newValue;
                                      status = newValue?? '';
                                      _filterAndPaginateProducts();
                                    });
                                  },
                                  items: <String>[
                                    'Status',
                                    'In preparation',
                                    'Completed',
                                    'Cancelled'
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(width: constraints.maxWidth * 0.01),// 5% of screen width
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.13, // 40% of screen width
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Sub Category',
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down_outlined), // default icon
                                  iconSize: 24,
                                  value: dropdownValue2,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue2 = newValue;
                                      selectDate = newValue?? '';
                                      _filterAndPaginateProducts();
                                    });
                                  },
                                  items: <String>['Select Year',
                                    '2023',
                                    '2024',
                                    '2025'
                                  ]
                                      .map<DropdownMenuItem<String>>((String value) {
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
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDataTable() {
    if (filteredData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 300),
        child: Center(
          child: Text('No products found'),
        ),
      );
    }
    return LayoutBuilder(builder: (context, constraints){
      var _mediaQuery = MediaQuery.of(context).size.width;
      return Column(
        children: [
          Container(
            width: _mediaQuery,
            color: const Color(0xFFF7F7F7),
            child:
            DataTable(
              headingRowHeight: 40,
              columns: [

                DataColumn(label: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text('Status',style:TextStyle( color: Colors.indigo[900],   fontSize: 15,
                        fontWeight: FontWeight.bold,),),
                    ))),
                DataColumn(label: Container(child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('Return ID',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                      fontWeight: FontWeight.bold),),
                ))),
                DataColumn(label: Container(child: Text('Created Date',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                    fontWeight: FontWeight.bold),))),
                DataColumn(label: Container(child: Text('Reference Number',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                    fontWeight: FontWeight.bold),))),
                DataColumn(label: Container(child: Text('Credit Amount',style:TextStyle(                            color: Colors.indigo[900], fontSize: 15,
                    fontWeight: FontWeight.bold),))),
              ],
              rows:filteredData
                  .skip((currentPage - 1) * itemsPerPage)
                  .take(itemsPerPage)
                  .map((returnMaster) {
                 //var isSelected = false;
                 final isSelected = _isselected == returnMaster;
                //final isSelected = _selectedProduct == product;
                return DataRow(
                    color: MaterialStateColor.resolveWith(
                            (states) => isSelected ? Colors.grey[200]! : Colors.white),
                    cells: [
                      DataCell(
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (event) {
                              setState(() {
                                _isselected = returnMaster;
                              });
                            },
                            onExit: (event) {
                              _isselected = null;
                            },
                            child: GestureDetector(

                              onTap:() {
                                context.go('/return-view', extra: returnMaster);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReturnView(returnMaster: returnMaster,)
                                  )
                                  , // pass the selected product here
                                );

                              },
                              child: Container(

                                // padding: EdgeInsets.only(left: 40),
                                  child: Text(returnMaster.status, style: TextStyle(fontSize: 15,color:isSelected ? Colors.deepOrange[200] : const Color(0xFFFFB315) ,),)),
                            ),
                          )),
                      DataCell(Container( child: Text(returnMaster.returnId!))),
                      DataCell(Container( child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(returnMaster.returnDate!.toString()),
                      ))),
                      DataCell(Container(child: Padding(
                        padding: const EdgeInsets.only(left:40),
                        child: Text(returnMaster.reason!),
                      ))),
                      DataCell(Container(child: Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(returnMaster.totalCredit.toString()),
                      ))),
                      // DataCell(Container(child: Padding(
                      //   padding: const EdgeInsets.only(left: 10),
                      //   child: Text(returnMaster.notes!),
                      // ))),

                    ]);
              }).toList(),
            ),
          ),
          const Divider(color: Colors.grey,height: 1,),

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

      );
    });

  }


  void _filterAndPaginateProducts() {
    filteredData = productList.where((product) {
      final matchesSearchText = product.returnId!.toLowerCase().contains(
          _searchText.toLowerCase());
      print('-----');
      print(product.returnDate);
      String orderYear = '';
      if (product.returnDate!.contains('/')) {
        final dateParts = product.returnDate!.split('/');
        if (dateParts.length == 3) {
          orderYear = dateParts[2]; // Extract the year
        }
      }
      // final orderYear = element.orderDate.substring(5,9);
      if (status.isEmpty && selectDate.isEmpty) {
        return matchesSearchText; // Include all products that match the search text
      }
      if(status == 'Status' && selectDate == 'Select Year'){
        return matchesSearchText;
      }
      if(status == 'Status' &&  selectDate.isEmpty)
      {
        return matchesSearchText;
      }
      if(selectDate == 'Select Year' &&  status.isEmpty)
      {
        return matchesSearchText;
      }
      if (status == 'Status' && selectDate.isNotEmpty) {
        return matchesSearchText && orderYear == selectDate; // Include all products
      }
      if (status.isNotEmpty && selectDate == 'Select Year') {
        return matchesSearchText && product.status == status;// Include all products
      }
      if (status.isEmpty && selectDate.isNotEmpty) {
        return matchesSearchText && orderYear == selectDate; // Include all products
      }

      if (status.isNotEmpty && selectDate.isEmpty) {
        return matchesSearchText && product.status == status;// Include all products
      }
      return matchesSearchText &&
          (product.status == status && orderYear == selectDate);
      return false;
    }).toList();
    setState(() {
      currentPage = 1;
    });
  }



}





class ReturnMaster {
  final String? returnId;
  final String? returnDate;
  final String? invoiceNumber;
  final String? reason;
  final String? contactPerson;
  final String status;
  final String? email;
  final double totalCredit;
  final String? notes;
  final List<ReturnItem> items;

  ReturnMaster({
    required this.returnId,
    required this.returnDate,
    required this.invoiceNumber,
    required this.reason,
    required this.contactPerson,
    required this.email,
    required this.status,
    required this.totalCredit,
    required this.notes,
    required this.items,
  });

  factory ReturnMaster.fromJson(Map<String, dynamic> json) {
    return ReturnMaster(
      returnId: json['returnId'],
      returnDate: json['returnDate'] ?? '',
      invoiceNumber: json['invoiceNumber'],
      reason: json['reason'],
      status: 'In preparation',
      contactPerson: json['contactPerson'],
      email: json['email'],
      totalCredit: json['totalCredit'].toDouble(),
      notes: json['notes'],
      items: (json['items'] as List)
          .map((item) => ReturnItem.fromJson(item))
          .toList(),
    );
  }



  factory ReturnMaster.fromString(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    return ReturnMaster.fromJson(jsonMap);
  }

}

class ReturnItem {
  final String? returnMasterItemId;
  final String? productName;
  final String? category;
  final String? subCategory;
  final double price;
  final int qty;
  final int returnQty;
  final double invoiceAmount;
  final double creditRequest;
  final String? imageId;
  final String? returnId;

  ReturnItem({
    required this.returnMasterItemId,
    required this.productName,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.qty,
    required this.returnQty,
    required this.invoiceAmount,
    required this.creditRequest,
    required this.imageId,
    required this.returnId,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      returnMasterItemId: json['returnMasterItemId'],
      productName: json['productName'],
      category: json['category'],
      subCategory: json['subCategory'],
      price: json['price'].toDouble(),
      qty: json['qty'],
      returnQty: json['returnQty'],
      invoiceAmount: json['invoiceAmount'].toDouble(),
      creditRequest: json['creditRequest'].toDouble(),
      imageId: json['imageId'],
      returnId: json['returnId'],
    );
  }
  factory ReturnItem.fromString(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    return ReturnItem.fromJson(jsonMap);
  }
}




