import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  String productName;
  String category;
  String subCategory;
  double price;
  int quantity;
  double totalAmount;

  Product({
    required this.productName,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.quantity,
    required this.totalAmount,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Selector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> availableProducts = [
    Product(
        productName: 'Product 1',
        category: 'Category A',
        subCategory: 'SubCategory A1',
        price: 10.0,
        quantity: 1,
        totalAmount: 10.0),
    Product(
        productName: 'Product 2',
        category: 'Category B',
        subCategory: 'SubCategory B1',
        price: 20.0,
        quantity: 1,
        totalAmount: 20.0),
  ];

  List<Product> selectedProducts = [];

  void _deleteProduct(int index) {
    setState(() {
      if (index < availableProducts.length) {
        availableProducts.removeAt(index);
      } else {
        selectedProducts.removeAt(index - availableProducts.length);
      }
    });
  }

  void _saveProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedProductPage(
          selectedProducts: selectedProducts,
          onAddParts: (List<Product> products) {
            setState(() {
              selectedProducts = products;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableProducts.length + selectedProducts.length,
              itemBuilder: (context, index) {
                Product product;
                if (index < availableProducts.length) {
                  product = availableProducts[index];
                } else {
                  product = selectedProducts[index - availableProducts.length];
                }

                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.productName,
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.category,
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.subCategory,
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.price.toString(),
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.quantity.toString(),
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.totalAmount.toString(),
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: IconButton(
                                onPressed: () {
                                  _deleteProduct(index);
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.blue,
                                ),
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
          ),
          ElevatedButton(
            onPressed: _saveProducts,
            child: Text('Save Products'),
          ),
        ],
      ),
    );
  }
}

class SelectedProductPage extends StatelessWidget {
  final List<Product> selectedProducts;
  final Function(List<Product>) onAddParts;

  SelectedProductPage({
    required this.selectedProducts,
    required this.onAddParts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Products Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                final product = selectedProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.productName,
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.category,
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.subCategory,
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.price.toString(),
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.quantity.toString(),
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                            TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    product.totalAmount.toString(),
                                    style:
                                    const TextStyle(color: Colors.black),
                                  ),
                                ),
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
          ),
          ElevatedButton(
            onPressed: () {
              onAddParts(selectedProducts);
            },
            child: Text('Add Parts'),
          ),
        ],
      ),
    );
  }
}
