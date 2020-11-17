import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monecom/components/signup_button_component.dart';
import 'package:monecom/screens/clients_list_screen.dart';
import 'package:monecom/screens/iot_info_screen.dart';
import 'package:monecom/screens/share_info_screen.dart';

import '../main.dart';

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  /*_addToken() {
    _firebaseMessaging.getToken().then((deviceToken) => {
          FirebaseFirestore.instance.collection("DeviceTokens").add({
            "device_token": "$deviceToken",
          })
        });
  }*/

  // instanciando banco de mensagens no firebase
  var snapshots = FirebaseFirestore.instance
      .collection("mensagens")
      .where("message", isNotEqualTo: null)
      .snapshots();

  _getToken() {
    _firebaseMessaging
        .getToken()
        .then((deviceToken) => {print("DeviceToken: $deviceToken")});
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }

  _deleteMessages() {
    FirebaseFirestore.instance
        .collection("mensagens")
        .snapshots()
        .forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        snapshot.reference.delete();
      }
    });
  }

  void initState() {
    super.initState();
    _configureFirebaseListeners();
    _getToken();
    _deleteMessages();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: shrineBlack400,
        toolbarHeight: 100,
        elevation: 0,
        title: BorderedText(
          strokeWidth: 10.0,
          strokeColor: shrinePurple900,
          child: Text(
            'Mon&Com',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'UniSans-Heavy',
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBaseBody(),
      floatingActionButton: _listaFloatingButton(),
    );
  }

  Widget _buildBaseBody() {
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingUpButton(),
              SizedBox(
                height: 30,
              ),
              _buildCompartilhaButton(),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 300,
                width: 340,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IotInfoScreen()),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      color: Colors.white,
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        padding: EdgeInsets.only(top: 15, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border:
                                Border.all(width: 4, color: shrinePurple900),
                            image: DecorationImage(
                              image: AssetImage("assets/images/cardFundo.png"),
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.dstATop),
                              fit: BoxFit.cover,
                            )),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logoApp.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IotInfoScreen()),
                  );
                },
                child: Text(
                  "Clique para monitorar",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listaFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => ClientsListScreen()));
      },
      tooltip: 'Ligar/Desligar',
      child: Icon(
        Icons.people,
        size: 40,
      ),
    );
  }

  Widget _buildCompartilhaButton() {
    return SizedBox(
      width: 250,
      height: 60,
      child: RaisedButton(
        elevation: 8,
        onPressed: () {
          return Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShareInfoScreen()),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          'Compartilhamento',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
