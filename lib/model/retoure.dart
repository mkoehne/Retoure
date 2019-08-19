import 'package:cloud_firestore/cloud_firestore.dart';

class Retoure {
  String id;
  String name;
  String notes;
  DateTime date;
  String imageURL;
  String userId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  Retoure({
    this.id,
    this.name,
    this.notes,
    this.date,
    this.imageURL,
    this.userId,
  });

//</e@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Retoure &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          notes == other.notes &&
          date == other.date &&
          userId == other.userId &&
          imageURL == other.imageURL);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      notes.hashCode ^
      date.hashCode ^
      userId.hashCode ^
      imageURL.hashCode;

  @override
  String toString() {
    return 'Retoure{' +
        ' id: $id,' +
        ' name: $name,' +
        ' notes: $notes,' +
        ' date: $date,' +
        ' userId: $userId,' +
        ' imageURL: $imageURL,' +
        '}';
  }

  Retoure copyWith({
    String id,
    String name,
    String image,
    DateTime date,
    String userId,
    String imageURL,
  }) {
    return new Retoure(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: image ?? this.notes,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      imageURL: imageURL ?? this.imageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'notes': this.notes,
      'date': Timestamp.fromDate(date),
      'userId': this.userId,
      'imageURL': this.imageURL,
    };
  }

  factory Retoure.fromDocument(DocumentSnapshot doc) {
    return Retoure.fromMap(doc.data);
  }

  factory Retoure.fromMap(Map<String, dynamic> map) {
    return new Retoure(
      id: map['id'] as String,
      name: map['name'] as String,
      notes: map['notes'] as String,
      date: Timestamp(map['date'].seconds, map['date'].nanoseconds).toDate(),
      userId: map['userId'] as String,
      imageURL: map['imageURL'] as String,
    );
  }

//</editor-fold>
}
