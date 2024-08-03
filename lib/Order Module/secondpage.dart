import 'dart:js';

import 'package:btb/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Product Module/Product Screen.dart';
import '../Return Module/return first page.dart';
import 'thirdpage.dart';
import '../screen/dashboard.dart';



class OrdersSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 984),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: CreateOrderPage(),
        );
      },
    );
  }
}

class CreateOrderPage extends StatefulWidget {
  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}


class _CreateOrderPageState extends State<CreateOrderPage> {
  String? _selectedDeliveryLocation;
  late TextEditingController _dateController;
  // String? _selectedDeliveryLocation;
  final deliveryLocationController = TextEditingController();
  final ContactPersonController = TextEditingController();
  final deliveryaddressController = TextEditingController();
  final ContactNumberController = TextEditingController();
  final CommentsController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateController = TextEditingController();

    _selectedDate = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    _dateController.text = formattedDate;
    print('date init');
    print(_dateController.text);
   // _selectedDate = _dateController.text as DateTime?;
  }

  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];





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
                        width:  screenWidth * 0.35,
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          value: _selectedDeliveryLocation,
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
                              _selectedDeliveryLocation = value!;
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
                          controller: deliveryaddressController,
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
                       // width: 370,
                        height: 40,
                        child: TextField(
                          controller: ContactPersonController,
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
                          controller: ContactNumberController,
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
                            controller: CommentsController,
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

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar:
          AppBar(
            backgroundColor: const Color(0xFFFFFFFF),
            title: Image.asset("images/Final-Ikyam-Logo.png"),
            // Set background color to white
            elevation: 2.0,
            shadowColor: const Color(0xFFFFFFFF),
            // Set shadow color to black
            actions: [
              Padding(
                padding:  const EdgeInsets.only(top: 10),
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
          body: LayoutBuilder(
            builder: (context, constraints){
              double maxHeight = constraints.maxHeight;
              double maxWidth = constraints.maxWidth;
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 984,
                      width: 200,
                      color: const Color(0xFFF7F6FA),
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: () {
                              // context
                              //     .go('${PageName.main}/${PageName.subpage1Main}');
                              context.go('/Create_Order/Orders/Home');
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder:
                              //         (context, animation, secondaryAnimation) =>
                              //     const DashboardPage(
                              //
                              //     ),
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
                                  '/Create_Order/Orders/Products');
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder:
                              //         (context, animation, secondaryAnimation) =>
                              //     const ProductPage(
                              //       product: null,
                              //     ),
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
                             // context.go('/BeforplacingOrder/Orderspage');
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
                              context.go('/Create_Order/Orders/Return');
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder:
                              //         (context, animation, secondaryAnimation) =>
                              //     const Returnpage(),
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
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: 
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            color: Colors.white,
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: IconButton(
                                    icon:
                                    const Icon(Icons.arrow_back), // Back button icon
                                    onPressed: () {
                                      context.go(
                                          '/Orders');
                                      //  Navigator.push(
                                      //      context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => NextPage(product: , data: data2, inputText: '', subText: '')),
                                      // );
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 30,top: 12),
                                  child: Text(
                                    'Create Order',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0,top: 0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 1), // Space above/below the border
                            height: 2,
                            // width: 1000,
                            width: 1900,// Border height
                            color: Colors.grey[300], // Border color
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right:100),
                          child: SizedBox(
                            width: screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                             // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(right: maxWidth * 0.085,top: 50),
                                  child: const Text((' Order Date')),
                                ),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFEBF3FF), width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    height: 39,
                                    width: maxWidth *0.13,
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
                                // SizedBox(height: 20.h),

                              ],
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 100,top: 50),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFB2C2D3)),
                              borderRadius: BorderRadius.circular(5), // Set border radius here
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
                          padding: const EdgeInsets.only(top: 60,left: 50,right: 100 ),
                          child: Container(
                            //width: screenWidth * 0.8,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFB2C2D3), width: 2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 10, left: 30),
                                  child: Text(
                                    'Add Products',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    border: TableBorder.all(color: const Color(0xFFB2C2D3)),
                                    columnSpacing: screenWidth * 0.066,
                                    headingRowHeight: 40,
                                    columns: const [
                                      DataColumn(label: Text('Product Name')),
                                      DataColumn(label: Text('Category')),
                                      DataColumn(label: Text('Sub Category')),
                                      DataColumn(label: Text('Price')),
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('Amount')),
                                      DataColumn(label: Text('TAX')),
                                      DataColumn(label: Text('Discount')),
                                      DataColumn(label: Text('Total Amount')),
                                    ],
                                    rows: const [],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30, top: 25),
                                      child: SizedBox(
                                        width: screenWidth * 0.12,
                                        child: OutlinedButton(
                                          // onPressed: handleButtonPress,
                                          //my copy
                                          onPressed: ()

                                          {
                                            String validateFields() {
                                              if ( _selectedDeliveryLocation == null || _selectedDeliveryLocation!.isEmpty) {
                                                return 'Please fill in the delivery location.';
                                              }
                                              if (ContactPersonController.text.isEmpty) {
                                                return 'Please fill in the contact person name.';
                                              }
                                              if (deliveryaddressController.text.isEmpty) {
                                                return 'Please fill in the delivery address.';
                                              }
                                              if (ContactNumberController.text.isEmpty) {
                                                return 'Please fill in the contact number.';
                                              }
                                              if (CommentsController.text.isEmpty) {
                                                return 'Please fill in the comments.';
                                              }

                                              return '';
                                            }
                                            String validationMessage = validateFields();
                                            if (validationMessage == '') {
                                              Map<String, dynamic> data = {
                                                'deliveryLocation': _selectedDeliveryLocation,
                                                'ContactName': ContactPersonController.text,
                                                'Address': deliveryaddressController.text,
                                                'ContactNumber': ContactNumberController.text,
                                                'Comments': CommentsController.text,
                                                'date': _dateController.text,
                                              };
                                              context.go('/Home/Orders/Create_Order/Add_Product',extra: data);
                                              // Navigator.push(
                                              //   context,
                                              //   PageRouteBuilder(
                                              //     pageBuilder: (context, animation, secondaryAnimation) =>
                                              //         OrderPage3(data: data),
                                              //     transitionDuration: const Duration(milliseconds: 200),
                                              //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              //       return FadeTransition(
                                              //         opacity: animation,
                                              //         child: child,
                                              //       );
                                              //     },
                                              //   ),
                                              // );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(validationMessage),
                                                ),
                                              );
                                            }
                                          },

                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            side: BorderSide.none,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.only(right: 30),
                                            child: Text(
                                              '+ Add Products',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 900.h),
                      ],
                    ),
                  ))
                ],
              );
            },

          ),
        );
      },
    );
  }
}


