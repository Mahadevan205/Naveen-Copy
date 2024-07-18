// import 'package:flutter/material.dart';
// import 'package:btb/sprint2/orderpage2.dart';
//
// void main() {
//   runApp(const OrderPage1());
// }
//
// class OrderPage1 extends StatefulWidget {
//   const OrderPage1({super.key});
//
//   @override
//   State<OrderPage1> createState() => _OrderPage1State();
// }
//
// class _OrderPage1State extends State<OrderPage1> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: const Color(0xFFFFFFFF),
//         appBar: AppBar(
//           title: Image.asset("images/Final-Ikyam-Logo.png"),
//           backgroundColor: const Color(0xFFFFFFFF),
//           elevation: 4.0,
//           shadowColor: const Color(0xFFFFFFFF),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 30),
//               child: IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon press
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 100),
//               child: IconButton(
//                 icon: const Icon(Icons.account_circle),
//                 onPressed: () {
//                   // Handle user icon press
//                 },
//               ),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.only(top: 20, left: 1000),
//           child: Builder(
//             builder: (context) {
//               return OutlinedButton(
//                 onPressed: () {
//                   // print('button clicked');
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const OrderPage2(),
//                     ),
//                   );
//                 },
//                 style: OutlinedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   side: BorderSide.none,
//                 ),
//                 child: const Text(
//                   "Create",
//                   style: TextStyle(color: Colors.white, fontSize: 15),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }