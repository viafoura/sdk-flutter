import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});
  static const routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
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