import 'dart:convert';
import 'dart:html';
import 'package:btb/Order%20Module/eighthpage.dart';
import 'package:btb/Order%20Module/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import '../screen/login.dart';
import '../screen/dashboard.dart';




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



  @override
  void dispose() {
    //_orderIdController.removeListener(_fetchOrders);
    _dateController.dispose();
    super.dispose();
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
        print(responseBody);
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onChanged: isEditing ? (String? value) {
                            setState(() {
                              data2['deliveryLocation'] = value!;
                            });
                          } : null, // Disable changing selection if not in editing mode
                          items: list.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          isExpanded: true,
                        ),

                        //                     DropdownButtonFormField<String>(
    //                       value: data2['deliveryLocation'] != null &&
    //                                                list.contains(data2['deliveryLocation'])
    //                                                ? data2['deliveryLocation']
    //                                                : null,
    //                       decoration: InputDecoration(
    //                         filled: true,
    //
    //                         fillColor: Colors.grey.shade200,
    //                         border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(5.0),
    //                           borderSide: BorderSide.none,
    //                         ),
    //                         hintText: 'Select Location',
    //                         contentPadding:const EdgeInsets.symmetric(
    //                             horizontal: 8, vertical: 8),
    //                       ),
    //                       onChanged: (String? value) {
    // setState(() {
    //                          data2['deliveryLocation'] = value!;
    //                        });
    //                       },
    //                       items: list.map<DropdownMenuItem<String>>((String value) {
    //                         return DropdownMenuItem<String>(
    //                           enabled: isEditing,
    //                           value: value,
    //                           child: Text(value),
    //                         );
    //                       }).toList(),
    //                       isExpanded: true,
    //                     ),
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
                    SizedBox(
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
        )


    );
  }

  void _showProductDetails(OrderDetail orderDetails) {
    print('Selected Order:');
    print('Order ID: ${orderDetails.orderId}');
    print('Order Date: ${orderDetails.orderDate}');
    print('Contact Person: ${orderDetails.contactPerson}');
    print('Delivery Location: ${orderDetails.deliveryLocation}');
    print('total: ${orderDetails.total}');

    data2['deliveryLocation'] = orderDetails.deliveryLocation;
    print ('--------deliver');
    print(data2['deliveryLocation']);

    print(productNameController.text);
    CreatedDateController.text = orderDetails.orderDate!;
    orderIdController.text = orderDetails.orderId!;
    deliveryLocationController.text = orderDetails.deliveryLocation!;
    contactPersonController.text = orderDetails.contactPerson!;
    deliveryAddressController.text = orderDetails.deliveryAddress!;

    contactNumberController.text = orderDetails.contactNumber!;
    commentsController.text = orderDetails.comments!;
    totalController.text = orderDetails.total.toString();
    // contactPersonController.text = orderDetails.orderDate;
    deliveryLocationController.text = orderDetails.deliveryLocation!;
    print('------------devli');
    print(data2['deliveryLocation']);

    setState(() {
      selectedItems = List<Map<String, dynamic>>.from(orderDetails.items);
    });

    print('Selected Order:');
    print('Order ID: ${orderDetails.orderId}');
    print('Order Date: ${orderDetails.orderDate}');
    print('Contact Person: ${orderDetails.contactPerson}');
    print('Delivery Location: ${orderDetails.deliveryLocation}');
    print('total: ${orderDetails.total}');

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
  //old copy
  // void _showProductDetails(int index) {
  //   final selectedOrderDetails = _orders[index];
  //   print('Selected Order:');
  //   print('Order ID: ${selectedOrderDetails['orderId']}');
  //   print('Order Date: ${selectedOrderDetails['orderDate']}');
  //   print('Contact Person: ${selectedOrderDetails['contactPerson']}');
  //   print('Delivery Location: ${selectedOrderDetails['deliveryLocation']}');
  //   print('total: ${selectedOrderDetails['total']}');
  //
  //   data2['deliveryLocation'] = selectedOrderDetails['deliveryLocation'];
  //   print ('--------deliver');
  //   print(data2['deliveryLocation']);
  //
  //
  //   print(productNameController.text);
  //   CreatedDateController.text = _orders[index]['orderDate'];
  //   orderIdController.text = _orders[index]['orderId'];
  //   deliveryLocationController.text = _orders[index]['deliveryLocation'];
  //   contactPersonController.text = _orders[index]['contactPerson'];
  //   deliveryAddressController.text = _orders[index]['deliveryAddress'];
  //
  //   contactNumberController.text = _orders[index]['contactNumber'];
  //   commentsController.text = _orders[index]['comments'];
  //   totalController.text = _orders[index]['total'].toString();
  //   // contactPersonController.text = _orders[index]['orderDate'];
  //   deliveryLocationController.text = _orders[index]['deliveryLocation'];
  //   print('------------devli');
  //   print(data2['deliveryLocation']);
  //   final selectedOrder = _orders[index];
  //   setState(() {
  //     selectedItems = List<Map<String, dynamic>>.from(selectedOrder['items']);
  //   });
  //
  //   print('Selected Order:');
  //   print('Order ID: ${selectedOrder['orderId']}');
  //   print('Order Date: ${selectedOrder['orderDate']}');
  //   print('Contact Person: ${selectedOrder['contactPerson']}');
  //   print('Delivery Location: ${selectedOrder['deliveryLocation']}');
  //   print('total: ${selectedOrder['total']}');
  //
  //   for (var item in selectedItems) {
  //     print('Product Name: ${item['productName']}');
  //     print('Price: ${item['price']}');
  //     print('Quantity: ${item['qty']}');
  //     print('Category: ${item['category']}');
  //     print('Sub Category: ${item['subCategory']}');
  //     print('Total Amount: ${item['totalAmount']}');
  //     print('------------------------');
  //
  //     // Add more fields to print as needed
  //   }
  // }

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

