import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/payment_model.dart';
import 'package:flutter_admin/app/service/booking_service.dart' as booking;

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
  late final CollectionReference _departuresRef;
  late final CollectionReference _routesRef;
  DatabaseService() {
    _PaymentRef = _firebase.collection(TODO_COLLECTION_REF);
    _routesRef = _firebase.collection(ROUTES_COLLECTION_REF);
    _departuresRef = _firebase.collection(DEPARTURES_COLLECTION_REF);
  }

  Stream<List<Payment>> getPayment({String? nameQuery}) {
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
          final bookingIds = paymentData['booking_id'] as List<dynamic>? ?? [];

            print(
                'Type of booking_id: ${paymentData['booking_id'].runtimeType}');
            print('Contents of booking_id: ${paymentData['booking_id']}');

            List<Map<String, dynamic>> bookingList = [];

            for (String bookingId in bookingIds) {
              final booking.DatabaseService _databasebookingService =
                  booking.DatabaseService();
              final bookings = await _databasebookingService
                  .getBooking(nameQuery: bookingId)
                  .first;

              if (bookings.isNotEmpty) {
                bookingList.addAll(
                    bookings.map((booking) => booking.toJson()).toList());
              } else {
                print('No booking data found for booking ID: $bookingId');
              }
            }
            paymentData['booking_id'] = bookingList;
            // debugPrint('bookingList: ${bookingList[0]}', wrapWidth: 1024);
            debugPrint(
                'Arrival Station ID: ${bookingList[0]['departure_id']['route_id']['arrival_station_id']['id']}');
            debugPrint(
                'Departure Station ID: ${bookingList[0]['departure_id']['route_id']['departure_station_id']['id']}');

            Payment payment = Payment.fromJson(paymentData);
            if (payment.booking_id.isNotEmpty) {
              debugPrint(
                  'First booking_routes: ${payment.booking_id[0].departure_id.route_id.departure_station_id.id}');

              debugPrint(
                  'First booking_bus: ${payment.booking_id[0].departure_id.bus_id.carnamber}');
            } else {
              print('No booking data found for payment: ${payment.id}');
            }
            return payment;
          } catch (e) {
            print('Error processing payment: $e');
            return null;
          }
        }).toList();
        final resolvedPayment = await Future.wait(paymentFutures);

        final filteredPayment = resolvedPayment
            .where((payment) => payment != null)
            .cast<Payment>()
            .toList();
        if (nameQuery != null && nameQuery.isNotEmpty) {
          return filteredPayment
              .where((payment) => payment.payment_method == nameQuery)
              .toList();
        } else {
          return filteredPayment;
        }
      } catch (e, stackTrace) {
        print('Error fetching payment: $e');
        print(stackTrace);
        return [];
      }
    });
  }
}
