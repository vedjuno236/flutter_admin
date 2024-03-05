import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/bustype_model.dart';

const String TODO_COLLECTION_REF = "BusType";


class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference  _bustypeRef;

  DatabaseService() {
    _bustypeRef =
        _firebase.collection(TODO_COLLECTION_REF).withConverter<Bustype>(
              fromFirestore: (snapshots, _) => Bustype.fromJson(
                   snapshots.data()!),
              toFirestore: (bustype, _) => bustype.toJson(),
            );
  }


 Stream<QuerySnapshot> getBustype({String? nameQuery}) {
  
  if (nameQuery != null && nameQuery.isNotEmpty) {
    return _bustypeRef.where('name', isEqualTo: nameQuery).snapshots();
  } else {
    return _bustypeRef.snapshots();
  }
}

   void addBustype(Bustype bustype) async {
     _bustypeRef.add(bustype);
  }
}
