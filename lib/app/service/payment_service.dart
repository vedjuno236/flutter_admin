import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/payment_model.dart';

const String TODO_COLLECTION_REF = "Payment";
const String BOOKING_COLLECTION_REF = "Booking";
const String TICKET_COLLECTION_REF = "Tickets";
const String Passengers_COLLECTION_REF = "Passengers";
const String DEPARTURES_COLLECTION_REF = "Departures";
const String ROUTES_COLLECTION_REF = "Routes";
const String BUSES_COLLECTION_REF = "Buses";
const String BUSTYPE_COLLECTION_REF = "BusType";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _PaymentRef;
  late final CollectionReference _bookingRef;
  late final CollectionReference _ticketsRef;
  late final CollectionReference _passengersRef;
  late final CollectionReference _busesRef;
  late final CollectionReference _departuresRef;
  late final CollectionReference _routesRef;
  late final CollectionReference _bustypesRef;

  DatabaseService() {
    _PaymentRef = _firebase.collection(TODO_COLLECTION_REF);
    _bookingRef = _firebase.collection(BOOKING_COLLECTION_REF);
    _ticketsRef = _firebase.collection(TICKET_COLLECTION_REF);
    _passengersRef = _firebase.collection(Passengers_COLLECTION_REF);
    _departuresRef = _firebase.collection(DEPARTURES_COLLECTION_REF);
    _routesRef = _firebase.collection(ROUTES_COLLECTION_REF);
    _busesRef = _firebase.collection(BUSES_COLLECTION_REF);
    _bustypesRef = _firebase.collection(BUSTYPE_COLLECTION_REF);
  }

  Stream<List<Payment>> getpayment({String? nameQuery}) {
    return _PaymentRef.snapshots().asyncMap((querySnapshot) async {
      try {
        final paymentFutures = querySnapshot.docs.map((paymentDoc) async {
          try {
            final paymentData = paymentDoc.data() as Map<String, dynamic>?;

            if (paymentData == null ||
                paymentData.isEmpty ||
                !paymentData.containsKey('booking_id')) {
              return null;
            }

            final bookingIds = List<String>.from(paymentData['booking_id']);

            List<Map<String, dynamic>> bookingList = [];

            for (String bookingId in bookingIds) {
              try {
                final bookingDoc = await _bookingRef.doc(bookingId).get();
                final departuresDoc =
                    await _departuresRef.doc('departure_id').get();

                if (bookingDoc.exists) {
                  final bookingData =
                      bookingDoc.data() as Map<String, dynamic>;
                  print('bookingData:$bookingData');

                  final departuresId = (paymentDoc.data()
                          as Map<String, dynamic>?)?['departure_id'];

                  print('departuresId:$departuresId');

                  final routeId = (departuresDoc.data()  as Map<String, dynamic>?)?['route_id'];
                  print('routeId:$routeId');

                  if (routeId == null) {
                    return null;
                  }
                  final routeDoc = await _routesRef.doc(routeId).get();
                  final routeData =
                      routeDoc.data() as Map<String, dynamic>?;
                  print('routeData:$routeData');
                  if (routeData == null ||
                      !routeData.containsKey('arrival_station_id') ||
                      !routeData.containsKey('departure_station_id')) {
                    return null;
                  }
                  final arrivalStationId =
                      routeData['arrival_station_id'].toString();
                  final departureStationId =
                      routeData['departure_station_id'].toString();

                  final arrivalStationDoc = await FirebaseFirestore.instance
                      .collection('Stations')
                      .doc(arrivalStationId)
                      .get();
                  final departureStationDoc =
                      await FirebaseFirestore.instance
                          .collection('Stations')
                          .doc(departureStationId)
                          .get();
                  if (!arrivalStationDoc.exists ||
                      !departureStationDoc.exists) {
                    return null;
                  }
                  final arrivalStationName =
                      arrivalStationDoc.get('name');
                  final departureStationName =
                      departureStationDoc.get('name');

                  final busId = departuresDoc['bus_id'].toString();
                  final busDoc = await _busesRef.doc(busId).get();
                  final busData = busDoc.data() as Map<String, dynamic>?;

                  final busTypeDoc = await _bustypesRef
                      .doc(busData?['bus_type_id'].toString())
                      .get();
                  final busTypeData =
                      busTypeDoc.data() as Map<String, dynamic>?;

                  if (busData == null ||
                      !busData.containsKey('bus_type_id') ||
                      !busData.containsKey('name') ||
                      !busData.containsKey('ticket_id')) {
                    return null;
                  }

                  busData['bus_type_id'] = busTypeData;
                  routeData['arrival_station_id'] = arrivalStationName;
                  routeData['departure_station_id'] = departureStationName;
                  final departuresData =
                      departuresDoc.data() as Map<String, dynamic>;
                  departuresData['bus_id'] = busData;
                  departuresData['route'] = routeData;

                  paymentData['departure_id'] = departuresData;
                  final ticketId = paymentData['ticket_id'] as String?;
                  final passengersId =
                      paymentData['passenger_id'] as String?;
                  final passengersDoc =
                      await _passengersRef.doc(passengersId).get();
                  final ticketDoc =
                      await _ticketsRef.doc(ticketId).get();
                  final ticketData =
                      ticketDoc.data() as Map<String, dynamic>?;
                  final passengersData =
                      passengersDoc.data() as Map<String, dynamic>?;
                  final departuresIdData =
                      departuresDoc.data() as Map<String, dynamic>?;
                  if (ticketData == null || passengersData == null) {
                    return null;
                  }
                  paymentData['ticket_id'] = ticketData;
                  paymentData['departure_id'] = departuresIdData;
                  paymentData['passenger_id'] = passengersData;

                  paymentData['departure_id'] = departuresData;
                  paymentData['id'] = paymentDoc.id;

                  return Payment.fromJson(paymentData);
                }
              } catch (e) {
                print('Error processing booking: $e');
                return null;
              }
            }
          } catch (e) {
            print('Error processing payment: $e');
            return null;
          }
        }).toList();
        final resolvedpayment = await Future.wait(paymentFutures);

        final filteredpayment = resolvedpayment
            .where((payment) => payment != null)
            .cast<Payment>()
            .toList();

        if (nameQuery != null && nameQuery.isNotEmpty) {
          return filteredpayment
              .where((payment) => payment.id == nameQuery)
              .toList();
        } else {
          return filteredpayment;
        }
      } catch (e, stackTrace) {
        print('Error fetching payment: $e');
        print(stackTrace);
        return [];
      }
    });
  }
}
