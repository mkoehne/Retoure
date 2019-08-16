import 'package:cloud_firestore/cloud_firestore.dart';

class Retoure {
  final String id;
  final String name;
  final String image;
  final DateTime date;
  final String imageURL;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Retoure({
    this.id,
    this.name,
    this.image,
    this.date,
    this.imageURL,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Retoure &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          date == other.date &&
          imageURL == other.imageURL);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      image.hashCode ^
      date.hashCode ^
      imageURL.hashCode;

  @override
  String toString() {
    return 'Retoure{' +
        ' id: $id,' +
        ' name: $name,' +
        ' image: $image,' +
        ' date: $date,' +
        ' imageURL: $imageURL,' +
        '}';
  }

  Retoure copyWith({
    String id,
    String name,
    String image,
    DateTime date,
    String imageURL,
  }) {
    return new Retoure(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      date: date ?? this.date,
      imageURL: imageURL ?? this.imageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'image': this.image,
      'date': this.date,
      'imageURL': this.imageURL,
    };
  }

  factory Retoure.fromMap(Map<String, dynamic> map) {
    return new Retoure(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      date: map['date'] as DateTime,
      imageURL: map['imageURL'] as String,
    );
  }

  factory Retoure.fromDocument(DocumentSnapshot doc) {
    return Retoure.fromMap(doc.data);
  }

  DateTime _convertStamp(Timestamp _stamp) {
    if (_stamp != null) {
      return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();

      /*
    if (Platform.isIOS) {
      return _stamp.toDate();
    } else {
      return Timestamp(_stamp.seconds, _stamp.nanoseconds).toDate();
    }
    */

    } else {
      return null;
    }
  }

//</editor-fold>
}
