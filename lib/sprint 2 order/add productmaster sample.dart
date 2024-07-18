
import 'dart:html';
import 'package:btb/screen/login.dart';
import 'package:btb/sprint%202%20order/seventhpage%20.dart';
import 'package:btb/thirdpage/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../fourthpage/orderspage order.dart';
import '../thirdpage/dashboard.dart';
import 'firstpage.dart';
import 'fourthpage.dart';
void main() {
  runApp(SelectedProductPage(selectedProducts: [],data: {},));
}
class Order {
  final String prodId;

  final String? proId;
  final String productName;
  String subCategory;
  String category;
  final String unit;
  final String tax;
  int qty;
  final String discount;
  final int price;
  String? selectedUOM;
  String? selectedVariation;
  int quantity;
  double total;
  double totalAmount;
  double totalamount;
  final String imageId;

  @override
  String toString() {
    return 'Order{productName: $productName, category: $category, subCategory: $subCategory, price: $price, qty: $qty, totalAmount: $totalAmount}';
  }

  Order({
    required this.prodId,
    required this.category,
    this.proId,
    required this.qty,
    required this.productName,
    required this.totalAmount,
    required this.subCategory,
    required this.unit,
    required this.selectedUOM,
    required this.selectedVariation,
    required this.quantity,
    required this.total,
    required this.totalamount,
    required this.tax,
    required this.discount,
    required this.price,
    required this.imageId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      prodId: json['prodId'] ?? '',
      category: json['category'] ?? '',
      productName: json['productName'] ?? '',
      subCategory: json['subCategory'] ?? '',
      unit: json['unit'] ?? '',
      tax: json['tax'] ?? '',
      totalAmount: (json['totalAmount'] is String ? double.tryParse(json['totalAmount']) : json['totalAmount']) ?? 0.0,
      qty: (json['qty'] is String ? int.tryParse(json['qty']): json['qty'] ?? 0),
      quantity: (json['quantity'] is String ? int.tryParse(json['quantity']) : json['quantity']) ?? 0,
      total: (json['totalamount'] is String ? double.tryParse(json['total']) : json['total']) ?? 0.0,
      totalamount: (json['total'] is String ? double.tryParse(json['totalamount']) : json['totalamount']) ?? 0.0,
      discount: json['discount'] ?? '',
      selectedUOM: json['uom'] ?? 'Select',
      selectedVariation: json['variation'] ?? 'Select',
      price: json['price'] ?? 0,
      imageId: json['imageId'] ?? '',
      proId: json['proId'] ?? '',
    );
  }


  Map<String, dynamic> asMap() {
    return {
      'proId': proId,
      'productName': productName,
      'category': category,
      'subCategory': subCategory,
      'price': price,
      'tax': tax,
      'unit': unit,
      'discount': discount,
      'selectedUOM': selectedUOM,
      'selectedVariation': selectedVariation,
      'quantity': quantity,
      'total': total,
      'totalamount': totalamount,
    };
  }
  Product orderToProduct() {
    return Product(
      prodId: this.prodId,
      price: this.price,
      productName: this.productName,
      proId: this.proId,
      category: this.category,
      subCategory: this.subCategory,
      selectedVariation: this.selectedVariation,
      selectedUOM: this.selectedUOM,
      totalamount: this.totalamount,
      total: this.total,
      tax: this.tax,
      quantity: this.quantity,
      discount: this.discount,
      imageId: this.imageId,
      unit: this.unit,
      totalAmount: this.totalAmount, qty: this.qty,
    );
  }

  Order productToOrder() {
    return Order(
      prodId: this.prodId,
      price: this.price,
      productName: this.productName,
      proId: this.proId,
      category: this.category,
      subCategory: this.subCategory,
      selectedVariation: this.selectedVariation,
      selectedUOM: this.selectedUOM,
      totalamount: this.totalamount,
      total: this.total,
      tax: this.tax,
      quantity: this.quantity,
      discount: this.discount,
      imageId: this.imageId,
      unit: this.unit,
      totalAmount: this.totalAmount,
      qty: this.qty,
    );
  }
}


class Orders1Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 984),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: (SelectedProductPage(selectedProducts: [],data: {},)),
        );
      },
    );
  }
}


class SelectedProductPage extends StatefulWidget {
  // final  List<Order> selectedProducts;
  final List<Product> selectedProducts;
  final Map<String, dynamic> data;


  SelectedProductPage({
    required this.selectedProducts,
    required this.data});

  @override
  State<SelectedProductPage> createState() => _SelectedProductPageState();
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  bool isOrdersSelected = false;
  double _total = 0.0;
  late List<Map<String, dynamic>> items;
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController CreatedDateController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = [];
  List<Order> selectedProducts = [];
  Map<String, dynamic> data2 = {};
  List<Order> itemdetails = [];
  List<Product> productList = []; //updated details
  //List<Map<String, dynamic>> selectedItems = [];
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController  _commentsController = TextEditingController();
  final TextEditingController  _deliveryaddressController = TextEditingController();
  final TextEditingController  _createdDateController = TextEditingController();
  late TextEditingController _dateController;
  String token = window.sessionStorage["token"]?? " ";
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  final TextEditingController ContactPersonController = TextEditingController();


  DateTime? _selectedDate;
  @override

  void initState() {
    super.initState();
    if(widget.selectedProducts.isEmpty)
    {
      print('---selectedproducts');
      print(widget.data['total']);
      // widget.data['items'] = widget.selectedProducts;
      print(widget.data);
      print(_createdDateController.text);
      print('--orderdate');
      // print(widget.data['orderDate']);
      widget.data['orderDate'];
      print(widget.data['orderDate']);
      ContactPersonController.text;
      widget.data['contactNumber'];
      widget.data['contactNumber'];
      widget.data['deliveryAddress'];
      widget.data['comments'];
      print(_contactPersonController.text);
      print(widget.data['contactNumber']);
      print(widget.data['comments']);
      print( widget.data['deliveryAddress']);
      // print(_contactPersonController.text);
      print('---contractper');
      print(_contactNumberController.text ?? '');


      if (widget.data != null && widget.data['items'] != null) {
        itemdetails = widget.data['items'].map<Order>((item) => Order(
          productName: item['productName'],
          category: item['category'],
          subCategory: item['subCategory'],
          price: item['price'],
          qty: item['qty'],
          tax: '',
          discount: '',
          selectedUOM: '',
          selectedVariation: '',
          quantity: item['qty'],
          unit: '',
          prodId: '',
          proId: '',
          total: item['totalAmount'] ?? 0.0,
          totalamount: 0.0, // Provide a default value of 0.0 if totalAmount is null
          imageId: '',
          totalAmount: 0.0,
        )).toList();

        // Convert List<Order> to List<Product>
        productList = itemdetails.map((order) => order.orderToProduct()).toList();
      }



      widget.data['orderDate'];
      print(_createdDateController.text);
      _createdDateController.text = widget.data['orderDate'] ?? '';
      _contactPersonController.text = widget.data['contactPerson'] ?? '';
      _contactNumberController.text = widget.data['contactNumber'] ?? '';
      _commentsController.text = widget.data['comments'] ?? '';
      _deliveryaddressController.text = widget.data['deliveryAddress'] ?? '';



      print("Selected products in SelectedProductPage: ${widget.selectedProducts}");
      items = widget.selectedProducts.map((order) {
        return {
          'productName': order.productName,
          'category': order.category,
          'subCategory': order.subCategory,
          'price': order.price,
          'qty': order.quantity,
          'totalAmount': order.totalAmount != null ? order.totalAmount : 0.0,
        };
      }).toList();
      print(widget.data['items']);
      _dateController = TextEditingController();
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat.yMd().format(_selectedDate!);
      _createdDateController.text = widget.data['orderDate'] ?? '';
      _contactPersonController.text = widget.data['contactPerson'] ?? '';
      _contactNumberController.text = widget.data['contactNumber'] ?? '';
      _commentsController.text = widget.data['comments'] ?? '';
      _deliveryaddressController.text = widget.data['deliveryAddress'] ?? '';

    }


    else{
      data2.remove('items');
      print('---selectedproducts');
      print('this one is else');
      print(widget.selectedProducts);
      print('---selectedproducts');
      // print(widget.selectedProducts);
      // widget.data['items'] = widget.selectedProducts;
      print(widget.data);
      print(_createdDateController.text);
      print('--orderdate');
      // print(widget.data['orderDate']);
      widget.data['orderDate'];
      print(widget.data['orderDate']);
      ContactPersonController.text;
      widget.data['contactNumber'];
      widget.data['contactNumber'];
      widget.data['deliveryAddress'];
      widget.data['comments'];
      print(_contactPersonController.text);
      print(widget.data['contactNumber']);
      print(widget.data['comments']);
      print( widget.data['deliveryAddress']);
      // print(_contactPersonController.text);
      print('---contractper');
      print(_contactNumberController.text);

      if (widget.data != null && widget.data['items'] != null) {
        itemdetails = widget.data['items'].map<Order>((item) => Order(
          productName: item['productName'],
          category: item['category'],
          subCategory: item['subCategory'],
          price: item['price'],
          qty: item['qty'],
          tax: '',
          discount: '',
          selectedUOM: '',
          selectedVariation: '',
          quantity: item['qty'],
          unit: '',
          prodId: '',
          proId: '',
          total: item['totalAmount'] ?? 0.0,
          totalamount: 0.0, // Provide a default value of 0.0 if totalAmount is null
          imageId: '',
          totalAmount: 0.0,
        )).toList();

        // Convert List<Order> to List<Product>
        productList = itemdetails.map((order) => order.orderToProduct()).toList();
      }



      widget.data['orderDate'];
      print(_createdDateController.text);
      _createdDateController.text = widget.data['orderDate'];
      _contactPersonController.text = widget.data['contactPerson'];
      _contactNumberController.text = widget.data['contactNumber'];
      _commentsController.text = widget.data['comments'];
      _deliveryaddressController.text =widget.data['deliveryAddress'];

      // data['totalAmount'] = widget.selectedProducts['total'];
      print("Selected products in SelectedProductPage: ${widget.selectedProducts}");
      widget.data['items'] = widget.selectedProducts.map((order) {
        updateTotalAmount(0);
        // widget.data['totalAmount'] = widget.selectedProducts;
        return {
          'productName': order.productName,
          'category': order.category,
          'subCategory': order.subCategory,
          'price': order.price,
          'qty': order.quantity,
          'totalAmount': order.totalAmount != 0 ? order.totalAmount : widget.data['totalAmount']

          ,
        };
      }).toList();
      print('----total');
      print(widget.data['totalAmount']);
      print(widget.data['total']);
      print(widget.data['items']);
      _dateController = TextEditingController();
      _selectedDate = DateTime.now();
      _dateController.text = DateFormat.yMd().format(_selectedDate!);
      _createdDateController.text = widget.data['orderDate'];
      _contactPersonController.text = widget.data['contactPerson'];
      _contactNumberController.text = widget.data['contactNumber'];
      _commentsController.text = widget.data['comments'];
      _deliveryaddressController.text =widget.data['deliveryAddress'];

      // widget.data['items'] = widget.selectedProducts;
    }
    /// widget.selectedProducts;
    // widget.data['items'] = widget.selectedProducts;
  }


  void _updateOrder(Map<String, dynamic> updatedOrder) async {
    final response = await http.put(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/add_update_delete_order_master'),
      headers: <String, String>{
        'Authorization': 'Bearer $token', // Replace with your API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedOrder),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(responseData['message'])),
      // );

      // Redirect to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeventhPage(selectedProducts: updatedOrder)), // Replace with your next page
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update order.');
    }
  }
  void updateTotalAmount(int productIndex) {
    if (productIndex >= 0 && productIndex < widget.selectedProducts.length) {
      double totalAmount = widget.selectedProducts[productIndex].total;
      setState(() {
        widget.data['totalAmount'] = totalAmount;
      });
    }
  }

  void _onSaveChanges() {

    final updatedOrder = {

      "orderId": widget.data['orderId'],

      "orderDate": _dateController.text,

      "deliveryLocation": widget.data['deliveryLocation'],

      "deliveryAddress": _deliveryaddressController.text,

      "contactPerson": _contactPersonController.text,

      "contactNumber": _contactNumberController.text,

      "comments": _commentsController.text,

      "total": double.parse(widget.data['total']),

      "items": widget.data['items'],

    };



    _updateOrder(updatedOrder);
    context.go('/seventhPage', extra: {'selectedProducts': updatedOrder});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SeventhPage(selectedProducts: updatedOrder)), // Replace with your next page
    );

  }

  void _deleteProduct(int index) {
    setState(() {
      widget.data['items'].removeAt(index);
      _calculateTotal();
    });
    // _calculateTotal(); // need on the last step
  }
  void _calculateTotal() {
    int total = 0;
    for (var item in widget.data['items']) {
      total += (item['price'] as int) * (item['qty'] as int);
    }
    setState(() {
      widget.data['total'] = total; // Update the total
    });
  }
  // void _calculateTotal() {
  //   double newTotal = 0.0;
  //   for (var product in widget.selectedProducts) {
  //
  //     newTotal += product.total;
  //     print(newTotal);// Add the total of each product to newTotal
  //   }
  //   setState(() {
  //     widget.data['total'] = newTotal;
  //     print('----wel');
  //     print(widget.data['total']);// Update the total in widget.data
  //   });
  // }

  @override
  void dispose() {
    _contactPersonController.dispose();
    // TODO: implement dispose
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
          body:
          LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Stack(
                    children: [
                      Align(
                        // Added Align widget for the left side menu
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 984,
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
                                  context.go('/Orderspage/placingorder/dasbaord');
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
                                      '/Orderspage/placingorder/productpage:product');
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
                                  context.go('/BeforplacingOrder/Orderspage');
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
                                    context.go('/Documents/Orderspage');
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
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(right: 100),
                                  child: OutlinedButton(
                                    onPressed: ()  {
                                      _onSaveChanges();
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
                                      'Save Changes',
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
                          height: 2,
                          // width: 1000,
                          width: constraints.maxWidth,// Border height
                          color: Colors.grey[300], // Border color
                        ),
                      ),
                      //date
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left: maxWidth* 0.81,top: 80,right: 120),
                              child: Text(('Order Date')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(left: maxWidth * 0.81, top: 10,),
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
                                                        // _showDatePicker(context);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                hintText: '        Select Date',
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
                              padding: const EdgeInsets.only(left: 310,top: 50,right: 100),
                              child: Container(
                                height:  380,
                                width: maxWidth,
                                // padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width:2),
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
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right:300),
                                          child: Text(
                                            'Comments',
                                            style: TextStyle(
                                              fontSize: 15.0,
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
                                              const SizedBox(height: 10,),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 30),
                                                child: SizedBox(
                                                  width: maxWidth * 0.8,
                                                  height: maxHeight * 0.04,
                                                  child: DropdownButtonFormField<String>(
                                                    value: widget.data['deliveryLocation'],
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.grey[200],
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      contentPadding:const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 8),
                                                    ),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        widget.data['deliveryLocation'] = value!;
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
                                                  width: maxWidth * 400,
                                                  child: TextField(
                                                    controller: _deliveryaddressController,
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
                                        const SizedBox(width: 20.0),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Contact Person'),
                                              const SizedBox(height: 10,),
                                              SizedBox(
                                                width: maxWidth * 0.2,
                                                height: maxHeight * 0.04,
                                                child: TextField(
                                                  controller:_contactPersonController,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[200],
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    hintText: 'Contact Person Name',
                                                    contentPadding:const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 8),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20.0),
                                              const Text('Contact Number'),
                                              const SizedBox(height: 10,),
                                              SizedBox(
                                                width: maxWidth * 0.2,
                                                height: maxHeight * 0.04,
                                                child: TextField(
                                                  controller: _contactNumberController,
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
                                                    contentPadding:const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 270,
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
                                                  height: maxHeight * 0.15,
                                                  child: TextField(
                                                    controller: _commentsController,
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
                              padding: const EdgeInsets.only
                                (top:50, left:310, right: 100),
                              child: Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: maxWidth*0.785,
                                  child: Container(
                                    width: maxWidth,
                                    padding: EdgeInsets.all(0.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey,width:2),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30, top: 10),
                                          child: Text(
                                            'Add Products',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 0.8),
                                        Container(
                                          width: maxWidth,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: SizedBox(
                                              height: 34,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex:1,
                                                    child: Center(
                                                      child: Text(
                                                        "SN",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        'Product Name',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "Category",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "Sub Category",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "Price",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "QTY",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "Total Amount",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 80,right: 5),
                                                    child: Center(
                                                      child: Text("  ",
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 90,right: 5),
                                                    child: Center(
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
                                          itemCount: widget.data['items']!= null? widget.data['items'].length : items!= null? items.length : 0,
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic> item = widget.data['items']!= null? widget.data['items'][index] : items[index];
                                            return Table(
                                              border: TableBorder.all(color: Colors.grey),
                                              children: [
                                                TableRow(
                                                  children: [
                                                    TableCell(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only( left: 10,
                                                            right: 10,
                                                            top: 15,
                                                            bottom: 5),
                                                        child: Center(child: Text('${index + 1}')),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                        child: Container(
                                                          height: 35,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(4.0),
                                                          ),
                                                          child: Center(child: Text(item['productName'],textAlign: TextAlign.center,)),
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
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(4.0),
                                                          ),
                                                          child: Center(child: Text(item['category'],textAlign: TextAlign.center,)),
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
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(4.0),
                                                          ),
                                                          child: Center(child: Text(item['subCategory'])),
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
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(4.0),
                                                          ),
                                                          child: Center(child: Text(item['price'].toString())),
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
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(4.0),
                                                          ),
                                                          child: Center(child: Text(item['qty'].toString())),
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
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(4.0),
                                                          ),
                                                          child: Center(child: Text(calculateTotalAmount(item).toString())),
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10, right: 10, top: 17, bottom: 5),
                                                        child: InkWell(
                                                          onTap: () {
                                                            _deleteProduct(index);
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
                                        SizedBox(height: 8.0),
                                        Padding(
                                          padding: EdgeInsets.only(left: 30),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => ProductPage123(selectedProducts: widget.data['items']),
                                              //   ),
                                              // );
                                              // print('---selecteditem');
                                              // print(selectedItems);
                                              // selectedItems.forEach((item) {
                                              //   print('productName: ${item['productName']}');
                                              //   print('orderMasterItemId: ${item['orderMasterItemId']}');
                                              //   print('category: ${item['category']}');
                                              //   print('subCategory: ${item['subCategory']}');
                                              //   print('price: ${item['price']}');
                                              //   print('qty: ${item['qty']}');
                                              //   print('totalAmount: ${item['totalAmount']}');
                                              //   print('---'); // separator between items
                                              // });
                                              Map<String, dynamic> data = {
                                                'deliveryLocation': data2['deliveryLocation'],
                                                'orderDate': CreatedDateController.text,
                                                'orderId': orderIdController.text,
                                                'contactPerson': contactPersonController.text,
                                                'deliveryAddress': deliveryAddressController.text,
                                                'contactNumber': contactNumberController.text,
                                                'comments': commentsController.text,
                                                'total': totalController.text,
                                                'items': selectedItems.map((item) => {
                                                  'productName': item['productName'],
                                                  'orderMasterItemId': item['orderMasterItemId'],
                                                  'category': item['category'],
                                                  'subCategory': item['subCategory'],
                                                  'price': item['price'],
                                                  'qty': item['qty'],
                                                  'totalAmount': item['totalAmount'],
                                                }).toList(),
                                              };
                                              //temporary unnecessary usage
                                              print('----data2 selectedprodct');
                                              print(widget.data);
                                              widget.data['items'];
                                              print('items');
                                              print(widget.data['items']);
                                              //  productList = widget.data['items'];
                                              //   print(productList);

                                              List<Product> productList = (widget.data['items'] as List)
                                                  .map((item) => Product.fromJson(item))
                                                  .toList();
                                              print('updated productlist');
                                              print(productList);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => NextPage(
                                                    product: Product(prodId: '',price: 0,productName: '',proId: '',category: '',selectedVariation: '',selectedUOM: '',subCategory: '',totalamount: 0,total: 0,tax: '',quantity: 0,discount: '',imageId: '',unit: '', totalAmount: 0.0,qty: 0), // You need to pass a Product object here
                                                    products: [], // You need to pass a list of Product objects here
                                                    data: widget.data,
                                                    selectedProducts: productList,

                                                    // widget.data['items'].map<Order>((item) => Order(
                                                    //   productName: item['productName'],
                                                    //   category: item['category'],
                                                    //   subCategory: item['subCategory'],
                                                    //   price: item['price'],
                                                    //   qty: item['qty'],
                                                    //   tax: '',
                                                    //   discount: '',
                                                    //   selectedUOM: '',
                                                    //   selectedVariation: '',
                                                    //   quantity: 0,
                                                    //   unit: '',
                                                    //   prodId: '',
                                                    //   proId: '',
                                                    //   total: 0,
                                                    //   totalamount: 0,
                                                    //   imageId: '',
                                                    //   totalAmount: item['totalAmount'],
                                                    // )).toList(),
                                                    inputText: 'hello',

                                                    // You need to pass a string here
                                                    subText: 'some_text', notselect: '', // You need to pass a string here
                                                    //selectedproducts: [],
                                                    // SelectedProducts: widget.data['items'].map<Order>((item) => Order(
                                                    //    productName: item['productName'],
                                                    //    category: item['category'],
                                                    //    subCategory: item['subCategory'],
                                                    //    price: item['price'],
                                                    //    qty: item['qty'],
                                                    //    tax: '',
                                                    //    discount: '',
                                                    //    selectedUOM: '',
                                                    //    selectedVariation: '',
                                                    //    quantity: 0,
                                                    //    unit: '',
                                                    //    prodId: '',
                                                    //    proId: '',
                                                    //    total: 0,
                                                    //    totalamount: 0,
                                                    //    imageId: '',
                                                    //    totalAmount: item['totalAmount'],
                                                    //  )).toList(),
                                                    //  selectedproducts: [],
                                                    //  selectedProducts: [],
                                                  ),
                                                ),
                                              );
                                            },
                                            // icon: Icon(Icons.add,color: Colors.white,),
                                            child: Text('+Add Products',style: TextStyle(color: Colors.white),),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(color: Colors.grey,),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 100 ,top: 10,bottom: 7),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(

                                              padding: EdgeInsets.only(left: 30,right: 30,top: 20,bottom: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.blue),
                                                borderRadius: BorderRadius.circular(8.0),
                                                color:  Colors.white,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Total',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 16.0),
                                                    Text(
                                                      widget.data['total'].toString(),
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
                                        // Padding(
                                        //   padding: const EdgeInsets.only(top: 8,left: 750,bottom: 10),
                                        //   child: Row(
                                        //     children: [
                                        //       SizedBox(width: 10), // add some space between the line and the text
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
                                        //                     text: '         ', // Add a space character
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
                                        //                     text: '             ', // Add a space character
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
                                        //                     text: widget.data['total'].toString(),
                                        //                     // text: widget.data['total'].toStringAsFixed(2),
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
                                        // )

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      // Row(
                      //
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //
                      //   children: [
                      //
                      //     Padding(
                      //
                      //       padding: const EdgeInsets.only(left: 350, top: 750,right: 20),
                      //
                      //       child: SizedBox(
                      //
                      //         width: 1200,
                      //
                      //         child: Card(
                      //
                      //           color: Colors.white,
                      //
                      //           child: Container(
                      //
                      //             decoration: BoxDecoration(
                      //
                      //               boxShadow: [
                      //
                      //                 BoxShadow(
                      //
                      //                   color: Colors.grey.withOpacity(0.5),
                      //
                      //                   spreadRadius: 2,
                      //
                      //                   blurRadius: 5,
                      //
                      //                   offset: const Offset(0, 3),
                      //
                      //                 ),
                      //
                      //               ],
                      //
                      //               color: Colors.white, // Container background color
                      //
                      //               borderRadius: BorderRadius.circular(2),
                      //
                      //             ),
                      //
                      //             child: Column(
                      //
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //
                      //               children: [
                      //
                      //                 const Padding(
                      //
                      //                   padding: EdgeInsets.only(left: 30, top: 10),
                      //
                      //                   child: Text(
                      //
                      //                     'Add Parts',
                      //
                      //                     style: TextStyle(
                      //
                      //                         fontSize: 20,
                      //
                      //                         fontWeight: FontWeight.bold,
                      //
                      //                         color: Colors.grey),
                      //
                      //                   ),
                      //
                      //                 ),
                      //
                      //                 SizedBox(height: 10,),
                      //
                      //                 DataTable(
                      //
                      //                     columns: [
                      //
                      //                       DataColumn(label: Text('SN')),
                      //
                      //                       DataColumn(label: Text('Product Name')),
                      //
                      //                       DataColumn(label: Text('Category')),
                      //
                      //                       DataColumn(label: Text('Subcategory')),
                      //
                      //                       DataColumn(label: Text('Price')),
                      //
                      //                       DataColumn(label: Text('Quantity')),
                      //
                      //                       DataColumn(label: Text('Total Amount')),
                      //
                      //                       DataColumn(label: Text('       ')),
                      //
                      //                     ],
                      //
                      //
                      //
                      //                     rows:
                      //                     widget.data['items']!= null
                      //                         ?
                      //                     List.generate(
                      //                       widget.data['items'].length,
                      //                           (index) {
                      //                         Map<String, dynamic> item = widget.data['items'][index];
                      //                         return DataRow(
                      //                           cells: [
                      //                             DataCell(Text('Item ${index + 1}')),
                      //                             DataCell(Text(item['productName'])),
                      //                             DataCell(Text(item['category'])),
                      //                             DataCell(Text(item['subCategory'])),
                      //                             DataCell(Text(item['price'].toString())),
                      //                             DataCell(Text(item['qty'].toString())),
                      //                             DataCell(Text(item['totalAmount'].toString())),
                      //                             DataCell(InkWell(
                      //                               onTap: (){
                      //                                 _deleteProduct(index);
                      //                               },
                      //                               child: const Icon(
                      //                                 Icons.remove_circle_outline,
                      //                                 size: 18,
                      //                                 color: Colors.blue,
                      //                               ),
                      //                             )),
                      //                           ],
                      //                         );
                      //                       },
                      //                     )
                      //                         : items != null
                      //                         ? List.generate(
                      //                       widget.data['items'].length,
                      //                           (index) {
                      //                         Map<String, dynamic> item = widget.data['items'][index];
                      //                         return DataRow(
                      //                           cells: [
                      //                             DataCell(Text('Item ${index + 1}')),
                      //                             DataCell(Text(item['productName'])),
                      //                             DataCell(Text(item['category'])),
                      //                             DataCell(Text(item['subCategory'])),
                      //                             DataCell(Text(item['price'].toString())),
                      //                             DataCell(Text(item['qty'].toString())),
                      //                             DataCell(Text(item['totalAmount'].toString())),
                      //                             DataCell(InkWell(
                      //                               onTap: (){
                      //                                 _deleteProduct(index);
                      //                               },
                      //                               child: const Icon(
                      //                                 Icons.remove_circle_outline,
                      //                                 size: 18,
                      //                                 color: Colors.blue,
                      //                               ),
                      //                             )),
                      //                           ],
                      //                         );
                      //                       },
                      //                     )
                      //
                      //                         :List.generate(
                      //                       items.length,
                      //                           (index) {
                      //                         Map<String, dynamic> item = items[index];
                      //                         return DataRow(
                      //                           cells: [
                      //                             DataCell(Text('Item ${index + 1}')),
                      //                             DataCell(Text(item['productName'])),
                      //                             DataCell(Text(item['category'])),
                      //                             DataCell(Text(item['subCategory'])),
                      //                             DataCell(Text(item['price'].toString())),
                      //                             DataCell(Text(item['qty'].toString())),
                      //                             DataCell(Text(item['totalAmount'].toString())),
                      //                             DataCell(InkWell(
                      //                               onTap: () {
                      //                                 _deleteProduct(index);
                      //                               },
                      //                               child: const Icon(
                      //                                 Icons.remove_circle_outline,
                      //                                 size: 18,
                      //                                 color: Colors.blue,
                      //                               ),
                      //                             )),
                      //                           ],
                      //                         );
                      //                       },
                      //                     )
                      //
                      //                 ),
                      //
                      //
                      //
                      //
                      //                 Padding(
                      //
                      //                   padding: const EdgeInsets.only(top: 10,),
                      //
                      //                   child: Container(
                      //
                      //                     // Space above/below the border
                      //
                      //                       height: 2, // Border height
                      //
                      //                       color: Colors.grey// Border color
                      //
                      //                   ),
                      //
                      //                 ),
                      //
                      //                 Padding(
                      //
                      //                   padding: const EdgeInsets.only(top: 8,left: 850,bottom: 10),
                      //
                      //                   child: Row(
                      //
                      //                     children: [
                      //
                      //                       SizedBox(width: 10), // add some space between the line and the text
                      //
                      //                       SizedBox(
                      //
                      //                         width: 220,
                      //
                      //                         child: Container(
                      //
                      //                           decoration: BoxDecoration(
                      //
                      //                             border: Border.all(color: Colors.blue),
                      //
                      //                           ),
                      //
                      //                           child: Padding(
                      //
                      //                             padding: const EdgeInsets.only(
                      //
                      //                               top: 10,
                      //
                      //                               bottom: 10,
                      //
                      //                               left: 5,
                      //
                      //                               right: 5,
                      //
                      //                             ),
                      //
                      //                             child: RichText(
                      //
                      //                               text: TextSpan(
                      //
                      //                                 children: [
                      //
                      //                                   const TextSpan(
                      //
                      //                                     text: '         ', // Add a space character
                      //
                      //                                     style: TextStyle(
                      //
                      //                                       fontSize: 10, // Set the font size to control the width of the gap
                      //
                      //                                     ),
                      //
                      //                                   ),
                      //
                      //                                   const TextSpan(
                      //
                      //                                     text: 'Total',
                      //
                      //                                     style: TextStyle(
                      //
                      //                                       fontWeight: FontWeight.bold,
                      //
                      //                                       color: Colors.blue,
                      //
                      //                                     ),
                      //
                      //                                   ),
                      //
                      //                                   const TextSpan(
                      //
                      //                                     text: '             ', // Add a space character
                      //
                      //                                     style: TextStyle(
                      //
                      //                                       fontSize: 10, // Set the font size to control the width of the gap
                      //
                      //                                     ),
                      //
                      //                                   ),
                      //
                      //                                   const TextSpan(
                      //
                      //                                     text: '₹',
                      //
                      //                                     style: TextStyle(
                      //
                      //                                       color: Colors.black,
                      //
                      //                                     ),
                      //
                      //                                   ),
                      //
                      //                                   TextSpan(
                      //
                      //                                     text: widget.data['total'],
                      //
                      //                                     style: const TextStyle(
                      //
                      //                                       color: Colors.black,
                      //
                      //                                     ),
                      //
                      //                                   )],
                      //
                      //                               ),
                      //
                      //                             ),
                      //
                      //                           ),
                      //
                      //                         ),
                      //
                      //                       ),
                      //
                      //                     ],
                      //
                      //                   ),
                      //
                      //                 )
                      //
                      //               ],
                      //
                      //             ),
                      //
                      //           ),
                      //
                      //         ),
                      //
                      //       ),
                      //
                      //     ),
                      //
                      //   ],
                      //
                      // ),
                    ],
                  ),
                );
              }
          )


      ),
    );
  }
}


double calculateTotalAmount(Map<String, dynamic> item) {
  double price = item['price'];
  int qty = item['qty'];
  double totalAmount = price * qty;
  return item['totalAmount'] = totalAmount;
}

