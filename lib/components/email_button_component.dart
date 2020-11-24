import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monecom/library/models/mysql.dart';
import 'package:url_launcher/url_launcher.dart';

DocumentSnapshot snapshot;

// ignore: must_be_immutable
class EmailButton extends StatelessWidget {
  // instanciando banco mysql
  var db = Mysql();
  var area;
  var idSensor;
  var data;

  List<String> body = [];

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
                    return str.substring(0, str.length);
                  }

                  String listaEmails = removeLastChar(mails);

                  db.getConnection().then((conn) {
                    String meusIds =
                        'select idSensor,data,area from registroIot_V2;';
                    conn.query(meusIds).then((results) {
                      var meusResults = results.toList();

                      for (int i = 0; i < meusResults.length; i++) {
                        String idSensor =
                            meusResults.elementAt(i).values[0].toString();
                        String data =
                            meusResults.elementAt(i).values[1].toString();
                        String area =
                            meusResults.elementAt(i).values[2].toString();

                        String aux =
                            "O sensor $idSensor foi acionado na área $area;\nEm ${data.toString().substring(8, 10).toLowerCase()}/${data.toString().substring(5, 7)}/${data.toString().substring(0, 4)};\nÀs ${data.toString().substring(11, 19)};\n\n";

                        body.add(aux);
                      }

                      final Uri _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: '$listaEmails',
                        queryParameters: {
                          'subject':
                              '[Mon&Com] Estamos enviando informações do monitoramento.',
                          'body':
                              '${body.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(',', '')}'
                        },
                      );
                      launch(_emailLaunchUri.toString());
                    });
                  });
                });
              })),
    );
  }
}
