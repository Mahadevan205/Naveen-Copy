import 'dart:html';

import 'package:btb/sprint%202%20order/add%20productmaster%20sample.dart';
import 'package:btb/sprint%202%20order/eighthpage.dart';
import 'package:btb/sprint%202%20order/seventhpage%20.dart';
import 'package:flutter/cupertino.dart';
//import 'package:btb/sprint%202%20order/seventh%20page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import '../fifthpage/sample.dart';
import '../fourthpage/orderspage order.dart';
import '../screen/login.dart';
import '../thirdpage/dashboard.dart';
import '../thirdpage/productclass.dart';
import 'firstpage.dart';
import 'orderspage first.dart' as ord;

void main(){
  runApp(
      MaterialApp(
          home: SixthPage(product: detail(orderId: '', orderDate: '', total: 0, status: '', deliveryStatus: '', referenceNumber: '', items: []),
          )));

}




class SixthPage extends StatefulWidget {
  final detail? product;
  final List<Map<String, dynamic>>? item;
  final Map<String, dynamic>? body;
  final List<Map<String, dynamic>>? itemsList;
// final detail product;
// final List<Map<String, dynamic>> item;

  const SixthPage({super.key, required this.product, this.item, this.body, this.itemsList});

  // final detail product;
  //
  // const SixthPage({super.key, required this.product});




  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String token = window.sessionStorage["token"] ?? " ";
  final _orderIdController = TextEditingController();
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  Map<String, dynamic> data2 = {};
  List<Map> _orders = [];
  bool _loading = false;
  bool isEditing = false;
  final TextEditingController deliveryLocationController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = [];
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
  bool? _isChecked1 = true;
  detail _selectedOrder = detail(orderId: '',
      total: 0,
      deliveryStatus: '',
      status: '',
      orderDate: '',
      referenceNumber: '',
      items: []);
  bool? _isChecked2 = false;
  int selectedIndex = -1;
  int _selectedIndex = -1;

  late TextEditingController _dateController;
  bool? _isChecked3 = false;
  bool? _isChecked4 = false;
  final TextEditingController totalAmountController = TextEditingController();
  bool isOrdersSelected = false;
  String _errorMessage = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchOrders();
  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   //    final args = ModalRoute.of(context)?.settings.arguments as int?;
  //   //    if (args != null) {
  //   //        setState(() {
  //   //         _selectedIndex = args;
  //   //       });
  //   //   }
  //   //   });
  //   _selectedOrder = widget.product!;
  //   print(_selectedOrder);
  //   print('-----selectorder');
  //   _orderIdController.addListener(_fetchOrders);
  //   _dateController = TextEditingController();
  //
  //
  //   _selectedDate = DateTime.now();
  //   _dateController.text = DateFormat.yMd().format(_selectedDate!);
  // }


  @override
  void initState() {
    super.initState();

    _orderIdController.addListener(() {
      _fetchOrders();
    });
    // loadData();
    //  init();
    print('--ordermodule data sixthpage');

    // _orderModel.loadData();
    // Provider.of<OrderProvider>(context, listen: false).init();
    _fetchOrders();


    // Consumer<OrderProvider>(
    //   builder: (context, orderProvider, child) {
    //     return Column(
    //       children: [
    //         Text('Product1: ${orderProvider.orderModel.product}'),
    //         Text('Item: ${orderProvider.orderModel.item}'),
    //         Text('Body: ${orderProvider.orderModel.body}'),
    //         Text('Items List: ${orderProvider.orderModel.itemsList}'),
    //       ],
    //     );
    //   },
    // );

    orderIdController.text = widget.product!.orderId ?? '';

// Assuming widget.product!.items is a list of items
    List<dynamic> items = widget.product!.items;

// Iterate over the items list


    if (widget.product != null) {
      //data2['deliveryLocation'] = widget.product.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          orderIdController.text = widget.product!.orderId ?? '';
          print('orderIdController.text');
          print(orderIdController.text);
          totalController.text = widget.product!.total.toString() ?? '';
          deliveryAddressController.text = widget.product!.deliveryAddress! ?? '';
          contactPersonController.text = widget.product!.contactPerson! ?? '';
          contactNumberController.text = widget.product!.contactNumber! ?? '';
          commentsController.text = widget.product!.comments! ?? '';
          data2['deliveryLocation'] = widget.product!.deliveryLocation! ?? '';
         // widget.product!.items = widget.body[it];

          displayItemDetails();
        });
      });


      _selectedOrder = widget.product!;
      print(_selectedOrder);
      print('-----selectorder');
    } else {
      print('Product is null');
    //  deliveryAddressController.text = widget.product!.deliveryAddress! ?? '';

//
//    _selectedOrder = widget.product!;
//
//   _selectedOrder = _selectedOrder;
//    print(_selectedOrder);

    }


    if (widget.body != null) {
      print('Body: ${widget.body}');
      print('Items List: ${widget.itemsList}');
      print('Order Date: ${widget.body?['orderDate']}');
      print('Delivery Location: ${widget.body?['deliveryLocation']}');
      print('Delivery Address: ${widget.body?['deliveryAddress']}');
      print('Contact Person: ${widget.body?['contactPerson']}');
      print('Contact Number: ${widget.body?['contactNumber']}');
      print('Comments: ${widget.body?['comments']}');
      print('Total: ${widget.body?['total']}');
      print('id: ${widget.body?['id']}');

      for (var item in items) {
        if (item['orderId'] == orderIdController.text) {
          print('Order Master Id: ${item['orderMasterItemId']}');
        }
      }

      if (widget.body?['items'] != null) {
        for (var item in widget.body?['items']) {

          print('  Product Name: ${item['productName']}');
          print(' OrderMasterId: ${item['orderMasterItemId']}');
          print('  Category: ${item['category']}');
          print('  Sub Category: ${item['subCategory']}');
          print('  Price: ${item['price'].toString()}');
          print('  Qty: ${item['qty'].toString()}');
          print('  Total Amount: ${item['totalAmount'].toString()}');
          print(''); // empty line for separation
          selectedItems = List.from(widget.body?['items']);
        }
      } else {
        print('No items');
      }

      if (widget.body != null) {
        deliveryAddressController.text = widget.body?['deliveryAddress'] ?? '';
        data2['deliveryLocation'] = widget.body?['deliveryLocation'] ?? [];
        contactPersonController.text = widget.body?['contactPerson'] ?? '';
        contactNumberController.text = widget.body?['contactNumber'] ?? '';
        commentsController.text = widget.body?['comments'] ?? '';
        CreatedDateController.text = widget.body?['orderDate'] ?? '';
        totalController.text = widget.body?['total'] ?? '';
        widget.body?['orderId'];
      }
    } else {
      print('Body is null');
    }

    if (widget.product != null) {
      _selectedOrder = widget.product!;
    } else {
      print('Error: Product is null');
      // You can also show a error message to the user
      // For example:
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: Product is null')),
      // );
    }

    if (widget.itemsList != null) {
      // access widget.itemsList here
    } else {
      print('ItemsList is null');
    }
    _dateController = TextEditingController();

    _selectedDate = DateTime.now();
    _dateController.text = DateFormat.yMd().format(_selectedDate!) ?? '';
  }

  @override
  void dispose() {
    _orderIdController.removeListener(_fetchOrders);
    _dateController.dispose();

    super.dispose();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _loading = true;
      _orders = []; // clear the orders list
      _errorMessage = ''; // clear the error message
    });
    try {
      final orderId = _orderIdController.text
          .trim(); // trim to remove whitespace
      final url = orderId.isEmpty
          ? 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster'
          : 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Replace with your API key
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody != null) {
          final jsonData = jsonDecode(responseBody).cast<
              Map<dynamic, dynamic>>();
          setState(() {
            _orders =
                jsonData; // update _orders with all orders or search results
            _errorMessage = ''; // clear the error message
          });
        } else {
          setState(() {
            _orders = []; // clear the orders list
            _errorMessage = 'Failed to load orders';
          });
        }
      } else {
        setState(() {
          _orders = []; // clear the orders list
          _errorMessage = 'Failed to load orders';
        });
      }
    } catch (e) {
      setState(() {
        _orders = []; // clear the orders list
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Future<void> _fetchOrders() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _loading = true;
  //       _orders = []; // clear the orders list
  //       _errorMessage = ''; // clear the error message
  //     });
  //     final orderId = _orderIdController.text.trim(); // trim to remove whitespace
  //     if (orderId.isEmpty) {
  //       setState(() {
  //         _loading = false;
  //         _errorMessage = 'No product found'; // show no product found message
  //       });
  //       return; // exit the function early
  //     }
  //     try {
  //       final response = await http.get(
  //         Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId'),
  //         headers: {
  //           'Authorization': 'Bearer $token', // Replace with your API key
  //           'Content-Type': 'application/json',
  //         },
  //       );
  //       if (response.statusCode == 200) {
  //         final responseBody = response.body;
  //         if (responseBody!= null) {
  //           final jsonData = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
  //           setState(() {
  //             _orders = jsonData;
  //             _errorMessage = ''; // clear the error message
  //           });
  //         } else {
  //           setState(() {
  //             _orders = []; // clear the orders list
  //             _errorMessage = 'Failed to load orders';
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           _orders = []; // clear the orders list
  //           _errorMessage = 'Failed to load orders';
  //         });
  //       }
  //     } catch (e) {
  //       setState(() {
  //         _orders = []; // clear the orders list
  //         _errorMessage = 'Error: $e';
  //       });
  //     } finally {
  //       setState(() {
  //         _loading = false;
  //       });
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TableRow row1 = TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
            child: Text('Delivery Location'),
          ),
        ),

        TableCell(
          child: Row(
            children: [
              Spacer(),
              const Text(
                'Order Date',
                style: TextStyle(
                  //    fontSize: 16,// fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 35,
                  width: 175,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    enabled: isEditing,
                    controller: CreatedDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          iconSize: 20,
                          onPressed: () {
                            _showDatePicker(context);
                          },
                        ),
                      ),
                      hintText: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : 'Select Date',
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      border: InputBorder.none,
                      filled: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    TableRow row2 = TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
            child: Text('Address'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
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
                    Padding(
                      padding:  EdgeInsets.only(left: 30,top: 10),
                      child: Text('Select Delivery Location'),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding:  EdgeInsets.only(left: 30),
                      child: SizedBox(
                        width: screenWidth * 0.35,
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          value: data2['deliveryLocation'] != null &&
                              list.contains(data2['deliveryLocation'])
                              ? data2['deliveryLocation']
                              : null,
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
                              enabled: isEditing,
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          isExpanded: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding:  EdgeInsets.only(left: 30),
                      child: Text('Delivery Address'),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding:  EdgeInsets.only(left: 30),
                      child: SizedBox(
                        width: screenWidth * 0.35,
                        child: TextField(
                          enabled: isEditing,
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
              SizedBox(width: 30),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: const Text('Contact Person'),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: screenWidth * 0.2,
                        height: 40,
                        child: TextField(
                          enabled: isEditing,
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
                    SizedBox(height: 20),
                    const Text('Contact Number'),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: screenWidth * 0.2,
                        height: 40,
                        child: TextField(
                          enabled: isEditing,
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
                          enabled: isEditing,
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
          ),
        ),
      ],
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
              return  SingleChildScrollView(
                child: Stack(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 200,
                        height: 1150,
                        color: const Color(0xFFF7F6FA),
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                // setState(() {
                                //   isOrdersSelected = false;
                                //   // Handle button press19
                                // });
                              },
                              icon: Icon(Icons.warehouse,
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
                        padding: const EdgeInsets.only(
                          left: 200,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                const Icon(Icons.arrow_back), // Back button icon
                                onPressed: () {
                                  context.go('/Documents/Orderspage');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Orderspage()),
                                  );
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  'Order List',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Map<String, dynamic> data = {
                                      'deliveryLocation': data2['deliveryLocation'],
                                      'orderDate': CreatedDateController.text,
                                      'orderId': orderIdController.text,
                                      'contactPerson': contactPersonController.text,
                                      'deliveryAddress': deliveryAddressController
                                          .text,
                                      'contactNumber': contactNumberController.text,
                                      'comments': commentsController.text,
                                      'total': totalController.text,
                                      'items': selectedItems.map((item) =>
                                      {
                                        'productName': item['productName'],
                                        'orderMasterItemId': item['orderMasterItemId'],
                                        'category': item['category'],
                                        'subCategory': item['subCategory'],
                                        'price': item['price'],
                                        'qty': item['qty'],
                                        'totalAmount': item['totalAmount'],
                                      }).toList(),
                                    };
                                    print('sixthpage from');
                                    print(data);
                                    context.go('/Edit_Order', extra: data);
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                            SelectedProductPage(
                                              data: data, selectedProducts: [],),
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
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                    Colors.white, // Button background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(5),
                                      // Rounded corners
                                    ),
                                    // side: BorderSide.none,
                                    // No outline
                                  ),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 100),
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EighthPage()),
                                    );
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
                                    'Documents',
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
                      padding: const EdgeInsets.only(top: 0, left: 495),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10), // Space above/below the border
                        height: 1200,
                        // width: 1500,
                        width: 2,// Border height
                        color: Colors.grey[300], // Border color
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
                    Container(
                      margin: const EdgeInsets.only(
                        top: 60,
                        left:200,
                      ),
                      width: 300,
                      height: 1100,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 5),
                                  child: TextFormField(
                                    controller: _orderIdController,
                                    // Assign the controller to the TextFormField
                                    decoration: const InputDecoration(
                                      // labelText: 'Order ID',
                                      hintText: 'Search Order',
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.search_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 1),
                              Column(
                                children: [
                                  _loading
                                      ? Center(child: CircularProgressIndicator(
                                      value: _loading ? null : 0, strokeWidth: 4))
                                      : _errorMessage.isNotEmpty
                                      ? Center(child: Text(_errorMessage))
                                      : _orders.isEmpty
                                      ? Center(child: Text('No product found'))
                                      : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: _orders.length,
                                    itemBuilder: (context, index) {
                                      final order = _orders[index];
                                      return GestureDetector(
                                        onTap: () {
                                          _showProductDetails(index);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: _selectedOrder?.orderId ==
                                                order['orderId']
                                                ? Colors.lightBlue[200]
                                                : Colors.white,
                                          ),
                                          child: ListTile(
                                            title: Text('Order #${order['orderId']}'),
                                            subtitle: Text(
                                                'Order Date: ${order['orderDate']}'),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                  ),
                                  //corrected code for coming in the first place
                                  // _loading
                                  //     ? Center(child: CircularProgressIndicator(
                                  //     value: _loading? null : 0, strokeWidth: 4))
                                  //     : _errorMessage.isNotEmpty
                                  //     ? Center(child: Text(_errorMessage))
                                  //     : _orders.isEmpty
                                  //     ? Center(child: Text('No product found'))
                                  //     : ListView.separated(
                                  //   shrinkWrap: true,
                                  //   itemCount: _orders.length,
                                  //   itemBuilder: (context, index) {
                                  //     final order = _orders[index];
                                  //     bool isSelected = _selectedOrder.orderId == order['orderId'];
                                  //     return GestureDetector(
                                  //       onTap: () {
                                  //         setState(() {
                                  //           _orders.remove(order);
                                  //           _orders.insert(0, order);
                                  //           _selectedOrder = order as detail;
                                  //         });
                                  //         _showProductDetails(index);
                                  //       },
                                  //       child: AnimatedContainer(
                                  //         duration: Duration(milliseconds: 500),
                                  //         decoration: BoxDecoration(
                                  //           color: isSelected
                                  //               ? Colors.lightBlue[200]
                                  //               : Colors.white,
                                  //         ),
                                  //         child: ListTile(
                                  //           title: Text('Order #${order['orderId']}'),
                                  //           subtitle: Text('Order Date: ${order['orderDate']}'),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  //   separatorBuilder: (context, index) {
                                  //     return const Divider();
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                    
                          ),
                        ),
                      ),
                    
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 43, left: 200),
                    //   child: Container(
                    //     margin: const EdgeInsets.symmetric(
                    //         horizontal: 10), // Space above/below the border
                    //     height: 3, // Border height
                    //     color: Colors.grey[100], // Border color
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 550, top: 100,right: 120),
                      child: Container(
                        height: 100,
                        width: maxWidth,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB2C2D3), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_box,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      'Order Placed',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_box,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Invoice',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_box,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Payments',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_box,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Delivery',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 550,right: 120,top: 250),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB2C2D3)),
                          borderRadius: BorderRadius.circular(3.5), // Set border radius here
                        ),
                        child: Table(
                          border: TableBorder.all(color: Color(0xFFB2C2D3)),

                          columnWidths: {
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
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 550,top:250,right: 120),
                    //   child: Container(
                    //     height: 400,
                    //     width: maxWidth * 0.8,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey, width: 2),
                    //       borderRadius: BorderRadius.circular(8.0),
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(left:20),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               const Text(
                    //                 'Delivery Location',
                    //                 style: TextStyle(
                    //                   fontSize: 18.0,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   const Text(
                    //                     'Order Date',
                    //                     style: TextStyle(
                    //                       fontSize: 16,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                   SizedBox(width: 5),
                    //                   DecoratedBox(
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
                    //                       borderRadius: BorderRadius.circular(10),
                    //                     ),
                    //                     child: Container(
                    //                       height: 39,
                    //                       width: 175,
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.white.withOpacity(1),
                    //                         borderRadius: BorderRadius.circular(4),
                    //                       ),
                    //                       child: TextFormField(
                    //                         enabled: isEditing,
                    //                         controller: CreatedDateController,
                    //                         readOnly: true,
                    //                         decoration: InputDecoration(
                    //                           suffixIcon: Padding(
                    //                             padding: const EdgeInsets.only(right: 20),
                    //                             child: IconButton(
                    //                               icon: const Icon(Icons.calendar_month),
                    //                               iconSize: 20,
                    //                               onPressed: () {
                    //                                 _showDatePicker(context);
                    //                               },
                    //                             ),
                    //                           ),
                    //                           hintText: _selectedDate != null
                    //                               ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    //                               : 'Select Date',
                    //                           fillColor: Colors.white,
                    //                           contentPadding: const EdgeInsets.symmetric(
                    //                               horizontal: 8, vertical: 8),
                    //                           border: InputBorder.none,
                    //                           filled: true,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         const Divider(color: Colors.grey),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Padding(
                    //               padding: EdgeInsets.only(left: 20),
                    //               child: Text(
                    //                 'Address',
                    //                 style: TextStyle(
                    //                   fontSize: 15.0,
                    //                 ),
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: EdgeInsets.only(right: maxWidth * 0.16),
                    //               child: Text(
                    //                 'Comments',
                    //                 style: TextStyle(
                    //                   fontSize: 15.0,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         const Divider(
                    //           color: Colors.grey,
                    //           thickness: 1.0,
                    //           height: 1.0,
                    //         ),
                    //         const SizedBox(height: 5.0),
                    //         Row(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Expanded(
                    //               flex: 2,
                    //               child: Padding(
                    //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //                 child: Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     const Text('Select Delivery Location'),
                    //                     const SizedBox(height: 10),
                    //                     SizedBox(
                    //                       width: 450,
                    //                       height: 40,
                    //                       child: DropdownButtonFormField<String>(
                    //                         value: data2['deliveryLocation'] != null &&
                    //                             list.contains(data2['deliveryLocation'])
                    //                             ? data2['deliveryLocation']
                    //                             : null,
                    //                         decoration: InputDecoration(
                    //                           enabled: isEditing,
                    //                           filled: true,
                    //                           fillColor: Colors.grey[200],
                    //                           border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(5.0),
                    //                             borderSide: BorderSide.none,
                    //                           ),
                    //                           contentPadding: const EdgeInsets.symmetric(
                    //                               horizontal: 8, vertical: 8),
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
                    //                         isExpanded: true,
                    //                       ),
                    //                     ),
                    //                     const SizedBox(height: 20.0),
                    //                     const Text('Delivery Address'),
                    //                     const SizedBox(height: 10),
                    //                     SizedBox(
                    //                       width: maxWidth * 0.2,
                    //                       child: TextField(
                    //                         enabled: isEditing,
                    //                         controller: deliveryAddressController,
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
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //             const SizedBox(width: 20.0),
                    //             Expanded(
                    //               flex: 3,
                    //               child: Padding(
                    //                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //                 child: Column(
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     const Text('Contact Person'),
                    //                     const SizedBox(height: 10),
                    //                     SizedBox(
                    //                       width: maxWidth * 0.2,
                    //                       height: 40,
                    //                       child: TextField(
                    //                         enabled: isEditing,
                    //                         controller: contactPersonController,
                    //                         decoration: InputDecoration(
                    //                           filled: true,
                    //                           fillColor: Colors.grey[200],
                    //                           border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(5.0),
                    //                             borderSide: BorderSide.none,
                    //                           ),
                    //                           hintText: 'Contact Person Name',
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     const SizedBox(height: 24.0),
                    //                     const Text('Contact Number'),
                    //                     const SizedBox(height: 10),
                    //                     SizedBox(
                    //                       width: maxWidth * 0.2,
                    //                       height: 40,
                    //                       child: TextField(
                    //                         enabled: isEditing,
                    //                         controller: contactNumberController,
                    //                         keyboardType: TextInputType.number,
                    //                         inputFormatters: [
                    //                           FilteringTextInputFormatter.digitsOnly,
                    //                           LengthLimitingTextInputFormatter(10),
                    //                         ],
                    //                         decoration: InputDecoration(
                    //                           filled: true,
                    //                           fillColor: Colors.grey[200],
                    //                           border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(5.0),
                    //                             borderSide: BorderSide.none,
                    //                           ),
                    //                           hintText: 'Contact Person Number',
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //             Container(
                    //               height: 243,
                    //               width: 1,
                    //               color: Colors.grey,
                    //               margin: EdgeInsets.zero,
                    //             ),
                    //             const SizedBox(width: 20.0),
                    //             Expanded(
                    //               flex: 3,
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text('    '),
                    //                   SizedBox(
                    //                     width: maxWidth * 0.22,
                    //                     child: TextField(
                    //                       enabled: isEditing,
                    //                       controller: commentsController,
                    //                       decoration: InputDecoration(
                    //                         filled: true,
                    //                         fillColor: Colors.grey[200],
                    //                         border: OutlineInputBorder(
                    //                           borderRadius: BorderRadius.circular(5.0),
                    //                           borderSide: BorderSide.none,
                    //                         ),
                    //                         hintText: 'Enter your comments',
                    //                       ),
                    //                       maxLines: 5,
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
                    //maha copy
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 240, left: 550, right: 20),
                    //   child: Container(
                    //     height: 350,
                    //     width: 900,
                    //     // padding: EdgeInsets.all(16.0),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey, width: 2),
                    //       borderRadius: BorderRadius.circular(8.0),
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         const Padding(
                    //           padding: const EdgeInsets.only(left: 30, top: 10),
                    //           child: Text(
                    //             'Delivery Location',
                    //             style: TextStyle(
                    //               fontSize: 18.0,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //
                    //         const Divider(color: Colors.grey),
                    //         const Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Padding(
                    //               padding: EdgeInsets.only(left: 30, bottom: 5),
                    //               child: Text(
                    //                 'Address',
                    //                 style: TextStyle(
                    //                   fontSize: 15.0,
                    //                   // fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: EdgeInsets.only(right: 250),
                    //               child: Text(
                    //                 'Comments',
                    //                 style: TextStyle(
                    //                   fontSize: 15.0,
                    //                   // fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         const Divider(
                    //           color: Colors.grey,
                    //           thickness: 1.0,
                    //           height: 1.0,
                    //         ),
                    //         const SizedBox(height: 5.0),
                    //         Row(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Expanded(
                    //               flex: 2,
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Padding(
                    //                     padding: const EdgeInsets.only(left: 30),
                    //                     child: Text('Select Delivery Location'),
                    //                   ),
                    //                   const SizedBox(height: 10,),
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(
                    //                         left: 30, bottom: 5),
                    //                     child: SizedBox(
                    //                       width: 350,
                    //                       height: 40,
                    //                       child: DropdownButtonFormField<String>(
                    //                         value: data2['deliveryLocation'] !=
                    //                             null && list.contains(
                    //                             data2['deliveryLocation'])
                    //                             ? data2['deliveryLocation']
                    //                             : null,
                    //                         decoration: InputDecoration(
                    //                           enabled: isEditing,
                    //                           filled: true,
                    //                           fillColor: Colors.grey[200],
                    //                           border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(
                    //                                 5.0),
                    //                             borderSide: BorderSide.none,
                    //                           ),
                    //                           contentPadding: const EdgeInsets
                    //                               .symmetric(
                    //                               horizontal: 8, vertical: 8),
                    //                         ),
                    //                         onChanged: (String? value) {
                    //                           setState(() {
                    //                             data2['deliveryLocation'] = value!;
                    //                           });
                    //                         },
                    //                         items: list.map<
                    //                             DropdownMenuItem<String>>((
                    //                             String value) {
                    //                           return DropdownMenuItem<String>(
                    //                             value: value,
                    //                             child: Text(value),
                    //                           );
                    //                         }).toList(),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const SizedBox(height: 20.0),
                    //                   const Padding(
                    //                     padding: EdgeInsets.only(left: 30),
                    //                     child: Text('Delivery Address'),
                    //                   ),
                    //                   const SizedBox(height: 10,),
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(left: 30),
                    //                     child: SizedBox(
                    //                       width: 350,
                    //                       child: TextField(
                    //                         enabled: isEditing,
                    //                         controller: deliveryAddressController,
                    //                         decoration: InputDecoration(
                    //                           filled: true,
                    //                           fillColor: Colors.grey[200],
                    //                           border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(
                    //                                 5.0),
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
                    //             const SizedBox(width: 30.0),
                    //
                    //             Expanded(
                    //               flex: 3,
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text('Contact Person'),
                    //                   const SizedBox(height: 10,),
                    //                   SizedBox(
                    //                     width: 270,
                    //                     height: 40,
                    //                     child: TextField(
                    //                       enabled: isEditing,
                    //                       controller: contactPersonController,
                    //                       decoration: InputDecoration(
                    //                         filled: true,
                    //                         fillColor: Colors.grey[200],
                    //                         border: OutlineInputBorder(
                    //                           borderRadius: BorderRadius.circular(
                    //                               5.0),
                    //                           borderSide: BorderSide.none,
                    //                         ),
                    //                         hintText: 'Contact Person Name',
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const SizedBox(height: 24.0),
                    //                   const Text('Contact Number'),
                    //                   const SizedBox(height: 10,),
                    //                   SizedBox(
                    //                     width: 270,
                    //                     height: 40,
                    //                     child: TextField(
                    //                       enabled: isEditing,
                    //                       controller: contactNumberController,
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
                    //                           borderRadius: BorderRadius.circular(
                    //                               5.0),
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
                    //               height: 243,
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
                    //                         enabled: isEditing,
                    //                         controller: commentsController,
                    //                         decoration: InputDecoration(
                    //                           filled: true,
                    //                           fillColor: Colors.grey[200],
                    //                           border: OutlineInputBorder(
                    //                             borderRadius: BorderRadius.circular(
                    //                                 5.0),
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
                    Padding(
                      padding:  EdgeInsets.only(left: 550, top: 700,right: 120),
                      child: Container(
                        // height: 150,
                        width: maxWidth,
                        //   padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB2C2D3), width:
                          2),
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
                            Container(
                              width: maxWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFB2C2D3)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Table(
                                  columnWidths: {
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
                                            padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedItems.length,
                              itemBuilder: (context, index) {
                                var item = selectedItems[index];
                                // int index = selectedItems.indexOf(item) + 1;
                                return Table(
                                  border: TableBorder.all(
                                      color: Color(0xFFB2C2D3)),
                                  // Add this line
                                  columnWidths: {
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
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 10),
                                            child: Center(
                                              child: Text(
                                                ' ${index + 1}',
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
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item['productName'],
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
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item['category'],
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
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item['subCategory'],
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
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item['price'].toString(),
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
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item['qty'].toString(),
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
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item['totalAmount']
                                                      .toString(),
                                                  textAlign: TextAlign
                                                      .center,
                                                ),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 9,bottom: 9),
                              child: Align(
                                alignment: Alignment(0.9,0.8),
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 15,right: 10,top: 2,bottom: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(2.0),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RichText(text:
                                        TextSpan(
                                          children: [
                                            TextSpan(
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
                                              totalController.text,
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
                            // const Divider(color: Colors.grey,),
                            // Padding(
                            //   padding: EdgeInsets.only(top: 20,left: maxWidth * 0.2 ,right: maxWidth * 0.2),
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //         child: Container(
                            //   width: maxWidth * 0.25,
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
                            //                     text: 'Total',
                            //                     style: TextStyle(
                            //                       fontWeight: FontWeight.bold,
                            //                       color: Colors.blue,
                            //                     ),
                            //                   ),
                            //                   const TextSpan(
                            //                     text: '  ₹',
                            //                     style: TextStyle(
                            //                       color: Colors.black,
                            //                     ),
                            //                   ),
                            //                   TextSpan(
                            //                     text: totalController.text,
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
                    )
                
                
                  ],
                ),
              );
            }
        )


    );
  }

  void _showProductDetails(int index) {
    final selectedOrderDetails = _orders[index];
    print('Selected Order:');
    print('Order ID: ${selectedOrderDetails['orderId']}');
    print('Order Date: ${selectedOrderDetails['orderDate']}');
    print('Contact Person: ${selectedOrderDetails['contactPerson']}');
    print('Delivery Location: ${selectedOrderDetails['deliveryLocation']}');
    print('total: ${selectedOrderDetails['total']}');

    data2['deliveryLocation'] = selectedOrderDetails['deliveryLocation'];
    print('--------deliver');
    print(data2['deliveryLocation']);


    //
    //
    // final selectedItem = selectedOrder['items'];
    //
    // List<String> productNames = [];
    // List<String> prices = [];
    // List<String> quantities = [];
    // List<String> categories = [];
    // List<String> subCategories = [];
    // List<String> totalAmounts = [];
    //
    // // Iterate over the items
    // for (var item in selectedItem) {
    //   productNames.add(item['productName']);
    //   prices.add(item['price'].toString());
    //   quantities.add(item['qty'].toString());
    //   categories.add(item['category']);
    //   subCategories.add(item['subCategory']);
    //   totalAmounts.add(item['totalAmount'].toString());
    // }
    // for (int i = 0; i < productNames.length; i++) {
    //   print('Product Name: ${productNames[i]}');
    //   print('Price: ${prices[i]}');
    //   print('Quantity: ${quantities[i]}');
    //   print('Category: ${categories[i]}');
    //   print('Sub Category: ${subCategories[i]}');
    //   print('Total Amount: ${totalAmounts[i]}');
    //   print('------------------------');
    // }
    //
    // print('Product Names: $productNames');
    // print('Prices: $prices');
    // print('Quantities: $quantities');
    // print('Categories: $categories');
    // print('Sub Categories: $subCategories');
    // print('Total Amounts: $totalAmounts');
    //
    // for (int i = 0; i < productNames.length; i++) {
    //   productNameController.text += '${productNames[i]}\n';
    //   priceController.text += '${prices[i]}\n';
    //   qtyController.text += '${quantities[i]}\n';
    //   categoryController.text += '${categories[i]}\n';
    //   subCategoryController.text += '${subCategories[i]}\n';
    //   totalAmountController.text += '${totalAmounts[i]}\n';
    // }
    //
    print(productNameController.text);
    CreatedDateController.text = _orders[index]['orderDate'];
    orderIdController.text = _orders[index]['orderId'];
    deliveryLocationController.text = _orders[index]['deliveryLocation'];
    contactPersonController.text = _orders[index]['contactPerson'];
    deliveryAddressController.text = _orders[index]['deliveryAddress'];
    contactNumberController.text = _orders[index]['contactNumber'];
    commentsController.text = _orders[index]['comments'];
    totalController.text = _orders[index]['total'].toString();
    // contactPersonController.text = _orders[index]['orderDate'];
    deliveryLocationController.text = _orders[index]['deliveryLocation'];
    print('------------devli');
    print(data2['deliveryLocation']);
    final selectedOrder = _orders[index];
    setState(() {
      selectedItems = List<Map<String, dynamic>>.from(selectedOrder['items']);
    });

    print('Selected Order:');
    print('Order ID: ${selectedOrder['orderId']}');
    print('Order Date: ${selectedOrder['orderDate']}');
    print('Contact Person: ${selectedOrder['contactPerson']}');
    print('Delivery Location: ${selectedOrder['deliveryLocation']}');
    print('total: ${selectedOrder['total']}');

    for (var item in selectedItems) {
      print('Product Name: ${item['productName']}');
      print('orderMasterItemId: ${item['orderMasterItemId']}');
      print('Price: ${item['price']}');
      print('Quantity: ${item['qty']}');
      print('Category: ${item['category']}');
      print('Sub Category: ${item['subCategory']}');
      print('Total Amount: ${item['totalAmount']}');
      print('------------------------');

      // Add more fields to print as needed
    }
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
      });
    }
  }

  // void displayItemDetails() {
  //   String _productName = '';
  //    for (var item in widget.product!.items) {
  //     setState(() {
  //       _productName = item['productName'];
  //     });
  //     break; // To display only the first item's product name
  //   }
  // }

  void displayItemDetails() {
    for (var item in widget.product!.items) {
      selectedItems.add({
        'orderMasterItemId': item['orderMasterItemId'],
        'productName': item['productName'],
        'category': item['category'],
        'subCategory': item['subCategory'],
        'price': item['price'],
        'qty': item['qty'],
        'totalAmount': item['totalAmount'],
      });
    }
  }


  Widget _buildCheckboxItem(String title, bool? isChecked, String content,
      Function(bool?) onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            onChanged(value);
          },
          activeColor: Colors.green,
        ),
        const SizedBox(height: 8.0),
        Text(title),
        const SizedBox(height: 4.0),
        Text(
          content,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }


  Widget tableHeader(String text) {
    return TableCell(
      child: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget tableCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            6, 2, 6, 2),
        child: Container(
          height: 35,
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text(text)),
        ),
      ),
    );
    //TableCell(
    //               verticalAlignment:
    //               TableCellVerticalAlignment.middle,
    //               child: Padding(
    //                 padding: const EdgeInsets.fromLTRB(
    //                     6, 2, 6, 2),
    //                 child: Container(
    //                   height: 35,
    //                   decoration: BoxDecoration(
    //                     color: Colors.grey[300],
    //                   ),
    //                   child: Center(
    //                     child: Text(
    //                       item['productName'],
    //                       style: const TextStyle(
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
  }

}