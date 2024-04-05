import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/passengers_model.dart';

const String TODO_COLLECTION_REF = "Passengers";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _passengersRef;

  DatabaseService() {
    _passengersRef = _firebase
        .collection(TODO_COLLECTION_REF)
        .withConverter<Passengers>(
          fromFirestore: (snapshots, _) => Passengers.fromJson(snapshots.data()!),
          toFirestore: (passengers, _) => passengers.toJson(),
        );
  }

  Stream<QuerySnapshot> getPassgers({String? nameQuery}) {
    if (nameQuery != null && nameQuery.isNotEmpty) {
      return _passengersRef.where('name', isEqualTo: nameQuery).snapshots();
    } else {
      return _passengersRef.snapshots();
    }
  }




 void deletepassengers(String? passengerId) {
  if (passengerId != null && passengerId.isNotEmpty) {
    _passengersRef.doc(passengerId).delete();
  } else {
    print("Invalid passengerId: $passengerId");
  }
}



}
