import 'dart:convert';

class Constants {
  static const String TOPIC_WELCOME = '/WELCOME';
  static const String TOPIC_REGISTRATION = '/REGISTER';
  static const String TOPIC_MESSAGE = '/MESSAGE/';
  static const String TOPIC_ALERT = '/HPV';
  static const String TOPIC_UNREGISTRATION = '/UNREGISTER';

  static const String FIELD_PAYLOAD_TYPE = "PayloadType";
  static const String FIELD_ID = "ID";
  static const String FIELD_TIMESTAMP = "TimeStamp";
  static const String FIELD_USER = "USER";
  static const String FIELD_NAME = "Name";
  static const String FIELD_DEPT = "Dept";
  static const String FIELD_CALL_SIGN = "CallSign";
  static const String FIELD_STATUS = "Status";
  static const String FIELD_PLATFORM = "Platform";
  static const String FIELD_CONTENT = "Content";

  static const String FIELD_CID = "Cid";
  static const String FIELD_TYPE = "Type";
  static const String FIELD_BODY = "Body";

  static const String FIELD_SEND_TO = "SendTo";
  static const String FIELD_REPLY_TO = "ReplyTo";
  static const String FIELD_RESPONSE_TYPE = "ResponseType";
  static const String FIELD_CONTENTS = "Contents";

  static const String FIELD_RESPONSE = "Response";
  static const String FIELD_RECEIVED_TIMESTAMP = "ReceivedTimeStamp";
  static const String FIELD_READ_TIMESTAMP = "ReadTimeStamp";
  static const String FIELD_RESPONDED_TIMESTAMP = "RespondedTimeStamp";

  static const String FIELD_NOTIFICATION_ID = "NotificationId";
  static const String FIELD_SENDER = "Sender";
  static const String FIELD_PRIORITY = "Priority";
  static const String FIELD_ADDRESS_TO = "Addressed_To";
  static const String FIELD_ALERT_STATUS = "Status";
  static const String FIELD_MESSAGE_TYPE = "MessageType";
  static const String FIELD_ALERT_CONTENTS = "Content";
  static const String FIELD_ALERTCONTENT_TIMESTAMP = "TimeStamp";
  static const String FIELD_PROBENAME = "ProbeName";
  static const String FIELD_SYSTEM = "System";
  static const String FIELD_VERSION = "Version";
  static const String FIELD_ROLE = "Role";
  static const String FIELD_NOTES = "Notes";
  static const String FIELD_ALERTCONTENT_ID = "ID";
  static const String FIELD_ALERTCONTENT_STATUS = "Status";
}

enum ResponseTypes {
  None,
  Options__Yes_No,
  Options__Maybe_Yes_No,
  Options__Custom,
  Options__True_False,
  Options__A_B_C_D,
  Rating__0_1_2_3_4_5,
  Rating__1_2_3_4_5,
  Rating__0_1_2_3_4_5_6_7_8_9_10,
  Rating__1_2_3_4_5_6_7_8_9_10
}

class PayloadWelcome {
  String payloadType = "";
  String iD = "";
  String timeStamp = "";
  String user = "";
  String name = "";
  String dept = "";
  String callSign = "";
  String status = "";
  String platform = "";
  String content = "";

  PayloadWelcome(
      {this.payloadType,
      this.iD,
      this.timeStamp,
      this.user,
      this.name,
      this.dept,
      this.callSign,
      this.status,
      this.platform,
      this.content});

  factory PayloadWelcome.fromJson(dynamic json) {
    return PayloadWelcome(
        payloadType: json[Constants.FIELD_PAYLOAD_TYPE] as String,
        iD: json[Constants.FIELD_ID] as String,
        timeStamp: json[Constants.FIELD_TIMESTAMP] as String,
        user: json[Constants.FIELD_USER] as String,
        name: json[Constants.FIELD_NAME] as String,
        dept: json[Constants.FIELD_DEPT] as String,
        callSign: json[Constants.FIELD_CALL_SIGN] as String,
        status: json[Constants.FIELD_STATUS] as String,
        platform: json[Constants.FIELD_PLATFORM] as String,
        content: json[Constants.FIELD_CONTENT] as String);
  }

  @override
  String toString() {
    return '{"${Constants.FIELD_PAYLOAD_TYPE}": "${this.payloadType}","${Constants.FIELD_ID}": "${this.iD}","${Constants.FIELD_TIMESTAMP}":"${this.timeStamp}","${Constants.FIELD_USER}":"${this.user}","${Constants.FIELD_NAME}":"${this.name}","${Constants.FIELD_DEPT}":"${this.dept}","${Constants.FIELD_CALL_SIGN}":"${this.callSign}","${Constants.FIELD_STATUS}":"${this.status}","${Constants.FIELD_PLATFORM}":"${this.platform}","${Constants.FIELD_CONTENT}":"${this.content}"}';
  }
}

class PayloadRegister {
  String payloadType = "";
  String iD = "";
  String timeStamp = "";
  String user = "";
  String name = "";
  String dept = "";
  String callSign = "";
  String status = "";
  String platform = "";
  String content = "";

  PayloadRegister(
      {this.payloadType,
      this.iD,
      this.timeStamp,
      this.user,
      this.name,
      this.dept,
      this.callSign,
      this.status,
      this.platform,
      this.content});
  factory PayloadRegister.fromJson(dynamic json) {
    return PayloadRegister(
        payloadType: json[Constants.FIELD_PAYLOAD_TYPE] as String,
        iD: json[Constants.FIELD_ID] as String,
        timeStamp: json[Constants.FIELD_TIMESTAMP] as String,
        user: json[Constants.FIELD_USER] as String,
        name: json[Constants.FIELD_NAME] as String,
        dept: json[Constants.FIELD_DEPT] as String,
        callSign: json[Constants.FIELD_CALL_SIGN] as String,
        status: json[Constants.FIELD_STATUS] as String,
        platform: json[Constants.FIELD_PLATFORM] as String,
        content: json[Constants.FIELD_CONTENT] as String);
  }

  @override
  String toString() {
    return '{"${Constants.FIELD_PAYLOAD_TYPE}": "${this.payloadType}","${Constants.FIELD_ID}": "${this.iD}","${Constants.FIELD_TIMESTAMP}":"${this.timeStamp}","${Constants.FIELD_USER}":"${this.user}","${Constants.FIELD_NAME}":"${this.name}","${Constants.FIELD_DEPT}":"${this.dept}","${Constants.FIELD_CALL_SIGN}":"${this.callSign}","${Constants.FIELD_STATUS}":"${this.status}","${Constants.FIELD_PLATFORM}":"${this.platform}","${Constants.FIELD_CONTENT}":"${this.content}"}';
  }
}

ResponseTypes enumFromString(String value) {
  switch (value) {
    case "ResponseTypes.None":
      ResponseTypes.None;
      break;
    case "ResponseTypes.Options__Yes_No":
      ResponseTypes.Options__Yes_No;
      break;
    case "ResponseTypes.Options__Maybe_Yes_No":
      ResponseTypes.Options__Maybe_Yes_No;
      break;
    case "ResponseTypes.Options__Custom":
      ResponseTypes.Options__Custom;
      break;
    case "ResponseTypes.Options__True_False":
      ResponseTypes.Options__True_False;
      break;
    case "ResponseTypes.Options__A_B_C_D":
      ResponseTypes.Options__A_B_C_D;
      break;
    case "ResponseTypes.Rating__0_1_2_3_4_5":
      ResponseTypes.Rating__0_1_2_3_4_5;
      break;
    case "ResponseTypes.Rating__1_2_3_4_5":
      ResponseTypes.Rating__1_2_3_4_5;
      break;
    default:
      ResponseTypes.None;
      break;
  }
}

class PayloadMessage {
  String payloadType = "";
  String iD = "";
  String timeStamp = "";
  String user = "";
  String sendTo = '';
  String replyTo = '';
  String receivedTimeStamp;
  ResponseTypes responseType = ResponseTypes.None;
  Content contents;

  PayloadMessage(
      {this.payloadType,
      this.iD,
      this.timeStamp,
      this.user,
      this.sendTo,
      this.replyTo,
      this.receivedTimeStamp,
      this.responseType,
      this.contents});

  factory PayloadMessage.fromJson(dynamic json) {
    return PayloadMessage(
        payloadType: json[Constants.FIELD_PAYLOAD_TYPE] as String,
        iD: json[Constants.FIELD_ID] as String,
        timeStamp: json[Constants.FIELD_TIMESTAMP] as String,
        user: json[Constants.FIELD_USER] as String,
        sendTo: json[Constants.FIELD_SEND_TO] as String,
        replyTo: json[Constants.FIELD_REPLY_TO] as String,
        receivedTimeStamp: json[Constants.FIELD_RECEIVED_TIMESTAMP],
        responseType: enumFromString(json[Constants.FIELD_RESPONSE_TYPE]),
        contents: Content.fromJson(json[Constants.FIELD_CONTENTS]));
  }

  @override
  String toString() {
    return '{"${Constants.FIELD_PAYLOAD_TYPE}":"${this.payloadType}","${Constants.FIELD_ID}":"${this.iD}","${Constants.FIELD_TIMESTAMP}":"${this.timeStamp}","${Constants.FIELD_USER}":"${this.user}", "${Constants.FIELD_SEND_TO}":"${this.sendTo}", "${Constants.FIELD_REPLY_TO}":"${this.replyTo}","${Constants.FIELD_RESPONSE_TYPE}": "${this.responseType}","${Constants.FIELD_CONTENTS}":${this.contents}}';
  }
}

class Content {
  String cid;
  String type;
  var body = """ """;

  Content({this.cid, this.body, this.type});

  factory Content.fromJson(dynamic json) {
    return Content(
        cid: json[Constants.FIELD_CID],
        body: json[Constants.FIELD_BODY],
        type: json[Constants.FIELD_TYPE]);
  }

  factory Content.fromPayload(Content payload) {
    return Content(cid: payload.cid, body: payload.body, type: payload.type);
  }
  @override
  String toString() {
    return '''{"${Constants.FIELD_CID}":"$cid","${Constants.FIELD_TYPE}":"$type","${Constants.FIELD_BODY}":"$body"}''';
  }
}

class Message extends PayloadMessage {
  String payloadType = "";
  String iD = "";
  String timeStamp = "";
  String user = "";
  String sendTo = '';
  String replyTo = '';
  ResponseTypes responseType = ResponseTypes.None;
  Content contents;
  String response = '';
  String receivedTimeStamp;
  String readTimeStamp = '';
  String respondedTimeStamp = '';

  Message(
      {this.payloadType,
      this.iD,
      this.timeStamp,
      this.user,
      this.sendTo,
      this.replyTo,
      this.responseType,
      this.contents,
      this.response,
      this.receivedTimeStamp,
      this.readTimeStamp,
      this.respondedTimeStamp})
      : super(
            payloadType: '',
            iD: '',
            timeStamp: '',
            user: '',
            sendTo: '',
            replyTo: '',
            responseType: ResponseTypes.None,
            contents: contents);

  factory Message.fromJson(dynamic json) {
    return Message(
        payloadType: json[Constants.FIELD_PAYLOAD_TYPE] as String,
        iD: json[Constants.FIELD_ID] as String,
        timeStamp: json[Constants.FIELD_TIMESTAMP] as String,
        user: [Constants.FIELD_USER] as String,
        sendTo: json[Constants.FIELD_SEND_TO] as String,
        replyTo: json[Constants.FIELD_REPLY_TO] as String,
        responseType: enumFromString(json[Constants.FIELD_RESPONSE_TYPE]),
        contents: Content.fromJson(json[Constants.FIELD_CONTENTS]),
        response: json[Constants.FIELD_RESPONSE] as String,
        receivedTimeStamp: json[Constants.FIELD_RECEIVED_TIMESTAMP].toString(),
        readTimeStamp: json[Constants.FIELD_READ_TIMESTAMP] as String,
        respondedTimeStamp:
            json[Constants.FIELD_RESPONDED_TIMESTAMP] as String);
  }

  factory Message.fromPayload(PayloadMessage payload) {
    return Message(
        payloadType: payload.payloadType,
        iD: payload.iD,
        timeStamp: payload.timeStamp,
        user: payload.user,
        sendTo: payload.sendTo,
        replyTo: payload.replyTo,
        responseType: payload.responseType,
        contents: payload.contents,
        response: '',
        receivedTimeStamp: payload.receivedTimeStamp.toString(),
        readTimeStamp: '',
        respondedTimeStamp: '');
  }

  @override
  String toString() {
    print(ResponseTypes.None == responseType);

    return '{"${Constants.FIELD_PAYLOAD_TYPE}":"$payloadType","${Constants.FIELD_ID}":"$iD","${Constants.FIELD_TIMESTAMP}":"$timeStamp","${Constants.FIELD_USER}":"$user","${Constants.FIELD_SEND_TO}":"$sendTo","${Constants.FIELD_REPLY_TO}":"$replyTo","${Constants.FIELD_RESPONSE_TYPE}":"$responseType","${Constants.FIELD_CONTENTS}":$contents,"${Constants.FIELD_RESPONSE}":"$response","${Constants.FIELD_RECEIVED_TIMESTAMP}":"$receivedTimeStamp","${Constants.FIELD_READ_TIMESTAMP}":"$readTimeStamp","${Constants.FIELD_RESPONDED_TIMESTAMP}":"$respondedTimeStamp"}';
  }
}

class AlertContent {
  String timeStamp;
  String probeName;
  String system;
  String version;
  String role;
  String notes;
  String iD;
  int status;

  AlertContent(this.timeStamp, this.probeName, this.system, this.version,
      this.role, this.notes, this.iD, this.status);

  factory AlertContent.fromJSon(dynamic json) {
    return AlertContent(
        json[Constants.FIELD_ALERTCONTENT_TIMESTAMP],
        json[Constants.FIELD_PROBENAME],
        json[Constants.FIELD_SYSTEM],
        json[Constants.FIELD_VERSION],
        json[Constants.FIELD_ROLE],
        json[Constants.FIELD_NOTES],
        json[Constants.FIELD_ALERTCONTENT_ID],
        json[Constants.FIELD_ALERTCONTENT_STATUS]);
  }
}

class AlertPayload {
  String notificationId;
  String sender;
  int priority;
  String addressedTo;
  int status;
  int messageType;
  AlertContent alertContent;

  AlertPayload(this.notificationId, this.sender, this.priority,
      this.addressedTo, this.status, this.messageType, this.alertContent)
      : super();

  factory AlertPayload.fromJson(dynamic json) {
    return AlertPayload(
        json[Constants.FIELD_NOTIFICATION_ID],
        json[Constants.FIELD_SENDER],
        json[Constants.FIELD_PRIORITY],
        json[Constants.FIELD_ADDRESS_TO],
        json[Constants.FIELD_STATUS],
        json[Constants.FIELD_MESSAGE_TYPE],
        AlertContent.fromJSon(json[Constants.FIELD_ALERT_CONTENTS]));
  }

  factory AlertPayload.fromPayload(AlertPayload payload) {
    return AlertPayload(
        payload.notificationId,
        payload.sender,
        payload.priority,
        payload.addressedTo,
        payload.status,
        payload.messageType,
        payload.alertContent);
  }
}
