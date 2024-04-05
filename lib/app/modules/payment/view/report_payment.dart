import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class report_payment extends StatefulWidget {
  final String docId;

  report_payment({required this.docId});

  @override
  State<report_payment> createState() => _ReportPaymentState();
}

class _ReportPaymentState extends State<report_payment> {
  late List<Map<String, dynamic>> paymentData;

  final formattedDateTime =
      DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'lo_LA', symbol: '₭');
  @override
  void initState() {
    super.initState();
    fetchPaymentData();
  }

Future<void> fetchPaymentData() async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Payment').get();

  paymentData = [];
  for (var doc in querySnapshot.docs) {
    final bookingIds = List<String>.from(doc['booking_id']);
    final bookingDetails = await Future.wait(
      bookingIds.map((bookingId) async {
        final bookingDoc = await FirebaseFirestore.instance.collection('Booking').doc(bookingId).get();
        return bookingDoc.exists ? bookingDoc.data() : null;
      }),
    );

    for (var i = 0; i < bookingDetails.length; i++) {
      final paymentEntry = {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      };
      paymentData.add(paymentEntry);
    }
  }
  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      canChangeOrientation: false,
      build: (format) => generateDocument(format),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = pw.Font.ttf(await rootBundle.load('fonts/BoonHome-400.ttf'));

    Uint8List logoData =
        (await rootBundle.load('assets/images/logo.png')).buffer.asUint8List();

    doc.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 0,
            marginLeft: 20,
            marginRight: 20,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font1,
          ),
        ),
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 15),
                pw.Center(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        height: 100,
                        child: pw.Image(
                          pw.MemoryImage(logoData),
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                      pw.Text(
                        '     ສະມາຄົມຂົນສົ່ງແຂວງຫຼວງພະບາງ ',
                        style: pw.TextStyle(
                          font: font1,
                          fontSize: 25,
                        ),
                      ),
                      pw.Text(
                        ' ລາຍງານຂໍ້ມູນສະຖານີ',
                        style: pw.TextStyle(
                          font: font1,
                          fontSize: 25,
                        ),
                      ),
                      pw.Text(
                        formattedDateTime,
                        style: pw.TextStyle(
                          font: font1,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                if (paymentData != null) // Check if paymentData is not null
                  pw.Center(
                    child: pw.Table.fromTextArray(
                      context: context,
                      cellAlignment: pw.Alignment.center,
                      headerStyle: pw.TextStyle(
                        font: font1,
                        fontSize: 12,
                      ),
                      headers: [
                        'ເວລາຊໍາລະ',
                        'ລະຫັດການຈອງ',
                        'ລາຍລະອຽດ',
                
                            'ລວມເງີນ',
                      ],
                      data: paymentData
                          .map((entry) => [
                               // Current date and time
                                entry['pay_date'] != null
                                    ? dateFormat.format(entry['pay_date']
                                        .toDate()) // Format pay_date
                                    : "",
                                entry['booking_id'] != null
                                    ? entry['booking_id'].join(", ")
                                    : "",

                                entry['description'] != null
                                    ? entry['description']
                                    : "",

                               
                                entry['total'] != null
                                    ? numberFormat.format(double.parse(entry[
                                        'total'])) // Convert to double and format total
                                    : "", // Empty string if total is null
                              ])
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }
}
