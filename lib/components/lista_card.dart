import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monecom/main.dart';
import 'package:monecom/screens/alterar_cadastro_screen.dart';

class ListaCard extends StatelessWidget {
  var snapshots = FirebaseFirestore.instance
      .collection("clientes")
      .where("email", isNotEqualTo: null)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: shrineBlack100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 7,
      child: StreamBuilder(
        stream: snapshots,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.length == 0) {
            return Center(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Nenhum cliente cadastrado.",
                    style: TextStyle(fontSize: 20),
                  )),
            );
          }
          return Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int i) {
                var doc = snapshot.data.docs[i];
                var item = doc.data();
                var docId = doc.id;

                return GestureDetector(
                  onLongPress: () {
                    return showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return BottomSheet(
                            onClosing: () {},
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 22),
                                  child: Text(
                                    'Alterar cadastro',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                AlterarCadastroScreen(docId)));
                                  },
                                ),
                                FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 22),
                                  child: Text(
                                    'Excluir cadastro',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          title: Text(
                                            "Atenção:",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: shrineBlack400,
                                            ),
                                          ),
                                          content: Text(
                                            "Deseja confirmar a exclusão do cadastro desse usuário?",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: shrineBlack400,
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(
                                                "Cancelar",
                                                style: TextStyle(
                                                    color: shrinePurple900),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                "Continuar",
                                                style: TextStyle(
                                                    color: shrinePurple900),
                                              ),
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('clientes')
                                                    .doc(docId)
                                                    .delete();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: ListTile(
                    title: Text(item['nome']),
                    subtitle: Text(
                      item['email'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
