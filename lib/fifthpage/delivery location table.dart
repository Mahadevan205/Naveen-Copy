import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: AddressCommentsContainer(),
      ),
    ),
  ));
}
class AddressCommentsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 200,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Comments',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items at the start vertically
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(child: Text('Address Details')),
                  ),
                ),
                VerticalDivider(color: Colors.grey, width: 1),
                Expanded(
                  flex: 2, // Adjust the flex property to give more space to the comments section
                  child: Container(
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 1.0,
                          width: 1.0,
                          color: Colors.grey, // Vertical line at the start
                          margin: EdgeInsets.only(right: 4.0), // Adjust margin if needed
                        ),
                        SizedBox(height: 4.0), // Adjust spacing if needed
                        Text('Comments Section'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
