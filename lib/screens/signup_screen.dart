import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:monecom/main.dart';
import 'package:monecom/stores/signup_store.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpStore signUpStore = GetIt.I<SignUpStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.8,
        title: Text(
          'SignUp',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildName(),
              _buildEmail(),
              SizedBox(
                height: 60,
              ),
              Observer(
                builder: (_) {
                  return SizedBox(
                    height: 40,
                    width: 110,
                    child: _buildSendButton(context),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return RaisedButton(
      child: Text(
        'Enviar',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      onPressed: () {
        if (signUpStore.isFormValid) {
          FirebaseFirestore db = FirebaseFirestore.instance;

          db.collection("clientes").add({
            "nome": "${signUpStore.name}",
            "email": "${signUpStore.email}",
          });

          Navigator.pop(context);

          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return _buildAlertDialog();
              });
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Pronto",
        style: TextStyle(
          color: shrineBlack400,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "O cliente foi cadastrado com sucesso!",
        style: TextStyle(
          color: shrineBlack400,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding:
          EdgeInsets.only(left: 20, top: 30.0, right: 20, bottom: 40),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
  }

  Widget _buildName() {
    return Observer(builder: (_) {
      return TextField(
        onChanged: signUpStore.setName,
        decoration: InputDecoration(
          labelText: 'Nome',
          errorText: signUpStore.nameError,
        ),
      );
    });
  }

  Widget _buildEmail() {
    return Observer(builder: (_) {
      return TextField(
        onChanged: signUpStore.setEmail,
        decoration: InputDecoration(
          labelText: 'E-mail',
          errorText: signUpStore.emailError,
        ),
        keyboardType: TextInputType.emailAddress,
      );
    });
  }
}
