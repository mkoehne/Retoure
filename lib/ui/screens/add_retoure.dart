import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:retoure/ui/utils/repository.dart';
import 'package:retoure/ui/utils/theme_changer.dart';
import 'package:uuid/uuid.dart';

class AddRetoureScreen extends StatefulWidget {
  AddRetoureScreen();

  @override
  _AddRetoureScreenState createState() => _AddRetoureScreenState();
}

class _AddRetoureScreenState extends State<AddRetoureScreen>
    with SingleTickerProviderStateMixin {
  String name;
  String notes;
  DateTime date = DateTime.now();
  TimeOfDay time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
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
      backgroundColor: _themeChanger.getAppTheme().theme.backgroundColor,
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
          color: _themeChanger.getAppTheme().theme.backgroundColor,
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
                          _DateTimePicker(
                            labelText: "Datum",
                            selectedDate: date,
                            selectedTime: time,
                            selectDate: (DateTime date) {
                              setState(() {
                                date = date;
                              });
                            },
                            selectTime: (TimeOfDay time) {
                              setState(() {
                                time = time;
                              });
                            },
                          ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  color: _themeChanger
                                      .getAppTheme()
                                      .theme
                                      .mainBackgroundColor,
                                  onPressed: () {
                                    _displayOptionsDialog();
                                  },
                                  child: Text('Image'))),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  color: _themeChanger
                                      .getAppTheme()
                                      .theme
                                      .mainBackgroundColor,
                                  onPressed: () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      date = new DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                      );

                                      var retoure = await Repository.internal()
                                          .createRetoure(
                                              name, notes, imageSource, date);
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

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
