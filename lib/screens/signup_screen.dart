import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:monecom/main.dart';
import 'package:monecom/stores/signup_store.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpStore signUpStore = GetIt.I<SignUpStore>();

  TextEditingController txtCep = TextEditingController();
  TextEditingController txtCidade = TextEditingController();
  TextEditingController txtEstado = TextEditingController();
  TextEditingController txtRua = TextEditingController();
  TextEditingController txtBairro = TextEditingController();
  TextEditingController txtNumero = TextEditingController();
  TextEditingController txtComplemento = TextEditingController();

  _consultaCep() async {
    String cep = txtCep.text;

    String url = 'https://viacep.com.br/ws/${cep}/json/';

    http.Response response;

    response = await http.get(url);

    Map<String, dynamic> retorno = json.decode(response.body);

    String logradouro = retorno["logradouro"];
    String localidade = retorno["localidade"];
    String bairro = retorno["bairro"];
    String uf = retorno["uf"];

    setState(() {
      txtBairro.text = bairro;
      txtRua.text = logradouro;
      txtCidade.text = localidade;
      txtEstado.text = uf;

      String resultado =
          "Rua: $logradouro, Bairro: $bairro, Cidade: $localidade, Estado: $uf";

      print(resultado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.8,
        title: Text(
          'Cadastro',
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
              SizedBox(
                height: 10,
              ),
              _buildEmail(),
              SizedBox(
                height: 10,
              ),
              _buildPhone(),
              SizedBox(
                height: 10,
              ),
              _buildConsultaCep(),
              SizedBox(
                height: 10,
              ),
              _buildEndereco(),
              SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 40,
                width: 110,
                child: _buildSendButton(context),
              ),
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
      onPressed: () async {
        if (signUpStore.isFormValid) {
          FirebaseFirestore db = FirebaseFirestore.instance;

          QuerySnapshot snapshot = await db
              .collection("clientes")
              .where("email", isEqualTo: signUpStore.email)
              .get();

          if (snapshot.docs.isNotEmpty) {
            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "Desculpe",
                      style: TextStyle(
                        color: shrineBlack400,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      "O e-mail já foi cadastrado no nosso sistema! Tente novamente.",
                      style: TextStyle(
                        color: shrineBlack400,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 20, top: 30.0, right: 20, bottom: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  );
                });
          } else {
            Navigator.pop(context);

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildAlertDialog();
                });

            return db.collection("clientes").add({
              "nome": "${signUpStore.name}",
              "email": "${signUpStore.email}",
              "endereco": {
                "rua": "${txtRua.text}",
                "bairro": "${txtBairro.text}",
                "cidade": "${txtCidade.text}",
                "uf": "${txtEstado.text}",
                "numero": "${txtNumero.text}",
                "complemento": "${txtComplemento.text}",
              },
              "telefone": "${signUpStore.phone}"
            });
          }
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
          labelText: 'Nome*',
          errorText: signUpStore.nameError,
        ),
      );
    });
  }

  Widget _buildPhone() {
    return Observer(builder: (_) {
      return TextField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          TelefoneInputFormatter()
        ],
        onChanged: signUpStore.setPhone,
        decoration: InputDecoration(
          labelText: 'Telefone*',
          errorText: signUpStore.phoneError,
        ),
      );
    });
  }

  Widget _buildEmail() {
    return Observer(builder: (_) {
      return TextField(
        onChanged: signUpStore.setEmail,
        decoration: InputDecoration(
          labelText: 'E-mail*',
          errorText: signUpStore.emailError,
        ),
        keyboardType: TextInputType.emailAddress,
      );
    });
  }

  Widget _buildConsultaCep() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            child: TextField(
              maxLength: 8,
              controller: txtCep,
              decoration: InputDecoration(
                counterText: "",
                labelText: 'Digite o CEP',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Container(
          height: 40,
          width: 60,
          margin: EdgeInsets.only(top: 20),
          child: RaisedButton(
            padding: EdgeInsets.only(right: 0),
            child: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: _consultaCep,
          ),
        )
      ],
    );
  }

  Widget _buildEndereco() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Cidade',
                ),
                controller: txtCidade,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 80,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'UF',
                ),
                controller: txtEstado,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Rua',
                ),
                controller: txtRua,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 80,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nº',
                ),
                controller: txtNumero,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Bairro',
                ),
                controller: txtBairro,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 120,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Complemento',
                ),
                controller: txtComplemento,
              ),
            ),
          ],
        )
      ],
    );
  }
}
