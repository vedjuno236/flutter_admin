import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/bus_model.dart';

const String TODO_COLLECTION_REF = "Buses";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _busesRef;

  DatabaseService() {
    _busesRef = _firebase
        .collection(TODO_COLLECTION_REF)
        .withConverter<Buses>(
          fromFirestore: (snapshots, _) => Buses.fromJson(snapshots.data()!),
          toFirestore: (buses, _) => buses.toJson(),
        );
  }

  Stream<QuerySnapshot> getBuses({String? nameQuery}) {
    if (nameQuery != null && nameQuery.isNotEmpty) {
      return _busesRef.where('name', isEqualTo: nameQuery).snapshots();
    } else {
      return _busesRef.snapshots();
    }
  }

  void addStation(Buses  buses) async {
    _busesRef.add(buses);
  }
}
