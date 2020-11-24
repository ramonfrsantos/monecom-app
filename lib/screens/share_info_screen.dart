import 'package:flutter/material.dart';
import 'package:monecom/components/email_button_component.dart';
import 'package:monecom/components/whatsapp_button_component.dart';
import 'package:monecom/screens/clients_list_screen.dart';

class ShareInfoScreen extends StatefulWidget {
  @override
  _ShareInfoScreenState createState() => _ShareInfoScreenState();
}

class _ShareInfoScreenState extends State<ShareInfoScreen> {
  @override
  Widget build(BuildContext context) {
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
              EmailButton(),
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
      tooltip: 'Lista de clientes',
      child: Icon(
        Icons.people,
        size: 40,
      ),
    );
  }
}
