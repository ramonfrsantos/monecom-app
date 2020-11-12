import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppButton extends StatelessWidget {
  final double value;

  WhatsAppButton(this.value);

  @override
  Widget build(BuildContext context) {
    String menssagem = "Olá, gostaria de falar com um atendente.";

    return SizedBox(
      width: 300,
      height: 50,
      child: RaisedButton(
        elevation: 8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SUPORTE',
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Image.asset(
              "assets/images/icWhatsApp.png",
              color: Colors.white,
              width: 26,
              height: 26,
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          String url = 'whatsapp://send?phone=+5531996676802&text=$menssagem';

          launch(Uri.encodeFull(url));
        },
      ),
    );
  }
}
