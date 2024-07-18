// class Product {
//
//   @override
//   String toString() {
//     return 'Product{proId: $proId, productName: $productName, category: $category, subCategory: $subCategory, price: $price, tax: $tax, unit: $unit, discount: $discount, selectedUOM: $selectedUOM, selectedVariation: $selectedVariation, quantity: $quantity, total: $total, totalamount: $totalamount}';
//   }
//
//   final String proId;
//   String productName;
//   String category;
//   String subCategory;
//   double price;
//   final String tax;
//   final String unit;
//   final String discount;
//   String selectedUOM;
//   String selectedVariation;
//   int quantity;
//   double total;
//   double totalamount;
//
//   Product({
//     required this.proId,
//     required this.productName,
//     required this.category,
//     required this.subCategory,
//     required this.price,
//     required this.tax,
//     required this.unit,
//     required this.discount,
//     required this.selectedUOM,
//     required this.selectedVariation,
//     required this.quantity,
//     required this.total,
//     required this.totalamount,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       proId: json['proId']?? '',
//       productName: json['productName']?? '',
//       category: json['category']?? '',
//       subCategory: json['subCategory']?? '',
//       price: (json['price'] is String? double.tryParse(json['price']) : json['price']?.toDouble())?? 0.0,
//       tax: json['tax']?? '',
//       unit: json['unit']?? '',
//       discount: json['discount']?? '',
//       selectedUOM: json['uom']?? 'Select',
//       selectedVariation: json['variation']?? 'Select',
//       quantity: (json['quantity'] is String? int.tryParse(json['quantity']) : json['quantity'])?? 0,
//       total: (json['totalamount'] is String? double.tryParse(json['total']) : json['total'])?? 0.0,
//       totalamount: (json['total'] is String? double.tryParse(json['totalamount']) : json['totalamount'])?? 0.0,
//     );
//   }
//
//   Map<String, dynamic> asMap() {
//     return {
//       'proId': proId,
//       'productName': productName,
//       'category': category,
//       'ubCategory': subCategory,
//       'price': price,
//       'tax': tax,
//       'unit': unit,
//       'discount': discount,
//       'electedUOM': selectedUOM,
//       'electedVariation': selectedVariation,
//       'quantity': quantity,
//       'total': total,
//       'totalamount':totalamount,
//     };
//   }
// }