import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../../model/bustype_model.dart';
import '../../../model/tickets_model.dart';
import '../../../service/buses_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/bus_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_admin/app/modules/bus/view/report_buses.dart';

class report_buses extends StatefulWidget {
  final String docId; // Assuming you're passing document ID as a String
  report_buses({required this.docId});

  @override
  State<report_buses> createState() => _reporttState();
}

class _reporttState extends State<report_buses> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late String _name;
  final formattedDateTime =
      DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
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
      final List<Buses> buses = await databaseService.getBuses().first;

      // Convert logo image
      Uint8List logoData = (await rootBundle.load('assets/images/logo.png'))
          .buffer
          .asUint8List();

     
      List<List<dynamic>> busData = buses.map((bus) {
  final ticketNames = bus.ticketId.map((ticket) => ticket.name).toList();
  return [
    bus.name,
    bus.bustypeName,
    bus.capacity,
    bus.capacityVip,
    bus.carnamber,
    ticketNames, // List of ticket names for this bus
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
                          ' ລາຍງານຂໍ້ມູນລົດ',
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
                        'ຊື່',
                        'ປະເພດລົດ',
                        'ບ່ອນນັ່ງທໍາມະດາ',
                        'ບ່ອນນັ່ງvip',
                        'ທະບຽນລົດ',
                        'ແພັກແກັດ'
                      ],
                      data: busData,
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
