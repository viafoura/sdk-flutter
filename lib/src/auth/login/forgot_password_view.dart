import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});
  static const routeName = '/forgotPassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
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