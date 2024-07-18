
import 'dart:ui';

import 'package:flutter/material.dart';

const primaryColor = Color(0xFFFFFFFF);
const mHoverColor = Color(0xFFE3F2FD);
const mSaveButton = Color(0xFF4098D7);
const mSaveButtonBorder = Color(0x6EB1E1FF);
const mGreyDivider = Color(0x1F000000);
const mTextFieldBorder = Color(0xff9FB3C8);
const mErrorColor = Color(0xFFC62828);

TextStyle textFieldStyle = TextStyle(fontWeight: FontWeight.bold,
  fontFamily: 'Arial', // Assuming Arial or similar sans-serif font
  color: Colors.grey[600], // Light grey color
);

TextStyle textFieldStyle2 = TextStyle(fontWeight: FontWeight.bold,
  fontFamily: 'Arial', // Assuming Arial or similar sans-serif font
  color: Colors.white, // Light grey color
);

customPopupDecoration({required String hintText, bool? error, bool? isFocused}) {
  return InputDecoration(
    hoverColor: mHoverColor,
    suffixIcon:  const Icon(Icons.arrow_drop_down_circle_sharp, color: mSaveButton, size: 14),
    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    constraints: const BoxConstraints(maxHeight: 35),
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 14, color: Color(0xB2000000)),
    counterText: '',
    contentPadding: const EdgeInsets.fromLTRB(12, 00, 0, 0),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: isFocused == true ? Colors.blue : error == true ? mErrorColor : mTextFieldBorder)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: error == true ? mErrorColor : mTextFieldBorder)),
    focusedBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: error == true ? mErrorColor : Colors.blue)),
  );
}

textFieldDecoration({required String hintText, bool? error}) {
  return  InputDecoration(
    border: const OutlineInputBorder(
        borderSide: BorderSide(color:  Colors.blue)),
    constraints: BoxConstraints(maxHeight: error==true ? 60:35),
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 14,),
    counterText: '',
    contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
    enabledBorder:const OutlineInputBorder(borderSide: BorderSide(color: mTextFieldBorder)),
    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  );
}

