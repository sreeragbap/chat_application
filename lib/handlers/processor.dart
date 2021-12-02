import 'dart:convert';
import 'package:messageapp/handlers/datas_tore.dart';
import 'package:messageapp/handlers/message_parsers.dart';
import 'package:messageapp/mqtt_connection.dart';

class ProcessorFactory {
  static Handler buildProcessor() {
    Handler welcomeProcessor = WelcomeHandler();
    Handler registrationProcessor = RegistrationHandler();
    Handler unRegistrationProcessor = UnRegistrationHandler();
    welcomeProcessor._nextHandler = unRegistrationProcessor;
    registrationProcessor.nextHandler = welcomeProcessor;
    Handler sentDailogueProcessor = SentDialogueHandler();
    sentDailogueProcessor.nextHandler = registrationProcessor;
    Handler firstProcessor = DialogueHandler();
    firstProcessor.nextHandler = sentDailogueProcessor;

    return firstProcessor;
  }
}

class MQMessage {
  String topic = "";
  dynamic payload = "";
  MQMessage(this.topic, this.payload);
}

class HandlerResponse {
  AppContext context;
  bool messageProcessed;

  HandlerResponse(this.context, this.messageProcessed);
}

class Handler {
  Handler _nextHandler;
  // ignore: unnecessary_getters_setters
  Handler get nextHandler => _nextHandler;
  HandlerResponse response;

  // ignore: unnecessary_getters_setters
  set nextHandler(Handler succeedingHandler) {
    _nextHandler = succeedingHandler;
  }

  bool _messageProcessed = false;
  bool get messageProcessed => _messageProcessed;

  HandlerResponse process(AppContext context, MQMessage message) {
    bool result = false;
    response = HandlerResponse(context, result);
    if (message.topic.startsWith(AppContext.PROTOCOL_SIGNATURE)) {
      response = customisedProcessing(context, message);
      result = response.messageProcessed;
      context = response.context;
    } else {
      if (message.topic.startsWith(Constants.TOPIC_ALERT)) {
        AlertPayload payload =
            AlertPayload.fromJson(jsonDecode(message.payload));
        context.appData.addAlertMessage(AlertPayload.fromPayload(payload));
        result = true;
      }
    }
    if (!result) {
      if (_nextHandler != null) {
        response = _nextHandler.process(context, message);
        _messageProcessed = response.messageProcessed;
        context = response.context;
      }
    }
    return response;
  }

  HandlerResponse customisedProcessing(AppContext context, MQMessage message) {
    bool result = false;
    // throw UnimplementedError("An overriding customisedProcessing() is mandatory for using Handler class");
    response = HandlerResponse(context, result);
    return response;
  }
}

class RegistrationHandler extends Handler {
  @override
  HandlerResponse customisedProcessing(AppContext context, MQMessage message) {
    bool result = false;
    if (message.topic.endsWith(Constants.TOPIC_REGISTRATION)) {
      PayloadRegister payload =
          PayloadRegister.fromJson(jsonDecode(message.payload));
      if (payload.user !=
          context.getValue(AppContext.ACTIVE_USER, AppContext.NIL)) {
        context.appData.addContact(Employee(
            empNo: payload.user,
            name: payload.name,
            dept: payload.dept,
            isSelected: false));
      }
      result = true;
    }
    response = HandlerResponse(context, result);
    return response;
  }
}

class UnRegistrationHandler extends Handler {
  @override
  HandlerResponse customisedProcessing(AppContext context, MQMessage message) {
    bool result = false;
    if (message.topic.endsWith(Constants.TOPIC_UNREGISTRATION)) {
      PayloadRegister payload =
          PayloadRegister.fromJson(jsonDecode(message.payload));
      if (payload.user !=
          context.getValue(AppContext.ACTIVE_USER, AppContext.NIL)) {
        context.appData.removeContact(Employee(
            empNo: payload.user,
            name: payload.name,
            dept: payload.dept,
            isSelected: false));
      }
      result = true;
    }
    response = HandlerResponse(context, result);
    return response;
  }
}

class WelcomeHandler extends Handler {
  @override
  HandlerResponse customisedProcessing(AppContext context, MQMessage message) {
    bool result = false;
    if (message.topic.endsWith(Constants.TOPIC_WELCOME)) {
      PayloadWelcome payload =
          PayloadWelcome.fromJson(jsonDecode(message.payload));
      if (payload.user !=
          context.getValue(AppContext.ACTIVE_USER, AppContext.NIL)) {
        context.appData.addContact(Employee(
            empNo: payload.user,
            name: payload.name,
            dept: payload.dept,
            isSelected: false));
        result = true;
      }
    }
    response = HandlerResponse(context, result);
    return response;
  }
}

//  for incoming messages..
class DialogueHandler extends Handler {
  @override
  HandlerResponse customisedProcessing(AppContext context, MQMessage message) {
    bool result = false;
    String user = context.getValue(AppContext.ACTIVE_USER, AppContext.NIL);
    dynamic messageJson = jsonDecode(message.payload);
    String sender = messageJson[Constants.FIELD_USER];
    if (message.topic.endsWith(Constants.TOPIC_MESSAGE + user)) {
      PayloadMessage payload =
          PayloadMessage.fromJson(jsonDecode(message.payload));
      if (sender != user && sender != AppContext.NIL) {
        context.appData.addMessage(Message.fromPayload(payload));
      }
      result = true;
    }
    response = HandlerResponse(context, result);
    return response;
  }
}

// for sent messages..
class SentDialogueHandler extends Handler {
  @override
  HandlerResponse customisedProcessing(AppContext context, MQMessage message) {
    bool result = false;
    String user = context.getValue(AppContext.ACTIVE_USER, AppContext.NIL);
    dynamic messageJson = jsonDecode(message.payload.toString());
    String sender = messageJson[Constants.FIELD_USER];
    if (sender == user && sender != AppContext.NIL) {
      if (messageJson[Constants.FIELD_PAYLOAD_TYPE] == "RQMV1") {
        PayloadMessage payload =
            PayloadMessage.fromJson(jsonDecode(message.payload));
        context.appData.addMessage(Message.fromPayload(payload));
        result = true;
      }
    }
    response = HandlerResponse(context, result);
    return response;
  }
}
