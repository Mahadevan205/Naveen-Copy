import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  // Future<String?> filePicker() async {
  //   Uint8List? imageStore;
  //   //Files Allowed Only Picker.
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'], // Specify allowed image file extensions
  //   );
  //   if (result != null) {
  //     try {
  //       setState(() {
  //         Uint8List? fileBytes = result.files.first.bytes;
  //         // Get current date and time with milliseconds since the epoch
  //         DateTime now = DateTime.now();
  //         int millisecondsSinceEpoch = now.millisecondsSinceEpoch;
  //         String first5char=millisecondsSinceEpoch.toString().substring(0,5);
  //         print('-------first5char-------');
  //         print(first5char);
  //         // Create filename with date and time
  //         // String fileName = '${DateTime.now()}$millisecondsSinceEpoch${result.files.first.name}';
  //         String fileName = '${DateTime.now().toString().replaceAll(RegExp(r'[-:.\s]'), '')}$first5char${result.files.first.name}';
  //         print('----------------');
  //         print(fileName);
  //         storeImageBytes=fileBytes;
  //       });
  //       // Return the generated filename
  //       // return fileName;
  //     } catch (e) {
  //       print('Error uploading file: $e');
  //       return null;
  //     }
  //   }
  //   return null;
  // }
  // has context menu
  Future<void> openImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Use the picked file (upload it, display it, etc.)
      print('Image picked: ${pickedFile.path}');
    } else {
      print('No image picked');
    }
  }
}
