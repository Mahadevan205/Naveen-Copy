/*import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loginorderbooking/image_container.dart';
import 'package:loginorderbooking/login_container.dart';
import 'package:loginorderbooking/target.dart';

class LoginScr extends StatefulWidget {
  const LoginScr({super.key});

  @override
  State<LoginScr> createState() => _LoginScrState();
}

class _LoginScrState extends State<LoginScr> {
  @override
  Widget build(BuildContext context) {
    if (Target(kIsWeb).isWeb()) {
      return Scaffold(
        body: Row(
          children: [
            // Custom layouts for mobile devices
            ImageContainer(),
            LoginContainer(),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            ImageContainer(),
            LoginContainer(),
            // Custom layouts for mobile device
          ],
        ),
      );
    }
  }
}

 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:btb/widgets/image_container.dart';
import 'package:btb/widgets/login_container.dart';
import 'package:btb/target.dart';

class LoginScr extends StatefulWidget {
  const LoginScr({Key? key}) : super(key: key);

  @override
  State<LoginScr> createState() => _LoginScrState();
}

class _LoginScrState extends State<LoginScr> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: ImageContainer(),
          ),
          Expanded(
            flex: 3,
            child: LoginContainer1(),
          ),
        ],
      ),
    );
  }
}