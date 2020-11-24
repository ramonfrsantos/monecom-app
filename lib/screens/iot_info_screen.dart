import 'package:bordered_text/bordered_text.dart';
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
  List<String> _ids = [];
  var _idSelecionado = '1';

  // instanciando banco mysql
  var db = Mysql();
  var area;
  var idSensor;
  var data;

  @override
  void initState() {
    _getData();
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

  criaDropDownButton() {
    return DropdownButton<String>(
        items: _ids.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(dropDownStringItem),
          );
        }).toList(),
        onChanged: (String novoItemSelecionado) {
          _dropDownItemSelected(novoItemSelecionado);
          setState(() {
            this._idSelecionado = novoItemSelecionado;
            _getData();
          });
        },
        value: _idSelecionado);
  }

  void _getData() {
    setState(() {
      db.getConnection().then((conn) {
        String meusIds = 'select idSensor from registroIot_V2;';
        conn.query(meusIds).then((results) {
          var meusResults = results.toList();

          for (int i = 0; i < meusResults.length; i++) {
            String aux = meusResults.elementAt(i).values[0].toString();

            _ids.add(aux);
          }
          print(_ids);
        });

        String sql =
            'select area, idSensor, data from registroIot_V2 where idSensor = $_idSelecionado;';
        conn.query(sql).then((results) {
          for (var row in results) {
            if (this.mounted) {
              setState(() {
                area = row[0];
                idSensor = row[1];
                data = row[2];
              });
            }
          }
        });
        conn.close();
      });
    });
  }

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      this._idSelecionado = novoItem;
    });
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
                        criaDropDownButton()
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
