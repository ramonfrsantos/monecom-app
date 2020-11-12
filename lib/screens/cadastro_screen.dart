import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:monecom/stores/cadastro_store.dart';

class CadastroScreen extends StatelessWidget {
  final CadastroStore cadastroStore = GetIt.I<CadastroStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
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
                height: 100,
              ),
              Observer(
                builder: (_) {
                  return RaisedButton(
                    child: Text('Enviar'),
                    onPressed: () {
                      if (cadastroStore.isFormValid) {
                        FirebaseFirestore db = FirebaseFirestore.instance;

                        db.collection("clientes").add({
                          "nome": "${cadastroStore.name}",
                          "email": "${cadastroStore.email}",
                        });

                        Navigator.pop(context);
                      } else {
                        return null;
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Observer(builder: (_) {
      return TextField(
        onChanged: cadastroStore.setName,
        decoration: InputDecoration(
          labelText: 'Nome',
          errorText: cadastroStore.nameError,
        ),
      );
    });
  }

  Widget _buildEmail() {
    return Observer(builder: (_) {
      return TextField(
        onChanged: cadastroStore.setEmail,
        decoration: InputDecoration(
          labelText: 'E-mail',
          errorText: cadastroStore.emailError,
        ),
        keyboardType: TextInputType.emailAddress,
      );
    });
  }
}
