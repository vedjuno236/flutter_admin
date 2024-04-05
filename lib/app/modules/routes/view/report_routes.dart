import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../service/routes_service.dart';
import 'package:flutter_admin/app/modules/routes/view/report_routes.dart';
class report_routes extends StatefulWidget {
  final String docId; // Assuming you're passing document ID as a String
  report_routes({required this.docId});

  @override
  State<report_routes> createState() => _reporttState();
}

class _reporttState extends State<report_routes> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late String _name;
  final formattedDateTime =
      DateFormat('HH:mm:ss').format(DateTime.now());
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
      final List<Routes> routes = await databaseService.getRoutes().first;

      // Convert logo image
      Uint8List logoData = (await rootBundle.load('assets/images/logo.png'))
          .buffer
          .asUint8List();

     
List<List<dynamic>> routesData = routes.map((route) {
  final departureTime = DateFormat('HH:mm:ss').format(route.departure_time.toDate());
  final arrivalTime = DateFormat('HH:mm:ss').format(route.arrival_time.toDate());
  
  return [
    departureTime,
    route.departure_station_id.name,
    arrivalTime,
    route.arrival_station_id.name,
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
                          ' ລາຍງານຂໍ້ມູນເສັ້ນທາງ',
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
                        fontSize: 20,
                      ),
                      headers: [
                        'ເວລາອອກ',
                        'ຕົ້ນທາງ',
                        'ເວລາຮອດ',
                        'ປາຍທາງ',
                      ],
                      data: routesData,
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
