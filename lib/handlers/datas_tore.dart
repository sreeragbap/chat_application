import 'package:messageapp/handlers/message_parsers.dart';
import 'package:messageapp/screens/login_screen.dart';

class DataStore {
  List<Employee> _contacts = [];
  List<Employee> get contacts => _contacts;

  List<ContactGroup> _subscriptions = [];
  List<ContactGroup> get subscriptions => _subscriptions;

  List<Message> _dialogue = [];
  List<Message> get dialogue => _dialogue;

  List<AlertPayload> _alertMessages = [];
  List<AlertPayload> get alertMessages => _alertMessages;

  void addMessageFromPayload(PayloadMessage payloadMessage) {
    Message newMessage = Message.fromPayload(payloadMessage);
    _dialogue.add(newMessage);
  }

  void addAlertMessage(AlertPayload alertMessage) {
    List notificationIdList = _alertMessages.map((message) {
      return message.notificationId;
    }).toList();
    if (_alertMessages.isNotEmpty) {
      if (!notificationIdList.contains(alertMessage.notificationId)) {
        _alertMessages.add(alertMessage);
      }
    } else {
      _alertMessages.add(alertMessage);
    }
  }

  void addMessage(Message newMessage) {
    List msgIdList = _dialogue.map((message) {
      return message.iD;
    }).toList();
    if (_dialogue.isNotEmpty) {
      if (!msgIdList.contains(newMessage.iD)) {
        _dialogue.add(newMessage);
      }
    } else {
      _dialogue.add(newMessage);
    }
  }

  void addSubscription(ContactGroup newGroup) {
    _subscriptions.add(newGroup);
  }

  void addContact(Employee newContact) {
    List empNoList = _contacts.map((contact) {
      return contact.empNo;
    }).toList();
    if (_contacts.isNotEmpty) {
      if (!empNoList.contains(newContact.empNo)) {
        _contacts.add(newContact);
      }
    } else {
      _contacts.add(newContact);
    }
  }

  void removeContact(Employee newContact) {
    if (_contacts.isNotEmpty) {
      _contacts.removeWhere((contact) => contact.empNo == newContact.empNo);
    }
  }
}

class Contact {
  String name = "";
  String description = "";
}

class Employee extends Contact {
  String empNo = "";
  String name = "";
  String dept = "";
  bool isSelected = false;
  String joined = DateTime.now().toString();

  Employee({this.empNo, this.name, this.dept, this.isSelected});
}

class ContactGroup extends Contact {
  List<Contact> members = [];
}

class DataElement {
  String name = "";
  var value;

  DataElement(this.name, this.value);
}

class AppContext {
  AppContext();
  Map<String, DataElement> _context = {};
  static const String NIL = '~~NiL~~';
  static const String PROTOCOL_SIGNATURE = '/JABBERWOCKEY/';
  static const String ACTIVE_USER = 'ActiveUser';

  DataStore appData = DataStore();

  getValue(String name, var defaultValue) {
    var returnValue = defaultValue;
    if (_context.containsKey(name)) {
      returnValue = _context[name].value;
    }
    return returnValue;
  }

  setValue(String name, var value) {
    DataElement dataElement = DataElement(name, value);
    _context[name] = dataElement;
  }
}
