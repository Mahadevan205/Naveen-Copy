import 'dart:html';
import 'package:btb/Order%20Module/add%20productmaster%20sample.dart';
import 'package:btb/Order%20Module/eighthpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import '../screen/login.dart';
import '../screen/dashboard.dart';
import 'firstpage.dart';



class SixthPage extends StatefulWidget {
  final detail? product;
  final List<dynamic>? orderDetails;
  final Map<String, dynamic>? storeStaticData;
  final List<Map<String, dynamic>>? item;
  final Map<String, dynamic>? body;
  final List<Map<String, dynamic>>? itemsList;


  const SixthPage({super.key, required this.product, this.item, this.body, this.itemsList,this.storeStaticData,this.orderDetails});





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
  String _searchText = '';
  bool _isFirstLoad = true;
  bool _loading = false;
  bool isEditing = false;
  final TextEditingController deliveryLocationController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = [];
  //List<dynamic> selectedItems = [];
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
  int _selectedIndex = -1;
  //List<Map<String, dynamic>> _orders = [];
  List<bool> _isSelected = [];
  List<OrderDetails> _searchResults = [];
  bool _firstTimeSort = true;
  // List<bool> _isSelected = [];
  List<bool> _isBlinked = [];
  List<Map<String, dynamic>> _sortedOrders = [];
  // String _selectedIndex = '';
  late TextEditingController _dateController;
  bool? _isChecked3 = false;
  bool? _isChecked4 = false;
  final TextEditingController totalAmountController = TextEditingController();
  bool isOrdersSelected = false;
  String _errorMessage = '';
  //String sam = 'ORD_02112';
  bool _isFirstMove = true;


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
    print('from firstpage');
    print(widget.orderDetails);
    //orderIdController.text = _isSelected as String;
    // _isSelected = List<bool>.filled(widget.orderDetails!.length, false);
//original
    _isSelected = List<bool>.filled(widget.orderDetails!.length, false);


    _orderIdController.addListener(() {
      _fetchOrders();
      });
    print('--ordermodule data sixthpage');

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
      print('-----orderId');
      //List<bool> orderId = (_selectedOrder.orderId ?? '') as List<bool>;

      //print(orderId);


      //List<bool> _isSelected = List<bool>.filled(orderId.length, false);
      // print(_isSelected);
      print('selectinde');
      print(_selectedIndex);

      print(_isSelected);
    } else {
      print('Product is null');
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
    //   _orderIdController.removeListener(_fetchOrders);
    _dateController.dispose();

    super.dispose();
  }
//this is the original
  Future<void> _fetchOrders() async {
    setState(() {
      _loading = true;
      _orders = []; // clear the orders list
      _errorMessage = ''; // clear the error message
    });
    try {
      final orderId = orderIdController.text
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
        print('-res--');
        print(responseBody);
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
            _showProductDetails(orderDetails);
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
                  //    fontSize: 16,// fontWeight: FontWeight.bold,
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
                        child:
                        DropdownButtonFormField<String>(
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onChanged: isEditing ? (String? value) {
                            setState(() {
                              data2['deliveryLocation'] = value!;
                            });
                          } : null, // Disable onChanged if not in editing mode
                          items: list.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              enabled: isEditing, // Disable items if not in editing mode
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          isExpanded: true,
                          iconDisabledColor: Colors.grey,
                          isDense: true,
                          selectedItemBuilder: (BuildContext context) {
                            return list.map((String value) {
                              return Text(
                                data2['deliveryLocation'] != null &&
                                    list.contains(data2['deliveryLocation'])
                                    ? data2['deliveryLocation']
                                    : 'Select Location',
                                style: TextStyle(color: Colors.grey),
                              );
                            }).toList();
                          },
                        )

                        // DropdownButtonFormField<String>(
                        //   value: data2['deliveryLocation'] != null &&
                        //       list.contains(data2['deliveryLocation'])
                        //       ? data2['deliveryLocation']
                        //       : null,
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //
                        //     fillColor: Colors.grey.shade200,
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(5.0),
                        //       borderSide: BorderSide.none,
                        //     ),
                        //     hintText: 'Select Location',
                        //     contentPadding:const EdgeInsets.symmetric(
                        //         horizontal: 8, vertical: 8),
                        //   ),
                        //   onChanged: (String? value) {
                        //     setState(() {
                        //       data2['deliveryLocation'] = value!;
                        //     });
                        //   },
                        //   items: list.map<DropdownMenuItem<String>>((String value) {
                        //     return DropdownMenuItem<String>(
                        //       enabled: isEditing,
                        //      value: value,
                        //      child: Text(value),
                        //     );
                        //   }).toList(),
                        //   isExpanded: true,
                        //   iconDisabledColor: Colors.red,
                        // ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding:  EdgeInsets  .only(left: 30),
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
                                  context.go('/Order_List');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const Orderspage()),
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
                              const Padding(
                                padding: EdgeInsets.only(left: 150),
                                child: Text('Order ID :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              ),
                            const SizedBox(width:8),
                          Text((orderIdController.text),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                            //  Text(orderIdController.text),
                              const SizedBox(width: 10,),
                              const Spacer(),
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
                                    Map<String, dynamic> orderDetailsMap = widget.orderDetails!.map((e) => e.toJson()).toList().asMap().cast<String, String>();

                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                            SelectedProductPage(
                                              data: data,
                                              selectedProducts: const [],
                                              orderDetails: orderDetailsMap,
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
                                    context.go('/Download');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const EighthPage()),
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
                        color: const Color(0xFFFFFFFF),
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
                                    //controller: _orderIdController,
                                    // Assign the controller to the TextFormField
                                    decoration: const InputDecoration(
                                      // labelText: 'Order ID',
                                      hintText: 'Search Order',
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.search_outlined),
                                    ),
                                    onChanged: (value) {
                                         setState(() {
                                            _searchText = value.toLowerCase();
                                          });
                                       },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Column(
                                children: [
                                  _loading
                                      ? const Center(child: CircularProgressIndicator(strokeWidth: 4))
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
                                          duration: const Duration(milliseconds: 200),
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

                            ],

                          ),
                        ),
                      ),

                    ),
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
                    Padding(
                      padding:  const EdgeInsets.only(left: 550, top: 700,right: 120),
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
                                  // Add this line
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
                                  padding: const EdgeInsets.only(left: 15,right: 10,top: 2,bottom: 2),
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

  void _showProductDetails(OrderDetail selectedOrderDetails) {
    //final selectedOrderDetails = widget.orderDetails![selectedOrderDetails];
    //final selectedOrderDetails = _orders[index];
    print('Selected Order:');
    print('Order ID: ${selectedOrderDetails.orderId}');
    print('Order Date: ${selectedOrderDetails.orderDate}');
    print('Contact Person: ${selectedOrderDetails.contactPerson}');
    print('Delivery Location: ${selectedOrderDetails.deliveryLocation}');
    print('total: ${selectedOrderDetails.total}');

    data2['deliveryLocation'] = selectedOrderDetails.deliveryLocation;
    print('--------deliver');
    print(data2['deliveryLocation']);

    print(productNameController.text);
    CreatedDateController.text = selectedOrderDetails.orderDate!;
    orderIdController.text = selectedOrderDetails.orderId!;
    deliveryLocationController.text = selectedOrderDetails.deliveryLocation!;
    contactPersonController.text = selectedOrderDetails.contactPerson!;
    deliveryAddressController.text = selectedOrderDetails.deliveryAddress!;
    contactNumberController.text = selectedOrderDetails.contactNumber!;
    commentsController.text = selectedOrderDetails.comments!;
    totalController.text = selectedOrderDetails.total.toString()!;
    // contactPersonController.text = _orders[index]['orderDate'];
    // deliveryLocationController.text = _orders[selectedOrderDetails]['deliveryLocation'];
    print('------------devli');
    print(data2['deliveryLocation']);
    final selectedOrder = selectedOrderDetails;
    setState(() {
      selectedItems = List<Map<String, dynamic>>.from(selectedOrder.items);
    });

    print('Selected Order:');
    print('Order ID: ${selectedOrder.orderId}');
    print('Order Date: ${selectedOrder.orderDate}');
    print('Contact Person: ${selectedOrder.contactPerson}');
    print('Delivery Location: ${selectedOrder.deliveryLocation}');
    print('total: ${selectedOrder.total}');

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

}

class OrderDetails {
  String orderId;
  String orderDate;
  String contactPerson;
  String deliveryLocation;
  double total;
  List<OrderItem> items;

  OrderDetails({
    required this.orderId,
    required this.orderDate,
    required this.contactPerson,
    required this.deliveryLocation,
    required this.total,
    required this.items,
  });
}

class OrderItem {
  String productName;
  double price;
  int qty;
  String category;
  String subCategory;
  double totalAmount;
  String orderMasterItemId;

  OrderItem({
    required this.productName,
    required this.price,
    required this.qty,
    required this.category,
    required this.subCategory,
    required this.totalAmount,
    required this.orderMasterItemId,
  });
}

