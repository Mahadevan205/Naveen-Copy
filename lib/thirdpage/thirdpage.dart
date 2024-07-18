import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:btb/target.dart';
import 'package:http/http.dart' as http;
import 'package:btb/thirdpage/product_form1.dart'; // Import the ProductForm widget

void main() {
  runApp(ProductList());
}

class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // For web view
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 30, left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.dashboard,
                              color: Colors.blue[900],
                            ),
                            label: Text('Home'),
                          ),
                          SizedBox(
                            width: 15,
                            height: 20,
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.warehouse_outlined,
                              color: Colors.blue[900],
                            ),
                            label: Text('Orders'),
                          ),
                          SizedBox(
                            width: 15,
                            height: 20,
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.fire_truck_outlined,
                              color: Colors.blue[900],
                            ),
                            label: Text('Delivery'),
                          ),
                          SizedBox(
                            width: 15,
                            height: 20,
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.document_scanner_rounded,
                              color: Colors.blue[900],
                            ),
                            label: Text('Invoice'),
                          ),
                          SizedBox(
                            width: 15,
                            height: 20,
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.payment_outlined,
                              color: Colors.blue[900],
                            ),
                            label: Text('Payment'),
                          ),
                          SizedBox(
                            width: 15,
                            height: 20,
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.backspace_sharp,
                              color: Colors.blue[900],
                            ),
                            label: Text('Return'),
                          ),
                          SizedBox(
                            width: 15,
                            height: 20,
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.insert_chart,
                              color: Colors.blue[900],
                            ),
                            label: Text('Reports'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 40,
                      left: 200,
                    ),
                    width: 300,
                    height: 986,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: 'Search Product',
                          prefix: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                              left: 1,
                            ),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          left: 600,
                        ),
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ProductForm(), // Use the ProductForm widget here
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 200, // Adjust left padding
                        right: 120, // Adjust right padding
                      ),
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
                            'Add New Product',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () {
                              // Implement edit button action
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue, // Button background color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // Rounded corners
                              ),
                              side: BorderSide.none, // No outline
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // For mobile view
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload,
                                color: Colors.blue[900], size: 40),
                            SizedBox(height: 8),
                            Text(
                              'Click to upload image',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'SVG, PNG, JPG, or GIF Recommended size (1000px * 1248px)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                                ProductForm(), // Use the ProductForm widget here
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
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
                          Expanded(
                            child: Text(
                              'Add New Product',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              // Implement cancel button action
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey[400], // Button background color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // Rounded corners
                              ),
                              side: BorderSide.none, // No outline
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () {
                              // Implement save button action
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue, // Button background color
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
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
