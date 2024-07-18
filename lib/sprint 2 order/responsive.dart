// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SafeArea(
//           child: CreateOrderPage(),
//         ),
//       ),
//     );
//   }
// }
//
// class CreateOrderPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Create Order',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Container(),
//                     ),
//                     Text('Order Date'),
//                     SizedBox(width: 8),
//                     Container(
//                       width: 200,
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: '29/09/2023',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Delivery Location',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Divider(),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Select Delivery Location'),
//                                   SizedBox(height: 8),
//                                   DropdownButtonFormField<String>(
//                                     items: [
//                                       DropdownMenuItem(
//                                           child: Text('Customer Name'),
//                                           value: 'customer_name'),
//                                     ],
//                                     onChanged: (value) {},
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   Text('Delivery Address'),
//                                   SizedBox(height: 8),
//                                   TextFormField(
//                                     maxLines: 3,
//                                     decoration: InputDecoration(
//                                       hintText: 'Address Details',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Contact Person'),
//                                   SizedBox(height: 8),
//                                   TextFormField(
//                                     decoration: InputDecoration(
//                                       hintText: 'Contact Person Name',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   Text('Contact Number'),
//                                   SizedBox(height: 8),
//                                   TextFormField(
//                                     decoration: InputDecoration(
//                                       hintText: 'Contact Person Number',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Comments'),
//                                   SizedBox(height: 8),
//                                   TextFormField(
//                                     maxLines: 5,
//                                     decoration: InputDecoration(
//                                       hintText:
//                                       'PLEASE INVOICE DIRECTLY. 90 DAY ARRANGEMENT AS PER PRASANTH',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Add Product',
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         Divider(),
//                         DataTable(
//                           columns: const <DataColumn>[
//                             DataColumn(
//                               label: Text('Product Name'),
//                             ),
//                             DataColumn(
//                               label: Text('Category'),
//                             ),
//                             DataColumn(
//                               label: Text('Sub Category'),
//                             ),
//                             DataColumn(
//                               label: Text('Price'),
//                             ),
//                             DataColumn(
//                               label: Text('Qty'),
//                             ),
//                             DataColumn(
//                               label: Text('Amount'),
//                             ),
//                             DataColumn(
//                               label: Text('TAX'),
//                             ),
//                             DataColumn(
//                               label: Text('Discount'),
//                             ),
//                             DataColumn(
//                               label: Text('Total Amount'),
//                             ),
//                           ],
//                           rows: const <DataRow>[
//                             DataRow(
//                               cells: <DataCell>[
//                                 DataCell(Text('Product 1')),
//                                 DataCell(Text('Category 1')),
//                                 DataCell(Text('Sub Category 1')),
//                                 DataCell(Text('\$100')),
//                                 DataCell(Text('1')),
//                                 DataCell(Text('\$100')),
//                                 DataCell(Text('10%')),
//                                 DataCell(Text('\$10')),
//                                 DataCell(Text('\$90')),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {},
//                           child: Text('+ Add Products'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: CreateOrderPage(),
        ),
      ),
    );
  }
}

class CreateOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          color: Colors.grey[200],
          child: Column(
            children: [
              SidebarButton(icon: Icons.home, label: 'Home'),
              SidebarButton(icon: Icons.shopping_cart, label: 'Orders'),
              SidebarButton(icon: Icons.delivery_dining, label: 'Delivery'),
              SidebarButton(icon: Icons.receipt, label: 'Invoice'),
              SidebarButton(icon: Icons.payment, label: 'Payment'),
              SidebarButton(icon: Icons.reply, label: 'Return'),
              SidebarButton(icon: Icons.report, label: 'Reports'),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Order',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Order Date'),
                      SizedBox(width: 8),
                      Container(
                        width: 200,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: '29/09/2023',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Location',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Select Delivery Location'),
                                    SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      items: [
                                        DropdownMenuItem(
                                            child: Text('Customer Name'),
                                            value: 'customer_name'),
                                      ],
                                      onChanged: (value) {},
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text('Delivery Address'),
                                    SizedBox(height: 8),
                                    TextFormField(
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: 'Address Details',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Contact Person'),
                                    SizedBox(height: 8),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Contact Person Name',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text('Contact Number'),
                                    SizedBox(height: 8),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Contact Person Number',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Comments'),
                                    SizedBox(height: 8),
                                    TextFormField(
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText:
                                        'PLEASE INVOICE DIRECTLY. 90 DAY ARRANGEMENT AS PER PRASANTH',
                                        border: OutlineInputBorder(),
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
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Product',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text('Product Name'),
                              ),
                              DataColumn(
                                label: Text('Category'),
                              ),
                              DataColumn(
                                label: Text('Sub Category'),
                              ),
                              DataColumn(
                                label: Text('Price'),
                              ),
                              DataColumn(
                                label: Text('Qty'),
                              ),
                              DataColumn(
                                label: Text('Amount'),
                              ),
                              DataColumn(
                                label: Text('TAX'),
                              ),
                              DataColumn(
                                label: Text('Discount'),
                              ),
                              DataColumn(
                                label: Text('Total Amount'),
                              ),
                            ],
                            rows: const <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('Product 1')),
                                  DataCell(Text('Category 1')),
                                  DataCell(Text('Sub Category 1')),
                                  DataCell(Text('\$100')),
                                  DataCell(Text('1')),
                                  DataCell(Text('\$100')),
                                  DataCell(Text('10%')),
                                  DataCell(Text('\$10')),
                                  DataCell(Text('\$90')),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('+ Add Products'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;

  SidebarButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton.icon(
        onPressed: () {
          // Handle navigation or actions here
        },
        icon: Icon(icon, color: Colors.black),
        label: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
