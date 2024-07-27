import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  String token = '';
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  // Function to check if all required fields are filled
  bool areRequiredFieldsFilled() {
    return productNameController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        taxController.text.isNotEmpty &&
        unitController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        discountController.text.isNotEmpty;
  }

  void checkEdit(
    String ProductName,
    String category,
    String subCategory,
    String tax,
    String unit,
    int price,
    String discount,
  ) async {
    if (!areRequiredFieldsFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    final productData = {
      "productName": productNameController.text,
      "category": categoryController.text,
      "subCategory": subCategoryController.text,
      "tax": taxController.text,
      "unit": unitController.text,
      "price": int.parse(priceController.text),
      "discount": discountController.text,
    };

    // void checkSave(
    //   String ProductName,
    //   String category,
    //   String subCategory,
    //   String tax,
    //   String unit,
    //   int price,
    //   String discount,
    // ) async {
    //   Map tempJson = {
    //     "productName": ProductName,
    //     "category": category,
    //     "tax": tax,
    //     "unit": unit,
    //     "price": price,
    //     "subCategory": subCategory,
    //   };
    const url =
        'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/update_productmaster';
    // String url =
    //     'https://tn4l1nop44.execute-api.ap-south-1.amazonaws.com/stage1/api/productmaster/add_productmaster';

    //   final response = await http.post(Uri.parse(url),
    //       headers: {
    //         "Content-Type": "application/json",
    //       },
    //       body: json.encode(tempJson));
    //   if (response.statusCode == 200) {
    //     Map tempData = json.decode(response.body);
    //     if (tempData.containsKey("error")) {
    //       if (mounted) {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(content: Text("Something went wrong")));
    //       }
    //     } else {
    //       ScaffoldMessenger.of(context)
    //           .showSnackBar(const SnackBar(content: Text("success")));
    //     }
    //   }
    // }
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer${token}'
      },
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add product: Server error")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully")),
        );
      }
    } else {
      // Add logging to understand why the request failed
      debugPrint('Failed to add product. Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add product")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // For larger screens (like web view)
          return Padding(
            padding: const EdgeInsets.only(
              left: 120,
              top: 220,
              right: 150,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('Product  Name*'),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            border: InputBorder.none,
                            filled: true,
                            hintText: 'Enter product name',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('Category*'),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  filled: true,
                                  hintText: 'Enter Category',
                                ),
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
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('Sub Category*'),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  filled: true,
                                  hintText: 'Enter Sub Category',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('Tax*'),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  filled: true,
                                  hintText: 'Enter tax',
                                ),
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
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('Unit*'),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  filled: true,
                                  hintText: 'Enter Unit',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('Price *'),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  filled: true,
                                  hintText: 'Enter Price',
                                ),
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
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('Discount'),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  border: InputBorder.none,
                                  filled: true,
                                  hintText: 'Enter Discount',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Implement cancel button action
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            Colors.grey[400], // Blue background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                        ),
                        side: BorderSide.none, // No outline
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18, // Increase font size if desired
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue, // Blue background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                        ),
                        side: BorderSide.none, // No outline
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18, // Increase font size if desired
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          // For smaller screens (like mobile view)
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Product Name*',
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter product name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Category*',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sub Category',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Sub category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tax*',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter tax',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Unit*',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Unit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Price*',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Discount*',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter Discount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.blue[100]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Implement cancel button action
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            Colors.grey[400], // Blue background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                        ),
                        side: BorderSide.none, // No outline
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18, // Increase font size if desired
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        token = window.sessionStorage["token"] ?? " ";
                        print("token");
                        print(token);
                        if (!areRequiredFieldsFilled()) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please fill in all required fields")),
                            );
                          }
                        } else {
                          checkEdit(
                            productNameController.text,
                            categoryController.text,
                            subCategoryController.text,
                            taxController.text,
                            unitController.text,
                            int.parse(priceController
                                .text), // Ensure this is a valid integer
                            discountController.text,
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue, // Blue background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                        ),
                        side: BorderSide.none, // No outline
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18, // Increase font size if desired
                          fontWeight: FontWeight.bold, // Bold text
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
