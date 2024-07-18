import 'dart:convert';
import 'dart:html';
// import 'package:btb/fifth%20page/crete.dart';
import 'package:btb/fifthpage/sixthpage.dart';
import 'package:btb/fifthpage/ss%20sixth%20page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'create order seventh page mahadevan.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CreateOrder(),
  ));
}

class CreateOrder extends StatefulWidget {
  const CreateOrder({Key? key, this.restorationId}) : super(key: key);
  final String? restorationId;

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  String token = window.sessionStorage["token"] ?? " ";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> list = ['SPRS', 'SSPR', 'PRSS', 'SRPS'];
  String dropdownValue = 'SPRS';
  String? selectedDropdownItem;
  String? errorMessage;
  late TextEditingController _dateController;
  DateTime? _selectedDate;
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController availableController = TextEditingController();
  final TextEditingController faxController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController outstandingController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController creditLimitController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController invoiceNoController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController descriptionContoller = TextEditingController();
  final TextEditingController partController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController snoController = TextEditingController();
  final TextEditingController uomContoller = TextEditingController();
  // final  TextEditingController itemsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat.yMd().format(pickedDate);
      });
    }
  }

  Future<void> checkSaved(
    String addressLine1,
    String addressLine2,
    String available,
    String fax,
    String supplier,
    String outstanding,
    int tel,
    String type,
    String comments,
    String name,
    int phone,
    int creditLimit,
    String notes,
    String totalAmount,
    String invoiceNo,
    String amount,
    String tax,
    List<Map<String, dynamic>> items,
  ) async {
    if (!areRequiredFieldsFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill in all required fields and select")),
      );
      return;
    }
    final productData = {
      "addressLine1": addressLine1Controller.text,
      "addressLine2": addressLine2Controller.text,
      "available": availableController.text,
      "fax": faxController.text,
      "supplier": supplierController.text,
      "outstanding": outstandingController.text,
      "tel": telController.text,
      "type": typeController.text,
      "comments": commentsController.text,
      "name": nameController.text,
      "phone": phoneController.text,
      "creditLimit": creditLimitController.text,
      "orderDate": _dateController.text,
      "glGroup": dropdownValue,
      // "items": itemDataList,
      "notes": notesController.text,
      "totalAmount": totalAmountController.text,
      "invoiceNo": invoiceNoController.text,
      "amount": amountController.text,
      "tax": taxController.text,
      "items": [
        {
          "amount": amountController.text,
          "description": descriptionContoller.text,
          "part": partController.text,
          "qty": qtyController.text,
          "rate": rateController.text,
          "sno": snoController.text,
          "uom": uomContoller.text,
        },
        {
          "amount": amountController.text,
          "description": descriptionContoller.text,
          "part": partController.text,
          "qty": qtyController.text,
          "rate": rateController.text,
          "sno": snoController.text,
          "uom": uomContoller.text,
        }
      ],
      // "items": itemsController.text,
    };
    final url =
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/add_order_master';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${token}'
      },
      body: json.encode(productData),
    );
    if (response.statusCode == 200) {
      print(token);
      final responseData = json.decode(response.body);
      print(responseData);

      if (responseData.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product")),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateOrder2(),
          ),
        );
      }
    } else if (response.statusCode == 400) {
      // Handle Bad Request error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bad Request: Please check your input")),
      );
    } else {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save product")),
      );
    }
  }

  bool areRequiredFieldsFilled() {
    return addressLine1Controller.text.isNotEmpty &&
        addressLine2Controller.text.isNotEmpty &&
        availableController.text.isNotEmpty &&
        faxController.text.isNotEmpty &&
        supplierController.text.isNotEmpty &&
        outstandingController.text.isNotEmpty &&
        telController.text.isNotEmpty &&
        typeController.text.isNotEmpty &&
        commentsController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        creditLimitController.text.isNotEmpty &&
        _dateController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Image.asset("images/Final-Ikyam-Logo.png"),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Handle notification icon press
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Handle user icon press
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                // Added Align widget for the left side menu
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.dashboard, color: Colors.blue[900]),
                        label: Text('Home'),
                      ),
                      SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateOrder()),
                          );
                        },
                        icon: Icon(Icons.warehouse_outlined,
                            color: Colors.blue[900]),
                        label: Text('Orders'),
                      ),
                      SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.fire_truck_outlined,
                            color: Colors.blue[900]),
                        label: Text('Delivery'),
                      ),
                      SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.document_scanner_rounded,
                            color: Colors.blue[900]),
                        label: Text('Invoice'),
                      ),
                      SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.payment_outlined,
                            color: Colors.blue[900]),
                        label: Text('Payment'),
                      ),
                      SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.backspace_sharp,
                            color: Colors.blue[900]),
                        label: Text('Return'),
                      ),
                      SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
                        label: Text('Reports'),
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back), // Back button icon
                          onPressed: () {
                            // Implement back button action
                          },
                        ),
                        Text(
                          'Create Order',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1200),
                          child: OutlinedButton(
                            onPressed: () {
                              checkSaved(
                                addressLine1Controller.text,
                                addressLine2Controller.text,
                                availableController.text,
                                faxController.text,
                                supplierController.text,
                                outstandingController.text,
                                int.parse(telController.text),
                                typeController.text,
                                commentsController.text,
                                nameController.text,
                                int.parse(phoneController.text),
                                int.parse(creditLimitController.text),
                                // itemDataList.text,
                                notesController.text,
                                totalAmountController.text,
                                invoiceNoController.text,
                                amountController.text,
                                taxController.text,
                                [
                                  {
                                    "amount": amountController.text,
                                    "description": descriptionContoller.text,
                                    "part": partController.text,
                                    "qty": qtyController.text,
                                    "rate": rateController.text,
                                    "sno": snoController.text,
                                    "uom": uomContoller.text,
                                  },
                                  {
                                    "amount": amountController.text,
                                    "description": descriptionContoller.text,
                                    "part": partController.text,
                                    "qty": qtyController.text,
                                    "rate": rateController.text,
                                    "sno": snoController.text,
                                    "uom": uomContoller.text,
                                  }
                                ],
                              );
                            },
                            // if (!areRequiredFieldsFilled()) {
                            //   if (mounted) {
                            //     print('-------please fill all fields----');
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //         content: Text(
                            //             "Please fill in all required fields"),
                            //       ),
                            //     );
                            //   }
                            // } else {
                            //   // If all required fields are filled, proceed with the action
                            //   checkSaved(
                            //     addressLine1Controller.text,
                            //     addressLine2Controller.text,
                            //     availableController.text,
                            //     faxController.text,
                            //     supplierController.text,
                            //     outstandingController.text,
                            //     int.parse(telController.text),
                            //     typeController.text,
                            //     commentsController.text,
                            //     nameController.text,
                            //     int.parse(phoneController.text),
                            //     int.parse(creditLimitController.text),
                            //     // itemDataList.text,
                            //     notesController.text,
                            //     totalAmountController.text,
                            //     invoiceNoController.text,
                            //     amountController.text,
                            //     taxController.text,
                            //     [
                            //       {
                            //         "amount": amountController.text,
                            //         "description": descriptionContoller.text,
                            //         "part": partController.text,
                            //         "qty": qtyController.text,
                            //         "rate": rateController.text,
                            //         "sno": snoController.text,
                            //         "uom": uomContoller.text,
                            //       },
                            //       {
                            //         "amount": amountController.text,
                            //         "description": descriptionContoller.text,
                            //         "part": partController.text,
                            //         "qty": qtyController.text,
                            //         "rate": rateController.text,
                            //         "sno": snoController.text,
                            //         "uom": uomContoller.text,
                            //       }
                            //     ],
                            //   );
                            // }
                            // },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Colors.blueAccent, // Button background color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // Rounded corners
                              ),
                              side: BorderSide.none, // No outline
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 18,
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
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 300, top: 100),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 10),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Container(
                          height: 100,
                          width: 1400,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white, // Container background color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Spacing between elements
                                children: [
                                  // First Field and TextFormField
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Text('Supplier'),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 350,
                                        child: TextFormField(
                                          controller: supplierController,
                                          decoration: InputDecoration(
                                            hintText: 'Supplier Name',
                                            contentPadding: EdgeInsets.all(8),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ), // Second Field and TextFormField
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Text('Type'),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 150,
                                        child: TextFormField(
                                          controller: typeController,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey[200],
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            border: InputBorder.none,
                                            filled: true,
                                            hintText: '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text and Dropdown
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 15,
                                        ),
                                        child: Text('Dropdown'),
                                      ),
                                      Container(
                                        height:
                                            30, // Increase height for better visibility
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .grey[200], // Background color

                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5), // Shadow position
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  1), // Padding to avoid text overflow
                                          child: DropdownButton<String>(
                                            value: dropdownValue,
                                            icon: const Icon(
                                                Icons.arrow_downward),
                                            iconSize: 24, // Size of the icon
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.deepPurple),
                                            underline:
                                                Container(), // We don't need the default underline since we're using a custom border
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                            items: list
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 15),
                                        child: Text('Date'),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        width: 150,
                                        child: TextFormField(
                                          controller: _dateController,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon:
                                                    Icon(Icons.calendar_month),
                                                onPressed: () {
                                                  _showDatePicker(context);
                                                }), // Prefix icon
                                            hintText: 'Select Date',
                                            fillColor: Colors.grey[200],
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            border: InputBorder.none,
                                            filled: true,
                                          ),
                                        ),
                                        // child: TextFormField(
                                        //   controller: _dateController,
                                        //   readOnly:
                                        //       true, // To make it non-editable
                                        //   decoration: InputDecoration(
                                        //     suffixIcon: IconButton(
                                        //         icon: Icon(Icons.calendar_month),
                                        //         onPressed: () {
                                        //           _showDatePicker(context);
                                        //         }), // Prefix icon
                                        //     hintText: 'Select Date',
                                        //     contentPadding: EdgeInsets.all(8),
                                        //     border: OutlineInputBorder(),
                                        //   ),
                                        // ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 300, top: 250),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 10),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      // Left container with multiple form fields
                      child: Container(
                        width: 1000,
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // Border to emphasize split
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 20),
                              child: Text(
                                'Invoicing Details',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10), // Space above/below the border
                              height: 1, // Border height
                              color: Colors.grey, // Border color
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 10),
                                  child: Text(
                                    'Address',
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical:
                                          10), // Space above/below the border
                                  height: 1, // Border height
                                  color: Colors.grey, // Border color
                                ),
                              ],
                            ),
                            // First row with "Name" and "Phone"
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Text('Name'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 420,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15, left: 30),
                                            child: TextFormField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[200],
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                filled: true,
                                                hintText: '',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 32),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Text('Phone'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 400,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15, left: 30),
                                            child: TextFormField(
                                              controller: phoneController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    10), // limits to 10 digits
                                              ],
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[200],
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                filled: true,
                                                hintText: '',
                                                errorText: errorMessage,
                                              ),
                                              onChanged: (value) {
                                                if (value.isNotEmpty &&
                                                    !isNumeric(value)) {
                                                  setState(() {
                                                    errorMessage =
                                                        'Please enter numbers only';
                                                  });
                                                } else {
                                                  setState(() {
                                                    errorMessage = null;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Second row with "Address Line 1" and "Fax"
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 14, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Text('Address Line 1'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 420,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15, left: 30),
                                            child: TextFormField(
                                              controller:
                                                  addressLine1Controller,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[200],
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                filled: true,
                                                hintText: '',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Text('Fax'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 400,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15, left: 30),
                                            child: TextFormField(
                                              controller: faxController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    10), // limits to 10 digits
                                              ],
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[200],
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                filled: true,
                                                hintText: '',
                                                errorText: errorMessage,
                                              ),
                                              onChanged: (value) {
                                                if (value.isNotEmpty &&
                                                    !isNumeric(value)) {
                                                  setState(() {
                                                    errorMessage =
                                                        'Please enter numbers only';
                                                  });
                                                } else {
                                                  setState(() {
                                                    errorMessage = null;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Third row with "Address Line 2" and "Tel"
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 14, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Text('Address Line 2'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 420,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15, left: 30),
                                            child: TextFormField(
                                              controller:
                                                  addressLine2Controller,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[200],
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                filled: true,
                                                hintText: '',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Text('Tel'),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: 400,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15, left: 30),
                                            child: TextFormField(
                                              controller: telController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey[200],
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: InputBorder.none,
                                                filled: true,
                                                hintText: '',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1301, top: 250),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Container(
                    width: 400,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Border to emphasize split
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 20),
                          child: Text(
                            '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10), // Space above/below the border
                          height: 1, // Border height
                          color: Colors.grey, // Border color
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 10),
                              child: Text(
                                'Comment',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10), // Space above/below the border
                              height: 1, // Border height
                              color: Colors.grey, // Border color
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 30, right: 20),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: SizedBox(
                                      width: 350,
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        child: TextFormField(
                                          controller: addressLine2Controller,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey[200],
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 70),
                                            border: InputBorder.none,
                                            filled: true,
                                            hintText: '',
                                          ),
                                        ),
                                        //TextFormField(
                                        //   controller: commentsController,
                                        //   decoration: InputDecoration(
                                        //     border: OutlineInputBorder(),
                                        //     contentPadding:
                                        //         EdgeInsets.symmetric(
                                        //       horizontal: 5,
                                        //       vertical: 70,
                                        //     ),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 300, top: 800),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 10),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 100,
                        width: 1400,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // Container background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Spacing between elements
                          children: [
                            // First Field and TextFormField
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text('Credit Limit'),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 350,
                                  child: TextFormField(
                                    controller: creditLimitController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      filled: true,
                                      hintText: '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text('Outstanding'),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 350,
                                  child: TextFormField(
                                    controller: outstandingController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      filled: true,
                                      hintText: '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Text('Available'),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 350,
                                  child: TextFormField(
                                    controller: availableController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: InputBorder.none,
                                      filled: true,
                                      hintText: '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 300, top: 950),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 10),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 200,
                        width: 1400,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // Container background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 10),
                              child: Text(
                                'Address',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10), // Space above/below the border
                              height: 1, // Border height
                              color: Colors.grey, // Border color
                            ),
                            Table(
                              border: TableBorder.all(
                                  color: Colors.grey, width: 2.0),
                              columnWidths: {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(1),
                                3: FlexColumnWidth(1),
                                4: FlexColumnWidth(1),
                                5: FlexColumnWidth(1),
                                6: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the first column to 50
                                        child: Center(
                                          child: Text(
                                            'Model',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: const SizedBox(
                                        height:
                                            50, // set the height of the first cell in the second column to 50
                                        child: Center(
                                          child: const Text(
                                            'QTY',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .left, // set the alignment of the text to left
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: const SizedBox(
                                        height:
                                            50, // set the height of the first cell in the third column to 50
                                        child: Center(
                                          child: Text(
                                            'Chassis cub',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .right, // set the alignment of the text to right
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: const SizedBox(
                                        height:
                                            50, // set the height of the first cell in the fourth column to 50
                                        child: Center(
                                          child: Text(
                                            'DSLB',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: const SizedBox(
                                        height:
                                            50, // set the height of the first cell in the fifth column to 50
                                        child: Center(
                                          child: Text(
                                            'YES/NO',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: const SizedBox(
                                        height:
                                            50, // set the height of the first cell in the sixth column to 50
                                        child: Center(
                                          child: Text(
                                            'BODYBUILDER?',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: const SizedBox(
                                        height:
                                            50, // set the height of the first cell in the seventh column to 50
                                        child: Center(
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           ProductPage3()),
                                      // );
                                    },
                                    child: const Text('Add Parts'),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }
}

class Item {
  final int amount;
  final String description;
  final String part;
  final int qty;
  final double rate;
  final int sno;
  final String uom;

  Item({
    required this.amount,
    required this.description,
    required this.part,
    required this.qty,
    required this.rate,
    required this.sno,
    required this.uom,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'part': part,
      'qty': qty,
      'rate': rate,
      'sno': sno,
      'uom': uom,
    };
  }
}
