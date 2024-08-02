import 'dart:convert';
import 'dart:html';
import 'package:btb/Return%20Module/return%20first%20page.dart';
import 'package:btb/Product%20Module/Edit.dart';
import 'package:btb/Product Module/Product Screen.dart';
import 'package:btb/screen/login.dart';
import 'package:btb/Order%20Module/add%20productmaster%20sample.dart';
import 'package:btb/Order%20Module/eighthpage.dart';
import 'package:btb/Order%20Module/fifthpage.dart';
import 'package:btb/Order%20Module/firstpage.dart';
import 'package:btb/Order%20Module/fourthpage.dart';
import 'package:btb/Order%20Module/secondpage.dart';
import 'package:btb/Order%20Module/seventhpage%20.dart';
import 'package:btb/Order%20Module/sixthpage.dart';
import 'package:btb/Order%20Module/thirdpage.dart';
import 'package:btb/screen/dashboard.dart';
import 'package:btb/widgets/productclass.dart' as ord;
import 'package:btb/widgets/productclass.dart';
import 'package:btb/Product%20Module/thirdpage%201.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Product Module/Create Product.dart';
import 'Return Module/return image.dart';
import 'Return Module/return module design.dart';
import 'Return Module/return ontap.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final productProvider = ProductProvider();
  await productProvider.init();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExtraDataProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductdetailProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider(prefs)),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

abstract class PageName {
  static const homeRoute = '/';
  static const dashboardRoute = '/dashboard';
  static const subpage1 = 'subpage1'; // Relative path, no leading slash
  static const subpage2 = 'subpage2'; // Relative path, no leading slash
  static const subsubPage1 = 'subsubPage1';
  static const main = '/main';
//  static const dashboardRoute1 = '/dashboard1';
  static const subpage1Main = 'subpage1Main'; // Relative path, no leading slash
  static const subpage2Main = 'subpage2Main';
  static const subpage22main = 'subpage22main';
  static const subsubpage2Main =
      'subsubpage2Main'; // Relative path, no leading slash
}

class MyApp extends StatelessWidget {


  final _router = GoRouter(
    initialLocation: window.sessionStorage.containsKey('token') ? '/dashboard' : '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScr(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) =>  DashboardPage(),
      ),
      GoRoute(
        path: '/Orders/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/Order_List',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/dashboard/addproduct',
        builder: (context, state) => const SecondPage(),
      ),
      GoRoute(
        path: '/dashboard/productpage/:product/addproduct',
        builder: (context, state) => const SecondPage(),
      ),
      GoRoute(
        path: '/return-view',
        builder: (context, state) {
          final returnMaster = state.extra as ReturnMaster?;
          return ReturnView(returnMaster: returnMaster);
        },
      ),
      GoRoute(
        path: '/Add_Image',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?; // Cast to Map<String, dynamic>

          final orderDetails = extra?['orderDetails'] as List<dynamic>;
          final storeImages = extra?['storeImages'] as List<String>;
          final imageSizeStrings = extra?['imageSizeStrings'] as List<String>;
          final orderDetailsMap = extra?['orderDetailsMap'] as Map<String, dynamic>;

          return ReturnImage(
            orderDetails: orderDetails,
            storeImages: storeImages,
            imageSizeStrings: imageSizeStrings,
            orderDetailsMap: orderDetailsMap,
          );
        },
      ),
      GoRoute(
        //remain me to use as last sprint consult wtih krishna sir
        path: '/dashboard/productpage/:product/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        //remain me to use as last sprint consult wtih krishna sir
        path: '/Return_List',
        builder: (context, state) => const Returnpage(),
      ),

      GoRoute(
        path: '/dashboard/productpage/:product',
        builder: (context, state) {
          final product = state.extra as ord.Product?;
          return ProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/dashboard/return/:return',
        builder: (context, state) {
          // final product = state.extra as ord.Product?;
          return const Returnpage();
        },
      ),
      GoRoute(
        path: '/OrdersList',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return const SixthPage(
              product: null,
              item: [],
              body: {},
              itemsList: [],
              orderDetails: [],
            );
          } else {
            return SixthPage(
              product: extra['product'] as detail?,
              item: List<Map<String, dynamic>>.from(extra['item']),
              body: Map<String, dynamic>.from(extra['body']),
              itemsList: List<Map<String, dynamic>>.from(extra['itemsList']),
              orderDetails: List<OrderDetail>.from(extra['orderDetails']),
            );
          }
        },
      ),
      // GoRoute(
      //     path: '/sixthPage/ontap',
      //     builder: (context, state) {
      //       final extra = state.extra as Map<String, dynamic>?;
      //       if (extra == null) {
      //         // Handle the case when extra is null
      //         context.read<OrderProvider>().loadData(); // Add this line
      //         return SixthPage(
      //           product: context.read<OrderProvider>().product,
      //           item: context.read<OrderProvider>().item,
      //           body: context.read<OrderProvider>().body,
      //           itemsList: context.read<OrderProvider>().itemsList,
      //         );
      //       } else {
      //         context.read<OrderProvider>().loadData(); // Add this line
      //         return SixthPage(
      //           product: extra['product'] as detail?,
      //           item: List<Map<String, dynamic>>.from(extra['item']),
      //           body: Map<String, dynamic>.from(extra['body']),
      //           itemsList: List<Map<String, dynamic>>.from(extra['itemsList']),
      //         );
      //       }
      //     }
      // ),
      GoRoute(
        path: '/orders/productpage/:product',
        builder: (context, state) {
          final product = state.extra as ord.Product?;
          return ProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/PlaceOrder',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: FifthPage(
            selectedProducts: (state.extra as Map<String, dynamic>)['selectedProducts'] as List<Product> ?? [],
            data: (state.extra as Map<String, dynamic>)['data'] as Map<String, dynamic> ?? {},
            select: '',
          ),
        ),
      ),
      GoRoute(
        path: '/dasbaord/productpage/addproduct',
        builder: (context, state) => const SecondPage(),
      ),
      GoRoute(
        path: '/dashboard/Add_Product',
        builder: (context, state) => const SecondPage(),
      ),
      GoRoute(
        path: '/Download',
        builder: (context, state) => const EighthPage(),
      ),
      GoRoute(
        path: '/Product_List',
        builder: (context, state) {
          final product = state.extra as ord.Product?;
          return ProductPage(product: product);
        },
      ),
      GoRoute(
          path: '/Edit_Product',
          builder: (context, state) {
            final params = state.extra as Map<String, dynamic>;
            return ProductForm1(
                product: null,
                prodId: params['prodId'] ?? '',
                priceText: params['priceText'] ?? '',
                productText: params['productText'] ?? '',
                selectedvalue2: params['selectedvalue2'] ?? '',
                discountText: params['discountText'] ?? '',
                selectedValue: params['selectedValue'] ?? '',
                selectedValue1: params['selectedValue1'] ?? '',
                selectedValue3: params['selectedValue3'] ?? '',
                imagePath: params['imagePath'] ?? '',
                displayData: params['displayData'] ?? '');
          }


      ),
      GoRoute(
          path: '/dashboard/productpage/:View',
          builder: (context, state) {
            final product = state.extra as Product?;
            return ProductForm1(
              displayData: const {},
              prodId: product?.prodId,
              imagePath: null,
              productText: null,
              priceText: null,
              selectedValue: null,
              selectedValue1: null,
              selectedValue3: null,
              selectedvalue2: null,
              discountText: null,
              product: product,
            );
          }),
      GoRoute(
        path: '/Order_List/Documents',
        builder: (context, state) {
          //final extra = state.extra;
          Map<String, dynamic>? selectedProductsMap;
          final extra = state.extra as Map<String, dynamic>;

          if (extra != null) {
            selectedProductsMap = (extra as Map<String, dynamic>)['selectedProducts'] as Map<String, dynamic>?;
          }

          return SeventhPage(
            selectedProducts: selectedProductsMap ?? {},
            product: null,
            orderId: extra['orderId'] as String,
            orderDetails: List<OrderDetail>.from(extra['orderDetails']),

          );
        },
      ),
      GoRoute(
        name: 'editProductRoute',
        path: '/dashboard/productpage/:Edit/Edit',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>?; // Make it nullable
          if (params == null) {
            // If params is null, return a default EditOrder or handle it as per your requirement
            return const EditOrder(
              prodId: '',
              textInput: '',
              priceInput: '',
              discountInput: '',
              inputText: '',
              subText: '',
              unitText: '',
              taxText: '',
              imagePath: null,
              imageId: '',
              productData: {},
            );
          } else {
            return EditOrder(
              prodId: params['prodId'] ?? '',
              textInput: params['textInput'] ?? '',
              priceInput: params['priceInput'] ?? '',
              discountInput: params['discountInput'] ?? '',
              inputText: params['inputText'] ?? '',
              subText: params['subText'] ?? '',
              unitText: params['unitText'] ?? '',
              taxText: params['taxText'] ?? '',
              imagePath: params['imagePath'] ?? '',
              imageId: params['imageId'] ?? '',
              productData: params['productData'] ?? {},
            );
          }
        },
      ),
      GoRoute(
        path: '/dashboard/productpage/ontap/Edit/Update1',
        builder: (context, state) {
          final Map<String, dynamic> extra =
          state.extra as Map<String, dynamic>;
          return ProductForm1(
            displayData: extra['displayData'],
            product: extra['product'],
            imagePath: extra['imagePath'],
            productText: extra['productText'],
            selectedValue: extra['selectedValue'],
            selectedValue1: extra['selectedValue1'],
            selectedValue3: extra['selectedValue3'],
            selectedvalue2: extra['selectedvalue2'],
            priceText: extra['priceText'],
            discountText: extra['discountText'],
            prodId: extra['prodId'],
          );
        },
      ),
      GoRoute(
        path: '/dasbaord/Orderspage',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/Placed_Order_List',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SixthPage(
            product: extra['product'] as detail?,
            item: extra['item'] as List<Map<String, dynamic>>?,
            body: extra['body'] as Map<String, dynamic>,
            itemsList: extra['itemsList'] as List<Map<String, dynamic>>,
            orderDetails: List<OrderDetail>.from(extra['orderDetails']),
          );
        },
      ),
      // GoRoute(
      //   path: '/sixthpage-from-fifthpage',
      //   builder: (context, state) {
      //     detail? details;
      //     if (state.extra is detail) {
      //       details = state.extra as detail;
      //     }
      //
      //     final items = state.uri.queryParameters['items'] as List<Map<String, dynamic>>?;
      //     final body = state.uri.queryParameters['body'] as Map<String, dynamic>?;
      //     final itemsList = state.uri.queryParameters['itemsList'] as List<Map<String, dynamic>>?;
      //
      //     return SixthPage(
      //       product: details,
      //       item: items,
      //       body: body,
      //       itemsList: itemsList,
      //     );
      //   },
      // ),
      GoRoute(
        path: '/dasbaord/Secondpage/arrowback',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/Secondpage/orderspage',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/CreateOrder/Orderspage',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/:products/Orderspage',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/BeforplacingOrder/Orderspage',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/Create/Orderspage',
        builder: (context, state) => const Orderspage(),
      ),
      GoRoute(
        path: '/Orderspage/dasbaord',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/Orderspage/orders/dasbaord',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/Orderspage/create/dasbaord',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/Orderspage/placingorder/dasbaord',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/Orderspage/placingorder/productpage:product',
        builder: (context, state) {
          final product = state.extra as ord.Product?;
          return ProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/dasbaord//productpage/:product/Orderspage',
        builder: (context, state) => const OrderPage3(data: {}),
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/Products',
        builder: (context, state) => const OrderPage3(data: {}),
      ),
      GoRoute(
        path: '/dasbaord//OrderPage/:product/arrowBack',
        builder: (context, state) => const OrderPage3(data: {}),
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/productpage/:product',
        builder: (context, state) {
          final product = state.extra as ord.Product?;
          return ProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/orders/productpage/:product',
        builder: (context, state) {
          final product = state.extra as ord.Product?;
          return ProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/create/productpage/:product',
        builder: (context, state) {
          final product = state.extra as ord.Product?;
          return ProductPage(product: product);
        },
      ),
      GoRoute(
        path: '/Order_List/Product_List',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return OrderPage3(
              data: data ?? {}); // Pass an empty map if data is null
        },
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/addproduct/addparts/addbutton',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return NextPage(
            product: data?['product'] as Product,
            data: data?['data'] as Map<String, dynamic>,
            inputText: data?['inputText'] as String,
            subText: data?['subText'] as String, products: const [], selectedProducts: const [], notselect: '',
          );
        },
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/placeorder/arrowback',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return NextPage(
            product: data?['product'] as Product,
            data: data?['data'] as Map<String, dynamic>,
            inputText: data?['inputText'] as String,
            subText: data?['subText'] as String, products: const [], selectedProducts: const [], notselect: '',
          );
        },
      ),
      GoRoute(
        path: '/Edit_Order',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            child: SelectedProductPage(
              data: data ?? {}, // If data is null, use an empty map
              selectedProducts: const [],
            ),
          );
        },
      ),
      GoRoute(
        path: '/Edit_Order/Add_Product_Item',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return MaterialPage(
            child: SelectedProductPage(
              data: data ?? {}, // If data is null, use an empty map
              selectedProducts: const [],
            ),
          );
        },
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/addproduct/addparts/addbutton/saveproducts',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return FifthPage(
            selectedProducts: data?['selectedProducts'] as List<Product>,
            data: data?['data'] as Map<String, dynamic>, select: '',
          );
        },
      ),
      GoRoute(
        path: '/Create_Order',
        builder: (context, state) =>  OrdersSecond(),
      ),
      GoRoute(
        path: '/Order_Return',
        builder: (context, state) =>  CreateReturn(storeImages: const [],storeImage: '',imageSizeStrings: const [],imageSizeString: '',orderDetailsMap: const {},orderDetails: const [],),
      ),
      GoRoute(
        path: '/dasbaord/Orderspage/addproduct/arrowback',
        builder: (context, state) =>  OrdersSecond(),
      ),
      GoRoute(
        path: '/Order_List/Product_List/Add_Products',
        pageBuilder: (context, state) {
          final extraDataProvider = context.read<ExtraDataProvider>();
          final extraData = extraDataProvider.extraData;
          // final extraData = state.extra as Map<String, dynamic>;

          final product = extraData.containsKey('product') ? Product.fromJson(extraData['product']) :

          Product(prodId: '',productName: '',imageId: '',subCategory: '',selectedUOM: '',selectedVariation: '',totalamount: 0,total: 0,tax: '',totalAmount: 0,unit: '',discount: '',category: '',price: 0,qty: 0,quantity: 0);;
          // Provide default constructor or handle null case

          final data = extraData.containsKey('data') ? Map<String, dynamic>.from(extraData['data']) : {};
          final inputText = extraData.containsKey('inputText') ? extraData['inputText'] : '';
          final subText = extraData.containsKey('subText') ? extraData['subText'] : '';
          final newData = <String, dynamic>{};
          data.forEach((key, value) {
            if (key is String) {
              newData[key] = value;
            }
          });

          Map<String, dynamic> data1 = {};


          return MaterialPage(
            key: state.pageKey,
            child: NextPage(
              selectedProducts: const [],
              product: product,
              data: data1,
              inputText: inputText,
              subText: subText,
              products: const [],
              notselect: '',
            ),
          );
        },
      ),


      // GoRoute(
      //   path: '/dasbaord/Orderspage/addproduct',
      //   builder: (context, state) => const OrdersSecond(),
      // ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('An error occurred.'),
      ),
    );
  }
}




class ExtraDataProvider with ChangeNotifier {
  Map<String, dynamic> _extraData = {'data': {}, 'inputText': '', 'ubText': ''}; // Initialize with default values

  Map<String, dynamic> get extraData => _extraData;

  void setExtraData(Map<String, dynamic> data) {
    _extraData = data;
    notifyListeners();
  }

  @override
  String toString() {
    return 'ExtraDataProvider: $_extraData';
  }
}




class DataProvider extends ChangeNotifier {
  List<Product> _selectedProducts = [];
  Map<String, dynamic> _data = {};

  List<Product> get selectedProducts => _selectedProducts;
  Map<String, dynamic> get data => _data;

  void setSelectedProducts(List<Product> products) {
    _selectedProducts = products;
    notifyListeners();
  }

  void setData(Map<String, dynamic> newData) {
    _data = newData;
    notifyListeners();
  }
}



class ProductProvider with ChangeNotifier {
  bool _initialized = false;
  List<Product> _selectedProducts = [];
  Map<String, dynamic> _data = {};
  String _deliveryLocation = '';
  String _contactName = '';
  String _address = '';
  String _contactNumber = '';
  String _comments = '';
  String _date = '';
  String _totalAmount = '';

  List<Product> get selectedProducts => _selectedProducts;
  Map<String, dynamic> get data => _data;



  String get deliveryLocation => _deliveryLocation;
  set deliveryLocation(String value) {
    _deliveryLocation = value;
    notifyListeners();
  }


  String get contactName => _contactName;
  set contactName(String value) {
    _contactName = value;
    notifyListeners();
  }


  String get totalAmount => _totalAmount;
  set totalAmount(String value) {
    _totalAmount = value;
    notifyListeners();
  }


  String get address => _address;
  set address(String value) {
    _address = value;
    notifyListeners();
  }



  String get contactNumber => _contactNumber;
  set contactNumber(String value) {
    _contactNumber = value;
    notifyListeners();
  }


  String get comments => _comments;
  set comments(String value) {
    _comments = value;
    notifyListeners();
  }


  String get date => _date;
  set date(String value) {
    _date = value;
    notifyListeners();
  }

  ProductProvider(){
    init();
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final selectedProductsJson = prefs.getString('selectedProducts');
    final dataJson = prefs.getString('data');

    if (selectedProductsJson != null) {
      _selectedProducts = (jsonDecode(selectedProductsJson) as List)
          .map((e) => Product.fromJson(e))
          .toList();
      print('Selected products loaded: $_selectedProducts');
    }

    if (dataJson != null) {
      _data = jsonDecode(dataJson);
      print('Data loaded: $_data');
    }

    notifyListeners();
  }

  void updateSelectedProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProducts', jsonEncode(products.map((e) => e.toJson()).toList()));
    _selectedProducts = products;
    notifyListeners();
  }

  void updateData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(data));
    _data = data;
    notifyListeners();
  }


}


class ProductdetailProvider with ChangeNotifier {
  Product? _product;

  Product? get product => _product;

  void setProduct(Product product) {
    _product = product;
    notifyListeners();
  }
}

class OrderProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  detail? _product;
  List<Map<String, dynamic>>? _item;
  Map<String, dynamic>? _body;
  List<Map<String, dynamic>>? _itemsList;

  OrderProvider(this._prefs) {
    init(); // Initialize data on provider creation
  }

  detail? get product => _product;

  List<Map<String, dynamic>>? get item => _item;

  Map<String, dynamic>? get body => _body;

  List<Map<String, dynamic>>? get itemsList => _itemsList;

  // Future<void> init() async {
  //   try {
  //     // Load data from SharedPreferences
  //     final productString = await _prefs.getString('product');
  //     final itemString = await _prefs.getString('item');
  //     final bodyString = await _prefs.getString('body');
  //     final itemsListString = await _prefs.getString('itemsList');
  //
  //     // Convert the loaded strings to detail objects
  //     if (productString != null) {
  //       final productJson = jsonDecode(productString);
  //       _product = detail.fromJson(productJson);
  //     }
  //     if (itemString != null) {
  //       final itemJson = jsonDecode(itemString);
  //       _item = List<Map<String, dynamic>>.from(itemJson);
  //     }
  //     if (bodyString != null) {
  //       final bodyJson = jsonDecode(bodyString);
  //       _body = Map<String, dynamic>.from(bodyJson);
  //     }
  //     if (itemsListString != null) {
  //       final itemsListJson = jsonDecode(itemsListString);
  //       _itemsList = List<Map<String, dynamic>>.from(itemsListJson);
  //     }
  //
  //     // Print the loaded data
  //     print('Loaded Data:');
  //     print('Product: $_product');
  //     print('Item: $_item');
  //     print('Body: $_body');
  //     print('Items List: $_itemsList');
  //
  //     // Save data to SharedPreferences
  //     if (_product != null) {
  //       final productMap = {
  //         "orderId": _product?.orderId,
  //         "orderDate": _product?.orderDate,
  //         "total": _product?.total,
  //         "status": _product?.status,
  //         "deliveryStatus": _product?.deliveryStatus,
  //         "referenceNumber": _product?.referenceNumber,
  //       };
  //       await _prefs.setString('product', jsonEncode(productMap));
  //     }
  //     if (_item != null) {
  //       await _prefs.setString('item', jsonEncode(_item));
  //     }
  //     if (_body != null) {
  //       await _prefs.setString('body', jsonEncode(_body));
  //     }
  //     if (_itemsList != null) {
  //       await _prefs.setString('itemsList', jsonEncode(_itemsList));
  //     }
  //
  //     // Print the saved data
  //     print('Saved data:');
  //     print('Product: ${_prefs.getString('product')}');
  //     print('Item: ${_prefs.getString('item')}');
  //     print('Body: ${_prefs.getString('body')}');
  //     print('Items List: ${_prefs.getString('itemsList')}');
  //
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error saving data: $e');
  //   }
  // }
  Future<void> init() async {
    try {
      // Print the loaded data
      print('Loaded Data:');
      print('Product: $_product');
      print('Item: $_item');
      print('Body: $_body');
      print('Items List: $_itemsList');

      // Save data to SharedPreferences

      //convert jsonencode first

      print('Product save: $_product');
      print('Item: $_item');
      print('Body: $_body');
      print('Items List: $itemsList');

      String productJson = _product?.toJson() ?? '';
      String itemJson = jsonEncode(_item);
      String bodyJson = jsonEncode(_body);
      String itemsListJson = jsonEncode(_itemsList);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('product', productJson);
      await prefs.setString('item', itemJson);
      await prefs.setString('body', bodyJson);
      await prefs.setString('itemsList', itemsListJson);





      notifyListeners();

      await printSavedDetails;
    } catch (e) {
      print('Error loaading data: $e');
    }
  }


  Future<void> printSavedDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve data from SharedPreferences
      String? productJson = prefs.getString('product');
      String? itemJson = prefs.getString('item');
      String? bodyJson = prefs.getString('body');
      String? itemsListJson = prefs.getString('itemsList');

      if (productJson != null) {
        detail product = detail.fromString(productJson);
        print('Products: $product');
      } else {
        print('Products: null');
      }

      if (itemJson != null) {
        var item = jsonDecode(itemJson);
        print('Item: $item');
      } else {
        print('Item: null');
      }

      if (bodyJson != null) {
        var body = jsonDecode(bodyJson);
        print('Body: $body');
      } else {
        print('Body: null');
      }

      if (itemsListJson != null) {
        List<dynamic> itemsList = jsonDecode(itemsListJson);
        print('Items List: $itemsList');
      } else {
        print('Items List: null');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }
// after it shows null
  Future<void> loadData() async {
    final productJson = _prefs.getString('product');
    final itemJson = _prefs.getString('item');
    final bodyJson = _prefs.getString('body');
    final itemsListJson = _prefs.getString('itemsList');

    if (productJson != null) {
      _product = detail.fromJson(jsonDecode(productJson));
    }
    if (itemJson != null) {
      _item = List<Map<String, dynamic>>.from(jsonDecode(itemJson));
    }
    if (bodyJson != null) {
      _body = Map<String, dynamic>.from(jsonDecode(bodyJson));
    }
    if (itemsListJson != null) {
      _itemsList = List<Map<String, dynamic>>.from(jsonDecode(itemsListJson));
    }

    notifyListeners(); // Don't forget to notify the listeners
  }

  void setItem(savedItem) {}


//
// Future<void> init() async {
//   try {
//     // Load data from SharedPreferences
//     final productString = await _prefs.getString('product');
//     final itemString = await _prefs.getString('item');
//     final bodyString = await _prefs.getString('body');
//     final itemsListString = await _prefs.getString('itemsList');
//
//     // Convert the loaded strings to detail objects
//     if (productString != null) {
//       final productJson = jsonDecode(productString);
//       _product = detail.fromJson(productJson);
//     }
//     if (itemString != null) {
//       final itemJson = jsonDecode(itemString);
//       _item = List<Map<String, dynamic>>.from(itemJson);
//     }
//     if (bodyString != null) {
//       final bodyJson = jsonDecode(bodyString);
//       _body = Map<String, dynamic>.from(bodyJson);
//     }
//     if (itemsListString != null) {
//       final itemsListJson = jsonDecode(itemsListString);
//       _itemsList = List<Map<String, dynamic>>.from(itemsListJson);
//     }
//
//     // Print the loaded data
//     print('Loaded Data:');
//     print('Product: ${_product?.toJson()}');
//     print('Item: $_item');
//     print('Body: $_body');
//     print('Items List: $_itemsList');
//
//     notifyListeners();
//   } catch (e) {
//     print('Error loading data: $e');
//   }
// }
//
// Future<void> saveData() async {
//   try {
//     // Save data to SharedPreferences
//     if (_product != null) {
//       await _prefs.setString('product', jsonEncode(_product?.toJson()));
//     }
//     if (_item != null) {
//       await _prefs.setString('item', jsonEncode(_item));
//     }
//     if (_body != null) {
//       await _prefs.setString('body', jsonEncode(_body));
//     }
//     if (_itemsList != null) {
//       await _prefs.setString('itemsList', jsonEncode(_itemsList));
//     }
//
//     // Print the saved data
//     print('Saved data:');
//     print('Product: ${_prefs.getString('product')}');
//     print('Item: ${_prefs.getString('item')}');
//     print('Body: ${_prefs.getString('body')}');
//     print('Items List: ${_prefs.getString('itemsList')}');
//
//     notifyListeners();
//   } catch (e) {
//     print('Error saving data: $e');
//   }
// }
//
// void updateProduct(detail newProduct) {
//   _product = newProduct;
//   saveData(); // Save the data to SharedPreferences
//   notifyListeners(); // Notify the listeners that the data has changed
// }

}

class NavigationProvider with ChangeNotifier {
  detail? _details;
  List<Map<String, dynamic>>? _items;
  Map<String, dynamic>? _body;
  List<Map<String, dynamic>>? _itemsList;

  detail? get details => _details;
  List<Map<String, dynamic>>? get items => _items;
  Map<String, dynamic>? get body => _body;
  List<Map<String, dynamic>>? get itemsList => _itemsList;

  void setDetails({
    required detail? detail,
    required List<Map<String, dynamic>>? item,
    required Map<String, dynamic>? body,
    required List<Map<String, dynamic>>? itemsList,
  }) {
    _details = detail;
    _items = items;
    _body = body;
    _itemsList = itemsList;
    notifyListeners();
    saveData();
  }


  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final details = {
      'product': _details,
      'item': _items,
      'body': _body,
      'itemsList': _itemsList,
    };
    prefs.setString('details', jsonEncode(details));
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('details');
    if (data != null) {
      final details = jsonDecode(data);
      _details = details['product'];
      _items = details['item'];
      _body = details['body'];
      _itemsList = List<Map<String, dynamic>>.from(details['itemsList']);
      notifyListeners();
    }
  }
// this is a updated urnning trying to fix


  // Future<void> init() async {
  //   try {
  //     // Load data from SharedPreferences
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     String? savedProductJson = prefs.getString('product');
  //     String? savedItemJson = prefs.getString('item');
  //     String? savedBodyJson = prefs.getString('body');
  //     String? savedItemsListJson = prefs.getString('itemsList');
  //
  //     if (savedProductJson != null) {
  //       _details = detail.fromString(savedProductJson);
  //       print('Loaded Product: $_details');
  //     } else {
  //       print('Loaded Product: null');
  //     }
  //
  //     if (savedItemJson != null) {
  //       _items = jsonDecode(savedItemJson);
  //       print('Loaded Item: $_items');
  //     } else {
  //       print('Loaded Item: null');
  //     }
  //
  //     if (savedBodyJson != null) {
  //       _body = jsonDecode(savedBodyJson);
  //       print('Loaded Body: $_body');
  //     } else {
  //       print('Loaded Body: null');
  //     }
  //
  //     if (savedItemsListJson != null) {
  //       _itemsList = jsonDecode(savedItemsListJson);
  //       print('Loaded Items List: $_itemsList');
  //     } else {
  //       print('Loaded Items List: null');
  //     }
  //
  //     // Print the loaded data
  //     print('Loaded Data from the fifth page:');
  //     print('Product: $_details');
  //     print('Item: $_items');
  //     print('Body: $_body');
  //     print('Items List: $_itemsList');
  //
  //     // Save data to SharedPreferences
  //
  //     // Convert to JSON
  //     String productJson = _details?.toJson() ?? '';
  //     String itemJson = jsonEncode(_items);
  //     String bodyJson = jsonEncode(_body);
  //     String itemsListJson = jsonEncode(_itemsList);
  //
  //     await prefs.setString('product', productJson);
  //     await prefs.setString('item', itemJson);
  //     await prefs.setString('body', bodyJson);
  //     await prefs.setString('itemsList', itemsListJson);
  //
  //     print('Data saved successfully');
  //
  //     // Retrieve and print saved data
  //     savedProductJson = prefs.getString('product');
  //     savedItemJson = prefs.getString('item');
  //     savedBodyJson = prefs.getString('body');
  //     savedItemsListJson = prefs.getString('itemsList');
  //
  //     if (savedProductJson != null) {
  //       detail savedProduct = detail.fromString(savedProductJson);
  //       print('Saved Product: $savedProduct');
  //     } else {
  //       print('Saved Product: null');
  //     }
  //
  //     if (savedItemJson != null) {
  //       var savedItem = jsonDecode(savedItemJson);
  //       print('Saved Item: $savedItem');
  //     } else {
  //       print('Saved Item: null');
  //     }
  //
  //     if (savedBodyJson != null) {
  //       var savedBody = jsonDecode(savedBodyJson);
  //       print('Saved Body: $savedBody');
  //     } else {
  //       print('Saved Body: null');
  //     }
  //
  //     if (savedItemsListJson != null) {
  //       List<dynamic> savedItemsList = jsonDecode(savedItemsListJson);
  //       print('Saved Items List: $savedItemsList');
  //     } else {
  //       print('Saved Items List: null');
  //     }
  //
  //   } catch (e) {
  //     print('Error loading or saving data: $e');
  //   }
  // }
  //uncommented this below one
  // Future<void> init() async {
  //   try {
  //
  //     // Print the loaded data
  //
  //
  //     // Save data to SharedPreferences
  //
  //     //convert jsonencode first
  //
  //
  //
  //     String productJson = _details?.toJson()?? '';
  //     String itemJson = jsonEncode(_items);
  //     String bodyJson = jsonEncode(_body);
  //     String itemsListJson = jsonEncode(_itemsList);
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('product', productJson);
  //     await prefs.setString('item', itemJson);
  //     await prefs.setString('body', bodyJson);
  //     await prefs.setString('itemsList', itemsListJson);
  //
  //     // Retrieve and print saved data
  //
  //     notifyListeners();
  //     await savedetails();
  //
  //
  //   } catch (e) {
  //     print('Error loaading data: $e');
  //   }
  // }

  //corrected code
  // Future<void> init() async {
  //   try {
  //
  //     // Print the loaded data
  //     print('Loaded Datafrom the fifthpage:');
  //     print('Product: $_details');
  //     print('Item: $_items');
  //     print('Body: $_body');
  //     print('Items List: $_itemsList');
  //
  //     // Save data to SharedPreferences
  //
  //     //convert jsonencode first
  //
  //     print('Product save fromthefifthpage: $_details');
  //     print('Item: $_items');
  //     print('Body: $_body');
  //     print('Items List: $itemsList');
  //
  //     String productJson = _details?.toJson()?? '';
  //     String itemJson = jsonEncode(_items);
  //     String bodyJson = jsonEncode(_body);
  //     String itemsListJson = jsonEncode(_itemsList);
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('product', productJson);
  //     await prefs.setString('item', itemJson);
  //     await prefs.setString('body', bodyJson);
  //     await prefs.setString('itemsList', itemsListJson);
  //
  //     // Retrieve and print saved data
  //     String? savedProductJson = prefs.getString('product');
  //     String? savedItemJson = prefs.getString('item');
  //     String? savedBodyJson = prefs.getString('body');
  //     String? savedItemsListJson = prefs.getString('itemsList');
  //
  //     if (savedProductJson!= null) {
  //       detail savedProduct = detail.fromString(savedProductJson);
  //       print('Saved Product: $savedProduct');
  //     } else {
  //       print('Saved Product: null');
  //     }
  //
  //     if (savedItemJson!= null) {
  //       var savedItem = jsonDecode(savedItemJson);
  //       print('Saved Item: $savedItem');
  //     } else {
  //       print('Saved Item: null');
  //     }
  //
  //     if (savedBodyJson!= null) {
  //       var savedBody = jsonDecode(savedBodyJson);
  //       print('Saved Body: $savedBody');
  //     } else {
  //       print('Saved Body: null');
  //     }
  //
  //     if (savedItemsListJson!= null) {
  //       List<dynamic> savedItemsList = jsonDecode(savedItemsListJson);
  //       print('Saved Items List: $savedItemsList');
  //     } else {
  //       print('Saved Items List: null');
  //     }
  //
  //
  //     await savedetails();
  //     notifyListeners();
  //
  //   } catch (e) {
  //     print('Error loaading data: $e');
  //   }
  // }



  void setProduct(detail product) {
    _details = product;
    notifyListeners();
  }

  void setItem(dynamic item) {
    _items = item;
    notifyListeners();
  }

  void setBody(dynamic body) {
    _body = body;
    notifyListeners();
  }

  void setItemsList(List<dynamic> itemsList) {
    _itemsList = itemsList.cast<Map<String, dynamic>>();
    notifyListeners();
  }



  Future<void> savedetails() async {
    try {
      // Load data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? savedProductJson = prefs.getString('product');
      String? savedItemJson = prefs.getString('item');
      String? savedBodyJson = prefs.getString('body');
      String? savedItemsListJson = prefs.getString('itemsList');

      if (savedProductJson != null) {
        _details = detail.fromString(savedProductJson);
      }
      if (savedItemJson != null) {
        _items = jsonDecode(savedItemJson);
      }
      if (savedBodyJson != null) {
        _body = jsonDecode(savedBodyJson);
      }
      if (savedItemsListJson != null) {
        _itemsList = jsonDecode(savedItemsListJson);
      }

      // Print the loaded data
      print('Loaded Data from the fifth page:');
      print('Product: $_details');
      print('Item: $_items');
      print('Body: $_body');
      print('Items List: $_itemsList');

      // ... rest of your code ...

    } catch (e) {
      print('Error loading data: $e');
    }
  }





  void updateNavigationData(detail? details, List<Map<String, dynamic>>? items, Map<String, dynamic>? body, List<Map<String, dynamic>>? itemsList,) {
    _details = details;
    _items = items;
    _body = body;
    _itemsList = itemsList;
    notifyListeners();
  }
}
