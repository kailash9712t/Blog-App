import 'package:uuid/uuid.dart';

class UUID {
  String newId() {
    Uuid id = Uuid();
    return id.v1();
  }
}
