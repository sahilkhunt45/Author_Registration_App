import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();

  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference authorRef;

  void connectWithAuthorsCollection() {
    authorRef = firebaseFirestore.collection("author");
  }

  Future<void> insertRecord({
    required String name,
    required String bookName,
  }) async {
    connectWithAuthorsCollection();
    Map<String, dynamic> data = {
      'name ': name,
      'bookName': bookName,
    };
    await authorRef.add(data);
  }

  Stream<QuerySnapshot> selectRecord() {
    connectWithAuthorsCollection();
    return authorRef.snapshots();
  }

  Future<void> updateRecord(
      {required Map<String, dynamic> updatedData,
      required String updatedId}) async {
    connectWithAuthorsCollection();
    await authorRef.doc(updatedId).update(updatedData);
  }

  Future<void> deleteRecord({required String id}) async {
    connectWithAuthorsCollection();
    await authorRef.doc(id).delete();
  }
}
