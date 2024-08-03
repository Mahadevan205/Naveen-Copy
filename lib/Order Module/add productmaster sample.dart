
import 'dart:html';
import 'package:btb/screen/login.dart';
import 'package:btb/Order%20Module/seventhpage%20.dart';
import 'package:btb/widgets/productclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import '../screen/dashboard.dart';
import 'firstpage.dart';
import 'fourthpage.dart';





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
    return 'Order{productName: $productName, category: $category, subCategory: $subCategory, price: $price, qty: $qty, totalAmount: $totalAmount, imageId: $imageId}';
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
      prodId: prodId,
      price: price,
      productName: productName,
      proId: proId,
      category: category,
      subCategory: subCategory,
      selectedVariation: selectedVariation,
      selectedUOM: selectedUOM,
      totalamount: totalamount,
      total: total,
      tax: tax,
      quantity: quantity,
      discount: discount,
      imageId: imageId,
      unit: unit,
      totalAmount: totalAmount, qty: qty,
    );
  }

  Order productToOrder() {
    return Order(
      prodId: prodId,
      price: price,
      productName: productName,
      proId: proId,
      category: category,
      subCategory: subCategory,
      selectedVariation: selectedVariation,
      selectedUOM: selectedUOM,
      totalamount: totalamount,
      total: total,
      tax: tax,
      quantity: quantity,
      discount: discount,
      imageId: imageId,
      unit: unit,
      totalAmount: totalAmount,
      qty: qty,
    );
  }
}




class SelectedProductPage extends StatefulWidget {
  // final  List<Order> selectedProducts;
  final List<Product> selectedProducts;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? orderDetails;


  SelectedProductPage({
    required this.selectedProducts,
    required this.data,this.orderDetails});

  @override
  State<SelectedProductPage> createState() => _SelectedProductPageState();
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  bool isOrdersSelected = false;
  double _total = 0.0;
  late List<Map<String, dynamic>> items;
  late Future<List<detail>> futureOrders;

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
  List<detail>filteredData= [];
  List<Order> itemdetails = [];
  List<Product> productList = []; //updated details
  //List<Map<String, dynamic>> selectedItems = [];
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController  _commentsController = TextEditingController();
  final TextEditingController  _deliveryaddressController = TextEditingController();
  final TextEditingController  _createdDateController = TextEditingController();
  late TextEditingController _dateController;
  List<dynamic> detailJson =[];
  String _searchText = '';
  String searchQuery = '';
  final String _category = '';
  String status= '';
  String selectDate ='';
  //String orderId = '';
  String token = window.sessionStorage["token"]?? " ";
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  final TextEditingController ContactPersonController = TextEditingController();


  DateTime? _selectedDate;
  @override

  void initState() {
    super.initState();
    print('--addproductmaster');
    futureOrders = fetchOrders() as Future<List<detail>>;
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

          return Center(child: CircularProgressIndicator());
        },
      );
    });
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

      String orderId;

      try {
        orderId = responseData['id'];

      }catch(e){
        print('Error parsing orderId: $e');
        orderId = ''; // or some default value
      }
      print('from the api response');
      print(orderId);

      // context.go('/Order_List/Documents',extra: {
      //   'selectedProducts': updatedOrder,
      //   'orderId': orderId,
      //   'orderDetails':  filteredData.map((detail) => OrderDetail(
      //     orderId: detail.orderId,
      //     orderDate: detail.orderDate,
      //     items: [],
      //     // Add other fields as needed
      //   )).toList(),
      //
      // });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SeventhPage(
          selectedProducts: updatedOrder,
          orderId: orderId,
          orderDetails:  filteredData.map((detail) => OrderDetail(
            orderId: detail.orderId,
            orderDate: detail.orderDate,
            items: [],
            // Add other fields as needed
          )).toList(),
          product: null,
        )), // Replace with your next page
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(responseData['message'])),
      // );

      // Redirect to the next page

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

      "total": double.parse(widget.data['total'].toString()),

      "items": widget.data['items'],

    };



    _updateOrder(updatedOrder);
  ///  context.go('/seventhPage', extra: {'selectedProducts': updatedOrder});

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


  @override
  void dispose() {
    _contactPersonController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                        width: screenWidth * 0.35,
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          value: widget.data['deliveryLocation'],
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
                    const SizedBox(height: 20),
                    const Padding(
                      padding:  EdgeInsets.only(left: 30),
                      child: Text('Delivery Address'),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding:  const EdgeInsets.only(left: 30),
                      child: SizedBox(
                        width: screenWidth * 0.35,
                        child: TextField(
                          controller: _deliveryaddressController,
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
                          width: screenWidth * 0.2,
                        height: 40,
                        child: TextField(
                          controller:_contactPersonController,
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
                        width: screenWidth * 0.2,
                        height: 40,
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
                            controller: _commentsController,
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
          body:
          LayoutBuilder(
              builder: (context, constraints){
                double maxHeight = constraints.maxHeight;
                double maxWidth = constraints.maxWidth;
                return Stack(
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
                                    const DashboardPage(

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
                            Container(
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
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 100),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 0, left: 0),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5), // Space above/below the border
                                height: 2,
                                // width: 1000,
                                width: constraints.maxWidth,// Border height
                                color: Colors.grey[300], // Border color
                              ),
                            ),
                            //date
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Container(
                                width: maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.only(top: 50,right: maxWidth * 0.085),
                                      child: const Text(('Order Date')),
                                    ),
                                    Padding(
                                      padding:  const EdgeInsets.only(top: 10,),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFEBF3FF), width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: const Color(0xFF418CFC)
                                          //         .withOpacity(0.16), // 0.2 * 0.8 = 0.16
                                          //     spreadRadius: 0,
                                          //     blurRadius: 6,
                                          //     offset: const Offset(0, 3),
                                          //   ),
                                          // ],
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
                                    //this is a new copy of now

                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 150,right: 100,top: 100),
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
                            buildDataTable(),
                            Padding(
                              padding: const EdgeInsets.only
                                (top:100, left:150, right: 100,bottom: 25),
                              child: SizedBox(
                                width: maxWidth*0.785,
                                child: Container(
                                  width: maxWidth,
                                  padding: const EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFB2C2D3),width:2),
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
                                      const SizedBox(height: 8),
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
                                        itemCount: widget.data['items']!= null? widget.data['items'].length : items!= null? items.length : 0,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> item = widget.data['items']!= null? widget.data['items'][index] : items[index];
                                          return Table(
                                            border: TableBorder.all(color: const Color(0xFFB2C2D3)), columnWidths: const {
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
                                      const SizedBox(height: 8.0),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print('----data2 selectedprodct');
                                            print(widget.data);
                                            //  widget.data['contactPerson']= widget.data['contactPerson'] == ''? ContactPersonController.text : widget.data['contactPerson'];
                                            widget.data['items'];
                                            print('items');
                                            print(widget.data['items']);
                                            //  productList = widget.data['items'];
                                            //   print(productList);
                                            widget.data['contactPerson'] = _contactPersonController.text;
                                            widget.data['deliveryAddress'] = _deliveryaddressController.text;
                                            widget.data['contactNumber'] = _contactNumberController.text;
                                            widget.data['comments'] = _commentsController.text;
                                            //  widget.data['total'] = widget.data['total'].toString();






                                            List<Product> productList = (widget.data['items'] as List)
                                                .map((item) => Product.fromJson(item))
                                                .toList();



                                            //data2 = data;


                                            print('updated productlist');
                                            print(productList);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => NextPage(
                                                  product: Product(prodId: '',price: 0,productName: '',proId: '',category: '',selectedVariation: '',selectedUOM: '',subCategory: '',totalamount: 0,total: 0,tax: '',quantity: 0,discount: '',imageId: '',unit: '', totalAmount: 0.0,qty: 0), // You need to pass a Product object here
                                                  products: const [], // You need to pass a list of Product objects here
                                                  data: widget.data,
                                                  selectedProducts: productList,
                                                  inputText: 'hello',

                                                  // You need to pass a string here
                                                  subText: 'some_text', notselect: '',
                                                ),
                                              ),
                                            );
                                          },
                                          // icon: Icon(Icons.add,color: Colors.white,),
                                          child: const Text('+Add Products',style: TextStyle(color: Colors.white),),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(color: Color(0xFFB2C2D3),),
                                      Padding(
                                        padding: const EdgeInsets.only(top:9,bottom: 9),
                                        child: Align(
                                          alignment: const Alignment(0.74,0.8),
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.only(left: 15,right: 10,top: 2,bottom: 2),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.blue),
                                              borderRadius: BorderRadius.circular(3),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 15,top: 5,left: 10,right: 10),
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
                                                        widget.data['total'].toString(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
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
}



double calculateTotalAmount(Map<String, dynamic> item) {
  double price = item['price'];
  int qty = item['qty'];
  double totalAmount = price * qty;
  return item['totalAmount'] = totalAmount;
}

