import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';

const String TODO_COLLECTION_REF = "Tickets";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _ticketsRef;

  DatabaseService() {
    _ticketsRef = _firebase
        .collection(TODO_COLLECTION_REF)
        .withConverter<Tickets>(
          fromFirestore: (snapshots, _) => Tickets.fromJson(snapshots.data()!),
          toFirestore: (tickets, _) => tickets.toJson(),
        );
  }

  Stream<QuerySnapshot> getTickets({String? nameQuery}) {
    if (nameQuery != null && nameQuery.isNotEmpty) {
      return _ticketsRef.where('name', isEqualTo: nameQuery).snapshots();
    } else {
      return _ticketsRef.snapshots();
    }
  }

  void addTickets(Tickets tickets) async {
    _ticketsRef.add(tickets);
  }

  void updateTickets(String ticketsId, tickets) {
    _ticketsRef.doc(ticketsId).update(tickets.toJson());
  }

  void deleteTickets(String ticketsId) {
    _ticketsRef.doc(ticketsId).delete();
  }
}
