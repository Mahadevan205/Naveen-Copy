import 'dart:convert';
import 'dart:html';
import 'package:btb/Return%20Module/return%20image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Product Module/Product Screen.dart';
import '../screen/login.dart';
import '../sprint 2 order/firstpage.dart';
import 'package:http/http.dart' as http;
import '../dashboard.dart';


class CreateReturn extends StatefulWidget {
  final String storeImage;
  List<String>? imageSizeString;
 // String? imageSizeString;
  //Color myColor = Color(0xFF428DFC);
  final List<dynamic> orderDetails;
   final List<String> storeImages;
  final Map<String, dynamic> orderDetailsMap;
   final List<String> imageSizeStrings;

   CreateReturn({super.key, required this.orderDetailsMap,required this.storeImage,this.imageSizeString,required this.imageSizeStrings,required this.storeImages,required this.orderDetails
  });
  @override
  State<CreateReturn> createState() {
    return _CreateReturnState();
  }
}

class _CreateReturnState extends State<CreateReturn> {

  String? _selectedReason;
  final _controller = TextEditingController();
  List<dynamic> _orderDetails = [];
  String _enteredValues = '';
  final List<String> list = [
    'Reason for return',' Option 1', '  Option 2'];
  int Index =1 ;
  bool isOrdersSelected = false;
  double totalAmount = 0.0;
  final totalController = TextEditingController();
  List<String> storeImages = [];
  List<String> imageSizeStrings = [];
  final TextEditingController NotesController = TextEditingController();
  final TextEditingController EmailAddressController = TextEditingController();
  final TextEditingController ContactpersonController = TextEditingController();
  final _reasonController = TextEditingController();

  //int totalAmount = 0;


  String _enteredValue = '';

  String token = window.sessionStorage["token"] ?? " ";
  double _totalAmount = 0;
  //String token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkaGFuYXNla2FyIiwiUm9sZXMiOlt7ImF1dGhvcml0eSI6ImRldmVsb3BlciJ9XSwiZXhwIjoxNzIxNjMwNDQ5LCJpYXQiOjE3MjE2MjMyNDl9.xLgmiyPCmi2spO9JrevsL--RWUPlpoThuK_v1tuaD8tqr-vb1uPMSlRgqvQHIXDBzN57kfZNhvvyTHKdWtUqqA';




  Future<void> _fetchOrderDetails() async {
    final orderId = _controller.text.trim();
    final url = orderId.isEmpty
        ? 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/get_all_ordermaster/'
        : 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/search_by_orderid/$orderId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Response: $jsonData');
      final orderData = jsonData.firstWhere(
              (order) => order['orderId'] == orderId, orElse: () => null);

      if (orderData != null) {
        setState(() {
          _orderDetails = orderData['items'].map((item) => {
            'productName': item['productName'],
            'qty': item['qty'],
            'totalAmount': item['totalAmount'],
            'price': item['price'],
            'category': item['category'],
            'subCategory': item['subCategory']
          }).toList();
        });
      } else {
        setState(() {
          _orderDetails = [{'productName': 'not found'}];
        });
      }
    } else {
      setState(() {
        _orderDetails = [{'productName': 'Error fetching order details'}];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('----design');
    print(widget.orderDetailsMap);
    print(widget.orderDetailsMap['emailAddress']);

    if(_reasonController.text.isEmpty){
      _reasonController.text.isEmpty ? 'Reason for return' : _reasonController.text;
    }


    if(widget.storeImage == 'hi'){
      EmailAddressController.text = widget.orderDetailsMap['emailAddress'];
      ContactpersonController.text = widget.orderDetailsMap['contactPerson'];
      _selectedReason = widget.orderDetailsMap['reason'];
      _controller.text =widget.orderDetailsMap['otherField'];
      _orderDetails = widget.orderDetailsMap['orderDetails'];
      totalController.text = widget.orderDetailsMap['totalAmount2'];
      // =;

      //print(orderDetailsMap);
      print('--dropdown value');
      print(widget.imageSizeString);
      print(widget.imageSizeStrings);
      print(widget.storeImages);

      //calculateTotal();

    }

  }



  Future<void> addReturnMaster() async {
    final apiUrl = 'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/return_master/add_return_master';
    // final token = ''; // Replace with your actual token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    List<Map<String, dynamic>> items = [];

    for (var item in _orderDetails) {
      items.add({
        "category": item['category'],
        "creditRequest": item['totalAmount2'],
        "imageId": item['imageId'],
        "invoiceAmount": item['totalAmount'],
        "price": item['price'],
        "productName": item['productName'],
        "qty": item['qty'],
        "returnQty": item['enteredQty'],
        "subCategory": item['subCategory'],
      });
    }

    final requestBody = {
      "contactPerson": ContactpersonController.text,
      "email": EmailAddressController.text,
      "invoiceNumber": _controller.text,
      "notes": NotesController.text,
      "reason": _reasonController.text,
      "totalCredit": totalController.text,
      "items": items,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Return Master added successfully');
    } else {
      print('Error: ${response.statusCode}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                child:
                PopupMenuButton<String>(
                  icon: const Icon(Icons.account_circle),
                  onSelected: (value) {
                    if (value == 'logout') {
                      window.sessionStorage.remove('token');
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
            return Stack(
              //   crossAxisAlignment: CrossAxisAlignment.start,
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
                            context.go('/Dashboard');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation,
                                    secondaryAnimation) =>
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
                            // context.go('${PageName.dashboardRoute}');
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Dashboard()),
                            // );
                            // Navigator.pushReplacementNamed(
                            //     context, PageName.dashboardRoute);
                            // context
                            //     .go('${PageName.main} / ${PageName.subpage1Main}');
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
                            context.go('/Product_List');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation,
                                    secondaryAnimation) =>
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

                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation,
                                    secondaryAnimation) =>
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
                    left: 200,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child:
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.white,
                            height: 40,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 30,top: 5),
                                  child: Text(
                                    'Order Return',
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
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 90),
                                    child: OutlinedButton(
                                      onPressed: () async{
                                        await addReturnMaster();
                                        // context.go(
                                        //     '${PageName.dashboardRoute}/${PageName.subpage1}');
                                        //router
                                        // context.go('/Create_Order');
                                        // Navigator.push(
                                        //   context,
                                        //   PageRouteBuilder(
                                        //     pageBuilder: (context, animation,
                                        //         secondaryAnimation) =>
                                        //         CreateReturn(storeImage: widget.storeImage,imageSizeString: widget.imageSizeString,),
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
                                        'Create Return',
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
                          Padding(
                            padding: const EdgeInsets.only(top: 0, left: 0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5),
                              // Space above/below the border
                              height: 3, // Border height
                              color: Colors.grey[100], // Border color
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50,right: 100,top: 50),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFB2C2D3), width: 2),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF00000029),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                                color: const Color(0xFFFFFFFF),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Invoice Number'),
                                              const SizedBox(height: 5,),
                                              SizedBox(
                                                height: 40,
                                                child: TextFormField(
                                                  controller: _controller,
                                                  onEditingComplete: _fetchOrderDetails,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
                                                      fillColor: Colors.grey.shade200,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      hintText: 'INV1900039'

                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Reason'),
                                              const SizedBox(height: 5,),
                                              SizedBox(
                                                height: 40,
                                                child:
                                                DropdownButtonFormField<String>(
                                                  value: _selectedReason,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey.shade200,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      borderSide: BorderSide.none, // Remove border by setting borderSide to BorderSide.none
                                                    ),
                                                    contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 8),
                                                  ),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _selectedReason = value!;
                                                      _reasonController.text = value;
                                                    });
                                                  },
                                                  items: list.map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  isExpanded: true,
                                                  hint: const Text('Reason for return'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: Column(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       Text('Reason'),
                                        //       SizedBox(height: 5,),
                                        //       SizedBox(
                                        //         height: 40,
                                        //         child:
                                        //         DropdownButtonFormField<String>(
                                        //           value:   _reasonController.text.isEmpty ? 'Reason for return' : _reasonController.text,
                                        //           // value: _reasonController.text ?? 'Select a reason',
                                        //
                                        //           decoration: InputDecoration(
                                        //             filled: true,
                                        //             fillColor: Colors.grey.shade200,
                                        //             border: OutlineInputBorder(
                                        //               borderRadius: BorderRadius.circular(5.0),
                                        //               borderSide: BorderSide.none,
                                        //             ),
                                        //             hintText: 'Option 1',
                                        //             contentPadding:const EdgeInsets.symmetric(
                                        //                 horizontal: 8, vertical: 8),
                                        //           ),
                                        //           onChanged: (String? value) {
                                        //             setState(() {
                                        //               _reasonController.text = value!;
                                        //             });
                                        //           },
                                        //           items: list.map<DropdownMenuItem<String>>((String value) {
                                        //             return DropdownMenuItem<String>(
                                        //               value: value,
                                        //               child: Text(value),
                                        //             );
                                        //           }).toList(),
                                        //           isExpanded: true,
                                        //         ),
                                        //         // DropdownButtonFormField(
                                        //         //   decoration: InputDecoration(
                                        //         //     filled: true,
                                        //         //     fillColor: Colors.grey.shade200,
                                        //         //     border: OutlineInputBorder(
                                        //         //       borderRadius: BorderRadius.circular(5.0),
                                        //         //       borderSide: BorderSide.none,
                                        //         //     ),
                                        //         //     hintText: 'Reason For Return',                                                    ),
                                        //         //   items: [
                                        //         //     DropdownMenuItem(
                                        //         //       child: Text('Option 1'),
                                        //         //       value: 'Option 1',
                                        //         //     ),
                                        //         //     DropdownMenuItem(
                                        //         //       child: Text('Option 2'),
                                        //         //       value: 'Option 2',
                                        //         //     ),
                                        //         //
                                        //         //     // Add more options as needed
                                        //         //   ],
                                        //         //   isExpanded: true,
                                        //         //   onChanged: (value) {
                                        //         //     _reasonController.text = value!;
                                        //         //     print('reason');
                                        //         //     print(_reasonController.text);
                                        //         //   },
                                        //         // ),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Contact Person'),
                                              const SizedBox(height: 5,),
                                              SizedBox(
                                                height: 40,
                                                child: TextFormField(
                                                  controller: ContactpersonController,
                                                  decoration:  InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.grey.shade200,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
                                                      hintText: 'Person Name'


                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Email'),
                                              const SizedBox(height: 5,),
                                              SizedBox(
                                                height: 40,
                                                child: TextFormField(
                                                controller: EmailAddressController,
                                                  decoration:  InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.grey.shade200,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
                                                      hintText: 'Person Email'

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
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 50,right: 100,top: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(color: const Color(0xFFB2C2D3), width: 2),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF00000029),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10,left: 30),
                                    child: Text(
                                      'Add Products',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Titillium Web',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: maxWidth,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFB2C2D3),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                      child: Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(3),
                                          2: FlexColumnWidth(2),
                                          3: FlexColumnWidth(2),
                                          4: FlexColumnWidth(2),
                                          5: FlexColumnWidth(1),
                                          6: FlexColumnWidth(1.2),
                                          7: FlexColumnWidth(2),
                                          8: FlexColumnWidth(2),
                                        },
                                        children: const [
                                          TableRow(
                                              children: [
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "SN",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        //  fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      'Product Name',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        //  fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "Category",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        // fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "Sub Category",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        // fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "Price",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        // fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "QTY",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        // fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "Return QTY",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        //  fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "Invoice Amount",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        //  fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                                TableCell(child: Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: Center(
                                                    child: Text(
                                                      "Credit Request",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        // fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),),
                                              ]
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   width: maxWidth,
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //       color: Color(0xFFB2C2D3),
                                  //       width: 1.2,
                                  //
                                  //     ),
                                  //
                                  //   ),
                                  //   child: const Padding(
                                  //     padding: EdgeInsets.only(
                                  //       top: 5,
                                  //       bottom: 5,
                                  //     ),
                                  //     child: SizedBox(
                                  //       height: 34,
                                  //       child: Row(
                                  //         children: [
                                  //           Expanded(
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 80,right: 25),
                                  //               child: Text(
                                  //                 "SN",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 26,right: 10),
                                  //               child: Text(
                                  //                 'Product Name',
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //
                                  //             child: Padding(padding: EdgeInsets.only(left: 52,right: 15),
                                  //               child: Text(
                                  //                 "Category",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left:
                                  //               45,right: 5),
                                  //               child: Text(
                                  //                 "Sub Category",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 65,right: 10),
                                  //               child: Text(
                                  //                 "Price",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 65,right: 25),
                                  //               child: Text(
                                  //                 "QTY",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 40,right: 25),
                                  //               child: Text(
                                  //                 "Return QTY",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Expanded(
                                  //
                                  //             child: Padding(
                                  //               padding: EdgeInsets.only(left: 25,right: 25),
                                  //               child: Text(
                                  //                 "Invoice Amount",
                                  //                 style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,fontSize: 12
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Padding(
                                  //             padding: EdgeInsets.only(left: 25,right: 5),
                                  //             child: Center(
                                  //               child: Text("Credit Request ",style: TextStyle(
                                  //                 fontWeight: FontWeight.bold,fontSize: 12
                                  //               ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           Padding(
                                  //             padding: EdgeInsets.only(left: 10,right: 5),
                                  //             child: Center(
                                  //               child: Text(" ",style: TextStyle(
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _orderDetails.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> item = _orderDetails[index];
                                      return Table(
                                        border: TableBorder.all(color: Colors.blue),
                                          //  Color(0xFFFFFFFF)
                                          columnWidths: const {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(3),
                                          2: FlexColumnWidth(2),
                                          3: FlexColumnWidth(2),
                                          4: FlexColumnWidth(2),
                                          5: FlexColumnWidth(1),
                                          6: FlexColumnWidth(1.2),
                                            7: FlexColumnWidth(2),
                                            8: FlexColumnWidth(2),
                                          },

                                        children: [
                                          TableRow(
                                              children:[
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
                                                    //  alignment: Alignment.center, // Add this line
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 0),
                                                        child: TextFormField(
                                                          initialValue: (item['enteredQty']?? '').toString(),
                                                          textAlign: TextAlign.center, // Center alignment
                                                          decoration: const InputDecoration(
                                                              border: InputBorder.none, // Remove underline
                                                              contentPadding: EdgeInsets.only(
                                                                  bottom: 12
                                                              )
                                                              //contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 8) // Set content padding
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              if (value.isEmpty) {
                                                                item['enteredQty'] = 0;
                                                                item['totalAmount2'] = 0;
                                                              } else {
                                                                item['enteredQty'] = int.parse(value);
                                                                if (item['enteredQty'] > (item['qty']?? 0)) {
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    const SnackBar(content: Text('Please enter a valid quantity')),
                                                                  );
                                                                } else {
                                                                  item['totalAmount2'] = item['price'] * item['enteredQty'];
                                                                }
                                                              }
                                                              // calculate the total amount
                                                              totalAmount = _orderDetails.fold(0.0, (sum, item) => sum + (item['totalAmount2']?? 0));
                                                              totalController.text = totalAmount.toStringAsFixed(2); // update the totalController
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // TableCell(
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                //     child: Container(
                                                //       height: 35,
                                                //       width: 50,
                                                //       decoration: BoxDecoration(
                                                //         color: Colors.grey[300],
                                                //         borderRadius: BorderRadius.circular(4.0),
                                                //       ),
                                                //       child: Center(
                                                //         child: TextFormField(
                                                //           initialValue: (item['enteredQty']?? '').toString(),
                                                //           textAlign: TextAlign.center, // Center alignment
                                                //           decoration: const InputDecoration(
                                                //             border: InputBorder.none, // Remove underline
                                                //             contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 8) // Set content padding
                                                //           ),
                                                //           onChanged: (value) {
                                                //             setState(() {
                                                //               if (value.isEmpty) {
                                                //                 item['enteredQty'] = 0;
                                                //                 item['totalAmount2'] = 0;
                                                //               } else {
                                                //                 item['enteredQty'] = int.parse(value);
                                                //                 if (item['enteredQty'] > (item['qty']?? 0)) {
                                                //                   ScaffoldMessenger.of(context).showSnackBar(
                                                //                     const SnackBar(content: Text('Please enter a valid quantity')),
                                                //                   );
                                                //                 } else {
                                                //                   item['totalAmount2'] = item['price'] * item['enteredQty'];
                                                //                 }
                                                //               }
                                                //               // calculate the total amount
                                                //               totalAmount = _orderDetails.fold(0.0, (sum, item) => sum + (item['totalAmount2']?? 0));
                                                //               totalController.text = totalAmount.toStringAsFixed(2); // update the totalController
                                                //             });
                                                //           },
                                                //         ),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
                                                // TableCell(
                                                //   child: Padding(
                                                //     padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                                //     child: Container(
                                                //       height: 35,
                                                //       width: 50,
                                                //       decoration: BoxDecoration(
                                                //         color: Colors.grey[300],
                                                //         borderRadius: BorderRadius.circular(4.0),
                                                //       ),
                                                //       child:TextFormField(
                                                //         initialValue: (item['enteredQty']?? '').toString(),
                                                //         onChanged: (value) {
                                                //           setState(() {
                                                //             if (value.isEmpty) {
                                                //               item['enteredQty'] = 0;
                                                //               item['totalAmount2'] = 0;
                                                //             } else {
                                                //               item['enteredQty'] = int.parse(value);
                                                //               if (item['enteredQty'] > (item['qty']?? 0)) {
                                                //                 ScaffoldMessenger.of(context).showSnackBar(
                                                //                   SnackBar(content: Text('Please enter a valid quantity')),
                                                //                 );
                                                //               } else {
                                                //                 item['totalAmount2'] = item['price'] * item['enteredQty'];
                                                //               }
                                                //             }
                                                //             // calculate the total amount
                                                //             totalAmount = _orderDetails.fold(0.0, (sum, item) => sum + (item['totalAmount2']?? 0));
                                                //             totalController.text = totalAmount.toStringAsFixed(2); // update the totalController
                                                //           });
                                                //         },
                                                //       ),
                                                //     ),
                                                //   ),
                                                // ),
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
                                                      child: Center(child: Text(item['totalAmount'].toString())),
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
                                                      child: Center(child: Text(item['totalAmount2']!= null? item['totalAmount2'].toString() : '0'),
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ]
                                          )
                                        ],

                                      );
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25 ,top: 5,bottom: 5),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.only(left: 15,right: 10,top: 6,bottom: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: const Color(0xFF0277BD)),
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
                                                    text:  'Total Credit',
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
                                                     text: totalController.text,
                                                     style: const TextStyle(
                                                   color: Colors.black,
                                                     ),
                                                    ) ],
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

                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 50,right: 100,top: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF00000029),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                                border: Border.all(color: const Color(0xFFB2C2D3), width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Text(
                                          'Image Upload',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: 'Titillium Web',
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:  const EdgeInsets.only(right: 30),
                                        child: Padding(
                                          padding:  EdgeInsets.only(left: maxWidth * 0.15),
                                          child: OutlinedButton.icon(
                                            icon: const Icon(Icons.upload,color: Colors.white,size: 18,),
                                            label: const Text('Upload',style: TextStyle(color: Colors.white,),),
                                            onPressed: () {
                                              Map<String, dynamic> orderDetailsMap = {
                                                'emailAddress': EmailAddressController.text,
                                                'contactPerson': ContactpersonController.text,
                                                'reason': _selectedReason,
                                                'otherField': _controller.text,
                                                'orderDetails': _orderDetails,
                                                'totalAmount2': totalController.text,
                                              };
                                              print('return design module file');
                                              print(orderDetailsMap);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => NextPage(orderDetails: _orderDetails, storeImages: widget.storeImages, imageSizeStrings: widget.imageSizeStrings, orderDetailsMap: orderDetailsMap,)),
                                              );
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(builder: (context) => NextPage(_orderDetails,storeImages,imageSizeStrings, orderDetails: [],)),
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Color(0xFFB2C2D3), // Choose a color that contrasts with the background
                                    thickness: 1, // Set a non-zero thickness
                                  ),
                                  // Divider(color: Color(0xFF00000029),),

                                  const SizedBox(height: 8),
                                  Column(
                                    children: [
                                      if(widget.storeImages != '')
                                        Column(
                                          children: List.generate(widget.storeImages.length, (i) {
                                            return Row(
                                              // children: [
                                              //   Icon(Icons.image),
                                              //   Text('${widget.imageSizeString!}', style: TextStyle(fontSize: 24)),
                                              //   Padding(
                                              //     padding: const EdgeInsets.only(left: 1280), // add 10 pixels of space to the left
                                              //     child: Text('${widget.imageSizeStrings[i]}', style: TextStyle(fontSize: 24)),
                                              //   ),
                                              //   IconButton(
                                              //     icon: Icon(Icons.delete_forever_rounded,color: Colors.deepOrange,),
                                              //     onPressed: () {
                                              //       if (i < widget.imageSizeString!.length) {
                                              //         setState(() {
                                              //           widget.imageSizeString?.removeAt(i);
                                              //          // widget.imageSizeString = removeCharAt(widget.imageSizeString!, i);
                                              //           // Remove from list
                                              //          // widget.imageSizeStrings.removeAt(i);
                                              //        });
                                              //       } else {
                                              //         setState(() {
                                              //         ///  widget.imageSizeString = removeCharAt(widget.imageSizeString!, i);
                                              //           // Remove from list
                                              //           widget.imageSizeStrings.removeAt(i);
                                              //         });
                                              //       }
                                              //     },
                                              //   ),
                                              // ],
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(left: 30),
                                                  child: Icon(Icons.image,color: Colors.blue,size: 30,),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15),
                                                  child: Text('${widget.storeImages[i]}', style: const TextStyle(fontSize: 18)),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 30), // add 10 pixels of space to the left
                                                  child: Text('${widget.imageSizeStrings[i]}', style: const TextStyle(fontSize: 18)),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete_forever_rounded,color: Colors.deepOrange,size: 35,),
                                                  onPressed: () {
                                                    if (i < widget.storeImages.length - 0) {
                                                      setState(() {
                                                        widget.storeImages.removeAt(i);
                                                        widget.imageSizeStrings.removeAt(i);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        widget.storeImages.removeAt(i);
                                                        widget.imageSizeStrings.removeAt(i - 1);
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          }),
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 50,right: 100,top: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF00000029),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                                border: Border.all(color: const Color(0xFFB2C2D3), width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: NotesController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        border: InputBorder.none,
                                      ),
                                      maxLines: 5, // To make it a single line text field
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))

              ],
            );
          }
      ),
    );
  }
}


String removeCharAt(String str, int index) {
  return str.substring(0, index) + str.substring(index + 1);
}

DataRow dataRow(int sn, String productName, String brand, String category, String subCategory, String price, int qty, int returnQty, String invoiceAmount, String creditRequest) {
  return DataRow(cells: [
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(sn.toString()),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(productName),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(brand),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(category),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(subCategory),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(price),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(qty.toString()),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(returnQty.toString()),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(invoiceAmount),
        ),
      ),
    ),
    DataCell(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
        ),
        child: Center(
          child: Text(creditRequest),
        ),
      ),
    ),
  ]);
}




