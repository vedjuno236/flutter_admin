
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/stations_model.dart';

const String TODO_COLLECTION_REF = "Stations";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _stationsRef;

  DatabaseService() {
    _stationsRef = _firebase.collection(TODO_COLLECTION_REF).withConverter<Stations>(
          fromFirestore: (snapshots, _) => Stations.fromJson(snapshots.data()!),
          toFirestore: (stations, _) => stations.toJson(),
        );
  }

 Stream<QuerySnapshot> getStations({String? nameQuery}) {
  // print('Name Query: $nameQuery'); 
  if (nameQuery != null && nameQuery.isNotEmpty) {
    return _stationsRef.where('name', isEqualTo: nameQuery).snapshots();
  } else {
    return _stationsRef.snapshots();
  }
}


  void addStation(Stations stations) async {
    _stationsRef.add(stations);
  }
   void updateStations(String stationsId,  stations) {
    _stationsRef.doc(stationsId).update(stations.toJson());
  }

  void deleteStation(String stationsId) {
    _stationsRef.doc(stationsId).delete();
  }
}

