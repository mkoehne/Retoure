import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:retoure/ui/utils/application.dart';
import 'package:uuid/uuid.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class ImagePage extends StatefulWidget {
  @override
  ImagePageState createState() {
    return new ImagePageState();
  }
}

class ImagePageState extends State<ImagePage> {
  AppState state;
  File imageFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Theme.of(context).brightness,
        backgroundColor: Colors.white,
        title: Text(
          "Image",
          style: TextStyle(fontSize: 24.0, color: Colors.black),
        ),
      ),
      body: ModalProgressHUD(
          child: imageFile == null ? Text('Select an image') : enableUpload(),
          inAsyncCall: _saving),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (state == AppState.free)
            _pickImage();
          else if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Widget enableUpload() {
    var uuid = new Uuid();

    return Container(
      child: Column(
        children: <Widget>[
          Image.file(imageFile, height: 300.0, width: 300.0),
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Theme.of(context).accentColor,
            splashColor: Colors.blueGrey,
            onPressed: () async {
              setState(() {
                _saving = true;
              });

              final StorageReference firebaseStorageRef =
                  FirebaseStorage.instance.ref().child(uuid.v4() + '.jpg');
              final StorageUploadTask task =
                  firebaseStorageRef.putFile(imageFile);

              final StorageTaskSnapshot downloadUrl = (await task.onComplete);

              final String url = (await downloadUrl.ref.getDownloadURL());
              print('URL Is $url');

              Application.image = url;

              setState(() {
                _saving = false;
              });
            },
          )
        ],
      ),
    );
  }

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.blue,
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  Future<Null> _saveImage() async {}

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}
