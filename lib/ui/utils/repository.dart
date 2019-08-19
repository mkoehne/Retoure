import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retoure/model/retoure.dart';
import 'package:retoure/ui/utils/auth.dart';

final CollectionReference retouresCollection =
    Firestore.instance.collection('retoures');

class Repository {
  static final Repository _instance = new Repository.internal();

  factory Repository() => _instance;

  Repository.internal();

  Future<Retoure> createRetoure(
      String name, String note, String image, DateTime date) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(retouresCollection.document());
      var user = await Auth.getUserLocal();
      String userId;
      if (user == null) {
        userId = "";
      } else {
        userId = user.userId;
      }
      Retoure retoure = new Retoure();
      retoure.name = name;
      retoure.notes = note;
      retoure.imageURL = image;
      retoure.date = date;
      retoure.userId = userId;
      retoure.id = ds.documentID;
      final Map<String, dynamic> data = retoure.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Retoure.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future<Retoure> saveRetoure(Retoure truck) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(retouresCollection.document());
      truck.id = ds.documentID;
      final Map<String, dynamic> data = truck.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Retoure.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
}
