import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Take full width
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 25),
            child: Image.asset('images/Final-Ikyam-Logo.png'),
          ),
          SizedBox(height: 50), // You can adjust this value
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4, // Take 70% of screen width
              height: MediaQuery.of(context).size.width * 0.3, // Take 70% of screen width
              child: Image.asset(
                'images/ikyam1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 25),
            child: Image.asset('images/Final-Ikyam-Logo.png'),
          ),
          SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              child: Image.asset(
                'images/ikyam1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


 */
