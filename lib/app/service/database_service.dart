import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/bustype.dart';

const String TODO_COLLECTION_REF = "BusType";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference<Bustype> _bustypeRef;

  DatabaseService() {
    _bustypeRef =
        _firebase.collection(TODO_COLLECTION_REF).withConverter<Bustype>(
              fromFirestore: (snapshot, _) => Bustype.fromJson(snapshot.data()),
              toFirestore: (bustype, _) => bustype.toJson(),
            );
  }

  Stream<QuerySnapshot<Bustype>> getBustype() {
    return _bustypeRef.snapshots();
  }

  Future<void> addBustype(Bustype bustype) async {
    await _bustypeRef.add(bustype);
  }
}
