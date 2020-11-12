import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

DocumentSnapshot snapshot;

class EmailButton extends StatelessWidget {
  int statusSensor;
  int idSensor;
  var data;

  EmailButton(this.statusSensor, this.idSensor, this.data);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 60,
      child: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: RaisedButton(
              elevation: 8,
              child: Text(
                'COMPARTILHAR RESULTADOS',
                style: TextStyle(
                  fontSize: 19,
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
                      'body':
                          "O sensor $idSensor foi acionado na área $statusSensor, em ${data.toString().substring(8, 10).toLowerCase()}/${data.toString().substring(5, 7)}/${data.toString().substring(0, 4)}, às ${data.toString().substring(11, 19)}."
                    },
                  );

                  launch(_emailLaunchUri.toString());
                });
              })),
    );
  }
}
