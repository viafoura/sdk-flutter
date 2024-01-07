import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[

        ])
      ),
    ));
  }
}