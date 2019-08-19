import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:retoure/model/retoure.dart';
import 'package:retoure/ui/utils/application.dart';
import 'package:retoure/ui/utils/repository.dart';
import 'package:retoure/ui/utils/theme_changer.dart';
import 'package:uuid/uuid.dart';

import 'image.dart';

class AddRetoureScreen extends StatefulWidget {
  AddRetoureScreen();

  @override
  _AddRetoureScreenState createState() => _AddRetoureScreenState();
}

class _AddRetoureScreenState extends State<AddRetoureScreen>
    with SingleTickerProviderStateMixin {
  String name;
  String notes;
  DateTime date;
  String imageSource;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PermissionStatus _status;

  @override
  void initState() {
    super.initState();

    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera)
        .then(_updateStatus);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: _themeChanger.getAppTheme().theme.mainTextColor),
        brightness: _themeChanger.getAppTheme().theme.brightness,
        backgroundColor: _themeChanger.getAppTheme().theme.mainBackgroundColor,
        title: Text(
          "Neue Retoure",
          style: TextStyle(
              fontSize: 24.0,
              color: _themeChanger.getAppTheme().theme.mainTextColor),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Builder(
              builder: (context) => Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Name'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the retoure name';
                              }
                            },
                            onSaved: (val) => setState(() => name = val),
                          ),
                          TextFormField(
                              decoration: InputDecoration(labelText: 'Notes'),
                              validator: (value) {
                                if (value.isEmpty) {}
                              },
                              onSaved: (val) => setState(() => notes = val)),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
                                    _displayOptionsDialog();
                                  },
                                  child: Text('Image'))),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      var retoure = await Repository.internal()
                                          .createRetoure(name, notes,
                                              imageSource, DateTime.now());
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Save'))),
                        ]),
                  )))),
    );
  }

  void _displayOptionsDialog() async {
    await _optionsDialogBox();
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take Photo'),
                    onTap: _askPermission,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select Image From Gallery'),
                    onTap: imageSelectorGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _askPermission() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.camera]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> value) {
    final status = value[PermissionGroup.camera];
    if (status == PermissionStatus.granted) {
      imageSelectorCamera();
    } else {
      _updateStatus(status);
    }
  }

  _updateStatus(PermissionStatus value) {
    if (value != _status) {
      setState(() {
        _status = value;
      });
    }
  }

  void imageSelectorCamera() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    var uuid = new Uuid();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uuid.v4() + '.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(imageFile);

    final StorageTaskSnapshot downloadUrl = (await task.onComplete);

    final String url = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url');

    setState(() {
      imageSource = url;
    });
  }

  void imageSelectorGallery() async {
    Navigator.pop(context);
    var imageFile1 = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    var uuid = new Uuid();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(uuid.v4() + '.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(imageFile1);

    final StorageTaskSnapshot downloadUrl = (await task.onComplete);

    final String url = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url');

    imageSource = url;

    final StorageReference firebaseStorageRef1 =
        FirebaseStorage.instance.ref().child(uuid.v4() + '.jpg');
    final StorageUploadTask task1 = firebaseStorageRef.putFile(imageFile1);

    final StorageTaskSnapshot downloadUrl1 = (await task.onComplete);

    final String url1 = (await downloadUrl.ref.getDownloadURL());
    print('URL Is $url1');
    setState(() {
      imageSource = url1;
    });
  }
}
