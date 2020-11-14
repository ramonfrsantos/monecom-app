import 'package:flutter/material.dart';
import 'package:monecom/components/email_button_component.dart';
import 'package:monecom/components/whatsapp_button_component.dart';
import 'package:monecom/library/models/mysql.dart';
import 'package:monecom/screens/clients_list_screen.dart';

class ShareInfoScreen extends StatefulWidget {
  @override
  _ShareInfoScreenState createState() => _ShareInfoScreenState();
}

class _ShareInfoScreenState extends State<ShareInfoScreen> {
  var db = Mysql();
  var statusSensor;
  var idSensor;
  var data;

  void _getData() {
    db.getConnection().then((conn) {
      String sql =
          'select statusSensor,idSensor, data from registrosIot where idSensor = 3;';
      conn.query(sql).then((results) {
        for (var row in results) {
          if (this.mounted) {
            setState(() {
              statusSensor = row[0];
              idSensor = row[1];
              data = row[2];
            });
          }
        }
      });
      conn.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    _getData();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.8,
        title: Text(
          "Compartilhamento",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
              ),
              WhatsAppButton(),
              SizedBox(
                height: 20,
              ),
              EmailButton(statusSensor, idSensor, data),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _listFloatingButton(),
    );
  }

  Widget _listFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ClientsListScreen()));
      },
      tooltip: 'Ligar/Desligar',
      child: Icon(
        Icons.people,
        size: 40,
      ),
    );
  }
}