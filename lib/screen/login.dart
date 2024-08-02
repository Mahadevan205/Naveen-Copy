import 'package:flutter/material.dart';
import 'package:btb/widgets/login_container.dart';

class LoginScr extends StatefulWidget {
  const LoginScr({super.key});

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