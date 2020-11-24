import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:monecom/library/models/mysql.dart';
import 'package:monecom/screens/clients_list_screen.dart';

import '../main.dart';

class IotInfoScreen extends StatefulWidget {
  @override
  _IotInfoScreenState createState() => _IotInfoScreenState();
}

class _IotInfoScreenState extends State<IotInfoScreen> {
  var _idController = TextEditingController();

  // instanciando o banco de mensagens
  var snapshots = FirebaseFirestore.instance
      .collection("mensagens")
      .where("message", isNotEqualTo: null)
      .snapshots();

  // instanciando banco mysql
  var db = Mysql();
  var area;
  var idSensor;
  var id;
  var data;

  void _getData() {
    setState(() {
      if (id == "") {
        db.getConnection().then((conn) {
          String sql = 'select area,idSensor, data from registroIot_V2;';
          conn.query(sql).then((results) {
            for (var row in results) {
              if (this.mounted) {
                setState(() {
                  area = row[0];
                  data = row[2];
                  idSensor = row[1];
                });
              }
            }
          });
          conn.close();
        });
      } else {
        db.getConnection().then((conn) {
          String sql =
              'select area,idSensor, data from registroIot_V2 where idSensor = $id;';
          conn.query(sql).then((results) {
            for (var row in results) {
              if (this.mounted) {
                setState(() {
                  area = row[0];
                  data = row[2];
                  idSensor = row[1];
                });
              }
            }
          });
          conn.close();
        });
      }
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _idController.addListener(() {
      id = _idController.text;
      setState(() {
        _getData();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.8,
        title: Text(
          "Monitoramento",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: SizedBox(
        height: 420,
        width: 340,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: _buildInfoCard(),
          ),
        ),
      )),
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

  Widget _buildInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      color: shrineBlack100,
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(22),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              BorderedText(
                strokeColor: shrinePurple900,
                strokeWidth: 10.0,
                child: Text(
                  "Informações do sensor",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'UniSans-Heavy'),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Row(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "ID do Sensor: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          color: shrineBlack400,
                          height: 40,
                          width: 45,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _idController,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Uni-Sans'),
                            decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: ''),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Área de acionamento: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: area == null ? "" : "$area",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Data: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: data == null
                            ? ""
                            : "${data.toString().substring(8, 10).toLowerCase()}/${data.toString().substring(5, 7)}/${data.toString().substring(0, 4)}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Horário: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: data == null
                            ? ""
                            : "${data.toString().substring(11, 19)}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
