import 'dart:html';

import 'package:btb/fifthpage/create_order.dart';
//import 'package:btb/sprint%202%20order/nextpagesample.dart';
import 'package:btb/sprint%202%20order/seventhpage%20.dart';
import 'package:btb/thirdpage/productclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import '../Product Module/Product Screen.dart';

import '../dashboard.dart';
import 'fourthpage.dart';
// import 'nextpage123.dart';



void main() {
  runApp(SelectedProductPage(selectedProducts: const [],data: const {},));
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




class SelectedProductPage extends StatefulWidget {
  // final  List<Order> selectedProducts;
  final List<Order> selectedProducts;
  final Map<String, dynamic> data;


  SelectedProductPage({
    required this.selectedProducts,
    required this.data});

  @override
  State<SelectedProductPage> createState() => _SelectedProductPageState();
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  bool isOrdersSelected = false;
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
    /// widget.selectedProducts;
    print('---selectedproducts');
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
        total: item['totalAmount'],
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



    print("Selected products in SelectedProductPage: ${widget.selectedProducts}");
    items = widget.selectedProducts.map((order) {
      return {
        'productName': order.productName,
        'category': order.category,
        'subCategory': order.subCategory,
        'price': order.price,
        'qty': order.quantity,
        'totalAmount': order.totalAmount,
      };
    }).toList();



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
        MaterialPageRoute(builder: (context) => SeventhPage(selectedProducts: updatedOrder,product: null,)), // Replace with your next page
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update order.');
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SeventhPage(selectedProducts: updatedOrder, product: null,)), // Replace with your next page
    );

  }

  void _deleteProduct(int index) {
    setState(() {
      widget.data['items'].removeAt(index);
    });
    // _calculateTotal(); // need on the last step
  }

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
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFFFFF),
            title: Image.asset("images/Final-Ikyam-Logo.png"),
            // Set background color to white
            elevation: 2.0,
            shadowColor: const Color(0xFFFFFFFF),
            // Set shadow color to black
            actions: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Handle notification icon press
                  },
                ),
              ),
              SizedBox(width: 10,),
              Align(
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
            ],
          ),
          body:
          LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Stack(
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
                                      context.go(
                                          '/dasbaord/Orderspage/placeorder/arrowback');
                                      //  Navigator.push(
                                      //      context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => NextPage(product: , data: data2, inputText: '', subText: '')),
                                      // );
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 950),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 1250, top: 80),
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
                                  width: 258,
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withOpacity(1), // Opacity is 1, fully opaque
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: data2['date'] != null
                                                  ? DateFormat('dd-MM-yyyy').format(
                                                  DateTime.parse(data2['date']))
                                                  : 'Select Date'),
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
                          padding: const EdgeInsets.only(left: 300,top: 200),
                          child: Container(
                            height:  350,
                            width: 1200,
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
                                              width: 350,
                                              child: DropdownButtonFormField<String>(
                                                value: widget.data['deliveryLocation'],
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
                                              width: 350,
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
                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Contact Person'),
                                          SizedBox(
                                            width: 350,
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
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          const Text('Contact Number'),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                            width: 350,
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
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 250,
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
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 300, top: 200),
                        //       child: DecoratedBox(
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.grey, width: 10),
                        //           borderRadius: BorderRadius.circular(20),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 5,
                        //               offset: const Offset(0, 3),
                        //             ),
                        //           ],
                        //         ),
                        //         // Left container with multiple form fields
                        //         child: Container(
                        //           width: 798,
                        //           height: 500,
                        //           decoration: const BoxDecoration(
                        //             color: Colors.white,
                        //             // Border to emphasize split
                        //           ),
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 20),
                        //                 child: Text(
                        //                   'Delivery Location',
                        //                   style: TextStyle(
                        //                       fontSize: 20, fontWeight: FontWeight.bold),
                        //                 ),
                        //               ),
                        //               Container(
                        //                 margin: const EdgeInsets.symmetric(
                        //                     vertical: 10), // Space above/below the border
                        //                 height: 1, // Border height
                        //                 color: Colors.grey, // Border color
                        //               ),
                        //               Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   const Padding(
                        //                     padding: EdgeInsets.only(left: 30, top: 10),
                        //                     child: Text(
                        //                       'Address',
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     margin: const EdgeInsets.symmetric(
                        //                         vertical:
                        //                         10), // Space above/below the border
                        //                     height: 1, // Border height
                        //                     color: Colors.grey, // Border color
                        //                   ),
                        //                 ],
                        //               ),
                        //               // First row with "Name" and "Phone"
                        //               Padding(
                        //                 padding: const EdgeInsets.all(16),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child:
                        //                             Text('Select Delivery Location'),
                        //                           ),
                        //                           const SizedBox(
                        //                             height: 10,
                        //                           ),
                        //                           SizedBox(
                        //                             height: 50,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding:
                        //                               const EdgeInsets.only(left: 30),
                        //                               child: Container(
                        //                                 decoration: BoxDecoration(
                        //                                   border: Border.all(
                        //                                       color: Colors.grey,
                        //                                       width: 1),
                        //                                   borderRadius:
                        //                                   BorderRadius.circular(5),
                        //                                 ),
                        //                                 child: DropdownButton<String>(
                        //                                   value:
                        //                                   data2['deliveryLocation'],
                        //                                   icon: const Padding(
                        //                                     padding: EdgeInsets.only(
                        //                                         left: 210),
                        //                                     child: Icon(
                        //                                         Icons.arrow_drop_down),
                        //                                   ),
                        //                                   iconSize: 24,
                        //
                        //                                   elevation: 16,
                        //
                        //                                   style: const TextStyle(
                        //                                       color: Colors.black),
                        //                                   underline: Container(),
                        //                                   // We don't need the default underline since we're using a custom border
                        //                                   onChanged: (String? value) {
                        //                                     setState(() {
                        //                                       data2['deliveryLocation'] =
                        //                                       value!;
                        //                                     });
                        //                                   },
                        //                                   items: list.map<
                        //                                       DropdownMenuItem<
                        //                                           String>>(
                        //                                           (String value) {
                        //                                         return DropdownMenuItem<
                        //                                             String>(
                        //                                           value: value,
                        //                                           child: Text(value),
                        //                                         );
                        //                                       }).toList(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     const SizedBox(width: 32),
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Contact Name'),
                        //                           ),
                        //                           const SizedBox(
                        //                             height: 10,
                        //                           ),
                        //                           SizedBox(
                        //                             height: 50,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 controller: TextEditingController(
                        //                                     text: data2['ContactName']),
                        //                                 // controller: phoneController,
                        //                                 decoration: const InputDecoration(
                        //                                   hintText: 'Contact Person Name',
                        //                                   contentPadding:
                        //                                   EdgeInsets.all(8),
                        //                                   border: OutlineInputBorder(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               // Second row with "Address Line 1" and "Fax"
                        //               Padding(
                        //                   padding:
                        //                   const EdgeInsets.only(left: 14, bottom: 20),
                        //                   child: Row(
                        //                     children: [
                        //                       SizedBox(
                        //                         width: 367, // or any other width you want
                        //                         child: Column(
                        //                           crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                           children: [
                        //                             const Padding(
                        //                               padding: EdgeInsets.only(left: 30),
                        //                               child: Text('Delivery Address'),
                        //                             ),
                        //                             const SizedBox(height: 10),
                        //                             SizedBox(
                        //                               height: 200,
                        //                               child: Padding(
                        //                                 padding: const EdgeInsets.only(
                        //                                     bottom: 15, left: 30),
                        //                                 child: TextFormField(
                        //                                   controller:
                        //                                   TextEditingController(
                        //                                       text: data2['Address']),
                        //                                   //controller: commentsController,
                        //                                   decoration:
                        //                                   const InputDecoration(
                        //                                     border: OutlineInputBorder(),
                        //                                     contentPadding:
                        //                                     EdgeInsets.symmetric(
                        //                                       horizontal: 5,
                        //                                       vertical: 30,
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(width: 16),
                        //                       Row(
                        //                         children: [
                        //                           Padding(
                        //                             padding: const EdgeInsets.only(top:1.0,left:10.0),
                        //                             child: SizedBox(
                        //                               width: 380, // or any other width you want
                        //                               child: Column(
                        //                                 crossAxisAlignment:
                        //                                 CrossAxisAlignment.stretch,
                        //                                 children: [
                        //                                   const Padding(
                        //                                     padding: EdgeInsets.only(
                        //                                         left: 30, top: 10),
                        //                                     child: Text('Contact Number'),
                        //                                   ),
                        //                                   const SizedBox(height: 10),
                        //                                   SizedBox(
                        //                                     height: 50,
                        //                                     child: Padding(
                        //                                       padding: const EdgeInsets.only(
                        //                                           bottom: 15, left: 30),
                        //                                       child: TextFormField(
                        //                                         controller:
                        //                                         TextEditingController(
                        //                                             text: data2[
                        //                                             'ContactNumber']),
                        //                                         //controller: faxController,
                        //                                         decoration:
                        //                                         const InputDecoration(
                        //                                           hintText:
                        //                                           'Contact Person Number',
                        //                                           contentPadding:
                        //                                           EdgeInsets.all(8),
                        //                                           border: OutlineInputBorder(),
                        //                                         ),
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ],
                        //                   )),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 200,left: 300,right: 80),
                        //   child: Container(
                        //     height: 350,
                        //     // padding: EdgeInsets.all(16.0),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.blue),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 30,top: 10),
                        //           child: Text(
                        //             'Delivery Location',
                        //             style: TextStyle(
                        //               fontSize: 18.0,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //         Divider(color: Colors.grey),
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.only(left: 30,bottom: 5),
                        //               child: Text(
                        //                 'Address',
                        //                 style: TextStyle(
                        //                   fontSize: 18.0,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.only(right: 350,bottom: 5),
                        //               child: Text(
                        //                 'Comments',
                        //                 style: TextStyle(
                        //                   fontSize: 18.0,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         Divider(
                        //           color: Colors.grey,
                        //           thickness: 1.0,
                        //           height: 1.0,
                        //         ),
                        //         SizedBox(height: 5.0),
                        //         Row(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Expanded(
                        //               flex: 2,
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: Text('Select Delivery Location'),
                        //                   ),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: SizedBox(
                        //                       width: 350,
                        //                       child: DropdownButtonFormField<String>(
                        //                         value: data2['deliveryLocation'],
                        //                         decoration: InputDecoration(
                        //                           filled: true,
                        //                           fillColor: Colors.grey[200],
                        //                           border: OutlineInputBorder(
                        //                             borderRadius: BorderRadius.circular(5.0),
                        //                             borderSide: BorderSide.none,
                        //                           ),
                        //                         ),
                        //                         onChanged: (String? value) {
                        //                           setState(() {
                        //                             data2['deliveryLocation'] = value!;
                        //                           });
                        //                         },
                        //                         items: list.map<DropdownMenuItem<String>>((String value) {
                        //                           return DropdownMenuItem<String>(
                        //                             value: value,
                        //                             child: Text(value),
                        //                           );
                        //                         }).toList(),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   SizedBox(height: 20.0),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: Text('Delivery Address'),
                        //                   ),
                        //                   SizedBox(height: 10,),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(left: 30),
                        //                     child: SizedBox(
                        //                       width: 350,
                        //                       child: TextField(
                        //                         controller: TextEditingController(
                        //                             text: data2['Address']),
                        //                         decoration: InputDecoration(
                        //                           filled: true,
                        //                           fillColor: Colors.grey[200],
                        //                           border: OutlineInputBorder(
                        //                             borderRadius: BorderRadius.circular(5.0),
                        //                             borderSide: BorderSide.none,
                        //                           ),
                        //                           hintText: 'Address Details',
                        //                         ),
                        //                         maxLines: 3,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(width: 30.0),
                        //             Expanded(
                        //               flex: 3,
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text('Contact Person'),
                        //                   SizedBox(
                        //                     width: 350,
                        //                     child: TextField(
                        //                       controller: TextEditingController(
                        //                           text: data2['ContactName']),
                        //                       decoration: InputDecoration(
                        //                         filled: true,
                        //                         fillColor: Colors.grey[200],
                        //                         border: OutlineInputBorder(
                        //                           borderRadius: BorderRadius.circular(5.0),
                        //                           borderSide: BorderSide.none,
                        //                         ),
                        //                         hintText: 'Contact Person Name',
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   SizedBox(height: 20.0),
                        //                   Text('Contact Number'),
                        //                   SizedBox(height: 10,),
                        //                   SizedBox(
                        //                     width: 350,
                        //                     child: TextField(
                        //                       controller: TextEditingController(
                        //                           text: data2['ContactNumber']),
                        //                       keyboardType:
                        //                       TextInputType.number,
                        //                       inputFormatters: [
                        //                         FilteringTextInputFormatter
                        //                             .digitsOnly,
                        //                         LengthLimitingTextInputFormatter(
                        //                             10),
                        //                         // limits to 10 digits
                        //                       ],
                        //                       decoration: InputDecoration(
                        //                         filled: true,
                        //                         fillColor: Colors.grey[200],
                        //                         border: OutlineInputBorder(
                        //                           borderRadius: BorderRadius.circular(5.0),
                        //                           borderSide: BorderSide.none,
                        //                         ),
                        //                         hintText: 'Contact Person Number',
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             Container(
                        //               height: 237,
                        //               width: 1,
                        //               color: Colors.grey, // Vertical line at the start
                        //               margin: EdgeInsets.zero, // Adjust margin if needed
                        //             ),
                        //             SizedBox(width: 20.0),
                        //             Expanded(
                        //               flex: 3,
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text('    '),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(right: 10),
                        //                     child: SizedBox(
                        //                       child: TextField(
                        //                         controller: TextEditingController(
                        //                             text: data2['Comments']),
                        //                         decoration: InputDecoration(
                        //                           filled: true,
                        //                           fillColor: Colors.grey[200],
                        //                           border: OutlineInputBorder(
                        //                             borderRadius: BorderRadius.circular(5.0),
                        //                             borderSide: BorderSide.none,
                        //                           ),
                        //                           hintText: 'Enter your comments',
                        //                         ),
                        //                         maxLines: 5,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Row(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 300, top: 200),
                        //       child: DecoratedBox(
                        //         decoration: BoxDecoration(
                        //           border: Border.all(color: Colors.grey, width: 10),
                        //           borderRadius: BorderRadius.circular(20),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.5),
                        //               spreadRadius: 2,
                        //               blurRadius: 5,
                        //               offset: const Offset(0, 3),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Container(
                        //           width: 798,
                        //           height: 500,
                        //           decoration: const BoxDecoration(
                        //             color: Colors.white,
                        //           ),
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 20),
                        //                 child: Text(
                        //                   'Delivery Location',
                        //                   style: TextStyle(
                        //                       fontSize: 20, fontWeight: FontWeight.bold),
                        //                 ),
                        //               ),
                        //               const Divider(color: Colors.grey, height: 20),
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 10),
                        //                 child: Text('Address'),
                        //               ),
                        //               const Divider(color: Colors.grey, height: 20),
                        //               Padding(
                        //                 padding: const EdgeInsets.all(16),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text(
                        //                                 'Select Delivery Location'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 50,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   left: 30),
                        //                               child: Container(
                        //                                 decoration: BoxDecoration(
                        //                                   border: Border.all(
                        //                                       color: Colors.grey,
                        //                                       width: 1),
                        //                                   borderRadius: BorderRadius
                        //                                       .circular(5),
                        //                                 ),
                        //                                 child: DropdownButton<String>(
                        //                                   value: data2['deliveryLocation'],
                        //                                   icon: const Padding(
                        //                                     padding: EdgeInsets.only(
                        //                                         left: 210),
                        //                                     child: Icon(
                        //                                         Icons.arrow_drop_down),
                        //                                   ),
                        //                                   iconSize: 24,
                        //                                   elevation: 16,
                        //                                   style: const TextStyle(
                        //                                       color: Colors.black),
                        //                                   underline: Container(),
                        //                                   onChanged: (String? value) {
                        //                                     setState(() {
                        //                                       data2['deliveryLocation'] =
                        //                                       value!;
                        //                                     });
                        //                                   },
                        //                                   items: list.map<
                        //                                       DropdownMenuItem<String>>((
                        //                                       String value) {
                        //                                     return DropdownMenuItem<
                        //                                         String>(
                        //                                       value: value,
                        //                                       child: Text(value),
                        //                                     );
                        //                                   }).toList(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     const SizedBox(width: 32),
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Contact Name'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 70,
                        //                             width: 400,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 controller: TextEditingController(
                        //                                     text: data2['ContactName']),
                        //                                 decoration: const InputDecoration(
                        //                                   hintText: 'Contact Person Name',
                        //                                   contentPadding: EdgeInsets.all(
                        //                                       8),
                        //                                   border: OutlineInputBorder(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Padding(
                        //                 padding: const EdgeInsets.all(16),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Delivery Address'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 150,
                        //                             // Increase the height here
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 maxLines: null,
                        //                                 // Allow the TextFormField to expand vertically
                        //                                 expands: true,
                        //                                 // Allow the TextFormField to expand vertically
                        //                                 controller: TextEditingController(
                        //                                     text: data2['Address']),
                        //                                 decoration: const InputDecoration(
                        //                                   border: OutlineInputBorder(),
                        //                                   contentPadding: EdgeInsets.all(
                        //                                       8),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     const SizedBox(width: 16),
                        //                     Expanded(
                        //                       child: Column(
                        //                         crossAxisAlignment: CrossAxisAlignment
                        //                             .start,
                        //                         children: [
                        //                           const Padding(
                        //                             padding: EdgeInsets.only(left: 30),
                        //                             child: Text('Contact Person'),
                        //                           ),
                        //                           const SizedBox(height: 10),
                        //                           SizedBox(
                        //                             height: 150,
                        //                             child: Padding(
                        //                               padding: const EdgeInsets.only(
                        //                                   bottom: 15, left: 30),
                        //                               child: TextFormField(
                        //                                 controller: TextEditingController(
                        //                                     text: data2['ContactNumber']),
                        //                                 decoration: const InputDecoration(
                        //                                   hintText: 'Contact Person Name',
                        //                                   contentPadding: EdgeInsets.all(
                        //                                       8),
                        //                                   border: OutlineInputBorder(),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 1100, top: 200),
                        //   child: DecoratedBox(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.5),
                        //           spreadRadius: 2,
                        //           blurRadius: 5,
                        //           offset: const Offset(0, 3),
                        //         ),
                        //       ],
                        //     ),
                        //     child: Container(
                        //       width: 400,
                        //       height: 500,
                        //       decoration: const BoxDecoration(
                        //         color: Colors.white,
                        //         // Border to emphasize split
                        //       ),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Padding(
                        //             padding: EdgeInsets.only(left: 30, top: 20),
                        //             child: Text(
                        //               '',
                        //               style: TextStyle(
                        //                   fontSize: 20, fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //           Container(
                        //             margin: const EdgeInsets.symmetric(
                        //                 vertical: 10), // Space above/below the border
                        //             height: 1, // Border height
                        //             color: Colors.grey, // Border color
                        //           ),
                        //           Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               const Padding(
                        //                 padding: EdgeInsets.only(left: 30, top: 10),
                        //                 child: Text(
                        //                   'Comments',
                        //                 ),
                        //               ),
                        //               Container(
                        //                 margin: const EdgeInsets.symmetric(
                        //                     vertical: 10), // Space above/below the border
                        //                 height: 1, // Border height
                        //                 color: Colors.grey, // Border color
                        //               ),
                        //             ],
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.only(
                        //                 left: 20, top: 30, right: 20),
                        //             child: Row(
                        //               children: [
                        //                 Column(
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Padding(
                        //                       padding: const EdgeInsets.only(bottom: 10),
                        //                       child: SizedBox(
                        //                         width: 350,
                        //                         height: 200,
                        //                         child: Padding(
                        //                           padding: const EdgeInsets.only(
                        //                             left: 10,
                        //                             top: 10,
                        //                             bottom: 10,
                        //                           ),
                        //                           child: TextFormField(
                        //                             controller: TextEditingController(
                        //                                 text: data2['Comments']),
                        //                             //controller: commentsController,
                        //                             decoration: const InputDecoration(
                        //                               border: OutlineInputBorder(),
                        //                               contentPadding:
                        //                               EdgeInsets.symmetric(
                        //                                 horizontal: 5,
                        //                                 vertical: 70,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [

                            Padding(

                              padding: const EdgeInsets.only(left: 350, top: 750,right: 20),

                              child: SizedBox(

                                width: 1200,

                                child: Card(

                                  color: Colors.white,

                                  child: Container(

                                    decoration: BoxDecoration(

                                      boxShadow: [

                                        BoxShadow(

                                          color: Colors.grey.withOpacity(0.5),

                                          spreadRadius: 2,

                                          blurRadius: 5,

                                          offset: const Offset(0, 3),

                                        ),

                                      ],

                                      color: Colors.white, // Container background color

                                      borderRadius: BorderRadius.circular(2),

                                    ),

                                    child: Column(

                                      mainAxisAlignment: MainAxisAlignment.start,

                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        const Padding(

                                          padding: EdgeInsets.only(left: 30, top: 10),

                                          child: Text(

                                            'Add Parts',

                                            style: TextStyle(

                                                fontSize: 20,

                                                fontWeight: FontWeight.bold,

                                                color: Colors.grey),

                                          ),

                                        ),

                                        SizedBox(height: 10,),

                                        DataTable(

                                            columns: const [

                                              DataColumn(label: Text('SN')),

                                              DataColumn(label: Text('Product Name')),

                                              DataColumn(label: Text('Category')),

                                              DataColumn(label: Text('Subcategory')),

                                              DataColumn(label: Text('Price')),

                                              DataColumn(label: Text('Quantity')),

                                              DataColumn(label: Text('Total Amount')),

                                              DataColumn(label: Text('       ')),

                                            ],



                                            rows:
                                            widget.data['items']!= null
                                                ?
                                            List.generate(
                                              widget.data['items'].length,
                                                  (index) {
                                                Map<String, dynamic> item = widget.data['items'][index];
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text('Item ${index + 1}')),
                                                    DataCell(Text(item['productName'])),
                                                    DataCell(Text(item['category'])),
                                                    DataCell(Text(item['subCategory'])),
                                                    DataCell(Text(item['price'].toString())),
                                                    DataCell(Text(item['qty'].toString())),
                                                    DataCell(Text(item['totalAmount'].toString())),
                                                    DataCell(InkWell(
                                                      onTap: (){
                                                        _deleteProduct(index);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove_circle_outline,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                    )),
                                                  ],
                                                );
                                              },
                                            )
                                                : items != null
                                                ? List.generate(
                                              widget.data['items'].length,
                                                  (index) {
                                                Map<String, dynamic> item = widget.data['items'][index];
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text('Item ${index + 1}')),
                                                    DataCell(Text(item['productName'])),
                                                    DataCell(Text(item['category'])),
                                                    DataCell(Text(item['subCategory'])),
                                                    DataCell(Text(item['price'].toString())),
                                                    DataCell(Text(item['qty'].toString())),
                                                    DataCell(Text(item['totalAmount'].toString())),
                                                    DataCell(InkWell(
                                                      onTap: (){
                                                        _deleteProduct(index);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove_circle_outline,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                    )),
                                                  ],
                                                );
                                              },
                                            )

                                                :List.generate(
                                              items.length,
                                                  (index) {
                                                Map<String, dynamic> item = items[index];
                                                return DataRow(
                                                  cells: [
                                                    DataCell(Text('Item ${index + 1}')),
                                                    DataCell(Text(item['productName'])),
                                                    DataCell(Text(item['category'])),
                                                    DataCell(Text(item['subCategory'])),
                                                    DataCell(Text(item['price'].toString())),
                                                    DataCell(Text(item['qty'].toString())),
                                                    DataCell(Text(item['totalAmount'].toString())),
                                                    DataCell(InkWell(
                                                      onTap: () {
                                                        _deleteProduct(index);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove_circle_outline,
                                                        size: 18,
                                                        color: Colors.blue,
                                                      ),
                                                    )),
                                                  ],
                                                );
                                              },
                                            )

                                        ),




                                        Padding(

                                          padding: const EdgeInsets.only(top: 10,),

                                          child: Container(

                                            // Space above/below the border

                                              height: 2, // Border height

                                              color: Colors.grey// Border color

                                          ),

                                        ),

                                        Padding(

                                          padding: const EdgeInsets.only(top: 8,left: 850,bottom: 10),

                                          child: Row(

                                            children: [

                                              SizedBox(width: 10), // add some space between the line and the text

                                              SizedBox(

                                                width: 220,

                                                child: Container(

                                                  decoration: BoxDecoration(

                                                    border: Border.all(color: Colors.blue),

                                                  ),

                                                  child: Padding(

                                                    padding: const EdgeInsets.only(

                                                      top: 10,

                                                      bottom: 10,

                                                      left: 5,

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

                                                            text: widget.data['total'],

                                                            style: const TextStyle(

                                                              color: Colors.black,

                                                            ),

                                                          )],

                                                      ),

                                                    ),

                                                  ),

                                                ),

                                              ),

                                            ],

                                          ),

                                        )

                                      ],

                                    ),

                                  ),

                                ),

                              ),

                            ),

                          ],

                        ),
                      ],
                    ),
                  ),
                );
              }
          )


      ),
    );
  }
}

