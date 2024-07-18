// import 'package:flutter/material.dart';
// import 'package:btb/sprint2/product.dart';
//
// class OredrPage5 extends StatefulWidget {
//   final List<Product> savedProducts;
//
//   const OredrPage5({required this.savedProducts});
//
//   @override
//   State<OredrPage5> createState() => _OredrPage5State();
// }
//
// class _OredrPage5State extends State<OredrPage5> {
//   List<Product> savedProducts = [];
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   selectedProducts = widget.selectedProducts;
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Selected Products'),
//       ),
//       body: ListView.builder(
//         itemCount: widget.savedProducts.length,
//         itemBuilder: (context, index) {
//           final product = widget.savedProducts[index];
//           return ListTile(
//             title: Text(product.productName),
//             subtitle: Text(product.category),
//             trailing: IconButton(
//               icon: Icon(Icons.remove),
//               onPressed: () {
//                 setState(() {
//                   widget.savedProducts.remove(product);
//                 });
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }