import 'package:flutter/foundation.dart';

class Contact {
  String name;
  String id;
  int contactNum;

  Contact({
    @required this.id,
    @required this.name,
    @required this.contactNum,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': contactNum,
    };
  }
}
