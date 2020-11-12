import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

DocumentSnapshot snapshot;

class EmailButton extends StatelessWidget {
  final double valor;

  EmailButton(this.valor);

  @override
  Widget build(BuildContext context) {
    String message = "Estão fazendo ${valor.toInt()} graus.";

    return SizedBox(
      width: 350,
      height: 60,
      child: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: RaisedButton(
              elevation: 8,
              child: Text(
                'Enviar email com as informações',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('clientes')
                    .get()
                    .then((value) {
                  String mails = '';
                  value.docs.forEach((element) {
                    mails = '$mails' + '${element.data()["email"].toString()},';
                  });

                  String removeLastChar(String str) {
                    return str.substring(0, str.length - 1);
                  }

                  String listaEmails = removeLastChar(mails);

                  final Uri _emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: '$listaEmails',
                    queryParameters: {
                      'subject':
                          '[Mon&Com] Estamos enviando informações do monitoramento.',
                      'body': '$message'
                    },
                  );

                  launch(_emailLaunchUri.toString());
                });
              })),
    );
  }
}
