import 'dart:typed_data';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw; // Import pdf package as pw
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import 'package:flutter_admin/app/model/departures_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/routes_model.dart';
import '../../../model/stations_model.dart';
import '../../../service/departures_servide.dart';
import '../../../service/routes_service.dart' as routes;
import '../../../service/tickets_service.dart' as tickets;

class report_departures extends StatefulWidget {
  final String docId; // Assuming you're passing document ID as a String
  report_departures({required this.docId});

  @override
  State<report_departures> createState() => _reporttState();
}

class _reporttState extends State<report_departures> {
  final routes.DatabaseService _databaseRoutesService =
      routes.DatabaseService();
  final tickets.DatabaseService _databaseticketsService =
      tickets.DatabaseService();
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late String _name;
  final formattedDateTime = DateFormat('HH:mm:ss').format(DateTime.now());

  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'lo_LA', symbol: '₭');

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

    final font1 = pw.Font.ttf(await rootBundle.load('fonts/BoonHome-400.ttf'));

    try {
      DatabaseService databaseService = DatabaseService();
      final List<Departures> departures =
          await databaseService.getDepartures().first;

      final List<Routes> routes =
          await _databaseRoutesService.getRoutes().first;

      Uint8List logoData = (await rootBundle.load('assets/images/logo.png'))
          .buffer
          .asUint8List();

      // Create combinedData list
      List<List<dynamic>> combinedData = [];

      // Add data rows to combinedData
      for (int i = 0; i < departures.length; i++) {
        final Departures departure = departures[i];
        final Routes route = routes[i];
        DateTime arrivalTime = route.arrival_time.toDate();
        DateTime departureTime = route.departure_time.toDate();

        String formattedArrivalTime =
            DateFormat('HH:mm:ss').format(arrivalTime);
        String formattedDepartureTime =
            DateFormat('HH:mm:ss').format(departureTime);
    
      final tickets = departure.bus_id.ticketId.map((ticket) => numberFormat.format(ticket.price)).toList();

        combinedData.add([
          departure.bus_id.carnamber.toString(),
          departure.route_id.departure_station_id.id.toString(),
          formattedDepartureTime,
          departure.route_id.arrival_station_id.id.toString(),
          formattedArrivalTime,
          tickets,
        ]);
      }

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
                          'ສະມາຄົມຂົນສົ່ງແຂວງຫຼວງພະບາງ ',
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
                        'ທະບຽນລົດ',
                        'ຕົ້ນທາງ',
                        'ເວລາອອກ',
                        'ປາຍທາງ',
                        'ເວລາຮອດ',
                        'ລາຄາ',
                      ],
                      data: combinedData,
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
