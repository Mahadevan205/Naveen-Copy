

import 'package:btb/sprint%202%20order/add%20productmaster%20sample.dart';
import 'package:flutter/material.dart';

import '../thirdpage/productclass.dart';



class SelectedProductPage2 extends StatefulWidget {
  final List<Order> selectedProducts;
  final Map<String, dynamic> data;

  SelectedProductPage2({
    required this.selectedProducts,
    required this.data,
  });

  @override
  State<SelectedProductPage2> createState() => _SelectedProductPage2State();
}

class _SelectedProductPage2State extends State<SelectedProductPage2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Products Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child:
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.selectedProducts.length,
              itemBuilder: (context, index) {
                final product = widget.selectedProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Table(
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
              Navigator.pop(context);
            },
            child: Text('Add Parts'),
          ),
        ],
      ),
    );
  }
}
