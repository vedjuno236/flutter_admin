import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/routes_model.dart'; // Assuming Routes model is in 'routes_model.dart'

const String ROUTES_COLLECTION_REF = "Routes";
const String STATION_COLLECTION_REF = "Stations";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _routesRef;
  late final CollectionReference
      _stationsRef; // Changed _stationstesRef to _stationsRef

  DatabaseService() {
    _routesRef = _firebase.collection(ROUTES_COLLECTION_REF);

    _stationsRef = _firebase.collection(
        STATION_COLLECTION_REF); // Corrected _stationstesRef to _stationsRef
  }


Stream<List<Routes>> getRoutes({String? nameQuery}) {
  return _routesRef.snapshots().asyncMap((querySnapshot) async {
    try {
      final routesFutures = querySnapshot.docs.map((routesDoc) async {
        final routesData = routesDoc.data() as Map<String, dynamic>?;

        // print('rou:${routesDoc.id}');

        if (routesData == null || routesData.isEmpty) {
          return null;
        }
        if (!routesData.containsKey('arrival_station_id') ||
            !routesData.containsKey('departure_station_id')) {
          return null;
        }

        final arrivalStationId = routesData['arrival_station_id'];
        final departureStationId = routesData['departure_station_id'];

        // Fetch station data for arrival station
        final arrivalStationDoc =
            await _stationsRef.doc(arrivalStationId).get();
        if (!arrivalStationDoc.exists) {
          return null;
        }
        final arrivalStationData =
            arrivalStationDoc.data() as Map<String, dynamic>?;
        if (arrivalStationData == null ||
            !arrivalStationData.containsKey('name')) {
          return null;
        }

        // Fetch station data for departure station
        final departureStationDoc =
            await _stationsRef.doc(departureStationId).get();
        if (!departureStationDoc.exists) {
          return null;
        }
        final departureStationData =
            departureStationDoc.data() as Map<String, dynamic>?;
        if (departureStationData == null ||
            !departureStationData.containsKey('name')) {
          return null;
        }

        // Construct Routes object
        routesData['id'] = routesDoc.id;
        routesData.addAll({
          "arrival_station_id": arrivalStationData,
          "departure_station_id": departureStationData
        });

        return Routes.fromJson(routesData);
      }).toList();
      final resolvedRoutes = await Future.wait(routesFutures);

      final filteredRoutes = resolvedRoutes
          .where((routes) => routes != null)
          .cast<Routes>()
          .toList();
          
      if (nameQuery != null && nameQuery.isNotEmpty) {
        return filteredRoutes.where((routes) => routes!.departure_station_id == nameQuery).toList();
      } else {
        return filteredRoutes;
      }
    } catch (e) {
      print('Error fetching routes: $e');
      return [];
    }
  });
}


  void addRoutes(Map<String, dynamic> mapData) async {
    _routesRef.add(mapData);
  }

  void updateRoutes(String routesId, routes) {
    _stationsRef.doc(routesId).update(routes.toJson());
  }

  void deleteroutes(String routesId) {
    _stationsRef.doc(routesId).delete();
  }
}
