import 'package:flutter/material.dart';
import 'package:monecom/library/util/colors_util.dart';
import 'package:monecom/screens/cadastro_screen.dart';

class CadastroButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: RaisedButton(
            elevation: 8,
            child: Text(
              'CADASTRAR E-MAIL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: ColorsUtil.coolBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CadastroScreen()));
            }),
      ),
    );
  }
}
