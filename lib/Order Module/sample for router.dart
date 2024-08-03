// // // Copyright 2013 The Flutter Authors. All rights reserved.
// // // Use of this source code is governed by a BSD-style license that can be
// // // found in the LICENSE file.
// //
// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';
// //
// // /// This sample app shows an app with two screens.
// // ///
// // /// The first route '/' is mapped to [HomeScreen], and the second route
// // /// '/details' is mapped to [DetailsScreen].
// // ///
// // /// The buttons use context.go() to navigate to each destination. On mobile
// // /// devices, each destination is deep-linkable and on the web, can be navigated
// // /// to using the address bar.
// // void main() => runApp(const MyApp());
// //
// // /// The route configuration.
// // final GoRouter _router = GoRouter(
// //   routes: <RouteBase>[
// //     GoRoute(
// //       path: '/',
// //       builder: (BuildContext context, GoRouterState state) {
// //         return const HomeScreen();
// //       },
// //       routes: <RouteBase>[
// //         GoRoute(
// //           path: 'details',
// //           builder: (BuildContext context, GoRouterState state) {
// //             return const DetailsScreen();
// //           },
// //         ),
// //       ],
// //     ),
// //   ],
// // );
// //
// // /// The main app.
// // class MyApp extends StatelessWidget {
// //   /// Constructs a [MyApp]
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp.router(
// //       routerConfig: _router,
// //     );
// //   }
// // }
// //
// // /// The home screen
// // class HomeScreen extends StatelessWidget {
// //   /// Constructs a [HomeScreen]
// //   const HomeScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Home Screen')),
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () => context.go('/details'),
// //           child: const Text('Go to the Details screen'),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // /// The details screen
// // class DetailsScreen extends StatelessWidget {
// //   /// Constructs a [DetailsScreen]
// //   const DetailsScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Details Screen')),
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () => context.go('/'),
// //           child: const Text('Go back to the Home screen'),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// void main() {
//   runApp(MyApp());
// }
// class NavigationState with ChangeNotifier {
//   List<String> _navigationPath = [];
//
//   List<String> get navigationPath => _navigationPath;
//
//   void pushRoute(String route) {
//     _navigationPath.add(route);
//     notifyListeners();
//   }
//
//   void popRoute() {
//     if (_navigationPath.isNotEmpty) {
//       _navigationPath.removeLast();
//       notifyListeners();
//     }
//   }
// }
//
// final navigationState = NavigationState();
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Navigation Demo',
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             if (navigationState.navigationPath.isNotEmpty) {
//               navigationState.popRoute();
//             }
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 navigationState.pushRoute('Products');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProductsScreen()),
//                 );
//               },
//               child: Text('Go to Products'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ProductsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products Screen'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             if (navigationState.navigationPath.isNotEmpty) {
//               navigationState.popRoute();
//             }
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Breadcrumb trail: ${navigationState.navigationPath.join(' > ')}'),
//             ElevatedButton(
//               onPressed: () {
//                 navigationState.pushRoute('Orders');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => OrdersScreen()),
//                 );
//               },
//               child: Text('Go to Orders'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class OrdersScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders Screen'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             if (navigationState.navigationPath.isNotEmpty) {
//               navigationState.popRoute();
//             }
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Breadcrumb trail: ${navigationState.navigationPath.join(' > ')}'),
//             ElevatedButton(
//               onPressed: () {
//                 navigationState.pushRoute('Returns');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ReturnsScreen()),
//                 );
//               },
//               child: Text('Go to Returns'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ReturnsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Returns Screen'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             if (navigationState.navigationPath.isNotEmpty) {
//               navigationState.popRoute();
//             }
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Breadcrumb trail: ${navigationState.navigationPath.join(' > ')}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: AppRouterDelegate(),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}

class AppRouterDelegate extends RouterDelegate<RoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Track the current path and button pressed
  RoutePath _currentPath = RoutePath.home;
  String? _currentButton;

  @override
  RoutePath get currentConfiguration => _currentPath;

  void _navigateToDetails(String buttonName) {
    _currentPath = RoutePath.details;
    _currentButton = buttonName;
    notifyListeners();
  }

  void _goHome() {
    _currentPath = RoutePath.home;
    _currentButton = null;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: HomePage(onNavigateToDetails: _navigateToDetails)),
        if (_currentPath == RoutePath.details)
          MaterialPage(child: DetailsPage(onNavigateBack: _goHome, buttonName: _currentButton)),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _currentPath = RoutePath.home;
        _currentButton = null;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}

class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    if (routeInformation.location == '/details') {
      return RoutePath.details;
    }
    return RoutePath.home;
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath configuration) {
    if (configuration == RoutePath.details) {
      return RouteInformation(location: '/details');
    }
    return RouteInformation(location: '/');
  }
}

class RoutePath {
  static final home = RoutePath();
  static final details = RoutePath();
}

class HomePage extends StatelessWidget {
  final void Function(String buttonName) onNavigateToDetails;

  HomePage({required this.onNavigateToDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
              (index) => ElevatedButton(
            onPressed: () => onNavigateToDetails('Home Button ${index + 1}'),
            child: Text('Home Button ${index + 1}'),
          ),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final VoidCallback onNavigateBack;
  final String? buttonName;

  DetailsPage({required this.onNavigateBack, this.buttonName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (buttonName != null) Text('Button Pressed: $buttonName'),
          ...List.generate(
            5,
                (index) => ElevatedButton(
              onPressed: onNavigateBack,
              child: Text('Details Button ${index + 1}'),
            ),
          ),
        ],
      ),
    );
  }
}


