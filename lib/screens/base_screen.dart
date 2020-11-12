import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monecom/components/cadastro_button.dart';
import 'package:monecom/components/email_button.dart';
import 'package:monecom/components/paisagem_view.dart';
import 'package:monecom/components/whatsapp_button.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class BaseScreen extends StatefulWidget {
  BaseScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  String broker = 'test.mosquitto.org';
  int port = 1883;
  String clientIdentifier = 'monecomclientid';
  String topic = 'monecom_temperatura';

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  double _temp = 20;

  StreamSubscription subscription;

  //Conecta no servidor MQTT assim que inicializar a tela

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  //Assina o tópico onde virão os dados de temperatura

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_temp);

    return Scaffold(
      appBar: AppBar(
        title: Text("Mon&Com"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "A temperatura atual é de $_temp ºC.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                PaisagemView(_temp),
                SizedBox(
                  height: 40,
                ),
                CadastroButton(),
                EmailButton(_temp),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: WhatsAppButton(_temp),
    );
  }

  /*FloatingActionButton(
    onPressed: _onoff,
    backgroundColor: Colors.blue,
    tooltip: 'Ligar/Desligar',
    child: Icon(
      Icons.play_arrow,
      color: Colors.white,
      size: 40,
    ),
  )*/

  /*void _onoff() async {
    Uint8Buffer value = Uint8Buffer();
    value.add(1);
    client.publishMessage("professor_onoff", mqtt.MqttQos.exactlyOnce, value);
  }*/

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
}
