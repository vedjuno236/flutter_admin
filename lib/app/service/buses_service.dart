// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_admin/app/model/bus_model.dart';
// import 'package:flutter_admin/app/model/tickets_model.dart';
// import 'package:get/get.dart';

// const String BUSES_COLLECTION_REF = "Buses";
// const String BUSTYPE_COLLECTION_REF = "BusType";
// const String TICKET_COLLECTION_REF = "Tickets";

// class DatabaseService {
//   final FirebaseFirestore _firebase = FirebaseFirestore.instance;

//   late final CollectionReference _busesRef;
//   late final CollectionReference _bustypesRef;
//   late final CollectionReference _ticketpesRef;

//   DatabaseService() {
//     _busesRef = _firebase.collection(BUSES_COLLECTION_REF);
//     _bustypesRef = _firebase.collection(BUSTYPE_COLLECTION_REF);
//     _ticketpesRef = _firebase.collection(TICKET_COLLECTION_REF);
//   }

// Stream<List<Buses>> getBuses({String? nameQuery}) {
//   return _busesRef.snapshots().asyncMap((querySnapshot) async {
//     try {
//       final busFutures = querySnapshot.docs.map((busDoc) async {
//         final busData = busDoc.data() as Map<String, dynamic>?;
//         if (busData == null || busData.isEmpty) {
//           return null;
//         }
//         if (!busData.containsKey('bus_type_id') ||
//             !busData.containsKey('name') ||
//             !busData.containsKey('ticket_id')) {
//           return null;
//         }

//         final bustypeId = busData['bus_type_id'];
//         final ticketIds = List<String>.from(busData['ticket_id']);

//         final bustypeDoc = await _bustypesRef.doc(bustypeId).get();
//         if (!bustypeDoc.exists) {
//           return null;
//         }
//         final bustypeData = bustypeDoc.data() as Map<String, dynamic>?;
//         if (bustypeData == null || !bustypeData.containsKey('name')) {
//           return null;
//         }

//         busData['id'] = busDoc.id;
//         busData.addAll({"bus_type_id": bustypeData});

//         List<Map<String, dynamic>> ticketList = [];
//         for (String ticketId in ticketIds) {
//           final ticketDoc = await _ticketpesRef.doc(ticketId).get();
//           final ticketData = ticketDoc.data() as Map<String, dynamic>?;
//           ticketList.add(ticketData!);
//         }

//         busData.addAll({"ticket": ticketList});
//         return Buses.fromJson(busData);
//       }).toList();

//       final resolvedBuses = await Future.wait(busFutures);

//       // Filtering out null elements and converting to List<Buses>
//       final filteredBuses = resolvedBuses.where((bus) => bus != null).cast<Buses>().toList();

//       // Filtering by name if nameQuery is provided
//       if (nameQuery != null && nameQuery.isNotEmpty) {
//         return filteredBuses.where((bus) => bus.carnamber == nameQuery).toList();
//       } else {
//         return filteredBuses;
//       }
//     } catch (e, stackTrace) {
//       print('Error fetching buses: $e');
//       print(stackTrace);
//       return []; // Returning empty list in case of error
//     }
//   });
// }


//   void addBuses(Map<String,dynamic> mapData) async{
//  _busesRef.add(mapData);
// }

//   void updateBuses(String busId, Buses bus) {
//     _busesRef.doc(busId).update(bus.toJson());
//   }

//   void deleteBuses(String busId) {
//     _busesRef.doc(busId).delete();
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/bus_model.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';
import 'package:get/get.dart';

const String BUSES_COLLECTION_REF = "Buses";
const String BUSTYPE_COLLECTION_REF = "BusType";
const String TICKET_COLLECTION_REF = "Tickets";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _busesRef;
  late final CollectionReference _bustypesRef;
  late final CollectionReference _ticketpesRef;

  DatabaseService() {
    _busesRef = _firebase.collection(BUSES_COLLECTION_REF);
    _bustypesRef = _firebase.collection(BUSTYPE_COLLECTION_REF);
    _ticketpesRef = _firebase.collection(TICKET_COLLECTION_REF);
  }

  Stream<List<Buses>> getBuses({String? nameQuery}) {
    return _busesRef.snapshots().asyncMap((querySnapshot) async {
      try {
        
        final busFutures = querySnapshot.docs.map((busDoc) async {
          final busData = busDoc.data() as Map<String, dynamic>?;
          if (busData == null || busData.isEmpty) {
            return null;
          }
          if (!busData.containsKey('bus_type_id') ||
              !busData.containsKey('name') ||
              !busData.containsKey('ticket_id')) {
            return null;
          }
          print("ticketId:${busData['ticket_id'].runtimeType}");
          final bustypeId = busData['bus_type_id'];
          final ticketIds = List<String>.from(busData['ticket_id']);

          // print('Bus ID: $bustypeId, Ticket IDs: $ticketIds'); // Debugging info

          // Fetch bustype data
          final bustypeDoc = await _bustypesRef.doc(bustypeId).get();
          if (!bustypeDoc.exists) {
            return null;
          }
          final bustypeData = bustypeDoc.data() as Map<String, dynamic>?;
          if (bustypeData == null || !bustypeData.containsKey('name')) {
            return null;
          }
          // Construct Buses object
          busData['id'] = busDoc.id;
          busData.addAll({"bus_type_id": bustypeData});

          // // Fetch and construct Tickets objects

          List<Map<String, dynamic>> ticketList = [];
          for (String ticketId in ticketIds) {
            final ticketDoc = await _ticketpesRef.doc(ticketId).get();
            final ticketData = ticketDoc.data() as Map<String, dynamic>?;
            ticketList.add(ticketData!);
          }

        
          busData.addAll({"ticket": ticketList});
          return Buses.fromJson(busData);
        }).toList();

        final resolvedBuses = await Future.wait(busFutures);

        return resolvedBuses.whereType<Buses>().toList();
      } catch (e, stackTrace) {
        print('Error fetching buses: $e');
        print(stackTrace); // Print stack trace for detailed error info
        return [];
      }
    });
  }

  void addBuses(Map<String,dynamic> mapData) async{
 _busesRef.add(mapData);
}

  void updateBuses(String busId, Buses bus) {
    _busesRef.doc(busId).update(bus.toJson());
  }

  void deleteBuses(String busId) {
    _busesRef.doc(busId).delete();
  }
}

