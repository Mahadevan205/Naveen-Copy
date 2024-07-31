import 'dart:convert';
import 'dart:html';
import 'package:btb/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../dashboard.dart';
class LoginContainer1 extends StatefulWidget {
  const LoginContainer1({super.key});
  @override
  State<LoginContainer1> createState() => _LoginContainerState();
}
class _LoginContainerState extends State<LoginContainer1> {
  final userName = TextEditingController();
  final password = TextEditingController();
  checkLogin(String username, String password) async {
    Map tempJson = {"userName": username, "password": password};
    String url =
        'https://mjl9lz64l7.execute-api.ap-south-1.amazonaws.com/stage1/api/user_master/login-authenticate';
    final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(tempJson));
    if (response.statusCode == 200) {
      Map tempData = json.decode(response.body);
      if (tempData.containsKey("error")) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Something went wrong")));
        }
      } else {
        window.sessionStorage["token"] = tempData['token'];
        context.go(PageName.dashboardRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8), // 80% of screen width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: constraints.maxHeight * 0.1), // 10% of screen height
              const Text(
                'Login to Your account',
                style: TextStyle(fontSize: 35, color: Colors.blue),
              ),
              SizedBox(height: constraints.maxHeight * 0.03), // 5% of screen height
              const Text(
                'Simplify your order management and \ngain complete control',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: constraints.maxHeight * 0.03), // 5% of screen height
              Align(
                alignment: const Alignment(0.9,0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.04),
                    const Align(
                        alignment: Alignment(-0.4, 0.0),
                        child: Text('Username',style: TextStyle(fontWeight: FontWeight.bold),)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: const Alignment(0.1, 0.0),
                      child: SizedBox(
                        height: 40,
                        width: constraints.maxWidth * 0.5,
                        child: TextFormField(
                          controller: userName,
                          decoration:const  InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your username',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            if (checkLogin(userName.text, password.text)) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardPage()),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                        alignment:Alignment(-0.4, 0.0),
                        child:  Text('Password',style: TextStyle(fontWeight: FontWeight.bold),)),
                    const SizedBox(height: 10),
                    Align(alignment: const Alignment(0.1, 0.0),
                      child: SizedBox(
                        height: 40,
                        width: constraints.maxWidth * 0.5,
                        child: TextFormField(
                          controller: password,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your Password',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            if (checkLogin(userName.text, password.text)) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardPage()),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment(0.47,0.2),
                      child: Text('Forgot password ?'),
                    ),
                    const SizedBox(height: 20,),
                    Align(
                      alignment: const Alignment(0.1, 0.2),
                      child: SizedBox(
                        width: constraints.maxWidth * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogin(userName.text, password.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Align(
                              alignment: Alignment(0.0, 0.0),
                              child:  Text('Login',style: TextStyle(color: Colors.white),)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 140),
                    Align(
                      alignment: const Alignment(0.1, 0.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Need help? ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Contact Support',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
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
      },
    );
  }
}


class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key});

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
          const SizedBox(height: 50), // You can adjust this value
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