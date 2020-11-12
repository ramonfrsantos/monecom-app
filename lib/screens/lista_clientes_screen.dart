import 'package:flutter/material.dart';
import 'package:monecom/components/lista_card.dart';

class ListaClientesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.8,
        title: Text(
          "Clientes cadastrados",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 32, top: 20, right: 32, bottom: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: ListaCard(),
            ),
          ),
        ),
      ),
    );
  }
}
