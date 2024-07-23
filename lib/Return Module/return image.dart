import 'package:btb/Return%20Module/return%20module%20design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../fourthpage/orderspage order.dart';
import '../sprint 2 order/firstpage.dart';
import '../thirdpage/dashboard.dart';
//
// void main(){
//   runApp(MaterialApp(home: NextPage(),));
// }


class NextPage extends StatefulWidget {
  final List<dynamic> orderDetails;

  const NextPage(this.orderDetails, {super.key});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  String? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
      AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        title: Image.asset("images/Final-Ikyam-Logo.png"),
        // Set background color to white
        elevation: 2.0,
        shadowColor: const Color(0xFFFFFFFF),
        // Set shadow color to black
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
                child: IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    // Handle user icon press
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            // Added Align widget for the left side menu
            alignment: Alignment.topLeft,
            child: Container(
              height: 1400,
              width: 200,
              color: const Color(0xFFF7F6FA),
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // context
                      //     .go('${PageName.main}/${PageName.subpage1Main}');
                      context.go('/Dashboard');
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation,
                              secondaryAnimation) =>
                          const Dashboard(
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
                      // context.go('${PageName.dashboardRoute}');
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Dashboard()),
                      // );
                      // Navigator.pushReplacementNamed(
                      //     context, PageName.dashboardRoute);
                      // context
                      //     .go('${PageName.main} / ${PageName.subpage1Main}');
                    },
                    icon: Icon(
                        Icons.dashboard, color: Colors.indigo[900]),
                    label: Text(
                      'Home',
                      style: TextStyle(color: Colors.indigo[900]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      context.go('/Product_List');
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation,
                              secondaryAnimation) =>
                          const ProductPage(
                            product: null,
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
                      // context.go('${PageName.main}/${PageName.subpage1Main}');

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation,
                              secondaryAnimation) =>
                          const Orderspage(),
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

                      // setState(() {
                      //   isOrdersSelected = false;
                      //   // Handle button press19
                      // });
                    },
                    icon: Icon(Icons.warehouse,
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
                    onPressed: () {},
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
                    icon: Icon(
                        Icons.insert_chart, color: Colors.blue[900]),
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
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                height: 60,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        'Order Return',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12, right: 130),
                        child: OutlinedButton(
                          onPressed: () {
                            // context.go(
                            //     '${PageName.dashboardRoute}/${PageName.subpage1}');
                            //router
                            // context.go('/Create_Order');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                    CreateReturn(),
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
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                            Colors.blueAccent,
                            // Button background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  5), // Rounded corners
                            ),
                            side: BorderSide.none, // No outline
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 43, left: 200),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10),
              // Space above/below the border
              height: 3, // Border height
              color: Colors.grey[100], // Border color
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80,right: 500,left: 500),
            child: Column(
              children: [
                                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.4, // Adjust width based on screen size
                          height: size.width * 0.3, // Adjust height based on screen size
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: size.width * 0.1, // Adjust icon size based on screen size
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Click to upload image',
                                  style: TextStyle(fontSize: size.width * 0.01), // Adjust font size based on screen size
                                ),
                                Text(
                                  'SVG, PNG, JPG, or GIF\nRecommended size (1000px * 1248px)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: size.width * 0.010), // Adjust font size based on screen size
                                ),
                              ],
                            ),
                          ),
                        ),
                SizedBox(height: 40,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Product'),
                    SizedBox(height: 40,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Reason For Return',
                      ),
                      value: _selectedProduct,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProduct = newValue as String?;
                        });
                      },
                      items: widget.orderDetails.map((item) {
                        return DropdownMenuItem(
                          value: item['productName'],
                          child: Text(item['productName'] ?? 'Unknown Product'),
                        );
                      }).toList(),
                     // underline: null,
                      isExpanded: true,
                    ),
                    )
                  ],
                )


              ],
            ),
          )
            )
        ],
      )
          )
        ]
      )
    );
  }
}

//
// class ReturnImagePage extends StatefulWidget {
//   final List<dynamic> orderDetails;
//
//   const ReturnImagePage(this.orderDetails, {super.key});
//  //  ReturnImagePage({super.key,required this.selectedProduct});
//
//   @override
//   State<ReturnImagePage> createState() => _ReturnImagePageState();
// }
//
// class _ReturnImagePageState extends State<ReturnImagePage> {
//   String? _selectedProduct;
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar:
//       AppBar(
//         backgroundColor: const Color(0xFFFFFFFF),
//         title: Image.asset("images/Final-Ikyam-Logo.png"),
//         // Set background color to white
//         elevation: 2.0,
//         shadowColor: const Color(0xFFFFFFFF),
//         // Set shadow color to black
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(width: 10,),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 35),
//                 child: IconButton(
//                   icon: const Icon(Icons.account_circle),
//                   onPressed: () {
//                     // Handle user icon press
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Align(
//             // Added Align widget for the left side menu
//             alignment: Alignment.topLeft,
//             child: Container(
//               height: 1400,
//               width: 200,
//               color: const Color(0xFFF7F6FA),
//               padding: const EdgeInsets.only(left: 20, top: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextButton.icon(
//                     onPressed: () {
//                       // context
//                       //     .go('${PageName.main}/${PageName.subpage1Main}');
//                       context.go('/Dashboard');
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder:
//                               (context, animation,
//                               secondaryAnimation) =>
//                           const Dashboard(
//                           ),
//                           transitionDuration:
//                           const Duration(milliseconds: 200),
//                           transitionsBuilder: (context, animation,
//                               secondaryAnimation, child) {
//                             return FadeTransition(
//                               opacity: animation,
//                               child: child,
//                             );
//                           },
//                         ),
//                       );
//                       // context.go('${PageName.dashboardRoute}');
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(builder: (context) => Dashboard()),
//                       // );
//                       // Navigator.pushReplacementNamed(
//                       //     context, PageName.dashboardRoute);
//                       // context
//                       //     .go('${PageName.main} / ${PageName.subpage1Main}');
//                     },
//                     icon: Icon(
//                         Icons.dashboard, color: Colors.indigo[900]),
//                     label: Text(
//                       'Home',
//                       style: TextStyle(color: Colors.indigo[900]),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton.icon(
//                     onPressed: () {
//                       context.go('/Product_List');
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder:
//                               (context, animation,
//                               secondaryAnimation) =>
//                           const ProductPage(
//                             product: null,
//                           ),
//                           transitionDuration:
//                           const Duration(milliseconds: 200),
//                           transitionsBuilder: (context, animation,
//                               secondaryAnimation, child) {
//                             return FadeTransition(
//                               opacity: animation,
//                               child: child,
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     icon: Icon(Icons.image_outlined,
//                         color: Colors.indigo[900]),
//                     label: Text(
//                       'Products',
//                       style: TextStyle(color: Colors.indigo[900]),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton.icon(
//                     onPressed: () {
//                       // context.go('${PageName.main}/${PageName.subpage1Main}');
//
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder:
//                               (context, animation,
//                               secondaryAnimation) =>
//                           const Orderspage(),
//                           transitionDuration:
//                           const Duration(milliseconds: 200),
//                           transitionsBuilder: (context, animation,
//                               secondaryAnimation, child) {
//                             return FadeTransition(
//                               opacity: animation,
//                               child: child,
//                             );
//                           },
//                         ),
//                       );
//
//                       // setState(() {
//                       //   isOrdersSelected = false;
//                       //   // Handle button press19
//                       // });
//                     },
//                     icon: Icon(Icons.warehouse,
//                         color: Colors.blueAccent),
//                     label: const Text(
//                       'Orders',
//                       style: TextStyle(
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.fire_truck_outlined,
//                         color: Colors.blue[900]),
//                     label: Text(
//                       'Delivery',
//                       style: TextStyle(color: Colors.indigo[900]),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.document_scanner_rounded,
//                         color: Colors.blue[900]),
//                     label: Text(
//                       'Invoice',
//                       style: TextStyle(color: Colors.indigo[900]),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.payment_outlined,
//                         color: Colors.blue[900]),
//                     label: Text(
//                       'Payment',
//                       style: TextStyle(color: Colors.indigo[900]),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.backspace_sharp,
//                         color: Colors.blue[900]),
//                     label: Text(
//                       'Return',
//                       style: TextStyle(color: Colors.indigo[900]),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton.icon(
//                     onPressed: () {},
//                     icon: Icon(
//                         Icons.insert_chart, color: Colors.blue[900]),
//                     label: Text(
//                       'Reports',
//                       style: TextStyle(color: Colors.indigo[900]),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 200,
//             right: 0,
//             top: 0,
//             bottom: 0,
//             child: Column(
//               children: [
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 0),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       color: Colors.white,
//                       height: 40,
//                       child: Row(
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.only(left: 30),
//                             child: Text(
//                               'Order Return',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           Spacer(),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 10, right: 130),
//                               child: OutlinedButton(
//                                 onPressed: () {
//                                   // context.go(
//                                   //     '${PageName.dashboardRoute}/${PageName.subpage1}');
//                                   //router
//                                   // context.go('/Create_Order');
//                                   Navigator.push(
//                                     context,
//                                     PageRouteBuilder(
//                                       pageBuilder: (context, animation,
//                                           secondaryAnimation) =>
//                                           CreateReturn(),
//                                       transitionDuration:
//                                       const Duration(milliseconds: 200),
//                                       transitionsBuilder: (context, animation,
//                                           secondaryAnimation, child) {
//                                         return FadeTransition(
//                                           opacity: animation,
//                                           child: child,
//                                         );
//                                       },
//                                     ),
//                                   );
//                                 },
//                                 style: OutlinedButton.styleFrom(
//                                   backgroundColor:
//                                   Colors.blueAccent,
//                                   // Button background color
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(
//                                         5), // Rounded corners
//                                   ),
//                                   side: BorderSide.none, // No outline
//                                 ),
//                                 child: const Text(
//                                   'Save',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w100,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 0, left: 0),
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 5),
//                     // Space above/below the border
//                     height: 3, // Border height
//                     color: Colors.grey[100], // Border color
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           width: size.width * 0.4, // Adjust width based on screen size
//                           height: size.width * 0.3, // Adjust height based on screen size
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.cloud_upload,
//                                   size: size.width * 0.1, // Adjust icon size based on screen size
//                                   color: Colors.blue,
//                                 ),
//                                 SizedBox(height: 16.0),
//                                 Text(
//                                   'Click to upload image',
//                                   style: TextStyle(fontSize: size.width * 0.01), // Adjust font size based on screen size
//                                 ),
//                                 Text(
//                                   'SVG, PNG, JPG, or GIF\nRecommended size (1000px * 1248px)',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(fontSize: size.width * 0.010), // Adjust font size based on screen size
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 32.0),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Select Product'),
//                               SizedBox(height: 5,),
//                               SizedBox(
//                                 height: 40,
//                                 child: DropdownButton(
//                                   value: _selectedProduct,
//                                   onChanged: (newValue) {
//                                     setState(() {
//                                       _selectedProduct = newValue as String?;
//                                     });
//                                   },
//                                   items: widget.orderDetails.map((item) {
//                                     return DropdownMenuItem(
//                                       value: item['productName'],
//                                       child: Text(item['productName'] ?? 'Unknown Product'),
//                                     );
//                                   }).toList(),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         DropdownButton<String>(
//                           hint: Text('Select Product'),
//                           value: 'Acer LCD Monitor',
//                           items: <String>['Acer LCD Monitor', 'Samsung LED Monitor', 'LG OLED Monitor']
//                               .map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (newValue) {
//                             // Handle dropdown change
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           )
//         ],
//       ),
//     );
//   }
// }
