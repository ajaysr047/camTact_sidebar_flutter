import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

import 'common/NavigationBloc.dart';

class MyCustomForm extends StatefulWidget with NavigationStates {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  File imageFile;
  String recognizedText = "";
  RegExp re = new RegExp('[6-9][0-9 ]+');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(5, 0, 30, 0),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                  controller: nameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Phone"),
//              initialValue: recognizedText,

                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                  controller: phoneController,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 100.0),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Contact contact = new Contact();
                          contact.givenName = nameController.text;
                          contact.phones = [
                            Item(label: "mobile", value: phoneController.text)
                          ];
                          Map<PermissionGroup, PermissionStatus> permissions =
                              await PermissionHandler().requestPermissions(
                                  [PermissionGroup.contacts]);

                          await ContactsService.addContact(contact);

                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                nameController.text + " Successfully added!"),
                          ));
                          phoneController.text = "";
                          nameController.text = "";
                          imageFile = null;
                          setState(() {});
                        }
                      },
                      child: Icon(Icons.person_add),
                      color: Colors.black,
                      textColor: Colors.white70,
                      splashColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      child: Icon(Icons.camera_enhance),
                      color: Colors.black,
                      textColor: Colors.white70,
                      splashColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      onPressed: () {
                        _showDialog(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(child: _decideImageWidget())
        ],
      ),
    ));
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Choose a source',
              style: TextStyle(color: Colors.white70),
            ),
            content: Text('Gallery or Camera',
                style: TextStyle(color: Colors.white70)),
            backgroundColor: Color(0xFF272D34),
            actions: <Widget>[
              FlatButton(
                child: Icon(Icons.photo_library,
                    size: 30.0, color: Colors.white70),
                splashColor: Color(0xFF4AC8EA),
                onPressed: () => _openGallery(context),
              ),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              FlatButton(
                child:
                    Icon(Icons.camera_alt, size: 30.0, color: Colors.white70),
                onPressed: () => _openCamera(context),
                splashColor: Color(0xFF4AC8EA),
              ),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              SizedBox(),
            ],
            elevation: 24.0,
          );
        });
  }

//  Choose widget
  Widget _decideImageWidget() {
    if (imageFile == null)
      return Icon(
        Icons.image,
        color: Colors.black38,
        size: 80.0,
      );
    else
      return Image.file(
        imageFile,
        width: 300.0,
        height: 300.0,
      );
  }

//  Open gallery
  _openGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = image;
    });
    Navigator.of(context).pop();
    final imageText = FirebaseVisionImage.fromFile(imageFile);
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(imageText);
//   recognizedText = visionText.text;
    String phone = visionText.text;
    Match firstPhone = re.firstMatch(phone);
    phone = phone.substring(firstPhone.start, firstPhone.end);
    this.setState(() {
      recognizedText = phone;
    });
    phoneController.text = recognizedText;
  }

  _openCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = image;
    });
    Navigator.of(context).pop();
    final imageText = FirebaseVisionImage.fromFile(imageFile);
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(imageText);
//    recognizedText = visionText.text;
    String phone = visionText.text;
    print(phone);
    Match firstPhone = re.firstMatch(phone);
    phone = phone.substring(firstPhone.start, firstPhone.end);
    this.setState(() {
      recognizedText = phone;
    });
    phoneController.text = recognizedText;
    print(recognizedText);
  }
}
