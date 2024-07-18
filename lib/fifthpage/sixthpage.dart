// Table(
//   border: TableBorder.all(color: Colors.grey, width: 2.0),
//   columnWidths: {
//     0: FlexColumnWidth(2),
//     1: FlexColumnWidth(3),
//     2: FlexColumnWidth(1),
//     3: FlexColumnWidth(2),
//     4: FlexColumnWidth(1),
//     5: FlexColumnWidth(1),
//     6: FlexColumnWidth(1),
//   },
//   children: [
//     TableRow(
//       children: [
//         TableCell(
//           child: SizedBox(
//             height:
//             50, // set the height of the first cell in the first column to 50
//             child: Center(
//               child: Text(
//                 'Product No',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign
//                     .center, // set the alignment of the text to center
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           child: SizedBox(
//             height:
//             50, // set the height of the first cell in the second column to 50
//             child: Center(
//               child: Text(
//                 'Desc1',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign
//                     .left, // set the alignment of the text to left
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           child: SizedBox(
//             height:
//             50, // set the height of the first cell in the third column to 50
//             child: Center(
//               child: Text(
//                 'Price',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign
//                     .right, // set the alignment of the text to right
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           child: SizedBox(
//             height:
//             50, // set the height of the first cell in the fourth column to 50
//             child: Center(
//               child: Text(
//                 'Order QTY',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign
//                     .center, // set the alignment of the text to center
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           child: SizedBox(
//             height:
//             50, // set the height of the first cell in the fifth column to 50
//             child: Center(
//               child: Text(
//                 'UOM',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign
//                     .center, // set the alignment of the text to center
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           child: SizedBox(
//             height:
//             50, // set the height of the first cell in the sixth column to 50
//             child: Center(
//               child: Text(
//                 'Variation',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign
//                     .center, // set the alignment of the text to center
//               ),
//             ),
//           ),
//         ),
//         TableCell(
//           child: SizedBox(
//             height:
//             50, // set the height of the first cell in the seventh column to 50
//             child: Center(
//               child: Text(
//                 'Add',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//                 textAlign: TextAlign
//                     .center, // set the alignment of the text to center
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//     TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 5, vertical: 8),
//           child: TableCell(
//             child: SizedBox(
//               height:
//               50, // set the height of the second cell in the first column to 30
//               child: Center(
//                 child: Text('$ProId'),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 5, vertical: 8),
//           child: TableCell(
//             child: SizedBox(
//               height:
//               50, // set the height of the second cell in the second column to 30
//               child: Center(
//                 child:
//                 Text('$ProName', textAlign: TextAlign.center),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 5, vertical: 8),
//           child: TableCell(
//             child: SizedBox(
//               height:
//               50, // set the height of the second cell in the third column to 30
//               child: Center(
//                 child: Text('$ProPrice'),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: 5, vertical: 8),
//           child: TableCell(
//             child: SizedBox(
//               height:
//               50, // set the height of the second cell in the fourth column to 30
//               child: Center(
//                 child: Text('0', textAlign: TextAlign.center),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 6),
//           child: TableCell(
//             child: SizedBox(
//               height:
//               50, // set the height of the first cell in the sixth column to 50
//               child: Center(
//                 child: DropdownButtonFormField<String>(
//                   value: selectedUOM,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedUOM = newValue!;
//                     });
//                   },
//                   items: uomList.map<DropdownMenuItem<String>>(
//                           (String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 6),
//           child: TableCell(
//             child: SizedBox(
//               height:
//               50, // set the height of the first cell in the sixth column to 50
//               child: Center(
//                 child: DropdownButtonFormField<String>(
//                   value: selectedVariation,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedVariation = newValue!;
//                     });
//                   },
//                   items: variationList
//                       .map<DropdownMenuItem<String>>(
//                           (String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 6),
//           child: TableCell(
//             child: SizedBox(
//               height:
//               50, // set the height of the first cell in the seventh column to 50
//               child: Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Icons.add,
//                       color: Colors.white,
//                     ),
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ],
// ),
