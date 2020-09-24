import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sekolah/models/sekolah.dart';

final CollectionReference myCollection =
    Firestore.instance.collection('Sekolah');

class DatabaseServices {
  Future<Sekolah> tambahDataSekolah(
      String nama, double lat, double long, String alamat, String photo) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(myCollection.document());
      var id = ds.reference.documentID;

      final Sekolah sekolah = new Sekolah(nama, lat, long, alamat, photo, id);
      final Map<String, dynamic> data = sekolah.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Sekolah.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getAlData({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = myCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Future<void> delete(String id) async {
    await myCollection.document(id).delete();
  }

  Future<void> edit(String id,
      {String nama,
      String alamat,
      String photo,
      double lat,
      double long}) async {
    await myCollection.document(id).setData({
      "nama": nama,
      "alamat": alamat,
      "photo": photo,
      "lat": lat,
      "long": long
    }, merge: true);
  }
}
