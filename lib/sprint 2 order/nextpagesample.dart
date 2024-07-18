import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../thirdpage/productclass.dart';
import 'add productmaster sample.dart';

class NextPage123 extends StatefulWidget {
  final Product product;
  final List<Product> products;
   final dynamic data;
  final String inputText;
  final List<Order> selectedProducts;
  final String subText;

  NextPage123({
    required this.product,
    required this.products,
    required this.data,
    required this.inputText,
    required this.selectedProducts,
    required this.subText,
  });

  @override
  _NextPage123State createState() => _NextPage123State();
}

class _NextPage123State extends State<NextPage123> {
  List<Map<String, dynamic>> selectedItems = [];
  List<Product> _allProducts = [];
  List<Product> productList = [];
  Map<String, dynamic> data2 = {};
  final TextEditingController totalController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController  _commentsController = TextEditingController();
  final TextEditingController  _deliveryaddressController = TextEditingController();
  final TextEditingController  _createdDateController = TextEditingController();
  late TextEditingController _dateController;
  final TextEditingController orderIdController = TextEditingController();
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];

  int _totalPages = 1;
  int _currentPage = 1;
  String token = window.sessionStorage["token"]?? " ";


  @override
  void initState() {
    print('----nextpage122');
    //print(selectedProducts);
    print(widget.data['items']);
    _createdDateController.text = widget.data['orderDate'];
    _contactPersonController.text = widget.data['contactPerson'];
    _contactNumberController.text = widget.data['contactNumber'];
    _commentsController.text = widget.data['comments'];
    _deliveryaddressController.text =widget.data['deliveryAddress'];

    super.initState();
   // selectedItems = List<Map<String, dynamic>>.from(widget.data['items']);
    fetchProducts(page: 1);
  }

  Future<void> fetchProducts({int? page}) async {
    final startIndex = (page ?? 1) * 10 - 10;
    final response = await http.get(
      Uri.parse(
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster?startIndex=$startIndex&limit=10',
      ),
      headers: {
        "Content-type": "application/json",
        "Authorization": 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          final products = jsonData.map((item) => Product.fromJson(item)).toList();
          setState(() {
            _allProducts.addAll(products);
            productList = _allProducts.sublist((page! - 1) * 10, page * 10);
            _totalPages = (_allProducts.length / 10).ceil();
          });
        } else if (jsonData is Map) {
          final products = jsonData['body'].map((item) => Product.fromJson(item)).toList();
          setState(() {
            _allProducts.addAll(products);
            productList = _allProducts.sublist((page! - 1) * 10, page * 10);
            _totalPages = (_allProducts.length / 10).ceil();
          });
        } else {
          setState(() {
            _allProducts = [];
            productList = [];
          });
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  // void _removeSelectedProduct(Order order) {
  //   setState(() {
  //     selectedProducts.remove(order);
  //   });
  // }

  void _removeSelectedItem(int index) {
    setState(() {
      selectedItems.removeAt(index);
    });
  }

  void _addProductToSelected(Product product, int quantity) {
    setState(() {
      widget.selectedProducts.add(Order(
        productName: product.productName,
        category: product.category,
        subCategory: product.subCategory,
        price: product.price,
        quantity: quantity,
        totalAmount: (product.price * quantity).toDouble(),
        prodId: '',
        proId: '',
        imageId: '',
        tax: '',
        totalamount: 0,
        total: 0,
        unit: '',
        selectedVariation: '',
        selectedUOM: '',
        discount: '',
        qty: 0,
      ));
    });
  }

  void _navigateToSelectedProductPage() {
    Map<String, dynamic> data = {
      'deliveryLocation': data2['deliveryLocation'],
      'orderDate': _createdDateController.text,
      'orderId': orderIdController.text,
      'contactPerson': _contactPersonController.text,
      'deliveryAddress': _deliveryaddressController.text,
      'contactNumber': _contactNumberController.text,
      'comments': _commentsController.text,
      'total': totalController.text,
      'items': selectedItems.map((item) => {
        'productName': item['productName'],
        'orderMasterItemId': item['orderMasterItemId'],
        'category': item['category'],
        'subCategory': item['subCategory'],
        'price': item['price'],
        'qty': item['qty'],
        'totalAmount': item['totalAmount'],
      }).toList(),
    };
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SelectedProductPage(data: data,selectedProducts: widget.selectedProducts,),
    //   ),
    // );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page 123'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSelectedItemsTable(),
            _buildProductsTable(),
            ElevatedButton(
              onPressed: _navigateToSelectedProductPage,
              child: Text('Save Products'),
            ),
          ],
        ),
      ),
    );

  }


  Widget _buildSelectedItemsTable() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Item')),
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('SubCategory')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Total Amount')),
        DataColumn(label: Text('Remove')),
      ],
      rows: List<DataRow>.generate(
        widget.data['items'].length,
            (index) {
              Map<String, dynamic> item = widget.data['items'][index];
              final order = widget.data['items'][index];
          return DataRow(
            cells: <DataCell>[
              DataCell(Text('Item ${index + 1}')),
              DataCell(Text(item['productName'])),
              DataCell(Text(item['category'])),
              DataCell(Text(item['subCategory'])),
              DataCell(Text(item['price'].toString())),
              DataCell(Text(item['qty'].toString())),
              DataCell(Text(item['totalAmount'].toString())),
              DataCell(
                InkWell(
                  onTap: () {
                    _removeSelectedItem; // Implement remove functionality
                  },
                  child: const Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }




  Widget _buildProductsTable() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Product Name')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('SubCategory')),
        DataColumn(label: Text('Price')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('Actions')),
      ],
      rows: productList.map((product) {
        TextEditingController quantityController = TextEditingController();
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(product.productName)),
            DataCell(Text(product.category)),
            DataCell(Text(product.subCategory)),
            DataCell(Text(product.price.toString())),
            DataCell(
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Quantity',
                ),
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  int quantity = int.parse(quantityController.text);
                  _addProductToSelected(product, quantity); // Add product to selected list
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }




}


