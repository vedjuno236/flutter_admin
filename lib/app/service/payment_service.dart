
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

                if (bookingDoc.exists) {
                  final bookingData = bookingDoc.data() as Map<String, dynamic>;
                  print('bookingData:$bookingData');
                  bookingList.add(bookingData);
                } else {
                  print('Document with ID $bookingId does not exist');
                }
              } catch (e) {
                print('Error fetching booking: $e');
                // Handle error fetching booking
              }
            }

            paymentData.addAll({"booking_id": bookingList});
            return Payment.fromJson(paymentData);
          } catch (e) {
            print('Error processing payment: $e');
            // Handle error processing payment
            return null;
          }
        }).toList();

        final resolvedPayment = await Future.wait(paymentFutures);

        return Future.value(resolvedPayment.whereType<Payment>().toList());
      } catch (e, stackTrace) {
        print('Error fetching payment: $e');
        print(stackTrace);
        return [];
      }
    });
  }
}
