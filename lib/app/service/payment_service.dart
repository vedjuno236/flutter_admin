// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_admin/app/model/payment_model.dart';

// const String PAYMENT_COLLECTION_REF = "Payment";
// const String BOOKING_COLLECTION_REF = "Booking";

// class DatabaseService {
//   final FirebaseFirestore _firebase = FirebaseFirestore.instance;

//   late final CollectionReference _paymentRef;
//   late final CollectionReference _bookingRef;

//   DatabaseService() {
//     _paymentRef = _firebase.collection(PAYMENT_COLLECTION_REF);
//     _bookingRef = _firebase.collection(BOOKING_COLLECTION_REF);
//   }

//   Stream<List<Payment>> getPayment({String? nameQuery}) {
//     return _paymentRef.snapshots().asyncMap((querySnapshot) async {
//       try {
//         final paymentFutures = querySnapshot.docs.map((paymentDoc) async {
//           final paymentData = paymentDoc.data() as Map<String, dynamic>?;
//           if (paymentData == null ||
//               paymentData.isEmpty ||
//               !paymentData.containsKey('booking_id')) {
//             return null;
//           }

//           final bookingIds = List<String>.from(paymentData['booking_id']);

//           final bookingFutures = bookingIds.map((bookingId) async {
//             if (bookingId.isNotEmpty) {
//               final bookingDoc = await _bookingRef.doc(bookingId).get();
//               if (bookingDoc.exists) {
//                 return bookingDoc.data();
//               } else {
//                 print("Error: Booking document not found for ID $bookingId");
//                 return null;
//               }
//             } else {
//               return null;
//             }
//           });

//           final bookingList = await Future.wait(bookingFutures);

//           if (bookingList.any((booking) => booking == null)) {
//             // If any booking is null, return null
//             return null;
//           }

//           paymentData['booking_id'] = bookingList;
//           return Payment.fromJson(paymentData);
//         }).toList();

//         final resolvedPayments = await Future.wait(paymentFutures);
//         final filteredPayments = resolvedPayments
//             .where((payment) => payment != null)
//             .cast<Payment>()
//             .toList();

//         if (nameQuery != null && nameQuery.isNotEmpty) {
//           return filteredPayments
//               .where((payment) => payment!.total == nameQuery)
//               .toList();
//         } else {
//           return filteredPayments;
//         }
//       } catch (e, stackTrace) {
//         print('Error fetching payments: $e');
//         print(stackTrace);
//         return []; // Returning empty list in case of error
//       }
//     });
//   }
// }






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/payment_model.dart';

const String TODO_COLLECTION_REF = "Payment";

class DatabaseService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  late final CollectionReference _PaymentRef;

  DatabaseService() {
    _PaymentRef = _firebase
        .collection(TODO_COLLECTION_REF)
        .withConverter<Payment>(
          fromFirestore: (snapshots, _) => Payment.fromJson(snapshots.data()!),
          toFirestore: (payment, _) => payment.toJson(),
        );
  }

  Stream<QuerySnapshot> getpayment({String? nameQuery}) {
    // print('Name Query: $nameQuery');
    if (nameQuery != null && nameQuery.isNotEmpty) {
      return _PaymentRef.where('name', isEqualTo: nameQuery).snapshots();
    } else {
      return _PaymentRef.snapshots();
    }
  }

  void addpayment(Payment payment) async {
    _PaymentRef.add(payment);
  }
}

