import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Order {
  final String prodId;
  final String? proId;
  final String productName;
  String subCategory;
  String category;
  final String unit;
  final String tax;
  final String discount;
  final int price;
  String? selectedUOM;
  String? selectedVariation;
  int quantity;
  double total;
  double totalamount;
  final String imageId;

  Order({
    required this.prodId,
    required this.category,
    this.proId,
    required this.productName,
    required this.subCategory,
    required this.unit,
    required this.selectedUOM,
    required this.selectedVariation,
    required this.quantity,
    required this.total,
    required this.totalamount,
    required this.tax,
    required this.discount,
    required this.price,
    required this.imageId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      prodId: json['prodId'] ?? '',
      category: json['category'] ?? '',
      productName: json['productName'] ?? '',
      subCategory: json['subCategory'] ?? '',
      unit: json['unit'] ?? '',
      tax: json['tax'] ?? '',
      quantity: (json['quantity'] is String ? int.tryParse(json['quantity']) : json['quantity']) ?? 0,
      total: (json['total'] is String ? double.tryParse(json['total']) : json['total']) ?? 0.0,
      totalamount: (json['total'] is String ? double.tryParse(json['totalamount']) : json['totalamount']) ?? 0.0,
      discount: json['discount'] ?? '',
      selectedUOM: json['uom'] ?? 'Select',
      selectedVariation: json['variation'] ?? 'Select',
      price: json['price'] ?? 0,
      imageId: json['imageId'] ?? '',
      proId: json['proId'] ?? '',
    );
  }

  Map<String, dynamic> asMap() {
    return {
      'proId': proId,
      'productName': productName,
      'category': category,
      'subCategory': subCategory,
      'price': price,
      'tax': tax,
      'unit': unit,
      'discount': discount,
      'selectedUOM': selectedUOM,
      'selectedVariation': selectedVariation,
      'quantity': quantity,
      'total': total,
      'totalamount': totalamount,
    };
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectedProductPage(selectedProducts: []),
    );
  }
}

class ProductPage123 extends StatefulWidget {
  final List<Order> selectedProducts;

  ProductPage123({required this.selectedProducts});

  @override
  _ProductPage123State createState() => _ProductPage123State();
}

class _ProductPage123State extends State<ProductPage123> {
  List<Order> products = [];
  final TextEditingController _textFormFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkaGFuYXNla2FyIiwiUm9sZXMiOlt7ImF1dGhvcml0eSI6ImRldmVsb3BlciJ9XSwiZXhwIjoxNzE5NjE1MTMyLCJpYXQiOjE3MTk2MDc5MzJ9.03mDVyQV5dF6Dpg7ENRdvpSgy9tuh7mDgSIzddLagFMJVvc6QP0RdA41YA_hfbCjW8O01u2SLlKqKRTaMjey4w'; // replace with your token
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final response = await http.get(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> productJson = json.decode(response.body);
      setState(() {
        products = productJson.map((json) => Order.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _handleAddButtonPress(Order product) {
    setState(() {
      widget.selectedProducts.insert(0, product);
    });
    _scrollController.jumpTo(0);
  }

  void _handleRemoveButtonPress(Order product) {
    setState(() {
      widget.selectedProducts.remove(product);
    });
  }

  @override
  void dispose() {
    _textFormFieldController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Table(
                  border: TableBorder.all(color: Colors.grey, width: 1),
                  children: widget.selectedProducts.map((product) {
                    return TableRow(
                      children: [
                        _buildTableCell(product.productName),
                        _buildTableCell(product.category),
                        _buildTableCell(product.subCategory),
                        _buildTableCell('${product.price}'),
                        _buildTableCell('${product.quantity}'),
                        _buildTableCell('${product.total}'),
                        TableCell(
                          child: IconButton(
                            onPressed: () {
                              _handleRemoveButtonPress(product);
                            },
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Order product = products[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: [
                      TableRow(
                        children: [
                          _buildTableCell(product.productName),
                          _buildTableCell(product.category),
                          _buildTableCell(product.subCategory),
                          _buildTableCell('${product.price}'),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$')),
                                    ],
                                    controller: _textFormFieldController..text = product.quantity > 0 ? product.quantity.toString() : '0',
                                    onEditingComplete: () {
                                      final currentValue = _textFormFieldController.text;
                                      if (product.quantity == 0) {
                                        setState(() {
                                          product.quantity = int.tryParse(currentValue) ?? 0;
                                          product.total = (product.price * product.quantity).toDouble();
                                        });
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value.isNotEmpty && value != '0') {
                                        setState(() {
                                          product.quantity = int.tryParse(value) ?? 0;
                                          product.total = (product.price * product.quantity).toDouble();
                                        });
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(bottom: 12),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _buildTableCell('${product.total}'),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: IconButton(
                              onPressed: () {
                                if (product.quantity == 0) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text('Please fill the quantity field'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  _handleAddButtonPress(product);
                                  _scrollController.jumpTo(0);
                                  setState(() {
                                    product.quantity = 0;
                                    product.total = 0; // Reset the quantity to 0
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectedProductPage(selectedProducts: widget.selectedProducts),
                  ),
                );
              },
              child: Text('Save Products'),
            ),
          ],
        ),
      ),
    );
  }

  TableCell _buildTableCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedProductPage extends StatefulWidget {
  final List<Order> selectedProducts;

  SelectedProductPage({required this.selectedProducts});

  @override
  State<SelectedProductPage> createState() => _SelectedProductPageState();
}

class _SelectedProductPageState extends State<SelectedProductPage> {
  List<Order> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    selectedProducts = widget.selectedProducts;
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final token = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkaGFuYXNla2FyIiwiUm9sZXMiOlt7ImF1dGhvcml0eSI6ImRldmVsb3BlciJ9XSwiZXhwIjoxNzE5NjE1MTMyLCJpYXQiOjE3MTk2MDc5MzJ9.03mDVyQV5dF6Dpg7ENRdvpSgy9tuh7mDgSIzddLagFMJVvc6QP0RdA41YA_hfbCjW8O01u2SLlKqKRTaMjey4w'; // replace with your token
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    final response = await http.get(
      Uri.parse('https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/get_all_productmaster'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> productJson = json.decode(response.body);
      setState(() {
        selectedProducts.addAll(productJson.map((json) => Order.fromJson(json)).toList());
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage123(selectedProducts: selectedProducts),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            border: TableBorder.all(color: Colors.grey, width: 1),
            children: selectedProducts.map((product) {
              return TableRow(
                children: [
                  _buildTableCell(product.productName),
                  _buildTableCell(product.category),
                  _buildTableCell(product.subCategory),
                  _buildTableCell('${product.price}'),
                  _buildTableCell('${product.quantity}'),
                  _buildTableCell('${product.total}'),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  TableCell _buildTableCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
