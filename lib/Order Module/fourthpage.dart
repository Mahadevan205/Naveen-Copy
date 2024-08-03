
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:btb/Order%20Module/thirdpage.dart';
import 'package:btb/widgets/productclass.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import '../screen/dashboard.dart';
import 'add productmaster sample.dart';
import 'fifthpage.dart';
import 'firstpage.dart';


class NextPage extends StatefulWidget {
  final List<Product> selectedProducts;
  final  Product product;
  final String notselect;
  final List<Product> products;
  final Map<String, dynamic> data;
  final String inputText;
  final String subText;

  const NextPage(
      {super.key,
        required this.product,
        required this.data,
        required this.inputText,
        required this.products,
        required this.notselect,
        required this.subText,
        required this.selectedProducts});

  @override
  State<NextPage> createState() => _NextPageState();
}
class _NextPageState extends State<NextPage> {


  Order productToOrder(Product product) {
    return Order(
      prodId: product.prodId,
      price: product.price,
      productName: product.productName,
      proId: product.proId,
      category: product.category,
      subCategory: product.subCategory,
      selectedVariation: product.selectedVariation,
      selectedUOM: product.selectedUOM,
      totalamount: product.totalamount,
      total: product.total,
      tax: product.tax,
      quantity: product.quantity,
      discount: product.discount,
      imageId: product.imageId,
      unit: product.unit,
      totalAmount: product.totalAmount,
      qty: product.qty,
    );
  }
  bool _isFirstTime = true;
  List<Product> products = [];
  final _scrollController = ScrollController();
  double _total = 0;
  String? dropdownValue1 = 'Filter I';
  bool isOrdersSelected = false;
  List<Product> productList = [];
  String? _selectedValue1;
  Map<String, dynamic> data2 = {};
  String? dropdownValue2 = 'Filter II';
  String token = window.sessionStorage["token"] ?? " ";
  String _searchText = '';
 // int _pageSize = 10; // Define the page size (e.g., 10 items per page)
  final String _category = '';
  final int _quantity = 0;
  final String _subCategory = '';
  List<Product> allProducts = [];
  // int startIndex = 0;
  String? _selectedValue;
  int currentPage = 1;
  Timer? _searchDebounceTimer;
  List<Product> filteredProducts = [];
  List<Product> selectedProducts = [];
  int _previousPage = 1;
 // int _currentPage = 1;
  int _startIndex = 0;
  // List<Product> productList = [];
 // int _totalPages = 1;
  List<Map<String, dynamic>> savedProducts = [];

  List<Product> _allProducts = [];
  int _currentPage = 1;
  int _totalPages = 1;
  int _pageSize = 10;


  Future<void> fetchProducts(int page, int pageSize) async {
    final response = await http.get(
      Uri.parse(
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster?page=$page&pageSize=$pageSize',
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
          final products = jsonData.map((item) => Product.fromJson(item)).toList();
          setState(() {
            _allProducts = products;
            _totalPages = (jsonData.length / pageSize).ceil();
            _updateProductList(); // Update the initial product list
          });
        } else {
          if (mounted) {
            setState(() {
              _allProducts = [];
              productList = [];
              _totalPages = 1;
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


  void _updateProductList() {
    final filteredProducts = _allProducts
        .where((product) => product.productName
        .toLowerCase()
        .contains(_searchText.toLowerCase()))
        .toList();

    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;

    setState(() {
      productList = filteredProducts
          .sublist(startIndex, endIndex > filteredProducts.length ? filteredProducts.length : endIndex);
    });
  }



  void _updateSearch(String searchText) {
    setState(() {
      _searchText = searchText;
      _currentPage = 1;  // Reset to first page when searching
      _updateProductList();
     // _clearSearch();
    });
  }


  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _updateProductList();
      });
    }
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _updateProductList();
      });
    }
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

  void initState() {
    super.initState();
    if(widget.subText == 'hii'){
      fetchProducts(_currentPage, _pageSize);
      print('hellllloo');
      print(widget.product);
      data2 = widget.data;
      data2.remove('items');
      print(data2);
      for (var product in widget.selectedProducts) {
        _addProduct(product);
      }
      // products.add(widget.product);
    }
    else if(widget.inputText == 'hello'){

       fetchProducts(_currentPage, _pageSize);
      print('ordermodule');
      data2 = widget.data;
      // _total = data2['total'];
      print(_total);

      // remove.data2['items'];
      print(data2);
      for (var product in widget.selectedProducts) {
        _addProduct(product);
        _calculateTotal();
      }
    }
    else{
      fetchProducts(_currentPage, _pageSize);
      print('--song--');
      print(widget.product);
      products.add(widget.product);
      products.addAll(widget.selectedProducts);
      print('product---');
      print(products);
      print(widget.data);
      print(widget.data['total']);
      print(widget.data['Comments']);
      print('data2');
      data2 = widget.data;
      print(data2);
      _calculateTotal();
      print('----select');
      print(widget.selectedProducts);
    }
  }

  void _addProduct(Product product) {
    setState(() {
      products.insert(0, product);
      _calculateTotal();
    });
    //_navigateToSelectedProductPage();
  }


  void _handleAddButtonPress(Product products) {
    Product newProduct = Product(
      productName: products.productName,
      category: products.category,
      subCategory: products.subCategory,
      selectedUOM: products.selectedUOM,
      selectedVariation: products.selectedVariation,
      discount: products.discount,
      proId: products.proId,
      price: products.price,
      tax: products.tax,
      unit: products.unit,
      quantity: products.quantity,
      total: products.total,
      totalamount: products.totalamount, prodId: '', imageId: '', totalAmount: products.totalAmount,
      qty: products.qty,
    );
    _addProduct(newProduct);
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      _calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                  child: IconButton(
                    icon: const Icon(Icons.account_circle),
                    onPressed: () {
                      // Handle user icon press
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
            builder: (context, constraints){
              return Stack(
                children: [
                  buildSideMenu(),
                  Positioned(
                    left: 200,
                    right: 0,
                  top: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back), // Back button icon
                                  onPressed: () {
                                    context.go('/dasbaord//OrderPage/:product/arrowBack');
                                    // product error occur so handle carefully for entering orderspage3
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const OrderPage3(data: {}, )),
                                    );
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 30,top: 10),
                                child: Text(
                                  'Go back',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 110,top: 10),
                                  child: Builder(
                                    builder: (context) {
                                      return OutlinedButton(
                                        onPressed: () {
                                          if (products.isNotEmpty && widget.inputText == '') {
                                            print('----weellls');
                                            print(selectedProducts);
                                            context.go('/Home/Orders/Create_Order/Add_Product/PlaceOrder',extra: {
                                              'selectedProducts': products,
                                              'data': data2,
                                              'select': '',

                                            });
                                            // Navigator.push(
                                            //   context,
                                            //   PageRouteBuilder(
                                            //     pageBuilder: (context, animation,
                                            //         secondaryAnimation) =>
                                            //         FifthPage(
                                            //           selectedProducts: products,
                                            //           data: data2,
                                            //           select: '',  ),
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
                                          }
                                          else
                                          {
                                            List<Order> orders = widget.selectedProducts.map((product) => product.productToOrder()).toList();
                                            print(
                                                '-------order data'
                                            );
                                            data2['total'] = _total.toString();

                                            // context.go('/Edit_Order/Add_Product_Item',extra:{
                                            //   'selectedProducts': products,
                                            //   'data': data2,
                                            // });

                                            print(orders);
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                    SelectedProductPage(
                                                      selectedProducts: products,
                                                      data: data2,),
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
                                          // print('button clicked');
                                          // _handleAddButtonPress1(selectedProducts)
                                          print('----Nothing else----');
                                          print(products);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          side: BorderSide.none,
                                        ),
                                        child: const Text(
                                          "Save Products",
                                          style: TextStyle(color: Colors.white, fontSize: 15),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:
                            0, left: 0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10), // Space above/below the border
                              height: 2,
                              // width: 1500,
                              width: constraints.maxWidth,// Border height
                              color: Colors.grey[300], // Border color
                            ),
                          ),
                          buildSearchAndTable(),
                          buildresultTable(),

                        ],
                      ),
                    ),
                  )
                ],
              );
            }
        )
    );
  }

  Widget buildMainContent() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue)
          ),
          padding: const EdgeInsets.only(top: 80),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 1111),
              buildresultTable(),
              const SizedBox(
                height: 1111,
              ),
              buildSearchField(),
              const SizedBox(height: 5),
              buildDataTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchAndTable() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child:
      Card(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 150, right: 100),
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // buildSearchField(),
            //const SizedBox(height: 5),
            //  buildDataTable(),
          ],
        ),
      ),
    );
  }

  Widget buildresultTable() {
    double maxWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(left: 50, right: 100),
            surfaceTintColor: const Color(0XFFFDFAFD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSearchField1(),
                const SizedBox(height: 1),
                //new one
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color:  Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Table(
                      // border: TableBorder.all(color: Colors.grey),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2.7),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1.8),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(2),
                        7:FlexColumnWidth(1),
                        // 8:FlexColumnWidth(2),

                      },
                      children: const [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  // left: 10,
                                  //   right: 10,
                                  top: 15,
                                  bottom: 5,
                                ),
                                child: Center(child: Text('SN',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                products.isEmpty
                    ? const Center(child: Text('No data available'))
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    return Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2.7),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1.8),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
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
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                child: Container(
                                  height: 35,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
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
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                child: Container(
                                  height: 35,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
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
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
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
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${product.price}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${product.quantity = product.quantity == 0 ? product.qty : product.quantity}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${product.total = product.total == 0 ? product.totalAmount : product.total}',
                                      // (product.price * product.quantity).toString(),
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
                                    _deleteProduct(products.indexOf(product));
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30,
                right: maxWidth *0.12),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 220,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 10,
                      right: 5,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '         ', // Add a space character
                            style: TextStyle(
                              fontSize: 10, // Set the font size to control the width of the gap
                            ),
                          ),
                          const TextSpan(
                            text: 'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const TextSpan(
                            text: '             ', // Add a space character
                            style: TextStyle(
                              fontSize: 10, // Set the font size to control the width of the gap
                            ),
                          ),
                          const TextSpan(
                            text: '₹',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: _total == 0 ? data2['total'].toString(): _total.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color:Colors.grey.shade200)
            ),
            margin: const EdgeInsets.only(left: 50, right: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSearchField(),
                const SizedBox(height: 5),
                buildDataTable(),
              ],
            ),
          ),
        ],

      ),
    );
  }

  Widget buildSearchField1() {
    return
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:const  EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Selected Products',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }

  Widget buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
             //   border: Border.all(color: Colors.green),
                color: Colors.blue.shade900,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: const Text(
                'Search Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 800,left: 30,top: 10,bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child:  SizedBox(
                  height: 40,
                  width: 350,
                  child:  TextFormField(
                    //controller: ,
                    decoration: const InputDecoration(

                      prefixIcon: Icon(Icons.search


                      ),
                      hintText: 'Search for products',
                      contentPadding:  EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border: InputBorder.none,
                    ),
    //int _previousPage = 1; // Store the previous page number
                    onChanged: _updateSearch,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }
  Widget buildDataTable() {
    double maxWidth = MediaQuery.of(context).size.width;
    return
      SizedBox(
        height: 650, // set the desired height
        width:
        maxWidth, // set the desired width// change contianer width in this place
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
    itemCount: productList.length,
         //     itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
    final product = productList[index];
                //Product product = filteredProducts[index];
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
                                  borderRadius: BorderRadius.circular(4.0)
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
                                  borderRadius: BorderRadius.circular(4.0)
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
                            padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5),
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4.0)
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
                                borderRadius: BorderRadius.circular(4.0),
                                color: Colors.grey.shade200,
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
                            padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5),
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4.0)
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
                            padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5),
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4.0)
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
                          child:  IconButton(
                            onPressed: () {
                              if (product.quantity == null || product.quantity == 0) {
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
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                _handleAddButtonPress(product);
                                _scrollController.jumpTo(0);
                                setState(() {
                                  product.quantity = 0;
                                  product.total = 0;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.add_circle_rounded,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _prevPage,
                ),
                Text('Page $_currentPage of $_totalPages'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _nextPage,
                ),
              ],
            ),
          ],
        ),
      );
    // );
  }


  Widget buildSideMenu() {
    return
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 200,
          height: 984,
          color: const Color(0xFFF7F6FA),
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {

                  // context
                  //     .go('${PageName.main}/${PageName.subpage1Main}');
                  context.go('/Add_Product/Create_Order/Orders/Home');
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
                      '/Add_Product/Create_Order/Orders/Products');
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
                  //context.go('/BeforplacingOrder/Orderspage');
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
                  context.go('/Add_Product/Create_Order/Orders/Return');
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


