import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messageapp/handlers/datas_tore.dart';
import 'package:messageapp/handlers/message_parsers.dart';
import 'package:messageapp/screens/login_screen.dart';
// import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';
import 'handlers/processor.dart';

List<String> printListElements = [];

class MQTTClientWrapper extends ChangeNotifier {
  var uuid = Uuid();

  MqttServerClient client =
      MqttServerClient.withPort('115.249.0.206', Uuid().v4(), 1883);

  // MqttBrowserClient client =
  //     MqttBrowserClient.withPort('115.249.0.206', Uuid().v4(), 1883);
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;
  Handler processor;
  BuildContext context;
  AppContext _appContext = AppContext();
  List<Employee> users = [];
  List<AlertPayload> alerts = [];
  List messages = [];

  MQTTClientWrapper() {
    processor = ProcessorFactory.buildProcessor();
  }

  void setUser(String myId) {
    _appContext.setValue(
        AppContext.ACTIVE_USER, userDetails.isEmpty ? '' : myId);
  }

  List<SetupUserdetails> userDetails = [];
  void storeUserDetails(SetupUserdetails user) {
    userDetails.add(SetupUserdetails(
        myname: user.myname,
        mynickname: user.mynickname,
        mydept: user.mydept,
        myId: user.myId,
        myemailid: user.myemailid));
    notifyListeners();
  }

  void setupMqttClient() {
    client.logging(on: true);
    client.keepAlivePeriod = 34000;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .keepAliveFor(34000)
        .withClientIdentifier(Uuid().v4())
        .withWillQos(MqttQos.exactlyOnce);
    client.connectionMessage = connMessage;
    client.autoReconnect = true;
  }

  Future<void> connectClient() async {
    try {
      print('MQTTClientWrapper::Mosquitto client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      print("connecting -try block- $connectionState");
      await client.connect();
    } on Exception catch (e) {
      print('MQTTClientWrapper::client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      print("connecting -catch block- $connectionState");
      client.disconnect();
    }
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print("connecting -checking connected- $connectionState");
      print('MQTTClientWrapper::Mosquitto client connected$connectionState');
    } else {
      print(
          'MQTTClientWrapper::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  //upadting appcontext
  AppContext updateAppContext(AppContext context, MQMessage message) {
    HandlerResponse processResponse = processor.process(_appContext, message);
    _appContext = processResponse.context;
    return _appContext;
  }

  //subcribing to topics and listening..
  void subscribeToTopic(String topicName) {
    print('MQTTClientWrapper::Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.exactlyOnce);
    print(client.updates.isEmpty);
    client.updates.listen(
        (List<MqttReceivedMessage<MqttMessage>> mqttRecievedMessage) {
      final recMess = mqttRecievedMessage[0].payload as MqttPublishMessage;
      final topic = mqttRecievedMessage[0].topic;

      final mqttMessage =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (topic.endsWith(Constants.TOPIC_REGISTRATION)) {
        print('user.isEmpty');
        publishWelcome();
      }
      users = updateAppContext(_appContext, MQMessage(topic, mqttMessage))
          .appData
          .contacts;
      notifyListeners();
      alerts = updateAppContext(_appContext, MQMessage(topic, mqttMessage))
          .appData
          .alertMessages;
      notifyListeners();
      messages = updateAppContext(_appContext, MQMessage(topic, mqttMessage))
          .appData
          .dialogue;
      notifyListeners();
      print("MQTTClientWrapper::GOT A NEW MESSAGE $mqttMessage");

      printListElements.add(mqttMessage);
      printListElements.add(connectionState.toString());
    }, onDone: () {
      client.connect();
    });
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
  }

  void _onDisconnected() {
    print(
        'MQTTClientWrapper::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print(
          'MQTTClientWrapper::OnDisconnected callback is solicited, this is correct');
    }
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
    notifyListeners();
  }

  void _onSubscribed(String topic) {
    print('MQTTClientWrapper::Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
    notifyListeners();
  }

  //preparing mqttclient..
  void prepareMqttClient() async {
    setupMqttClient();
    await connectClient();
    subscribeWelcome();
    subscribeRegister();
    subscribeUnRegister();
    subscribeToMyTopic();
    subscribeToAlertTopic();
    publishRegister('register');
    notifyListeners();
  }

  //publishing
  void publishMessage(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (client.connectionStatus.state == MqttConnectionState.disconnected) {
      connectClient();
      Future.delayed(
        const Duration(seconds: 2),
        () =>
            client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload),
      );
    } else {
      client.publishMessage(
        topic,
        MqttQos.exactlyOnce,
        builder.payload,
      );
    }
  }

  void sendRegisterMessage(String topic, dynamic paylod) {
    publishMessage(topic, paylod);
  }

  void subscribeWelcome() {
    subscribeToTopic('/JABBERWOCKEY/MACOM/TALK/WELCOME');
  }

  void subscribeRegister() {
    subscribeToTopic('/JABBERWOCKEY/MACOM/TALK/REGISTER');
  }

  void subscribeUnRegister() {
    subscribeToTopic('/JABBERWOCKEY/MACOM/TALK/UNREGISTER');
  }

  void subscribeToMyTopic() {
    subscribeToTopic('/JABBERWOCKEY/MACOM/TALK/MESSAGE/${userDetails[0].myId}');
  }

  void subscribeToAlertTopic() {
    subscribeToTopic("/HPV/MACOM/ASHIRVAD/Health/1002");
  }

  void publishWelcome() {
    PayloadWelcome payload = PayloadWelcome(
        payloadType: "RQRV1",
        iD: uuid.v1(),
        timeStamp: "2021-09-02T14:34:30.8019109\u002B05:30",
        user: userDetails[0].myId,
        name: userDetails[0].myname,
        dept: userDetails[0].mydept,
        callSign: userDetails[0].mynickname,
        status: "Online",
        platform: "WinX",
        content: "Registration Request");

    String topic = '/JABBERWOCKEY/MACOM/TALK/WELCOME';
    sendRegisterMessage(topic, payload.toString());
  }

  void publishRegister(String value) {
    String registerTopic = '';
    String topic = '/JABBERWOCKEY/MACOM/TALK/';
    String register = 'REGISTER';
    String unRegister = 'UNREGISTER';
    PayloadRegister payload = PayloadRegister(
        payloadType: "RQRV1",
        iD: uuid.v1(),
        timeStamp: "2021-09-02T14:34:30.8019109\u002B05:30",
        user: userDetails[0].myId,
        name: userDetails[0].myname,
        dept: userDetails[0].mydept,
        callSign: userDetails[0].mynickname,
        status: "Online",
        platform: "WinX",
        content: "Registration Request");
    if (value == "register") {
      registerTopic = topic + register;
    } else if (value == 'unregister') {
      registerTopic = topic + unRegister;
    }
    sendRegisterMessage(registerTopic, payload.toString());
  }

  String messageType(String msg) {
    String message = msg.toLowerCase();
    String messageType = "Text";
    if (message.contains('png') ||
        message.contains('jpeg') ||
        message.contains('jpg')) {
      messageType = 'Image';
    } else if (message.contains('mp4') || message.contains('MKV')) {
      messageType = 'Video';
    } else if (message.contains('pdf') ||
        message.contains('doc') ||
        message.contains('docx') ||
        message.contains('txt') ||
        message.contains('html') ||
        message.contains('pptx') ||
        message.contains('ppt') ||
        message.contains('xls')) {
      messageType = 'Document';
    }
    return messageType;
  }

  void sendMessage(
      String message, String userid, String userName, String responsetype) {
    print(messageType(message));
    final encodedmessage = base64.encode(utf8.encode(message));

    var uuid = Uuid();
    String topic = '/JABBERWOCKEY/MACOM/TALK/MESSAGE/$userid';
    Message messagePayload = Message(
        payloadType: "RQMV1",
        iD: uuid.v1(),
        timeStamp: "2021-09-02T14:34:30.8019109\u002B05:30",
        user: userDetails[0].myId,
        sendTo: userid,
        replyTo: "",
        responseType: ResponseTypes.None,
        contents: Content.fromPayload(Content(
          cid: "1001",
          body: encodedmessage,
          type: messageType(message),
        )),
        response: "",
        receivedTimeStamp: DateTime.now().millisecondsSinceEpoch.toString(),
        readTimeStamp: "",
        respondedTimeStamp: "");
    if (userid != null) {
      publishMessage(topic, messagePayload.toString());
    }
    messages = updateAppContext(
            _appContext, MQMessage(topic, messagePayload.toString()))
        .appData
        .dialogue;
    notifyListeners();
  }
}

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}
enum MqttSubscriptionState { IDLE, SUBSCRIBED }
