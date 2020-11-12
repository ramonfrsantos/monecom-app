import 'dart:async';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monecom/components/cadastro_button.dart';
import 'package:monecom/screens/compartilha_screen.dart';
import 'package:monecom/screens/gado_info_screen.dart';
import 'package:monecom/screens/lista_clientes_screen.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

import '../main.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  StreamController<Map> _streamController = StreamController<Map>();

  String broker = 'broker.hivemq.com';
  double _temp = 20;
  int port = 1883;
  String clientIdentifier = 'monecomclientid';
  String topic = 'monecom_temperatura';
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  StreamSubscription subscription;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
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
      body: Container(
        margin: EdgeInsets.only(bottom: 100),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CadastroButton(),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 250,
                  height: 60,
                  child: RaisedButton(
                    elevation: 8,
                    onPressed: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompartilhaScreen()),
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
                ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GadoInfoScreen()),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.grey,
                        elevation: 10,
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/images/cardFundo.png"),
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.dstATop),
                            fit: BoxFit.cover,
                          )),
                          child: Center(
                            child: BorderedText(
                              strokeWidth: 4.0,
                              strokeColor: Colors.black,
                              child: Text(
                                "Monitorar Informações",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ListaClientesScreen()));
        },
        tooltip: 'Ligar/Desligar',
        child: Icon(
          Icons.people,
          size: 40,
        ),
      ),
    );
  }

  //Conecta no servidor MQTT à partir dos dados configurados nos atributos desta classe (broker, port, etc...)

  void _connect() async {
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

  /*void _onoff() async {
    Uint8Buffer value = Uint8Buffer();
    value.add(1);
    client.publishMessage("professor_onoff", mqtt.MqttQos.exactlyOnce, value);
  }*/
}
