import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class CreateOrder2 extends StatefulWidget {
   const CreateOrder2({super.key, this.restorationId});
  final String? restorationId;
  @override
  State<CreateOrder2> createState() => _CreateOrder2State();
}

class _CreateOrder2State extends State<CreateOrder2> {
  String token = '';
  final List<String> list = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];
  String dropdownValue = 'Option 1';
  String? selectedDropdownItem;
  late TextEditingController _dateController;
  DateTime? _selectedDate;
  List<Product> selectedProducts = [];
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController availableController = TextEditingController();
  final TextEditingController faxController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController outstandingController = TextEditingController();
  final TextEditingController creditLimitController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
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
        _dateController.text.isNotEmpty; // Ensure image is selected
  }

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
            content:
                Text("Please fill in all required fields and select an image")),
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
      "items": items
          .map((item) => {
                "productId": item['productId'],
                "productName": item['productName'],
                "category": item['category'],
                "subCategory": item['subCategory'],
                "price": item['price'],
                "tax": item['tax'],
                "unit": item['unit'],
                "discount": item['discount'],
                "selectedUOM": item['selectedUOM'],
                "selectedVariation": item['selectedVariation'],
                "quantity": item['quantity'],
              })
          .toList(),
    };
    const productUrl =
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/order_master/add_order_master';

    final productResponse = await http.post(
      Uri.parse(productUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${token}'
      },
      body: json.encode(productData),
    );
    if (productResponse.statusCode == 200) {
      final responseData = json.decode(productResponse.body);

      if (responseData.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product: error")),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CreateOrder2(),
              settings: const RouteSettings(name: "/")),
          (route) => false,
        );
      }
    }
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
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle notification icon press
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
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
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.dashboard, color: Colors.blue[900]),
                        label: const Text('Home'),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.warehouse_outlined,
                            color: Colors.blue[900]),
                        label: const Text('Orders'),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.fire_truck_outlined,
                            color: Colors.blue[900]),
                        label: const Text('Delivery'),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.document_scanner_rounded,
                            color: Colors.blue[900]),
                        label: const Text('Invoice'),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.payment_outlined,
                            color: Colors.blue[900]),
                        label: const Text('Payment'),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.backspace_sharp,
                            color: Colors.blue[900]),
                        label: const Text('Return'),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.insert_chart, color: Colors.blue[900]),
                        label: const Text('Reports'),
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
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back), // Back button icon
                          onPressed: () {
                            // Implement back button action
                          },
                        ),
                        const Text(
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
                            onPressed: () async {
                              await checkSaved(
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
              Row(
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 100,
                        width: 1400,
                        padding: const EdgeInsets.all(16),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 15),
                                      child: Text('Supplier'),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 350,
                                      child: TextFormField(
                                        controller: supplierController,
                                        decoration: const InputDecoration(
                                          hintText: 'Supplier Name',
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ), // Second Field and TextFormField
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 15),
                                      child: Text('Type'),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 150,
                                      child: TextFormField(
                                        controller: typeController,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Text and Dropdown
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:  EdgeInsets.only(
                                        bottom: 15,
                                      ),
                                      child: Text('Dropdown'),
                                    ),
                                    Container(
                                      height:
                                          30, // Increase height for better visibility
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white, // Background color
                                        border: Border.all(
                                            color: Colors.grey,
                                            width: 1), // Border color and width
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
                                                10), // Padding to avoid text overflow
                                        child: DropdownButton<String>(
                                          value: dropdownValue,
                                          icon:
                                              const Icon(Icons.arrow_downward),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const     Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Text('Date'),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 150,
                                      child: TextFormField(
                                        controller: _dateController,
                                        readOnly:
                                            true, // To make it non-editable
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: const Icon(Icons.calendar_month),
                                              onPressed: () {
                                                _showDatePicker(context);
                                              }), // Prefix icon
                                          hintText: 'Select Date',
                                          contentPadding: const EdgeInsets.all(8),
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
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
              Padding(
                padding: const EdgeInsets.only(left: 300, top: 250),
                child: Row(
                  children: [
                    // Left container with multiple form fields
                    Container(
                      width: 1000,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey,
                            width: 1), // Border to emphasize split
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const  Padding(
                            padding:  EdgeInsets.only(left: 30, top: 20),
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
                              const   Padding(
                                padding:
                                    EdgeInsets.only(left: 30, top: 10),
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
                                      const Text('Name'),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: nameController,
                                        decoration:const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Phone'),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: phoneController,
                                        decoration:const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), // Second row with "Address Line 1" and "Fax"
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Address Line 1'),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: addressLine1Controller,
                                        decoration:const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Fax'),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: faxController,
                                        decoration:const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ), // Third row with "Address Line 2" and "Tel"
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Address Line 2'),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: addressLine2Controller,
                                        decoration:const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tel'),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: telController,
                                        decoration:const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
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
                    // Space between containers

                    // Right container
                    Container(
                      width: 400,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey,
                            width: 1), // Border to emphasize split
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const    Padding(
                            padding:  EdgeInsets.only(left: 30, top: 20),
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
                              const   Padding(
                                padding:
                                     EdgeInsets.only(left: 30, top: 10),
                                child: Text(
                                  'Comment',
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 30, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: TextFormField(
                                          controller: commentsController,
                                          decoration:const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10),
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
                  ],
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 100,
                        width: 1400,
                        padding: const EdgeInsets.all(16),
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
                                const   Padding(
                                  padding:  EdgeInsets.only(bottom: 15),
                                  child: Text('Credit Limit'),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 350,
                                  child: TextFormField(
                                    controller: creditLimitController,
                                    decoration:const InputDecoration(
                                      hintText: '',
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const      Padding(
                                  padding:  EdgeInsets.only(bottom: 15),
                                  child: Text('Outstanding'),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 350,
                                  child: TextFormField(
                                    controller: outstandingController,
                                    decoration:const InputDecoration(
                                      hintText: '',
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const   Padding(
                                  padding:  EdgeInsets.only(bottom: 15),
                                  child: Text('Available'),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 350,
                                  child: TextFormField(
                                    controller: availableController,
                                    decoration:const InputDecoration(
                                      hintText: '',
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(),
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 450,
                        width: 1400,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // Container background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const      Padding(
                              padding:  EdgeInsets.only(left: 30, top: 10),
                              child: Text(
                                'Add Parts',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ), // Space above/below the border
                              height: 1, // Border height
                              color: Colors.grey, // Border color
                            ),
                            Table(
                              border: TableBorder.all(
                                  color: Colors.grey, width: 2.0),
                              columnWidths:const {
                                0: FlexColumnWidth(0.5),
                                1: FlexColumnWidth(4),
                                2: FlexColumnWidth(1),
                                3: FlexColumnWidth(1),
                                4: FlexColumnWidth(1),
                                5: FlexColumnWidth(1),
                                6: FlexColumnWidth(1),
                                7: FlexColumnWidth(1),
                              },
                              children: [
                                const   TableRow(
                                  children: [
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the first column to 50
                                        child: Center(
                                          child: Text(
                                            'SN',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the second column to 50
                                        child: Padding(
                                          padding:  EdgeInsets.only(
                                              left: 10, top: 15),
                                          child: Text(
                                            'Description',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .left, // set the alignment of the text to left
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the third column to 50
                                        child: Center(
                                          child: Text(
                                            'Part #',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .right, // set the alignment of the text to right
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the fourth column to 50
                                        child: Center(
                                          child: Text(
                                            'UOM',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the fifth column to 50
                                        child: Center(
                                          child: Text(
                                            'QTY',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the sixth column to 50
                                        child: Center(
                                          child: Text(
                                            'Rate',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
                                        height:
                                            50, // set the height of the first cell in the seventh column to 50
                                        child: Center(
                                          child: Text(
                                            'Amount',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign
                                                .center, // set the alignment of the text to center
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: SizedBox(
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
                                ...selectedProducts.map((product) {
                                  return TableRow(
                                    children: [
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                product.productName,
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 15),
                                            child: Text(product.category,
                                                textAlign: TextAlign.left),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                product.selectedUOM,
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(product.tax,
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text('${product.price}',
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                                product.selectedVariation,
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                      // Add more cells for other product properties
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                            // In this place if i click that add button it will reflect data from that into this page in the row format
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 30, top: 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                    },
                                    child: const Text('Add Parts'),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ), // Space above/below the border
                              height: 1, // Border height
                              color: Colors.grey, // Border color
                            ),
                            const   Padding(
                              padding:
                                   EdgeInsets.only(right: 50, top: 20),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Amount:             2000000',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const     Padding(
                              padding:
                                   EdgeInsets.only(right: 50, top: 10),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Tax:             43567.67',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const   Padding(
                              padding:
                                   EdgeInsets.only(right: 50, top: 10),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Total Amount:        2343567.67',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 300, top: 1450),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 10),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 400,
                        width: 1400,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // Container background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const   Padding(
                              padding:  EdgeInsets.only(left: 30, top: 10),
                              child: Text(
                                'Office Use:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ), // Space above/below the border
                              height: 1, // Border height
                              color: Colors.grey, // Border color
                            ),
                            const   Row(
                              children: [
                                Padding(
                                  padding:
                                       EdgeInsets.only(left: 30, top: 50),
                                  child: Text(
                                    'NOTES:',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                width: 1350,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    top: 10,
                                  ),
                                  child: TextFormField(
                                    decoration:const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 70,
                                      ),
                                    ),
                                  ),
                                ))
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
}

class Product {
  final String proId;
  final String productName;
  final String category;
  final String subCategory;
  final double price;
  final String tax;
  final String unit;
  final String discount;
  String selectedUOM;
  String selectedVariation;

  Product({
    required this.proId,
    required this.productName,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.tax,
    required this.unit,
    required this.discount,
    required this.selectedUOM, // Add selectedUOM property
    required this.selectedVariation, // Add selectedVariation property
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      proId: json['proId'] ?? '',
      productName: json['productName'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      tax: json['tax'] ?? '',
      unit: json['unit'] ?? '',
      discount: json['discount'] ?? '',
      selectedUOM: json['uom'] ?? 'Select',
      selectedVariation: json['variation'] ?? 'Select',
    );
  }
}
