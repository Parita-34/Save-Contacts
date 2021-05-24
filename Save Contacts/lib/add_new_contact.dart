import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddNewContact extends StatefulWidget {
  final Function addCon;

  AddNewContact({this.addCon});

  @override
  _AddNewContactState createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {
  final nameController = TextEditingController();

  final numController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _formkey = GlobalKey<FormState>();
  String contactError;

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(35),
          height: 470,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: HexColor('#072734'),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formkey,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: 'Enter Name..',
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Name';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _key,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: 'Enter Contact No..',
                    // errorText: contactError,
                  ),
                  controller: numController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Contact number';
                    } else if (value.length < 10 || value.length > 10) {
                      return 'Please enter valid Contact Number';
                    } else
                      return null;
                  },
                ),
              ),
              SizedBox(
                height: 53,
              ),
              FlatButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 1.0,
                  ),
                ),
                onPressed: () {
                  String msg = 'Successfully Added';
                  print('Clicked');

                  if (_formkey.currentState.validate() &&
                      _key.currentState.validate()) {
                    if (nameController.text != '' || numController.text != '') {
                      setState(() {
                        widget.addCon(
                          nameController.text,
                          int.parse(numController.text),
                        );
                        numController.clear();
                        nameController.clear();
                      });
                    } else if (numController.text.length < 10) {
                      return 'Please enter valid Contact Number';
                    } else if (numController.text.isEmpty) {
                      return 'Please enter Contact Number';
                    } else if (nameController.text.isEmpty) {
                      return 'Please enter a Name';
                    }
                    Navigator.pop(context);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Successfully Added'),
                  ));
                },

                //Navigator.pop(context);
                // },
                height: 45,
                color: HexColor('#072734'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
