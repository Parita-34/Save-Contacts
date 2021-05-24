import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'contact.dart';

class ContactList extends StatelessWidget {
  final List<Contact> userContacts;

  ContactList(this.userContacts);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: userContacts.map((co) {
        return Card(
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                co.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#072734'),
                ),
              ),
              Text(
                co.contactNum.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: HexColor('#072734'),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
