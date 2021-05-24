import 'package:details/add_new_contact.dart';
import 'package:details/contact.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'contact_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE contact(id TEXT, name TEXT, number INTEGER)',
      );
    },
    version: 1,
  );
  runApp(MaterialApp(
    home: DesignUi(database),
    debugShowCheckedModeBanner: false,
  ));
}

class DesignUi extends StatefulWidget {
  final database;
  DesignUi(this.database);

  @override
  _DesignUiState createState() => _DesignUiState();
}

class _DesignUiState extends State<DesignUi> {
  List<Contact> contacts = [];
  List<Contact> temp;
  final snackBar = SnackBar(content: Text('Contact Deleted!!'));

  @override
  void initState() {
    super.initState();
    display();
  }

  void display() async {
    temp = await selectContact();

    setState(() {
      contacts = temp.toList();
    });
  }

  void addNewContact(String coname, int conumber) async {
    String numberto = conumber.toString();
    print(numberto);
    final newco = Contact(
      id: DateTime.now().toString(),
      name: coname,
      contactNum: conumber,
    );

    // contacts.add(newco);
    await insertDog(newco);

    setState(() {
      display();
    });
  }

  Future<void> insertDog(Contact contact) async {
    final db = await widget.database;

    await db.insert(
      'contact',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Contact>> selectContact() async {
    final db = await widget.database;

    final List<Map<String, dynamic>> maps = await db.query('contact');

    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        contactNum: maps[i]['number'],
      );
    });
  }

  void deleteContacts(String id, BuildContext context) async {
    await deleteContact(id);

    setState(() {
      display();
    });
  }

  Future<void> deleteContact(String id) async {
    final db = await widget.database;

    await db.delete(
      'contact',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#072734'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#072734'),
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddNewContact(
              addCon: addNewContact,
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 65.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.list,
                    size: 30,
                    color: HexColor('#072734'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Contact Details',
                  style: TextStyle(
                    fontSize: 39,
                    color: HexColor('#51666F'),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.teal[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              // ignore: unrelated_type_equality_checks
              child: contacts.isEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 150),
                          child: Image.asset(
                            'lib/images/duck.png',
                            height: 190,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              'You have no Contacts yet..',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 18),
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal[200],
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: HexColor('#072734'),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  contacts[index].name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#072734'),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                (contacts[index].contactNum).toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor('#072734'),
                                ),
                              ),
                              trailing: InkWell(
                                splashColor: Colors.red,
                                onTap: () {
                                  print('Delete');
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      title: Text('Delete!',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      content: Text(
                                        'Are you Sure?',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await deleteContacts(
                                                contacts[index].id, context);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );

                                  // Navigator.popAndPushNamed(context, TabScreen.routeName);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
