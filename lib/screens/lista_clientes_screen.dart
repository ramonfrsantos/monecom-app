import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monecom/main.dart';

class ListaClientesScreen extends StatelessWidget {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var snapshots = db
        .collection("clientes")
        .where("email", isNotEqualTo: null)
        .snapshots();

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
              child: Card(
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
                            onLongPress: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                          style:
                                              TextStyle(color: shrinePurple900),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          "Continar",
                                          style:
                                              TextStyle(color: shrinePurple900),
                                        ),
                                        onPressed: () async {
                                          await db
                                              .collection('clientes')
                                              .doc(docId)
                                              .delete();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
