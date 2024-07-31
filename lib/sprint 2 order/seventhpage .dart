import 'dart:convert';
import 'dart:html';
import 'package:btb/sprint%202%20order/eighthpage.dart';
import 'package:btb/sprint%202%20order/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import '../screen/login.dart';
import '../dashboard.dart';


// void main(){
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: SeventhPage(selectedProducts: {},),
//   ));
// }



class SeventhPage extends StatefulWidget {

  final Map<String, dynamic> selectedProducts;
  final detail? product;
  final String? orderId;
  final List<dynamic>? orderDetails;

  SeventhPage({super.key,required this.selectedProducts,required this.product,this.orderDetails,required this.orderId});

  @override
  State<SeventhPage> createState() => _SeventhPageState();
}

class _SeventhPageState extends State<SeventhPage> {
  final _formKey = GlobalKey<FormState>();
  bool isSelected = false;
  int _selectedIndex = -1;
  Map<String, dynamic> data2 = {};
  DateTime? _selectedDate;
  final TextEditingController deliveryLocationController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = [];
  final TextEditingController deliveryAddressController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  final TextEditingController CreatedDateController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  bool? _isChecked1 = true;
  bool _isFirstLoad = true;
  bool? _isChecked2 = true;
  String token = window.sessionStorage["token"]?? " ";
  List<Map> _orders = [];
  String _searchText = '';
  bool _loading = false;
  bool isEditing = false;
  late TextEditingController _dateController;
  bool? _isChecked3 = false;
  bool? _isChecked4 = false;
  final TextEditingController totalAmountController = TextEditingController();
  bool isOrdersSelected = false;
  String _errorMessage = '';
  List<bool> _isSelected = [];
  final _orderIdController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//     print('product');
//     print(widget.product);
//
//     if (widget.product != null && _orders.isNotEmpty) {
//       int index = _orders.indexWhere((element) => element['orderId'] == widget.product?.orderId);
//       if (index != -1) {
//         setState(() {
//           _selectedIndex = index;
//         });

//       }
//     }
//
//
//     // if (widget.product != null) {
//     //   _selectedIndex = widget.product! as int;
//     // } else {
//     //   print('Error: Product is null');
//     //   // You can also show a error message to the user
//     //   // For example:
//     //   // ScaffoldMessenger.of(context).showSnackBar(
//     //   //   SnackBar(content: Text('Error: Product is null')),
//     //   // );
//     // }
//
//
//
//
//     if (widget.product != null) {
//       //data2['deliveryLocation'] = widget.product.
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           orderIdController.text = widget.product!.orderId ?? '';
//           print('orderIdController.text');
//           print('Selected items length: ${selectedItems.length}');
//           print(orderIdController.text);
//           totalController.text = widget.product!.total.toString() ?? '';
//           deliveryAddressController.text = widget.product!.deliveryAddress! ?? '';
//           contactPersonController.text = widget.product!.contactPerson! ?? '';
//           contactNumberController.text = widget.product!.contactNumber! ?? '';
//           commentsController.text = widget.product!.comments! ?? '';
//           data2['deliveryLocation'] = widget.product!.deliveryLocation! ?? '';
//        //   selectedItems = widget.product!.items as List<Map<String, dynamic>>;
//
//           // widget.product!.items = widget.body[it];
//
//           //  displayItemDetails();
//         });
//       });
//     widget.selectedProducts;
//
//
//
//     print('--updated details');
//     if (widget.selectedProducts['total']!= null) {
//       totalController.text = widget.selectedProducts['total'].toString();
//     }
//     if (widget.selectedProducts['orderDate']!= null) {
//       CreatedDateController.text = widget.selectedProducts['orderDate'].toString();
//     }
//     if (widget.selectedProducts['contactPerson']!= null) {
//       contactPersonController.text = widget.selectedProducts['contactPerson'];
//     }
//     if (widget.selectedProducts['deliveryAddress']!= null) {
//       deliveryAddressController.text = widget.selectedProducts['deliveryAddress'];
//     }
//     if (widget.selectedProducts['contactNumber']!= null) {
//       contactNumberController.text = widget.selectedProducts['contactNumber'];
//     }
//     if (widget.selectedProducts['comments']!= null) {
//       commentsController.text = widget.selectedProducts['comments'];
//     }
//     if (widget.selectedProducts['deliveryLocation']!= null) {
//       data2['deliveryLocation'] = widget.selectedProducts['deliveryLocation'];
//     }
//     if (widget.selectedProducts['contactPerson']!= null) {
//       widget.selectedProducts['contactPerson'] = contactPersonController.text;
//     }
// //  widget.selectedProducts['contactPerson'] = contactPersonController.text;
//     if (widget.selectedProducts != null && widget.selectedProducts['items'] != null) {
//       for (var item in widget.selectedProducts['items']) {
//         selectedItems.add({
//           'productName': '${item['productName']}',
//           'category': '${item['category']}',
//           'subCategory': '${item['subCategory']}',
//           'price': '${item['price']}',
//           'qty': item['qty'].toString(),
//           'totalAmount': item['totalAmount'] = item['qty'] * item['price']
//
//         });
//       }
//
//
//
//
//         // _selectedOrder = widget.product!;
//         // print(_selectedOrder);
//         print('-----selectorder');
//       } else {
//         print('Product is null');
//         //  deliveryAddressController.text = widget.product!.deliveryAddress! ?? '';
//
// //
// //    _selectedOrder = widget.product!;
// //
// //   _selectedOrder = _selectedOrder;
// //    print(_selectedOrder);
//
//       }
//
//     }
//     // if (data2!= null) {
//     //     totalAmount = data2['total']!= null? double.parse(data2['total']) : 0.0;
//     //   }
//
//     print(widget.selectedProducts);
//     _orderIdController.addListener(_fetchOrders);
//     _dateController = TextEditingController();
//
//     _selectedDate = DateTime.now();
//     _dateController.text = DateFormat.yMd().format(_selectedDate!);
//
//     // Populate the _productItems list
//     // if (widget.selectedProducts['items']!= null) {
//     //   _productItems = widget.selectedProducts['items'];
//     // }
//
//     // if (widget.product != null) {
//     //   _selectedIndex = widget.product! as int;
//     // } else {
//     //   print('Error: Product is null');
//     //   // You can also show a error message to the user
//     //   // For example:
//     //   // ScaffoldMessenger.of(context).showSnackBar(
//     //   //   SnackBar(content: Text('Error: Product is null')),
//     //   // );
//     // }
//   }

  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_isFirstLoad) {
  //     print('didichange');
  //     _isFirstLoad = false;
  //     for (int i = 0; i < widget.orderDetails!.length; i++) {
  //       if (orderIdController.text == widget.orderDetails![i].orderId) {
  //         setState(() {
  //           var selectedItem = widget.orderDetails![i];
  //           widget.orderDetails!.removeAt(i);
  //           widget.orderDetails!.insert(0, selectedItem);
  //           for (int j = 0; j < _isSelected.length; j++) {
  //             _isSelected[j] = j == 0;
  //           }
  //         });
  //         break;
  //       }
  //     }
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      print('didichange');
      _isFirstLoad = false;
      for (int i = 0; i < widget.orderDetails!.length; i++) {
        if (orderIdController.text == widget.orderDetails![i].orderId) {
          setState(() {
            var selectedItem = widget.orderDetails![i];
            widget.orderDetails!.removeAt(i);
            widget.orderDetails!.insert(0, selectedItem);
            for (int j = 0; j < _isSelected.length; j++) {
              _isSelected[j] = j == 0;
            }
          });
          break;
        }
      }
    }
  }


  @override
  void initState() {
    super.initState();

    //_fetchOrders();


    print('sevetnhpage');
   // widget.orderId;
    print(widget.orderId);
    orderIdController.text = widget.orderId!;
    _isSelected = List<bool>.filled(widget.orderDetails!.length, false);
    print(widget.orderDetails);
    //_isSelected = List<bool>.filled(widget.orderDetails!.length, false);
    widget.selectedProducts;
  //  orderIdController.text = widget.product!.orderId ?? '';
    // _orderIdController.addListener((){
    //   _fetchOrders();
    // });

    print('--updated details');
    if (widget.selectedProducts['total']!= null) {
      totalController.text = widget.selectedProducts['total'].toString();
    }
    // if (widget.selectedProducts['orderId']!= null) {
    //   orderIdController.text = widget.selectedProducts['orderId'].toString();
    // }
    if (widget.selectedProducts['orderDate']!= null) {
      CreatedDateController.text = widget.selectedProducts['orderDate'].toString();
    }
    if (widget.selectedProducts['contactPerson']!= null) {
      contactPersonController.text = widget.selectedProducts['contactPerson'];
    }
    if (widget.selectedProducts['deliveryAddress']!= null) {
      deliveryAddressController.text = widget.selectedProducts['deliveryAddress'];
    }
    if (widget.selectedProducts['contactNumber']!= null) {
      contactNumberController.text = widget.selectedProducts['contactNumber'];
    }
    if (widget.selectedProducts['comments']!= null) {
      commentsController.text = widget.selectedProducts['comments'];
    }
    if (widget.selectedProducts['deliveryLocation']!= null) {
      data2['deliveryLocation'] = widget.selectedProducts['deliveryLocation'];
    }
    if (widget.selectedProducts['contactPerson']!= null) {
      widget.selectedProducts['contactPerson'] = contactPersonController.text;
    }
//  widget.selectedProducts['contactPerson'] = contactPersonController.text;
    if (widget.selectedProducts != null && widget.selectedProducts['items'] != null) {
      for (var item in widget.selectedProducts['items']) {
        selectedItems.add({
          'productName': '${item['productName']}',
          'category': '${item['category']}',
          'subCategory': '${item['subCategory']}',
          'price': '${item['price']}',
          'qty': item['qty'].toString(),
          'totalAmount': item['totalAmount'] = item['qty'] * item['price']

        });
      }

    }
    // if (data2!= null) {
    //     totalAmount = data2['total']!= null? double.parse(data2['total']) : 0.0;
    //   }

    print(widget.selectedProducts);
    //_orderIdController.addListener(_fetchOrders);
    _dateController = TextEditingController();

    _selectedDate = DateTime.now();
    _dateController.text = DateFormat.yMd().format(_selectedDate!);

    // Populate the _productItems list
    // if (widget.selectedProducts['items']!= null) {
    //   _productItems = widget.selectedProducts['items'];
    // }
  }


  // @override
  // void initState() {
  //   super.initState();
  //   widget.selectedProducts;
  //   print('--updated details');
  //   widget.selectedProducts['contactPerson'] = contactPersonController.text;
  //   print(widget.selectedProducts);
  //   _orderIdController.addListener(_fetchOrders);
  //   _dateController = TextEditingController();
  //
  //   _selectedDate = DateTime.now();
  //   _dateController.text = DateFormat.yMd().format(_selectedDate!);
  // }


  @override
  void dispose() {
    //_orderIdController.removeListener(_fetchOrders);
    _dateController.dispose();
    super.dispose();
  }

  // Future<void> _fetchOrders() async {
  //   setState(() {
  //     _loading = true;
  //     _orders = []; // clear the orders list
  //     _errorMessage = ''; // clear the error message
  //   });
  //   try {
  //     final orderId = _orderIdController.text
  //         .trim(); // trim to remove whitespace
  //     final url = orderId.isEmpty
  //         ? 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster'
  //         : 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $token', // Replace with your API key
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseBody = response.body;
  //       if (responseBody != null) {
  //         final jsonData = jsonDecode(responseBody).cast<
  //             Map<dynamic, dynamic>>();
  //         setState(() {
  //           _orders =
  //               jsonData; // update _orders with all orders or search results
  //           _errorMessage = ''; // clear the error message
  //         });
  //       } else {
  //         setState(() {
  //           _orders = []; // clear the orders list
  //           _errorMessage = 'Failed to load orders';
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         _orders = []; // clear the orders list
  //         _errorMessage = 'Failed to load orders';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _orders = []; // clear the orders list
  //       _errorMessage = 'Error: $e';
  //     });
  //   } finally {
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

  Future<void> _fetchOrderDetails(String orderId) async {
    try {
      final url = 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';
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
          final jsonData = jsonDecode(responseBody);
          if (jsonData is List<dynamic>) {
            final jsonObject = jsonData.first;
            final orderDetails = OrderDetail.fromJson(jsonObject);
            _showProductDetails(orderDetails as int);
          } else {
            print('Failed to load order details');
          }
        } else {
          print('Failed to load order details');
        }
      } else {
        print('Failed to load order details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Future<void> _fetchOrders() async {
  //   setState(() {
  //     _loading = true;
  //     _orders = []; // clear the orders list
  //     _errorMessage = ''; // clear the error message
  //   });
  //   try {
  //     final orderId = _orderIdController.text
  //         .trim(); // trim to remove whitespace
  //     final url = orderId.isEmpty
  //         ? 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster'
  //         : 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $token', // Replace with your API key
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseBody = response.body;
  //       if (responseBody != null) {
  //         final jsonData = jsonDecode(responseBody).cast<
  //             Map<dynamic, dynamic>>();
  //         setState(() {
  //           _orders =
  //               jsonData; // update _orders with all orders or search results
  //           _errorMessage = ''; // clear the error message
  //         });
  //       } else {
  //         setState(() {
  //           _orders = []; // clear the orders list
  //           _errorMessage = 'Failed to load orders';
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         _orders = []; // clear the orders list
  //         _errorMessage = 'Failed to load orders';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _orders = []; // clear the orders list
  //       _errorMessage = 'Error: $e';
  //     });
  //   } finally {
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TableRow row1 = TableRow(
      children: [
        const TableCell(
          child: Padding(
            padding: EdgeInsets.only(left: 30,top: 10,bottom: 10),
            child: Text('Delivery Location'),
          ),
        ),
        TableCell(
          child: Row(
            children: [
              const Spacer(),
              const Text(
                'Order Date',
                style: TextStyle(
              //    fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
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
                    const SizedBox(height: 20),
                    const Text('Contact Number'),
                    const SizedBox(height: 10,),
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
        appBar:  AppBar(
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
              return  SingleChildScrollView(
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
                                // context.go('${PageName.main}/${PageName.subpage1Main}');
                                // context.go('${PageName.dashboardRoute}');
                                context.go('/Orderspage/orders/dasbaord');
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
                                context.go('/orders/productpage/:product');
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
                                // context.go('${PageName.main}/${PageName.subpage1Main}');
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Orderspage()),
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
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 200,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.white,
                          height: 50,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: IconButton(
                                  icon:
                                  const Icon(Icons.arrow_back), // Back button icon
                                  onPressed: () {
                                    context.go('/Order_List');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Orderspage()),
                                    );
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 30,bottom: 10),
                                child: Text(
                                  'Order List',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 150),
                                child: Text('Order ID :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              ),
                              SizedBox(width:8),
                              Text((orderIdController.text),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              //  Text(orderIdController.text),
                              SizedBox(width: 10,),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5,right: 100),
                                child: OutlinedButton(
                                  onPressed: () {
                                    context.go('/Download');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const EighthPage()),
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
                        height: 950,
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
                        top: 70,
                        left: 200,
                      ),
                      width: 300,
                      height: 900
                      ,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                      left: 15, right: 15, bottom: 2),
                                  child: TextFormField(
                                  //  controller: _orderIdController, // Assign the controller to the TextFormField
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
                              const SizedBox(height: 5),
                              Column(
                                children: [
                                  _loading
                                      ? Center(child: CircularProgressIndicator(strokeWidth: 4))
                                      : _errorMessage.isNotEmpty
                                      ? Center(child: Text(_errorMessage))
                                      : widget.orderDetails!.isEmpty
                                      ? const Center(child: Text('No product found'))
                                      : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: _searchText.isNotEmpty
                                        ? widget.orderDetails!.where((orderDetail) =>
                                    orderDetail.orderId.toLowerCase().contains(_searchText.toLowerCase()) ||
                                        orderDetail.orderDate.toLowerCase().contains(_searchText.toLowerCase())
                                    ).length
                                        : widget.orderDetails!.length,
                                    itemBuilder: (context, index) {
                                      final isSelected = _isSelected[index];
                                      final orderDetail = _searchText.isNotEmpty
                                          ? widget.orderDetails!.where((orderDetail) =>
                                      orderDetail.orderId.toLowerCase().contains(_searchText.toLowerCase()) ||
                                          orderDetail.orderDate.toLowerCase().contains(_searchText.toLowerCase())
                                      ).elementAt(index)
                                          : widget.orderDetails![index];

                                      return GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            for (int i = 0; i < _isSelected.length; i++) {
                                              _isSelected[i] = i == index;
                                            }
                                            orderIdController.text = orderDetail.orderId;
                                          });
                                          await _fetchOrderDetails(orderDetail.orderId);
                                          //in this place write api to fetch datas?? _showProductDetails(orderDetail);
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.lightBlue : Colors.white,
                                          ),
                                          child: ListTile(
                                            title: Text('Order ID: ${orderDetail.orderId}'),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Order Date: ${orderDetail.orderDate}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                  ),
                                ],
                              )
                              //original
                              // Column(
                              //   children: [
                              //     _loading
                              //         ? const Center(child: CircularProgressIndicator())
                              //         : _errorMessage.isNotEmpty
                              //         ? Center(child: Text(_errorMessage))
                              //         : _orders.isEmpty
                              //         ? const Center(child: Text('No product found'))
                              //         : ListView.separated(
                              //       shrinkWrap: true,
                              //       itemCount: _orders.length,
                              //       itemBuilder: (context, index) {
                              //         return GestureDetector(
                              //           onTap: (){
                              //             setState(() {
                              //               _selectedIndex = index;
                              //               _showProductDetails(index);
                              //               //  Text('Order # ${_orders[index]['contactPerson']}');
                              //               //  contactPersonController.text = ${_orders[index]['contactPerson']
                              //             });
                              //             orderIdController.text = _orders[index]['orderId'];
                              //           },
                              //           child: Container(
                              //             //  margin: const EdgeInsets.all(5),
                              //             decoration: BoxDecoration(
                              //               color: _selectedIndex == index ? Colors.blue[100] : Colors.white,
                              //               // border: Border.all(color: Colors.grey),
                              //               // borderRadius: BorderRadius.circular(5),
                              //             ),
                              //             child: ListTile(
                              //               title: Text('Order #${_orders[index]['orderId']}'),
                              //               subtitle: Text('Order Date: ${_orders[index]['orderDate']}'),
                              //             ),
                              //           ),
                              //         );
                              //       },
                              //       separatorBuilder: (context, index) {
                              //         return const Divider();
                              //       },
                              //     ),
                              //   ],
                              // )
                              // Column(
                              //   children: [
                              //     _loading
                              //         ? Center(child: CircularProgressIndicator(strokeWidth: 4))
                              //         : _errorMessage.isNotEmpty
                              //         ? Center(child: Text(_errorMessage))
                              //         : widget.orderDetails!.isEmpty
                              //         ? const Center(child: Text('No product found'))
                              //         : ListView.separated(
                              //       shrinkWrap: true,
                              //       itemCount: widget.orderDetails!.length,
                              //       itemBuilder: (context, index) {
                              //         final isSelected = _isSelected[index];
                              //         return GestureDetector(
                              //           onTap: () async {
                              //             setState(() {
                              //               for (int i = 0; i < _isSelected.length; i++) {
                              //                 _isSelected[i] = i == index;
                              //               }
                              //               orderIdController.text = widget.orderDetails![index].orderId;
                              //             });
                              //             await _fetchOrderDetails(widget.orderDetails![index].orderId);
                              //             //in this place write api to fetch datas ?? _showProductDetails(widget.orderDetails![index]);
                              //           },
                              //           child: AnimatedContainer(
                              //             duration: Duration(milliseconds: 200),
                              //             decoration: BoxDecoration(
                              //               color: isSelected ? Colors.lightBlue : Colors.white,
                              //             ),
                              //             child: ListTile(
                              //               title: Text('Order ID: ${widget.orderDetails![index].orderId}'),
                              //               subtitle: Column(
                              //                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text('Order Date: ${widget.orderDetails![index].orderDate}'),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //         );
                              //       },
                              //       separatorBuilder: (context, index) {
                              //         return const Divider();
                              //       },
                              //     ),
                              //   ],
                              // )

                            ],
                          ),
                        ),
                      ),

                    ),
                    Container(
                      width: maxWidth,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 550, top: 100,right: 120),
                            child: Container(
                              height: 100,
                              width: maxWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFB2C2D3), width: 2),
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
                                            color: Colors.green,
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
                            padding: const EdgeInsets.only(left: 550,right: 120,top: 50),
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
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 550,top:50,right: 120),
                          //   child: Container(
                          //     height: 400,
                          //     width: maxWidth ,
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
                          //               padding: EdgeInsets.only(right: maxWidth * 0.20),
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
                            padding:  const EdgeInsets.only(left: 550, top: 50,right: 120),
                            child: Container(
                              // height: 150,
                              width: maxWidth,
                              //   padding: const EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFB2C2D3), width:
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
                       ],
                     ),
                    ],
                  ),
                ),
              ),
                                  // Container(
                                  //   width: maxWidth,
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //       color: Colors.grey,),
                                  //   ),
                                  //   child:  Padding(
                                  //     padding: EdgeInsets.only(
                                  //       top: 5,
                                  //       bottom: 5,
                                  //     ),
                                  //     child: SizedBox(
                                  //       // height: 34,
                                  //       child: Row(
                                  //         children: [
                                  //           Expanded(
                                  //             flex:1,
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 25,),
                                  //               child: Text(
                                  //                 "SN",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             flex: 1,
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 10,right: 10),
                                  //               child: Text(
                                  //                 'Product Name',
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             flex: 1,
                                  //             child: Padding(padding: EdgeInsets.only(left: 50,right: 15),
                                  //               child: Text(
                                  //                 "Category",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             flex: 1,
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 45,right: 10),
                                  //               child: Text(
                                  //                 "Sub Category",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             flex: 1,
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 90,right: 10),
                                  //               child: Text(
                                  //                 "Price",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //
                                  //           const Expanded(
                                  //             flex: 1,
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 65,right: 10),
                                  //               child: Text(
                                  //                 "QTY",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             flex: 1,
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(right: 10),
                                  //               child: Text(
                                  //                 "Total Amount",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: selectedItems.length,
                                    itemBuilder: (context, index) {
                                      var item = selectedItems[index];
                                      // int index = selectedItems.indexOf(item) + 1;
                                      return Table(
                                        border: TableBorder.all(
                                            color: const Color(0xFFB2C2D3)),
                                        columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(2.7),
                                          2: FlexColumnWidth(2),
                                          3: FlexColumnWidth(1.8),
                                          4: FlexColumnWidth(2),
                                          5: FlexColumnWidth(1),
                                          6: FlexColumnWidth(2),
                                        },
                                        // Add this line
                                        children: [
                                          TableRow(
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
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
                                      alignment: const Alignment(0.9,0.8),
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.only(left: 15,right: 10,top: 10,bottom: 2),
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
                          ),
                          // Padding(
                          //   padding:  EdgeInsets.only(left: 550, top: 50,right: 120),
                          //   child: Container(
                          //     // height: 150,
                          //     width: maxWidth,
                          //     //   padding: const EdgeInsets.all(0.0),
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.grey, width:
                          //       2),
                          //       borderRadius: BorderRadius.circular(5.0),
                          //     ),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.only(left: 30, top: 10),
                          //           child: Text(
                          //             'Add Products',
                          //             style: TextStyle(
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.bold,
                          //               color: Colors.grey[600],
                          //             ),
                          //           ),
                          //         ),
                          //         // Container(
                          //         //   width: maxWidth,
                          //         //   decoration: BoxDecoration(
                          //         //     border: Border.all(
                          //         //       color: Colors.grey,),
                          //         //   ),
                          //         //   child: const Padding(
                          //         //     padding: EdgeInsets.only(
                          //         //       top: 5,
                          //         //       bottom: 5,
                          //         //     ),
                          //         //     child: SizedBox(
                          //         //       // height: 34,
                          //         //       child: Row(
                          //         //         children: [
                          //         //           Expanded(
                          //         //             flex:1,
                          //         //             child: Center(
                          //         //               child: Text(
                          //         //                 "SN",
                          //         //                 style: TextStyle(
                          //         //                   fontWeight: FontWeight.bold,
                          //         //                 ),
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //           Expanded(
                          //         //             flex: 1,
                          //         //             child: Center(
                          //         //               child: Text(
                          //         //                 'Product Name',
                          //         //                 style: TextStyle(
                          //         //                   fontWeight: FontWeight.bold,
                          //         //                 ),
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //           Expanded(
                          //         //             flex: 1,
                          //         //             child: Center(
                          //         //               child: Text(
                          //         //                 "Category",
                          //         //                 style: TextStyle(
                          //         //                   fontWeight: FontWeight.bold,
                          //         //                 ),
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //           Expanded(
                          //         //             flex: 1,
                          //         //             child: Center(
                          //         //               child: Text(
                          //         //                 "Sub Category",
                          //         //                 style: TextStyle(
                          //         //                   fontWeight: FontWeight.bold,
                          //         //                 ),
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //           Expanded(
                          //         //             flex: 1,
                          //         //             child: Center(
                          //         //               child: Text(
                          //         //                 "Price",
                          //         //                 style: TextStyle(
                          //         //                   fontWeight: FontWeight.bold,
                          //         //                 ),
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //           Expanded(
                          //         //             flex: 1,
                          //         //             child: Center(
                          //         //               child: Text(
                          //         //                 "QTY",
                          //         //                 style: TextStyle(
                          //         //                   fontWeight: FontWeight.bold,
                          //         //                 ),
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //           Expanded(
                          //         //             flex: 1,
                          //         //             child: Center(
                          //         //               child: Text(
                          //         //                 "Total Amount",
                          //         //                 style: TextStyle(
                          //         //                   fontWeight: FontWeight.bold,
                          //         //                 ),
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //         ],
                          //         //       ),
                          //         //     ),
                          //         //   ),
                          //         // ),
                          //         ListView.builder(
                          //           shrinkWrap: true,
                          //           physics: const NeverScrollableScrollPhysics(),
                          //           itemCount: selectedItems.length,
                          //           itemBuilder: (context, index) {
                          //             var item = selectedItems[index];
                          //             // int index = selectedItems.indexOf(item) + 1;
                          //             return Table(
                          //               border: TableBorder.all(
                          //                   color: Colors.grey),
                          //               columnWidths: {
                          //                 0: FlexColumnWidth(1),
                          //                 1: FlexColumnWidth(3),
                          //                 2: FlexColumnWidth(2),
                          //                 3: FlexColumnWidth(2),
                          //                 4: FlexColumnWidth(2),
                          //                 5: FlexColumnWidth(1),
                          //                 6: FlexColumnWidth(2),
                          //               },
                          //               // Add this line
                          //               children: [
                          //                 TableRow(
                          //                   children: [
                          //                     TableCell(
                          //                       child: Padding(
                          //                         padding: EdgeInsets.only(
                          //                             left: 10,
                          //                             right: 10,
                          //                             top: 10,
                          //                             bottom: 10),
                          //                         child: Center(
                          //                           child: Text(
                          //                             ' ${index + 1}',
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     TableCell(
                          //                       child: Padding(
                          //                         padding: const EdgeInsets.only(
                          //                             left: 10,
                          //                             right: 10,
                          //                             top: 5,
                          //                             bottom: 5),
                          //                         child: Container(
                          //                           height: 35,
                          //                           decoration: BoxDecoration(
                          //                             color: Colors.grey[300],
                          //                             borderRadius: BorderRadius
                          //                                 .circular(4.0),
                          //                           ),
                          //                           child: Center(
                          //                             child: Text(
                          //                               item['productName'],
                          //                               textAlign: TextAlign
                          //                                   .center,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     TableCell(
                          //                       child: Padding(
                          //                         padding: const EdgeInsets.only(
                          //                             left: 10,
                          //                             right: 10,
                          //                             top: 5,
                          //                             bottom: 5),
                          //                         child: Container(
                          //                           height: 35,
                          //                           decoration: BoxDecoration(
                          //                             color: Colors.grey[300],
                          //                             borderRadius: BorderRadius
                          //                                 .circular(4.0),
                          //                           ),
                          //                           child: Center(
                          //                             child: Text(
                          //                               item['category'],
                          //                               textAlign: TextAlign
                          //                                   .center,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     TableCell(
                          //                       child: Padding(
                          //                         padding: const EdgeInsets.only(
                          //                             left: 10,
                          //                             right: 10,
                          //                             top: 5,
                          //                             bottom: 5),
                          //                         child: Container(
                          //                           height: 35,
                          //                           decoration: BoxDecoration(
                          //                             color: Colors.grey[300],
                          //                             borderRadius: BorderRadius
                          //                                 .circular(4.0),
                          //                           ),
                          //                           child: Center(
                          //                             child: Text(
                          //                               item['subCategory'],
                          //                               textAlign: TextAlign
                          //                                   .center,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     TableCell(
                          //                       child: Padding(
                          //                         padding: const EdgeInsets.only(
                          //                             left: 10,
                          //                             right: 10,
                          //                             top: 5,
                          //                             bottom: 5),
                          //                         child: Container(
                          //                           height: 35,
                          //                           decoration: BoxDecoration(
                          //                             color: Colors.grey[300],
                          //                             borderRadius: BorderRadius
                          //                                 .circular(4.0),
                          //                           ),
                          //                           child: Center(
                          //                             child: Text(
                          //                               item['price'].toString(),
                          //                               textAlign: TextAlign
                          //                                   .center,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     TableCell(
                          //                       child: Padding(
                          //                         padding: const EdgeInsets.only(
                          //                             left: 10,
                          //                             right: 10,
                          //                             top: 5,
                          //                             bottom: 5),
                          //                         child: Container(
                          //                           height: 35,
                          //                           decoration: BoxDecoration(
                          //                             color: Colors.grey[300],
                          //                             borderRadius: BorderRadius
                          //                                 .circular(4.0),
                          //                           ),
                          //                           child: Center(
                          //                             child: Text(
                          //                               item['qty'].toString(),
                          //                               textAlign: TextAlign
                          //                                   .center,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     TableCell(
                          //                       child: Padding(
                          //                         padding: const EdgeInsets.only(
                          //                             left: 10,
                          //                             right: 10,
                          //                             top: 5,
                          //                             bottom: 5),
                          //                         child: Container(
                          //                           height: 35,
                          //                           decoration: BoxDecoration(
                          //                             color: Colors.grey[300],
                          //                             borderRadius: BorderRadius
                          //                                 .circular(4.0),
                          //                           ),
                          //                           child: Center(
                          //                             child: Text(
                          //                               item['totalAmount']
                          //                                   .toString(),
                          //                               textAlign: TextAlign
                          //                                   .center,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         ),
                          //         Padding(
                          //           padding: const EdgeInsets.only(right: 25 ,top: 5,bottom: 5),
                          //           child: Align(
                          //             alignment: Alignment.centerRight,
                          //             child: Container(
                          //               height: 40,
                          //               padding: EdgeInsets.only(left: 15,right: 10,top: 10,bottom: 2),
                          //               decoration: BoxDecoration(
                          //                 border: Border.all(color: Colors.blue),
                          //                 borderRadius: BorderRadius.circular(8.0),
                          //                 color: Colors.white,
                          //               ),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.only(bottom: 2),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.min,
                          //                   children: [
                          //                     RichText(text:
                          //                     TextSpan(
                          //                       children: [
                          //                         TextSpan(
                          //                           text:  'Total',
                          //                           style: TextStyle(
                          //                               fontSize: 14,
                          //                               color: Colors.blue
                          //                             // fontWeight: FontWeight.bold,
                          //                           ),
                          //                         ),
                          //                         const TextSpan(
                          //                           text: '  ₹',
                          //                           style: TextStyle(
                          //                             color: Colors.black,
                          //                           ),
                          //                         ),
                          //                         TextSpan(
                          //                           text:
                          //                           totalController.text,
                          //                           style: const TextStyle(
                          //                             color: Colors.black,
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //         // const Divider(color: Colors.grey,),
                          //         // Padding(
                          //         //   padding: EdgeInsets.only(top: 20,left: maxWidth * 0.2 ,right: maxWidth * 0.2),
                          //         //   child: Row(
                          //         //     children: [
                          //         //       Expanded(
                          //         //         child: Container(
                          //         //   width: maxWidth * 0.25,
                          //         //           decoration: BoxDecoration(
                          //         //             border: Border.all(color: Colors.blue),
                          //         //           ),
                          //         //           child: Padding(
                          //         //             padding: const EdgeInsets.only(
                          //         //               top: 10,
                          //         //               bottom: 10,
                          //         //               left: 5,
                          //         //               right: 5,
                          //         //             ),
                          //         //             child: RichText(
                          //         //               text: TextSpan(
                          //         //                 children: [
                          //         //                   const TextSpan(
                          //         //                     text: 'Total',
                          //         //                     style: TextStyle(
                          //         //                       fontWeight: FontWeight.bold,
                          //         //                       color: Colors.blue,
                          //         //                     ),
                          //         //                   ),
                          //         //                   const TextSpan(
                          //         //                     text: '  ₹',
                          //         //                     style: TextStyle(
                          //         //                       color: Colors.black,
                          //         //                     ),
                          //         //                   ),
                          //         //                   TextSpan(
                          //         //                     text: totalController.text,
                          //         //                     style: const TextStyle(
                          //         //                       color: Colors.black,
                          //         //                     ),
                          //         //                   ),
                          //         //                 ],
                          //         //               ),
                          //         //             ),
                          //         //           ),
                          //         //         ),
                          //         //       ),
                          //         //     ],
                          //         //   ),
                          //         // ),
                          //
                          //
                          //       ],
                          //     ),
                          //   ),
                          // ),


                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 550, top: 100),
                    //       child: Container(
                    //         height: 100,
                    //         width: maxWidth,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(color: Colors.grey, width: 2),
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child:const Padding(
                    //           padding:  EdgeInsets.only(top: 30),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               Column(
                    //                 children: [
                    //                   Icon(
                    //                     Icons.check_box,
                    //                     color: Colors.green,
                    //                   ),
                    //                   Text(
                    //                     'Order Placed',
                    //                     style: TextStyle(
                    //                       color: Colors.black,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Icon(
                    //                     Icons.check_box,
                    //                     color: Colors.green,
                    //                   ),
                    //                   Text(
                    //                     'Invoice',
                    //                     style: TextStyle(
                    //                       color: Colors.black,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Icon(
                    //                     Icons.check_box_outline_blank,
                    //                     color: Colors.grey,
                    //                   ),
                    //                   Text(
                    //                     'Payments',
                    //                     style: TextStyle(
                    //                       color: Colors.grey,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Icon(
                    //                     Icons.check_box_outline_blank,
                    //                     color: Colors.grey,
                    //                   ),
                    //                   Text(
                    //                     'Delivery',
                    //                     style: TextStyle(
                    //                       color: Colors.grey,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 550,top:50,right: 120),
                    //   child: Container(
                    //     height: 400,
                    //     width: maxWidth ,
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
                    // Row(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 550, top:290),
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
                    //           width: 550,
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
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(left: 30),
                    //                             child: Text('Select Delivery Location'),
                    //                           ),
                    //                           const SizedBox(height: 10),
                    //                           SizedBox(
                    //                             height: 50,
                    //                             width: 400,
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(left: 30),
                    //                               child: Container(
                    //                                 decoration: BoxDecoration(
                    //                                   border: Border.all(color: Colors.grey, width: 1),
                    //                                   borderRadius: BorderRadius.circular(5),
                    //                                 ),
                    //                                 child: DropdownButton<String>(
                    //                                   value: data2['deliveryLocation'] != null && list.contains(data2['deliveryLocation']) ? data2['deliveryLocation'] : null,
                    //                                   icon: Icon(Icons.arrow_drop_down),
                    //                                   iconSize: 24,
                    //                                   elevation: 16,
                    //                                   style: const TextStyle(color: Colors.black),
                    //                                   underline: Container(),
                    //                                   onChanged: (String? value) {
                    //                                     setState(() {
                    //                                       data2['deliveryLocation'] = value!;
                    //                                     });
                    //                                   },
                    //                                   items: list.map<DropdownMenuItem<String>>((String value) {
                    //                                     return DropdownMenuItem<String>(
                    //                                       enabled: isEditing,
                    //                                       value: value,
                    //                                       child: Text(value),
                    //                                     );
                    //                                   }).toList(),
                    //                                   isExpanded: true,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     const SizedBox(width: 30),
                    //                     Expanded(
                    //                       child: Column(
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(left: 30.0,top: 27.0),
                    //                             child: Text('Contact Person'),
                    //                           ),
                    //                           const SizedBox(height: 7),
                    //                           SizedBox(
                    //                             height: 70,
                    //                             width: 400,
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(bottom: 15, left: 30),
                    //                               child: TextFormField(
                    //                                 enabled: isEditing,
                    //                                 controller: contactPersonController,
                    //                                 decoration: const InputDecoration(
                    //                                   hintText: 'Contact Person Name',
                    //                                   contentPadding: EdgeInsets.all(8),
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
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(left: 30),
                    //                             child: Text('Delivery Address'),
                    //                           ),
                    //                           const SizedBox(height: 10),
                    //                           SizedBox(
                    //                             height: 150, // Increase the height here
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(bottom: 15, left: 30),
                    //                               child: TextFormField(
                    //                                 enabled: isEditing,
                    //                                 maxLines: null, // Allow the TextFormField to expand vertically
                    //                                 expands: true, // Allow the TextFormField to expand vertically
                    //                                 controller: deliveryAddressController,
                    //                                 decoration: const InputDecoration(
                    //                                   border: OutlineInputBorder(),
                    //                                   contentPadding: EdgeInsets.all(8),
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
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(left: 30),
                    //                             child: Text('Contact Number'),
                    //                           ),
                    //                           const SizedBox(height: 10),
                    //                           SizedBox(
                    //                             height: 150,
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(bottom: 15, left: 30),
                    //                               child: TextFormField(
                    //                                 enabled: isEditing,
                    //                                 keyboardType: TextInputType.number,
                    //                                 inputFormatters: [
                    //                                   FilteringTextInputFormatter.digitsOnly,
                    //                                   LengthLimitingTextInputFormatter(10),
                    //                                 ],
                    //                                 controller: contactNumberController,
                    //                                 decoration: const InputDecoration(
                    //                                   hintText: 'Contact Person Number',
                    //                                   contentPadding: EdgeInsets.all(8),
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
                    //   padding: const EdgeInsets.only(left: 1100, top: 290),
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
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left: 90, top: 10),
                    //                 child: Row(
                    //                   children: [
                    //                     Text(
                    //                       'Order Date',
                    //                       style: TextStyle(
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.bold,
                    //                       ),
                    //                     ),
                    //                     SizedBox(width: 10), // Add some space between the text and the date picker
                    //                     DecoratedBox(
                    //                       decoration: BoxDecoration(
                    //                         border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
                    //                         borderRadius: BorderRadius.circular(10),
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                             color: const Color(0xFF418CFC).withOpacity(0.16),
                    //                             spreadRadius: 0,
                    //                             blurRadius: 6,
                    //                             offset: const Offset(0, 3),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                       child: Container(
                    //                         height: 39,
                    //                         width: 175,
                    //                         decoration: BoxDecoration(
                    //                           color: Colors.white.withOpacity(1),
                    //                           borderRadius: BorderRadius.circular(4),
                    //                         ),
                    //                         child: Column(
                    //                           children: [
                    //                             Expanded(
                    //                               child: TextFormField(
                    //                                 enabled: isEditing,
                    //                                 controller: CreatedDateController,
                    //                                 readOnly: true,
                    //                                 decoration: InputDecoration(
                    //                                   suffixIcon: Padding(
                    //                                     padding: const EdgeInsets.only(right: 20),
                    //                                     child: Padding(
                    //                                       padding: const EdgeInsets.only(top: 2, left: 10),
                    //                                       child: IconButton(
                    //                                         icon: const Padding(
                    //                                           padding: EdgeInsets.only(bottom: 16),
                    //                                           child: Icon(Icons.calendar_month),
                    //                                         ),
                    //                                         iconSize: 20,
                    //                                         onPressed: () {
                    //                                           _showDatePicker(context);
                    //                                         },
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                   hintText: _selectedDate!= null
                    //                                       ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    //                                       : 'Select Date',
                    //                                   fillColor: Colors.white,
                    //                                   contentPadding: const EdgeInsets.symmetric(
                    //                                       horizontal: 8, vertical: 8),
                    //                                   border: InputBorder.none,
                    //                                   filled: true,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
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
                    //                             enabled: isEditing,
                    //                             controller: commentsController,
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 550, top: 650),
                    //       child: SizedBox(
                    //         width: 955,
                    //         child:  Container(
                    //           width: 1252,
                    //           padding: EdgeInsets.all(0.0),
                    //           decoration: BoxDecoration(
                    //             border: Border.all(color: Colors.grey,width: 2),
                    //             borderRadius: BorderRadius.circular(5.0),
                    //           ),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left: 30, top: 10),
                    //                 child: Text(
                    //                   'Add Products',
                    //                   style: TextStyle(
                    //                     fontSize: 16,
                    //                     fontWeight: FontWeight.bold,
                    //                     color: Colors.grey[600],
                    //                   ),
                    //                 ),
                    //               ),
                    //
                    //               SizedBox(height: 0.8),
                    //               Container(
                    //                 decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                       color: Colors.grey, width: 1),
                    //                 ),
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.only(
                    //                     left: 10,
                    //                     right: 30,
                    //                     top: 10,
                    //                     bottom: 10,
                    //                   ),
                    //                   child: SizedBox(
                    //                     height: 20,
                    //                     child: Row(
                    //                       children: [
                    //                         const Padding(
                    //                           padding: EdgeInsets.only(
                    //                             left: 45,
                    //                             right: 29,
                    //                           ),
                    //                           child: Center(
                    //                             child: Text(
                    //                               'SN',
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.only(
                    //                             left: 58,
                    //                             right: 45,
                    //                           ),
                    //                           child: Center(
                    //                             child: Text(
                    //                               'Product Name',
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.only(
                    //                             left:10,
                    //                             right: 45,
                    //                           ),
                    //                           child: Center(
                    //                             child: Text(
                    //                               "Category",
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.only(
                    //                             left: 19,
                    //                             right: 35,
                    //                           ),
                    //                           child: Center(
                    //                             child: Text(
                    //                               "Sub Category",
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.only(
                    //                             left: 30,
                    //                             right: 50,
                    //                           ),
                    //                           child: Center(
                    //                             child: Text(
                    //                               "Price",
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.only(
                    //                             left: 57,
                    //                             right: 40,
                    //                           ),
                    //                           child: Center(
                    //                             child: Text(
                    //                               "QTY",
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const Padding(
                    //                           padding: EdgeInsets.only(
                    //                             left: 39,
                    //                             right: 2,
                    //                           ),
                    //                           child: Center(
                    //                             child: Text(
                    //                               "Total Amount",
                    //                               style: TextStyle(
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               ListView.builder(
                    //                 shrinkWrap: true,
                    //                 physics: const NeverScrollableScrollPhysics(),
                    //                 itemCount: selectedItems.length,
                    //                 itemBuilder: (context, index) {
                    //                   var item = selectedItems[index];
                    //                   // int index = selectedItems.indexOf(item) + 1;
                    //                   return Table(
                    //                     border: TableBorder.all(
                    //                         color: Colors.grey),
                    //                     // Add this line
                    //                     children: [
                    //                       TableRow(
                    //                         children: [
                    //                           TableCell(
                    //                             child: Padding(
                    //                               padding: EdgeInsets.only(
                    //                                   left: 10,
                    //                                   right: 10,
                    //                                   top: 10,
                    //                                   bottom: 10),
                    //                               child: Center(
                    //                                 child: Text(
                    //                                   '${index + 1}',
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           TableCell(
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(
                    //                                   left: 10,
                    //                                   right: 10,
                    //                                   top: 5,
                    //                                   bottom: 5),
                    //                               child: Container(
                    //                                 height: 35,
                    //                                 decoration: BoxDecoration(
                    //                                   color: Colors.grey[300],
                    //                                   borderRadius: BorderRadius.circular(4.0),
                    //                                 ),
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     item['productName'],
                    //                                     textAlign: TextAlign
                    //                                         .center,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           TableCell(
                    //                             child: Padding(
                    //                               padding:const EdgeInsets.only(
                    //                                   left: 10,
                    //                                   right: 10,
                    //                                   top: 5,
                    //                                   bottom: 5),
                    //                               child: Container(
                    //                                 height: 35,
                    //                                 decoration: BoxDecoration(
                    //                                   color: Colors.grey[300],
                    //                                   borderRadius: BorderRadius.circular(4.0),
                    //                                 ),
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     item['category'],
                    //                                     textAlign: TextAlign
                    //                                         .center,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           TableCell(
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(
                    //                                   left: 10,
                    //                                   right: 10,
                    //                                   top: 5,
                    //                                   bottom: 5),
                    //                               child: Container(
                    //                                 height: 35,
                    //                                 decoration: BoxDecoration(
                    //                                   color: Colors.grey[300],
                    //                                   borderRadius: BorderRadius.circular(4.0),
                    //                                 ),
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     item['subCategory'],
                    //                                     textAlign: TextAlign
                    //                                         .center,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           TableCell(
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(
                    //                                   left: 10,
                    //                                   right: 10,
                    //                                   top: 5,
                    //                                   bottom: 5),
                    //                               child: Container(
                    //                                 height: 35,
                    //                                 decoration: BoxDecoration(
                    //                                   color: Colors.grey[300],
                    //                                   borderRadius: BorderRadius.circular(4.0),
                    //                                 ),
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     item['price'].toString(),
                    //                                     textAlign: TextAlign
                    //                                         .center,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           TableCell(
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(
                    //                                   left: 10,
                    //                                   right: 10,
                    //                                   top: 5,
                    //                                   bottom: 5),
                    //                               child: Container(
                    //                                 height: 35,
                    //                                 decoration: BoxDecoration(
                    //                                   color: Colors.grey[300],
                    //                                   borderRadius: BorderRadius.circular(4.0),
                    //                                 ),
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     item['qty'].toString(),
                    //                                     textAlign: TextAlign
                    //                                         .center,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           TableCell(
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.only(
                    //                                   left: 10,
                    //                                   right: 10,
                    //                                   top: 5,
                    //                                   bottom: 5),
                    //                               child: Container(
                    //                                 height: 35,
                    //                                 decoration: BoxDecoration(
                    //                                   color: Colors.grey[300],
                    //                                   borderRadius: BorderRadius.circular(4.0),
                    //                                 ),
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     item['totalAmount'].toString(),
                    //                                     textAlign: TextAlign
                    //                                         .center,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   );
                    //                 },
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                     top: 8, left: 650, bottom: 10),
                    //                 child: Row(
                    //                   children: [
                    //                     SizedBox(width: 10),
                    //                     // add some space between the line and the text
                    //                     SizedBox(
                    //                       width: 220,
                    //                       child: Container(
                    //                         decoration: BoxDecoration(
                    //                           border: Border.all(color: Colors.blue),
                    //                         ),
                    //                         child: Padding(
                    //                           padding: const EdgeInsets.only(
                    //                             top: 10,
                    //                             bottom: 10,
                    //                             left: 5,
                    //                             right: 5,
                    //                           ),
                    //                           child: RichText(
                    //                             text: TextSpan(
                    //                               children: [
                    //                                 const TextSpan(
                    //                                   text: '         ',
                    //                                   // Add a space character
                    //                                   style: TextStyle(
                    //                                     fontSize: 10, // Set the font size to control the width of the gap
                    //                                   ),
                    //                                 ),
                    //                                 const TextSpan(
                    //                                   text: 'Total',
                    //                                   style: TextStyle(
                    //                                     fontWeight: FontWeight.bold,
                    //                                     color: Colors.blue,
                    //                                   ),
                    //                                 ),
                    //                                 const TextSpan(
                    //                                   text: '             ',
                    //                                   // Add a space character
                    //                                   style: TextStyle(
                    //                                     fontSize: 10, // Set the font size to control the width of the gap
                    //                                   ),
                    //                                 ),
                    //                                 const TextSpan(
                    //                                   text: '      ₹',
                    //                                   style: TextStyle(
                    //                                     color: Colors.black,
                    //                                   ),
                    //                                 ),
                    //                                 TextSpan(
                    //                                   text: totalController.text,
                    //                                   style: const TextStyle(
                    //                                     color: Colors.black,
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               )
                    //
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //updated naveen
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 550, top: 700),
                    //       child: SizedBox(
                    //         width: 955,
                    //         child: Card(
                    //           color: Colors.white,
                    //           child: Container(
                    //             width: 1252,
                    //             padding: const EdgeInsets.all(0.0),
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.grey, width:
                    //               2),
                    //               borderRadius: BorderRadius.circular(5.0),
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(left: 30, top: 10),
                    //                   child: Text(
                    //                     'Add Parts',
                    //                     style: TextStyle(
                    //                       fontSize: 16,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.grey[600],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   decoration: BoxDecoration(
                    //                     border: Border.all(
                    //                         color: Colors.grey, width: 1),
                    //                   ),
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.only(
                    //                       left: 10,
                    //                       right: 30,
                    //                       top: 10,
                    //                       bottom: 10,
                    //                     ),
                    //                     child: SizedBox(
                    //                       height: 20,
                    //                       child: Row(
                    //                         children: [
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(
                    //                               left: 39,
                    //                               right: 29,
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 'SN',
                    //                                 style: TextStyle(
                    //                                   fontWeight: FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(
                    //                               left: 50,
                    //                               right: 45,
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 'Product Name',
                    //                                 style: TextStyle(
                    //                                   fontWeight: FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(
                    //                               left: 10,
                    //                               right: 45,
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 "Category",
                    //                                 style: TextStyle(
                    //                                   fontWeight: FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(
                    //                               left: 10  ,
                    //                               right: 35,
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 "Sub Category",
                    //                                 style: TextStyle(
                    //                                   fontWeight: FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(
                    //                               left: 15,
                    //                               right: 50,
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 "Price",
                    //                                 style: TextStyle(
                    //                                   fontWeight: FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(
                    //                               left: 60,
                    //                               right: 40,
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 "QTY",
                    //                                 style: TextStyle(
                    //                                   fontWeight: FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                           const Padding(
                    //                             padding: EdgeInsets.only(
                    //                               left: 25,
                    //                               right: 2,
                    //                             ),
                    //                             child: Center(
                    //                               child: Text(
                    //                                 "Total Amount",
                    //                                 style: TextStyle(
                    //                                   fontWeight: FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 ListView.builder(
                    //                   shrinkWrap: true,
                    //                   physics: const NeverScrollableScrollPhysics(),
                    //                   itemCount: selectedItems.length,
                    //                   itemBuilder: (context, index) {
                    //                     var item = selectedItems[index];
                    //                     // int index = selectedItems.indexOf(item) + 1;
                    //                     return Table(
                    //                       border: TableBorder.all(
                    //                           color: Colors.grey),
                    //                       // Add this line
                    //                       children: [
                    //                         TableRow(
                    //                           children: [
                    //                             TableCell(
                    //                               child: Padding(
                    //                                 padding: EdgeInsets.only(
                    //                                     left: 10,
                    //                                     right: 10,
                    //                                     top: 10,
                    //                                     bottom: 10),
                    //                                 child: Center(
                    //                                   child: Text(
                    //                                     '$index',
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             TableCell(
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets.only(
                    //                                     left: 10,
                    //                                     right: 10,
                    //                                     top: 5,
                    //                                     bottom: 5),
                    //                                 child: Container(
                    //                                   height: 35,
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.grey[300],
                    //                                     borderRadius: BorderRadius.circular(4.0),
                    //                                   ),
                    //                                   child: Center(
                    //                                     child: Text(
                    //                                       item['productName'],
                    //                                       textAlign: TextAlign
                    //                                           .center,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             TableCell(
                    //                               child: Padding(
                    //                                 padding:const EdgeInsets.only(
                    //                                     left: 10,
                    //                                     right: 10,
                    //                                     top: 5,
                    //                                     bottom: 5),
                    //                                 child: Container(
                    //                                   height: 35,
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.grey[300],
                    //                                     borderRadius: BorderRadius.circular(4.0),
                    //                                   ),
                    //                                   child: Center(
                    //                                     child: Text(
                    //                                       item['category'],
                    //                                       textAlign: TextAlign
                    //                                           .center,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             TableCell(
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets.only(
                    //                                     left: 10,
                    //                                     right: 10,
                    //                                     top: 5,
                    //                                     bottom: 5),
                    //                                 child: Container(
                    //                                   height: 35,
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.grey[300],
                    //                                     borderRadius: BorderRadius.circular(4.0),
                    //                                   ),
                    //                                   child: Center(
                    //                                     child: Text(
                    //                                       item['subCategory'],
                    //                                       textAlign: TextAlign
                    //                                           .center,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             TableCell(
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets.only(
                    //                                     left: 10,
                    //                                     right: 10,
                    //                                     top: 5,
                    //                                     bottom: 5),
                    //                                 child: Container(
                    //                                   height: 35,
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.grey[300],
                    //                                     borderRadius: BorderRadius.circular(4.0),
                    //                                   ),
                    //                                   child: Center(
                    //                                     child: Text(
                    //                                       item['price'].toString(),
                    //                                       textAlign: TextAlign
                    //                                           .center,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             TableCell(
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets.only(
                    //                                     left: 10,
                    //                                     right: 10,
                    //                                     top: 5,
                    //                                     bottom: 5),
                    //                                 child: Container(
                    //                                   height: 35,
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.grey[300],
                    //                                     borderRadius: BorderRadius.circular(4.0),
                    //                                   ),
                    //                                   child: Center(
                    //                                     child: Text(
                    //                                       item['qty'].toString(),
                    //                                       textAlign: TextAlign
                    //                                           .center,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             TableCell(
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets.only(
                    //                                     left: 10,
                    //                                     right: 10,
                    //                                     top: 5,
                    //                                     bottom: 5),
                    //                                 child: Container(
                    //                                   height: 35,
                    //                                   decoration: BoxDecoration(
                    //                                     color: Colors.grey[300],
                    //                                     borderRadius: BorderRadius.circular(4.0),
                    //                                   ),
                    //                                   child: Center(
                    //                                     child: Text(
                    //                                       item['totalAmount'].toString(),
                    //                                       textAlign: TextAlign
                    //                                           .center,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     );
                    //                   },
                    //                 ),
                    //                 // const Divider(color: Colors.grey,),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 8,left: 650,bottom: 10),
                    //                   child: Row(
                    //                     children: [
                    //                       SizedBox(width: 10), // add some space between the line and the text
                    //                       SizedBox(
                    //                         width: 220,
                    //                         child: Container(
                    //                           decoration: BoxDecoration(
                    //                             border: Border.all(color: Colors.blue),
                    //                           ),
                    //                           child: Padding(
                    //                             padding: const EdgeInsets.only(
                    //                               top: 10,
                    //                               bottom: 10,
                    //                               left: 5,
                    //                               right: 5,
                    //                             ),
                    //                             child: RichText(
                    //                               text: TextSpan(
                    //                                 children: [
                    //                                   const TextSpan(
                    //                                     text: '         ', // Add a space character
                    //                                     style: TextStyle(
                    //                                       fontSize: 10, // Set the font size to control the width of the gap
                    //                                     ),
                    //                                   ),
                    //                                   const TextSpan(
                    //                                     text: 'Total',
                    //                                     style: TextStyle(
                    //                                       fontWeight: FontWeight.bold,
                    //                                       color: Colors.blue,
                    //                                     ),
                    //                                   ),
                    //                                   const TextSpan(
                    //                                     text: '             ', // Add a space character
                    //                                     style: TextStyle(
                    //                                       fontSize: 10, // Set the font size to control the width of the gap
                    //                                     ),
                    //                                   ),
                    //                                   const TextSpan(
                    //                                     text: '      ₹',
                    //                                     style: TextStyle(
                    //                                       color: Colors.black,
                    //                                     ),
                    //                                   ),
                    //                                   TextSpan(
                    //                                     text: totalController.text,
                    //                                     style: const TextStyle(
                    //                                       color: Colors.black,
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 )
                    //
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

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
    print ('--------deliver');
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

}


Widget _buildCheckboxItem(
    String title, bool? isChecked, String content, Function(bool?) onChanged) {
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
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.all(8.0),
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
double calculateTotalAmount(Map<String, dynamic> item) {
  double price = item['price'];
  int qty = item['qty'];
  double totalAmount = price * qty;
  return item['totalAmount'] = totalAmount;
}

