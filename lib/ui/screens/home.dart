import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:retoure/model/retoure.dart';
import 'package:retoure/ui/utils/theme_changer.dart';
import 'package:retoure/ui/widgets/slide_item.dart';

import 'detail.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Firestore db = Firestore.instance;
  List<Retoure> items;
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  Stream<QuerySnapshot> getTruckList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots =
        Firestore.instance.collection('retoures').snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          brightness: _themeChanger.getTheme().brightness,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
          backgroundColor:
              _themeChanger.getAppTheme().theme.mainBackgroundColor,
          title: Text(
            "Retoure",
            style: TextStyle(color: Colors.black),
          )),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('retoures').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    Card(
                      elevation: 6.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _themeChanger
                              .getAppTheme()
                              .theme
                              .mainBackgroundColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 15.0,
                            color:
                                _themeChanger.getAppTheme().theme.mainTextColor,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: _themeChanger
                                    .getAppTheme()
                                    .theme
                                    .mainBackgroundColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: _themeChanger
                                    .getAppTheme()
                                    .theme
                                    .mainBackgroundColor,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Suche",
                            prefixIcon: Icon(
                              Icons.search,
                              color: _themeChanger
                                  .getAppTheme()
                                  .theme
                                  .mainTextColor,
                            ),
                            suffixIcon: Icon(
                              Icons.filter_list,
                              color: _themeChanger
                                  .getAppTheme()
                                  .theme
                                  .mainTextColor,
                            ),
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: _themeChanger
                                  .getAppTheme()
                                  .theme
                                  .mainTextColor,
                            ),
                          ),
                          maxLines: 1,
                          controller: controller,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          if (filter != null && filter != "") {
                            String name = ds['name'].toString().toLowerCase();
                            if (name.contains(filter.toLowerCase())) {
                              return _buildTruckItem(ds);
                            } else {
                              return Container();
                            }
                          } else {
                            return _buildTruckItem(ds);
                          }
                        }),
                    SizedBox(height: 10.0),
                  ],
                ),
              );
            }
          }),
    );
  }

  Widget _buildTruckItem(DocumentSnapshot ds) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(Retoure.fromDocument(ds), false)),
        );
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: SlideItem(
            img: '${ds['image']}',
            title: '${ds['name']}',
          ),
        ),
      ),
    );
  }
}
