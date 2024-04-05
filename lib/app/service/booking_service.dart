// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_admin/app/model/booking_model.dart';

// const String TODO_COLLECTION_REF = "Booking";
// const String TICKET_COLLECTION_REF = "Tickets";
// const String Passengers_COLLECTION_REF = "Passengers";

// class DatabaseService {
//   final FirebaseFirestore _firebase = FirebaseFirestore.instance;

//   late final CollectionReference _bookingRef;
//   late final CollectionReference _ticketsRef;
//   late final CollectionReference _passengersRef; // Corrected variable name

//   DatabaseService() {
//     _bookingRef = _firebase.collection(TODO_COLLECTION_REF);
//     _ticketsRef = _firebase.collection(TICKET_COLLECTION_REF);
//     _passengersRef = _firebase
//         .collection(Passengers_COLLECTION_REF); // Corrected variable name
//   }

//   Stream<List<Booking>> getBooking({String? nameQuery}) {
//     return _bookingRef.snapshots().asyncMap((querySnapshot) async {
//       try {
//         final bookingFutures = querySnapshot.docs.map((bookingDoc) async {
//           final bookingData = bookingDoc.data() as Map<String, dynamic>?;

//           // print(bookingData);
//           if (bookingData == null || bookingData.isEmpty) {
//             return null;
//           }
//           if (!bookingData.containsKey('ticket_id')) {
//             return null;
//           }

//           final ticketId = bookingData['ticket_id'];
//           final passengersId = bookingData['passenger_id'];
//           final departureId = bookingData['departure_id'];

//           // print(ticketId);
//           // print('pass:$passengersId');
//           print('departure:$departureId');

//           final ticketDoc = await _ticketsRef.doc(ticketId).get();
//           final passengersDoc = await _passengersRef.doc(passengersId).get();

//           if (!ticketDoc.exists) {
//             return null;
//           }
//           final ticketData = ticketDoc.data() as Map<String, dynamic>?;
//           if (ticketData == null || !ticketData.containsKey('name')) {
//             return null;
//           }

//           bookingData['id'] = bookingDoc.id;
//           bookingData.addAll({"ticket_id": ticketData});
// //
//           if (!passengersDoc.exists) {
//             return null;
//           }
//           final passengersData = passengersDoc.data() as Map<String, dynamic>?;
//           if (passengersData == null || !passengersData.containsKey('name')) {
//             return null;
//           }

//           bookingData['id'] = bookingDoc.id;
//           bookingData.addAll({"passenger_id": passengersData});

//           return Booking.fromJson(bookingData);
//         }).toList();

//         final resolvedBuses = await Future.wait(bookingFutures);

//         // Filtering out null elements and converting to List<Buses>
//         final filteredBuses = resolvedBuses
//             .where((booking) => booking != null)
//             .cast<Booking>()
//             .toList();

//         // Filtering by name if nameQuery is provided
//         if (nameQuery != null && nameQuery.isNotEmpty) {
//           return filteredBuses
//               .where((booking) => booking.status == nameQuery)
//               .toList();
//         } else {
//           return filteredBuses;
//         }
//       } catch (e, stackTrace) {
//         print('Error fetching buses: $e');
//         print(stackTrace);
//         return []; // Returning empty list in case of error
//       }
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/booking_model.dart';

const String TODO_COLLECTION_REF = "Booking";
const String TICKET_COLLECTION_REF = "Tickets";
const String Passengers_COLLECTION_REF = "Passengers";
const String DEPARTURES_COLLECTION_REF = "Departures";
const String ROUTES_COLLECTION_REF = "Routes";
const String BUSES_COLLECTION_REF = "Buses";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late final CollectionReference _bookingRef;
  late final CollectionReference _ticketsRef;
  late final CollectionReference _passengersRef;
  late final CollectionReference _busesRef;
  late final CollectionReference _departuresRef;
  late final CollectionReference _routesRef;
  DatabaseService() {
    _bookingRef = _firebase.collection(TODO_COLLECTION_REF);
    _ticketsRef = _firebase.collection(TICKET_COLLECTION_REF);
    _passengersRef = _firebase.collection(Passengers_COLLECTION_REF);
    _departuresRef = _firebase.collection(DEPARTURES_COLLECTION_REF);
    _routesRef = _firebase.collection(ROUTES_COLLECTION_REF);
    _busesRef = _firebase.collection(BUSES_COLLECTION_REF);
  }

  Stream<List<Booking>> getBooking({String? nameQuery}) {
    return _bookingRef.snapshots().asyncMap((querySnapshot) async {
      try {
        final bookingFutures = querySnapshot.docs.map((bookingDoc) async {
          final bookingData = bookingDoc.data() as Map<String, dynamic>?;

          if (bookingData == null || bookingData.isEmpty) {
            return null;
          }
          if (!bookingData.containsKey('passenger_id') ||
              !bookingData.containsKey('ticket_id') ||
              !bookingData.containsKey('departure_id')) {
            return null;
          }
          final ticketId = bookingData['ticket_id'] as String?;
          final passengersId = bookingData['passenger_id'] as String?;
          final departuresId = bookingData['departure_id'] as String?;

          final ticketDoc = await _ticketsRef.doc(ticketId).get();
          final passengersDoc = await _passengersRef.doc(passengersId).get();
          final departuresDoc = await _departuresRef.doc(departuresId).get();

          final routeId = (departuresDoc.data()
              as Map<String, dynamic>?)?['route_id'] as String?;

          if (routeId == null) {
            return null;
          }
          final routeDoc = await _routesRef.doc(routeId).get();
          final routeData = routeDoc.data() as Map<String, dynamic>?;

          if (routeData == null ||
              !routeData.containsKey('arrival_station_id') ||
              !routeData.containsKey('departure_station_id')) {
            return null;
          }
          final arrivalStationId = routeData['arrival_station_id'].toString();
          final departureStationId =
              routeData['departure_station_id'].toString();

          final arrivalStationDoc = await FirebaseFirestore.instance
              .collection('Stations')
              .doc(arrivalStationId)
              .get();
          final departureStationDoc = await FirebaseFirestore.instance
              .collection('Stations')
              .doc(departureStationId)
              .get();
          if (!arrivalStationDoc.exists || !departureStationDoc.exists) {
            return null;
          }
          final arrivalStationName = arrivalStationDoc.get('name');
          final departureStationName = departureStationDoc.get('name');

          // Fetch Buses data and include the 'name' field in bookingData
          final busId = departuresDoc['bus_id'].toString();
          final busDoc = await _busesRef.doc(busId).get();

          final busData = busDoc.data() as Map<String, dynamic>?;

          if (busData == null ||
              !busData.containsKey('bus_type_id') ||
              !busData.containsKey('name') ||
              !busData.containsKey('ticket_id')) {
            return null;
          }

          final busTypeData = busData['bus_type_id']; 

          busData['bus_type_id'] = busTypeData;
          final dep = departuresDoc.data() as Map<String, dynamic>;
          dep['bus_id'] = busData;

          dep['bus_id'] = busData;
          bookingData['departure_id'] = dep;

          bookingData['id'] = departuresDoc.id;

          bookingData['route_id'] = routeData;
          bookingData['route_id']['arrival_station_id'] = arrivalStationName;
          bookingData['route_id']['departure_station_id'] =
              departureStationName;
          // print('departureStationName:$departureStationName');
          // print('arrivalStationName:$arrivalStationName');

          final ticketData = ticketDoc.data() as Map<String, dynamic>?;
          final passengersData = passengersDoc.data() as Map<String, dynamic>?;
          final departuresIdData =
              departuresDoc.data() as Map<String, dynamic>?;
          if (ticketData == null || passengersData == null) {
            return null;
          }

          bookingData['ticket_id'] = ticketData;
          bookingData['departure_id'] = departuresIdData;
          bookingData['passengers_id'] = passengersData;

          bookingData['departure_id'] = dep;
          // print('dep:$dep');

          // print('ticketData:$ticketData');
          // print('passengersData:$passengersData');

          return Booking.fromJson(bookingData);
        }).toList();
        final resolvedBookings = await Future.wait(bookingFutures);

        // print('resolvedBookings:$resolvedBookings');

        final filteredBookings = resolvedBookings
            .where((booking) => booking != null)
            .cast<Booking>()
            .toList();

        // print('filteredBookings:$resolvedBookings');

        if (nameQuery != null && nameQuery.isNotEmpty) {
          return filteredBookings
              .where((booking) => booking.id == nameQuery)
              .toList();
        } else {
          return filteredBookings;
        }
      } catch (e, stackTrace) {
        print('Error fetching bookings: $e');
        print(stackTrace);
        return [];
      }
    });
  }
}
