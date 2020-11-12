import 'package:flutter/material.dart';
import 'package:monecom/components/email_button.dart';
import 'package:monecom/components/whatsapp_button.dart';

class CompartilhaScreen extends StatelessWidget {
  final double temp;
  CompartilhaScreen(this.temp);

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
              WhatsAppButton(temp),
              SizedBox(
                height: 20,
              ),
              EmailButton(temp),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
