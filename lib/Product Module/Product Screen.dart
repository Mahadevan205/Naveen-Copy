import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/screen/login.dart';
import 'package:btb/widgets/productclass.dart' as ord;
import 'package:btb/Product%20Module/thirdpage%201.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../Return Module/return first page.dart';
import '../screen/dashboard.dart';
import '../widgets/pagination.dart';
import '../Order Module/firstpage.dart';
import '../widgets/mycustomscrollbehavior.dart';
import '../widgets/productdata.dart';
import 'Create Product.dart';
class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});
  final ord.Product? product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ord.Product? _selectedProduct;

  late ProductData productData;
  bool isHomeSelected = false;
  bool isOrdersSelected = false;
  Timer? _searchDebounceTimer;

  String _searchText = '';
  String _category = '';

  late TextEditingController _dateController;
  String _subCategory = '';
  int startIndex = 0;
  List<ord.Product> filteredProducts = [];
  String? dropdownValue1 = 'Category';
  String token = window.sessionStorage["token"] ?? " ";
  String? dropdownValue2 = 'Sub Category';
  bool _hasShownPopup = false;

  void _onSearchTextChanged(String text) {
    if (_searchDebounceTimer != null) {
      _searchDebounceTimer!.cancel(); // Cancel the previous timer
    }
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = text;
        _filterAndPaginateProducts();
      });
    });
  }
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalItems = 0;
  int totalPages = 0;
  bool isLoading = false;
  List<ord.Product> productList = [];

// Example method for fetching products
  Future<void> fetchProducts(int page, int itemsPerPage) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster?page=$page&limit=$itemsPerPage', // Changed limit to 10
        ),
        headers: {
          "Content-type": "application/json",
          "Authorization": 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<ord.Product> products = [];
        if (jsonData != null) {
          if (jsonData is List) {
            products = jsonData.map((item) => ord.Product.fromJson(item)).toList();
          } else if (jsonData is Map && jsonData.containsKey('body')) {
            products = (jsonData['body'] as List).map((item) => ord.Product.fromJson(item)).toList();
            //  totalItems = jsonData['totalItems'] ?? 0;

            print('pages');
            print(totalPages);// Changed itemsPerPage to 10
          }

          setState(() {
            productList = products;
            totalPages = (products.length / itemsPerPage).ceil();
            print(totalPages);
            _filterAndPaginateProducts();
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error decoding JSON: $e');
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
      if(filteredProducts.length > itemsPerPage) {
        setState(() {
          currentPage--;
          //  fetchProducts(currentPage, itemsPerPage);
        });
      }
      //fetchProducts(page: currentPage);
      // _filterAndPaginateProducts();
    }
  }

  void _goToNextPage() {
    print('nextpage');

    if (currentPage < totalPages) {
      if(filteredProducts.length > itemsPerPage) {
        setState(() {
          currentPage++;
        });
      }
    }
  }



  @override
  void initState() {
    super.initState();
    fetchProducts(currentPage, itemsPerPage);
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
            ],
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            double maxHeight = constraints.maxHeight;
            double maxWidth = constraints.maxWidth;
            return Stack(
              children: [
                Align(
                  // Added Align widget for the left side menu
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 2084,
                    width: 200,
                    color: const Color(0xFFF7F6FA),
                    padding: const EdgeInsets.only(left: 20, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TextButton.icon(
                        //   onPressed: () {
                        //     //Navigator.pushNamed(context, '/dashboard/productpage/:product/dashboard', arguments: {'product': null});
                        //     // Navigator.pushNamed(context, '/dashboard/productpage/:product/dashboard').then((_) {
                        //     //   showDialog(
                        //     //     context: context,
                        //     //     builder: (BuildContext context) {
                        //     //       return DashboardPage();
                        //     //     },
                        //     //   );
                        //     // });
                        //   },
                        //   icon: Icon(Icons.dashboard, color: Colors.indigo[900]),
                        //   label: Text(
                        //     'Home',
                        //     style: TextStyle(color: Colors.indigo[900]),
                        //   ),
                        // ),
                        TextButton.icon(
                          onPressed: ()  {
                            //  context.go('/dashboard/productpage/:product/dashboard').then((_) {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return DashboardPage();
                            //     },
                            //   );
                            // });
                            context.go('/Products/Home');
                            // Navigator.of(context).push(PageRouteBuilder(
                            //   pageBuilder: (context, animation,
                            //       secondaryAnimation) =>
                            //       DashboardPage(),
                            // ));
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
                            context.go('/Products/Orderspage/:Orders');
                            // Navigator.pushNamed(context, '/:products/Orderspage');
                            // context.go('/:products/Orderspage');
                            // Navigator.of(context).push(PageRouteBuilder(
                            //   pageBuilder: (context, animation,
                            //       secondaryAnimation) =>
                            //       Orderspage(),
                            // ));
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
                          onPressed: () {
                            context.go('/Home/Products/:Return');
                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     pageBuilder:
                            //         (context, animation, secondaryAnimation) =>
                            //     const Returnpage(),
                            //     transitionDuration:
                            //     const Duration(minutes: 250),
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
                              'Product List',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding:  EdgeInsets.only(right: maxWidth * 0.065),
                            child: OutlinedButton(
                              onPressed: () {
                                context.go('/Home/Products/Add_Product');
                                // Navigator.of(context).push(
                                //   PageRouteBuilder(
                                //     pageBuilder: (context, animation, secondaryAnimation) =>
                                //         SecondPage(
                                //          // product: null,
                                //         ),
                                //   ),
                                // );
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
                  padding:  EdgeInsets.only(left: 250, top: 120,right: maxWidth * 0.075,bottom: 10),
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
                          thickness: 6,
                         // scrollbarOrientation: ScrollbarOrientation.left,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              //  height: 1300,
                              width: maxWidth * 0.79,
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
                const SizedBox(height: 50,),
              ],
            );
          }
          )
      ),
    );
  }

  Widget buildSearchField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
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
                          maxWidth: constraints.maxWidth * 0.415, // 80% of screen width
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
                              maxWidth: constraints.maxWidth * 0.2, // 40% of screen width
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
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(Icons.arrow_drop_down_outlined),
                                  ), // default icon
                                  iconSize: 24, // change the size of the icon
                                  value: dropdownValue1,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue1 = newValue;
                                      _category = newValue?? '';
                                      _filterAndPaginateProducts();
                                    });
                                  },
                                  items: <String>[
                                    'Category',
                                    'Select 1',
                                    'Select 2',
                                    'Select 3'
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
                              maxWidth: constraints.maxWidth * 0.2, // 40% of screen width
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
                                      _subCategory = newValue?? '';
                                      _filterAndPaginateProducts();
                                    });
                                  },
                                  items: <String>['Sub Category', 'Yes', 'No']
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
    // _filterAndPaginateProducts();

    if (filteredProducts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 300),
        child: Center(
          child: Text('No products found'),
        ),
      );
    }
    return LayoutBuilder(builder: (context, constraints){
      var _mediaQuery = MediaQuery.of(context).size.width;
      // double padding = constraints.maxWidth * 0.05;
      // double right = constraints.maxWidth * 0.01;
      return
        Column(
          children: [
            Container(
              color: const Color(0xFFF7F7F7),
              width: _mediaQuery,
              child:
              DataTable(
                headingRowHeight: 40,
                columns: [
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        'Product Name',
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Category',
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sub Category',
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Unit',
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Price',
                        style: TextStyle(
                            color: Colors.indigo[900],
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                rows:  filteredProducts
                    .skip((currentPage - 1) * itemsPerPage)
                    .take(itemsPerPage)
                    .map((product) {
                  final isSelected = _selectedProduct == product;
                  return DataRow(
                    color: MaterialStateColor.resolveWith(
                            (states) => isSelected ? Colors.grey[200]! : Colors.white),
                    cells: [
                      DataCell(
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              _selectedProduct = product;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              _selectedProduct = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProduct = product;
                              });
                              context.go('/dashboard/productpage/:View', extra: product);

                              // Navigate to the new page and pass the selected product as an argument
                              // Navigator.of(context).push(PageRouteBuilder(
                              //   pageBuilder: (context, animation,
                              //       secondaryAnimation) =>
                              //    ProductForm1(
                              //     displayData: const {},
                              //     prodId: product.prodId,
                              //     imagePath: null,
                              //     productText: null,
                              //     priceText: null,
                              //     selectedValue: null,
                              //     selectedValue1: null,
                              //     selectedValue3: null,
                              //     selectedvalue2: null,
                              //     discountText: null,
                              //     product: product,
                              //     // productdetails: [
                              //     //   OrderDetail(
                              //     //     items: filteredProducts
                              //     //         .map((product) => ord.Product(
                              //     //       prodId: product.prodId,
                              //     //       productName: product.productName,
                              //     //       category: product.category,
                              //     //       subCategory: product.subCategory,
                              //     //       unit: product.unit,
                              //     //       price: product.price,
                              //     //     ))
                              //     //         .toList(),
                              //     //   ),
                              //     // ],
                              //   ),
                              // ));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 30), // Adjust padding as needed
                              child: Text(
                                product.productName,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isSelected
                                      ? Colors.deepOrange[200]
                                      : const Color(0xFFFFB315),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              _selectedProduct = product;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              _selectedProduct = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProduct = product;
                              });
                              // Navigate to the new page and pass the selected product as an argument
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm1(
                                      displayData: const {},
                                      prodId: product.prodId,
                                      imagePath: null,
                                      productText: null,
                                      priceText: null,
                                      selectedValue: null,
                                      selectedValue1: null,
                                      selectedValue3: null,
                                      selectedvalue2: null,
                                      discountText: null,
                                      product: product,
                                    )), // pass the selected product here
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                product.category,
                                style: const TextStyle(color: Color(0xFFA6A6A6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              _selectedProduct = product;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              _selectedProduct = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProduct = product;
                              });
                              // Navigate to the new page and pass the selected product as an argument
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm1(
                                      displayData: const {},
                                      prodId: product.prodId,
                                      imagePath: null,
                                      productText: null,
                                      priceText: null,
                                      selectedValue: null,
                                      selectedValue1: null,
                                      selectedValue3: null,
                                      selectedvalue2: null,
                                      discountText: null,
                                      product: product,
                                    )), // pass the selected product here
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                product.subCategory,
                                style: const TextStyle(
                                  color: Color(0xFFA6A6A6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              _selectedProduct = product;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              _selectedProduct = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProduct = product;
                              });
                              // Navigate to the new page and pass the selected product as an argument
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm1(
                                      displayData: const {},
                                      prodId: product.prodId,
                                      imagePath: null,
                                      productText: null,
                                      priceText: null,
                                      selectedValue: null,
                                      selectedValue1: null,
                                      selectedValue3: null,
                                      selectedvalue2: null,
                                      discountText: null,
                                      product: product,
                                    )), // pass the selected product here
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                product.unit,
                                style: const TextStyle(color: Color(0xFFA6A6A6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (event) {
                            setState(() {
                              _selectedProduct = product;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              _selectedProduct = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProduct = product;
                              });
                              // Navigate to the new page and pass the selected product as an argument
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm1(
                                      displayData: const {},
                                      prodId: product.prodId,
                                      imagePath: null,
                                      productText: null,
                                      priceText: null,
                                      selectedValue: null,
                                      selectedValue1: null,
                                      selectedValue3: null,
                                      selectedvalue2: null,
                                      discountText: null,
                                      product: product,
                                    )), // pass the selected product here
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                product.price.toString(),
                                style: const TextStyle(color: Color(0xFFA6A6A6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
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
                    onPreviousPage: _goToPreviousPage,
                    onNextPage: _goToNextPage,
                  ),
                ],
              ),
            ),

            if (filteredProducts.isEmpty)
              const Center(
                  child: Text('No products found', style: TextStyle(fontSize: 24))),
          ],

        );
    });
  }


  void _filterAndPaginateProducts() {
    filteredProducts = productList.where((product) {
      print('filter');
      print(filteredProducts);
      final matchesSearchText =
      product.productName.toLowerCase().contains(_searchText.toLowerCase());
      if (_category.isEmpty && _subCategory.isEmpty) {
        return matchesSearchText;
      }
      if(_category == 'Category' && _subCategory == 'Sub Category'){
        return matchesSearchText;
      }
      if(_category == 'Category' &&  _subCategory.isEmpty)
      {
        return matchesSearchText;
      }
      if(_subCategory == 'Sub Category' &&  _category.isEmpty)
      {
        return matchesSearchText;
      }
      if (_category == 'Category' && _subCategory.isNotEmpty) {
        return matchesSearchText && product.subCategory == _subCategory; // Include all products
      }
      if (_category.isNotEmpty && _subCategory == 'Sub Category') {
        return matchesSearchText && product.category == _category;// Include all products
      }
      if (_category.isEmpty && _subCategory.isNotEmpty) {
        return matchesSearchText && product.subCategory == _subCategory; // Include all products
      }
      if (_category.isNotEmpty && _subCategory.isEmpty) {
        return matchesSearchText && product.category == _category;// Include all products
      }
      return matchesSearchText &&
          (product.category == _category && product.subCategory == _subCategory);
    }).toList();

    filteredProducts.sort((a, b) => a.productName.toLowerCase().compareTo(b.productName.toLowerCase()));
    // final startIndex = (currentPage - 1) * itemsPerPage;
    // final endIndex = startIndex + itemsPerPage;
    //
    setState(() {
      currentPage = 1;
    });

  }

}



