// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
//
// void main(){
//   runApp(MaterialApp(home: DeliveryLocation(),));
// }
//
//
// class DeliveryLocation extends StatefulWidget {
//   const DeliveryLocation({Key? key}) : super(key: key);
//
//   @override
//   _DeliveryLocationState createState() => _DeliveryLocationState();
// }
//
// class _DeliveryLocationState extends State<DeliveryLocation> {
//   final TextEditingController deliveryaddressController =
//   TextEditingController();
//   final TextEditingController ContactPersonController =
//   TextEditingController();
//   final TextEditingController ContactNumberController =
//   TextEditingController();
//   final TextEditingController CommentsController = TextEditingController();
//
//   String? _selectedDeliveryLocation;
//   final List<String> list = [
//     'Select Delivery Location',
//     'Location 1',
//     'Location 2',
//     'Location 3'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body:
//       Padding(
//         padding: const EdgeInsets.only(left: 50, top: 50, right: 100),
//         child: Container(
//           height: 380,
//           width: 2100,
//           padding: const EdgeInsets.all(2),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey, width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, top: 10),
//                     child: Text(
//                       'Delivery Location',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     'Address',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, right: 30),
//                     child: Row(
//                       children: [
//
//                         Expanded(
//                           child: Container(
//                             height: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//
//                         Expanded(
//                           child: Container(
//                             height: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Container(
//                             height: 350,
//                             width: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             height: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//
//   }
// }

// for all screens without documents and edit screens

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// void main(){
//   runApp(MaterialApp(
//     home:TableExample() ,
//   ));
// }
//
//
// class TableExample extends StatelessWidget {
//   final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
//   @override
//   Widget build(BuildContext context) {
//     TableRow row1 = TableRow(
//       children: [
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
//             child: Text('Delivery Location'),
//           ),
//         ),
//         TableCell(
//           child: Text(''),
//         ),
//       ],
//     );
//
//     TableRow row2 = TableRow(
//       children: [
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
//             child: Text('Address'),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
//             child: Text('Comments'),
//           ),
//         ),
//       ],
//     );
//     TableRow row3 = TableRow(
//       children: [
//         TableCell(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding:  EdgeInsets.only(left: 30,top: 10),
//                       child: Text('Select Delivery Location'),
//                     ),
//                     SizedBox(height: 10,),
//                     Padding(
//                       padding:  EdgeInsets.only(left: 30),
//                       child: SizedBox(
//                         width: 400,
//                         height: 40,
//                         child: DropdownButtonFormField<String>(
//                         //  value: _selectedDeliveryLocation,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.grey.shade200,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: BorderSide.none,
//                             ),
//                             hintText: 'Select Location',
//                             contentPadding:const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 8),
//                           ),
//                           onChanged: (String? value) {
//                             // setState(() {
//                             //   _selectedDeliveryLocation = value!;
//                             // });
//                           },
//                           items: list.map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           isExpanded: true,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding:  EdgeInsets.only(left: 30),
//                       child: Text('Delivery Address'),
//                     ),
//                     SizedBox(height: 10,),
//                     Padding(
//                       padding:  EdgeInsets.only(left: 30),
//                       child: SizedBox(
//                         width: 400,
//                         child: TextField(
//                           //controller: deliveryaddressController,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor:Colors.grey.shade200,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: BorderSide.none,
//                             ),
//                             hintText: 'Enter Your Address',
//                           ),
//                           maxLines: 3,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 30),
//               Expanded(
//                 flex: 3,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: const Text('Contact Person'),
//                     ),
//                     SizedBox(height: 10,),
//                     SizedBox(
//                       width: 290,
//                       height: 40,
//                       child: TextField(
//                         //controller: ContactPersonController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             borderSide: BorderSide.none,
//                           ),
//                           hintText: 'Contact Person Name',
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 8),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     const Text('Contact Number'),
//                     SizedBox(height: 10,),
//                     SizedBox(
//                       width: 290,
//                       height: 40,
//                       child: TextField(
//                         //controller: ContactNumberController,
//                         keyboardType:
//                         TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter
//                               .digitsOnly,
//                           LengthLimitingTextInputFormatter(
//                               10),
//                           // limits to 10 digits
//                         ],
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             borderSide: BorderSide.none,
//                           ),
//                           hintText: 'Contact Person Number',
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         TableCell(
//           child: Expanded(
//             flex: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('    '),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 10,left: 10,bottom: 5),
//                   child: SizedBox(
//                     height: 250,
//                     child: TextField(
//                       // controlleCommentsController,
//                       decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.grey.shade200,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             borderSide: BorderSide.none,
//                           ),
//                           hintText: 'Enter Your Comments'
//
//
//                       ),
//                       maxLines: 5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//
//     return Scaffold(
//       body:
//       Padding(
//         padding: const EdgeInsets.only(left: 250,right: 100,top: 250),
//         child: Container(
//             decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xFFB2C2D3)),
//              borderRadius: BorderRadius.circular(3.5), // Set border radius here
//           ),
//           child: Table(
//             border: TableBorder.all(color: Color(0xFFB2C2D3)),
//
//             columnWidths: {
//               0: FlexColumnWidth(2),
//               1: FlexColumnWidth(1.4),
//             },
//             children: [
//               row1,
//               row2,
//               row3,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
//
// void main(){
//   runApp(MaterialApp(home: DeliveryLocation(),));
// }
//
//
// class DeliveryLocation extends StatefulWidget {
//   const DeliveryLocation({Key? key}) : super(key: key);
//
//   @override
//   _DeliveryLocationState createState() => _DeliveryLocationState();
// }
//
// class _DeliveryLocationState extends State<DeliveryLocation> {
//   final TextEditingController deliveryaddressController =
//   TextEditingController();
//   final TextEditingController ContactPersonController =
//   TextEditingController();
//   final TextEditingController ContactNumberController =
//   TextEditingController();
//   final TextEditingController CommentsController = TextEditingController();
//
//   String? _selectedDeliveryLocation;
//   final List<String> list = [
//     'Select Delivery Location',
//     'Location 1',
//     'Location 2',
//     'Location 3'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body:
//       Padding(
//         padding: const EdgeInsets.only(left: 50, top: 50, right: 100),
//         child: Container(
//           height: 380,
//           width: 2100,
//           padding: const EdgeInsets.all(2),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey, width: 2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, top: 10),
//                     child: Text(
//                       'Delivery Location',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     'Address',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 30, right: 30),
//                     child: Row(
//                       children: [
//
//                         Expanded(
//                           child: Container(
//                             height: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//
//                         Expanded(
//                           child: Container(
//                             height: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Container(
//                             height: 350,
//                             width: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             height: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main(){
  runApp(MaterialApp(
    home:TableExample() ,
  ));
}
class TableExample extends StatelessWidget {
  final List<String> list = ['  Name 1', '  Name 2', '  Name3'];
  @override
  Widget build(BuildContext context) {
    TableRow row1 = TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
            child: Text('Delivery Location'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left
                : 140),
            child: Row(
              children: [
                const Text(
                  'Order Date',
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEBF3FF), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 35,
                    width: 175,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextFormField(
                      // enabled: isEditing,
                      // controller: CreatedDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            iconSize: 20,
                            onPressed: () {
                              //   _showDatePicker(context);
                            },
                          ),
                        ),
                        // hintText: _selectedDate != null
                        //     ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        //     : 'Select Date',
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        border: InputBorder.none,
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    TableRow row2 = TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 30,top: 10,bottom: 10),
            child: Text('Address'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
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
                    Padding(
                      padding:  EdgeInsets.only(left: 30,top: 10),
                      child: Text('Select Delivery Location'),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding:  EdgeInsets.only(left: 30),
                      child: SizedBox(
                        width: 400,
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          //  value: _selectedDeliveryLocation,
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
                            // setState(() {
                            //   _selectedDeliveryLocation = value!;
                            // });
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
                    SizedBox(height: 20),
                    Padding(
                      padding:  EdgeInsets.only(left: 30),
                      child: Text('Delivery Address'),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding:  EdgeInsets.only(left: 30),
                      child: SizedBox(
                        width: 400,
                        child: TextField(
                          //controller: deliveryaddressController,
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
              SizedBox(width: 30),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: const Text('Contact Person'),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: 290,
                      height: 40,
                      child: TextField(
                        //controller: ContactPersonController,
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
                    SizedBox(height: 20),
                    const Text('Contact Number'),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: 290,
                      height: 40,
                      child: TextField(
                        //controller: ContactNumberController,
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
                          // controlleCommentsController,
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
          ),
        ),
      ],
    );

    return Scaffold(
      body:
      Padding(
        padding: const EdgeInsets.only(left: 250,right: 100,top: 250),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFB2C2D3)),
            borderRadius: BorderRadius.circular(3.5), // Set border radius here
          ),
          child: Table(
            border: TableBorder.all(color: Color(0xFFB2C2D3)),

            columnWidths: {
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
    );
  }
}