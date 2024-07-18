import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dropdown Filter Example'),
        ),
        body: DropdownFilterExample(),
      ),
    );
  }
}

class DropdownFilterExample extends StatefulWidget {
  @override
  _DropdownFilterExampleState createState() => _DropdownFilterExampleState();
}

class _DropdownFilterExampleState extends State<DropdownFilterExample> {
  String? selectedCategory;
  String? selectedItem;
  final List<String> categories = ['Fruit', 'Vegetable'];
  final Map<String, List<String>> items = {
    'Fruit': ['Apple', 'Banana', 'Orange'],
    'Vegetable': ['Carrot', 'Broccoli', 'Spinach']
  };
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items.values.expand((element) => element).toList();
  }

  void filterItems() {
    setState(() {
      if (selectedCategory != null) {
        filteredItems = items[selectedCategory] ?? [];
        if (selectedItem != null && !filteredItems.contains(selectedItem)) {
          selectedItem = null;
        }
      } else {
        filteredItems = items.values.expand((element) => element).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          hint: Text('Select Category'),
          value: selectedCategory,
          items: categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedCategory = newValue;
              selectedItem = null; // Reset the second dropdown
              filterItems();
            });
          },
        ),
        DropdownButton<String>(
          hint: Text('Select Item'),
          value: selectedItem,
          items: filteredItems.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedItem = newValue;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredItems[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
