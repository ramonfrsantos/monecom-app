import 'dart:async';

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

//------------------------------------------------------------------
// As configurações do mqtt estão mantidas no app, mas ele
// está integrado somente com o mysql e com o firebase. Caso haja necessidade
// os topicos mqtt podem ser usados normalmente, basta alterar
// as configurações.
//------------------------------------------------------------------

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

StreamSubscription<DocumentSnapshot> subscription;
final DocumentReference documentReference =
    FirebaseFirestore.instance.doc('2938nXJ2SKQLoqR8KVTJ');

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String token = '';

  String _getToken() {
    _firebaseMessaging
        .getToken()
        .then((deviceToken) => {print("DeviceToken: $deviceToken")});
  }

  _addToken() {
    _firebaseMessaging.getToken().then((deviceToken) => {
          FirebaseFirestore.instance.collection("DeviceTokens").add({
            "device_token": "$deviceToken",
          })
        });
  }

  // instanciando banco de mensagens no firebase
  var snapshots = FirebaseFirestore.instance
      .collection("mensagens")
      .where("message", isNotEqualTo: null)
      .snapshots();

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(message);
      },
    );
  }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMessage = data['message'];
  }

  // MQTT configuration================================
  /*String broker = 'broker.hivemq.com';
  double _temp = 20;
  int port = 1883;
  String clientIdentifier = 'monecomclientid';
  String topic = 'monecom_temperatura';
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }*/
  //===================================================

  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
    _configureFirebaseListeners();
    _getToken();
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

  //-------------------------------------------------------------------------
  // MQTT - CONFIG

  //Conecta no servidor MQTT à partir dos dados configurados nos atributos desta classe (broker, port, etc...)

  /*void _connect() async {
    client = mqtt.MqttClient(broker, '');
    client.port = port;
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean()
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    subscription = client.updates.listen(_onMessage);
    _subscribeToTopic(topic);
  }

  //Desconecta do servidor MQTT

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  //Executa algo quando desconectado, no caso, zera as variáveis e imprime msg no console

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  //Escuta quando mensagens são escritas no tópico. É aqui que lê os dados do servidor MQTT e modifica o valor do termômetro

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: ${message}");
    setState(() {
      _temp = double.parse(message);
    });
  }

  */ /*void _onoff() async {
    Uint8Buffer value = Uint8Buffer();
    value.add(1);
    client.publishMessage("professor_onoff", mqtt.MqttQos.exactlyOnce, value);
  }*/
}
