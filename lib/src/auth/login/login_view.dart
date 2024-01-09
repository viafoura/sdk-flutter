import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _MyLoginView();
}

class _MyLoginView extends State<LoginView> {

  MethodChannel channel = const MethodChannel('AUTH_CHANNEL');
  
  final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Expanded(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                    hintText: 'Enter your e-mail'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child:             TextButton(
              child: Text(
                "Log-in",
                style: TextStyle(fontSize: 25),
              ),
              onPressed: () async {
                final String result = await channel.invokeMethod("emailLogin", {
                  "type": "login",
                  "email": emailController.text,
                  "password": passwordController.text
                });
                if (result == "200"){
                  Navigator.of(context).pop();
                }
              },
            )
            ),
          ])),
        ));
  }
}