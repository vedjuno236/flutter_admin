import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/app/model/booking_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/routes_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import '../../../service/Booking_service.dart';
import 'package:flutter_admin/app/modules/routes/view/report_routes.dart';

class report_booking extends StatefulWidget {
  final String docId; // Assuming you're passing document ID as a String
  report_booking({required this.docId});

  @override
  State<report_booking> createState() => _reporttState();
}

class _reporttState extends State<report_booking> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late String _name;
  final formattedDateTime = DateFormat('HH:mm:ss').format(DateTime.now());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    return PdfPreview(
      canChangeOrientation: false,
      build: (format) => generateDocument(
        format,
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    // Load custom font
    final font1 = pw.Font.ttf(await rootBundle.load('fonts/BoonHome-400.ttf'));

    try {
      // Create an instance of DatabaseService
      DatabaseService databaseService = DatabaseService();

      // Fetch bus data using DatabaseService
      final List<Booking> booking = await databaseService.getBooking().first;

      // Convert logo image
      Uint8List logoData = (await rootBundle.load('assets/images/logo.png'))
          .buffer
          .asUint8List();

      List<List<dynamic>> bookingData = booking.map((booking) {
        final book_date =
            DateFormat('dd/MM/yyy HH:mm:ss').format(booking.book_date.toDate());
        final expired_time =
            DateFormat('dd/MM/yyy HH:mm:ss').format(booking.expired_time.toDate());
        final time = DateFormat('dd/MM/yyy HH:mm:ss').format(booking.time.toDate());

        return [
          book_date,
          booking.departure_id,
          expired_time,
          booking.passenger_id.name,
          booking.seat,
          booking.status,
          booking.ticket_id.name,
          time,
          // booking.user_id,
        ];
      }).toList();

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
                          ' ລາຍງານຂໍ້ມູນການຈອງ',
                          style: pw.TextStyle(
                            font: font1,
                            fontSize: 25,
                          ),
                        ),
                        // Add other text as needed
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Table.fromTextArray(
                      context: context,
                      cellAlignment: pw.Alignment.center,
                      headerStyle: pw.TextStyle(
                        font: font1,
                        fontSize: 10,
                      ),
                      headers: [
                        'ເວລາຈອງ',
                        'ລະຫັດອອກເດີນທາງ',
                        'ປີ້ໝົດເວລາ',
                        'ຊື່ຜູ້ຈອງ',
                        'ບ່ອນນັ່ງ',
                        'ສະຖານະ',
                        'ປະເພດປີ້',
                        'ເວລາຈອງ',
                        // 'ລະຫັດຜູ້ໃຊ້',
                      ],
                      data: bookingData,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      return doc.save();
    } catch (e, stackTrace) {
      print('Error generating document: $e');
      print(stackTrace);
      return Uint8List(0);
    }
  }
}
