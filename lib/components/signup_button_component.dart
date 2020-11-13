import 'package:flutter/material.dart';
import 'package:monecom/screens/signup_screen.dart';

class SingUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 60,
      child: RaisedButton(
          elevation: 8,
          child: Text(
            'Cadastrar cliente',
            style: TextStyle(fontSize: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          }),
    );
  }
}
