// import 'dart:io';
// import 'package:flutter/foundation.dart'; // Import foundation.dart
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final ImagePicker picker = ImagePicker();
//   File? _image;
//   String? _imageUrl; // Add this to handle web images
//
//   Future<void> getImage(ImageSource source) async {
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         if (kIsWeb) {
//           _imageUrl = pickedFile.path;
//         } else {
//           _image = File(pickedFile.path);
//         }
//       });
//     }
//   }
//
//   void _selectImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         if (kIsWeb) {
//           _imageUrl = pickedFile.path;
//         } else {
//           _image = File(pickedFile.path);
//         }
//       });
//     }
//   }
//
//   void _navigateToSecondPage() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               MySecondPage(image: _image, imageUrl: _imageUrl)),
//     );
//
//     if (result != null) {
//       setState(() {
//         _image = result['image'];
//         _imageUrl = result['imageUrl'];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Demo'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 200,
//             width: 200,
//             decoration: BoxDecoration(
//               border: Border.all(),
//             ),
//             child: _image == null && _imageUrl == null
//                 ? Center(child: Text('No Image'))
//                 : kIsWeb
//                     ? Image.network(_imageUrl!)
//                     : Image.file(_image!),
//           ),
//           ElevatedButton(
//             onPressed: _selectImage,
//             child: Text('Select Image'),
//           ),
//           ElevatedButton(
//             onPressed: _navigateToSecondPage,
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MySecondPage extends StatefulWidget {
//   final File? image;
//   final String? imageUrl; // Add this to handle web images
//
//   MySecondPage({required this.image, required this.imageUrl});
//
//   @override
//   _MySecondPageState createState() => _MySecondPageState();
// }
//
// class _MySecondPageState extends State<MySecondPage> {
//   File? _image;
//   String? _imageUrl; // Add this to handle web images
//
//   void _updateForm() {
//     Navigator.pop(
//       context,
//       {
//         'image': _image,
//         'imageUrl': _imageUrl,
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _image = widget.image;
//     _imageUrl = widget.imageUrl;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Demo'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 200,
//             width: 200,
//             decoration: BoxDecoration(
//               border: Border.all(),
//             ),
//             child: _image == null && _imageUrl == null
//                 ? Center(child: Text('No Image'))
//                 : kIsWeb
//                     ? Image.network(_imageUrl!)
//                     : Image.file(_image!),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final pickedFile =
//                   await ImagePicker().pickImage(source: ImageSource.gallery);
//
//               if (pickedFile != null) {
//                 setState(() {
//                   if (kIsWeb) {
//                     _imageUrl = pickedFile.path;
//                   } else {
//                     _image = File(pickedFile.path);
//                   }
//                 });
//               }
//             },
//             child: Text('Update Image'),
//           ),
//           ElevatedButton(
//             onPressed: _updateForm,
//             child: Text('Update'),
//           ),
//         ],
//       ),
//     );
//   }
// }
