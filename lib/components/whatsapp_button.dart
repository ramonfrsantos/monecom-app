import 'package:flutter/material.dart';
import 'package:monecom/library/util/colors_util.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppButton extends StatelessWidget {
  final double value;

  WhatsAppButton(this.value);

  @override
  Widget build(BuildContext context) {
    String menssagem = "O sensor está indicando o valor $value.";
    return FloatingActionButton(
      child: Image.asset("assets/images/icWhatsApp.png",
          width: 32, height: 32, color: Colors.white),
      backgroundColor: ColorsUtil.whatsApp,
      onPressed: () {
        String url = 'whatsapp://send?phone=+5531996676802&text=$menssagem';

        launch(Uri.encodeFull(url));
      },
    );
  }
}
