import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/departures_model.dart';

const String DEPARTURES_COLLECTION_REF = "Departures";
const String BUSES_COLLECTION_REF = "Buses";
const String ROUTES_COLLECTION_REF = "Routes";
const String TICKETS_COLLECTION_REF = "Tickets";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late final CollectionReference _departuresRef;
  late final CollectionReference<Map<String, dynamic>> _busesRef;
  late final CollectionReference _routesRef;
  late final CollectionReference _ticketsRef;

  DatabaseService() {
    _departuresRef = _firebase.collection(DEPARTURES_COLLECTION_REF);
    _busesRef = _firebase
        .collection(BUSES_COLLECTION_REF); // Provide explicit type information
    _routesRef = _firebase.collection(ROUTES_COLLECTION_REF);
    _ticketsRef = _firebase.collection(TICKETS_COLLECTION_REF);
  }

  Stream<List<Departures>> getDepartures({String? nameQuery}) {
    return _departuresRef.snapshots().asyncMap((querySnapshot) async {
      try {
        final departuresFutures = querySnapshot.docs.map((departuresDoc) async {
          final departuresData = departuresDoc.data() as Map<String, dynamic>?;

          if (departuresData == null || departuresData.isEmpty) {
            return null;
          }
          if (!departuresData.containsKey('bus_id') ||
              !departuresData.containsKey('route_id')) {
            return null;
          }

          final routeId = departuresData['route_id'];

          final busId = departuresData['bus_id'];

          final busDoc = await _busesRef.doc(busId).get();

          if (!busDoc.exists) {
            return null;
          }
          final busData = busDoc.data() as Map<String, dynamic>?;

          if (busData == null || !busData.containsKey('name')) {
            return null;
          }

          // Fetch ticket names associated with the bus
          final ticketIds = busData['ticket_id'] as List<dynamic>? ?? [];
          // print('ID:$ticketIds');
          // List<String> ticketNames = [];
          List<Map<String, dynamic>> ticketNames = [];

          for (String ticketId in ticketIds) {
            final ticketDoc = await _ticketsRef.doc(ticketId).get();

            if (ticketDoc.exists) {
              final ticketName = ticketDoc.get('price') as int?;

              print('Name:$ticketName');
              if (ticketName != null) {
                ticketNames.add({'price': ticketName});
              }
            }
          }

          // Fetch route data
          final routeDoc = await _routesRef.doc(routeId).get();

          if (!routeDoc.exists) {
            return null;
          }
          final routeData = routeDoc.data() as Map<String, dynamic>?;

          if (routeData == null ||
              !routeData.containsKey('arrival_station_id') ||
              !routeData.containsKey('departure_station_id')) {
            return null;
          }

          // Fetch station names
          final arrivalStationId = routeData['arrival_station_id'];
          final departureStationId = routeData['departure_station_id'];
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

          // Construct Departures object
          departuresData['id'] = departuresDoc.id;
          departuresData['bus_id'] = busData;
          departuresData['route'] = routeData;
          departuresData['route']['arrival_station_id'] = arrivalStationName;
          departuresData['route']['departure_station_id'] =
              departureStationName;
          departuresData['bus_id']['ticket_id'] =
              ticketNames; // Add ticket names to bus data
          // print('name:$ticketNames');

          busData.addAll({"ticket": ticketNames});
          // Pass departuresData directly to Departures.fromJson
          return Departures.fromJson(departuresData);
        }).toList();
        final resolvedDepartures = await Future.wait(departuresFutures);
        print(resolvedDepartures);
        return resolvedDepartures.whereType<Departures>().toList();
      } catch (e) {
        print('Error fetching departures: $e');
        return [];
      }
    });
  }

  void adddepartures(Map<String, dynamic> mapData) async {
    _departuresRef.add(mapData);
  }

  void updatedepartures(String departuresId, Departures departures) {
    _departuresRef.doc(departuresId).update(departures.toJson());
  }

  void deletedepartures(String departuresId) {
    _departuresRef.doc(departuresId).delete();
  }
}
