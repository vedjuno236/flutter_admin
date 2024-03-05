


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/stations_model.dart';

const String TODO_COLLECTION_REF = "Departures";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _departuresRef;

  DatabaseService() {
    _departuresRef = _firebase.collection(TODO_COLLECTION_REF).withConverter<Stations>(
          fromFirestore: (snapshots, _) => Stations.fromJson(snapshots.data()!),
          toFirestore: (departures, _) => departures.toJson(),
        );
  }

 Stream<QuerySnapshot> getStations({String? nameQuery}) {
  // print('Name Query: $nameQuery'); 
  if (nameQuery != null && nameQuery.isNotEmpty) {
    return _departuresRef.where('name', isEqualTo: nameQuery).snapshots();
  } else {
    return _departuresRef.snapshots();
  }
}


  void addStation(Stations stations) async {
    _departuresRef.add(stations);
  }
}

