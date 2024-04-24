import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/app/model/payment_model.dart';
import 'package:flutter_admin/app/service/payment_service.dart';
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

    try {
      // Create an instance of DatabaseService
      DatabaseService databaseService = DatabaseService();

      // Fetch bus data using DatabaseService
      final List<Payment> payment = await databaseService.getPayment().first;

      // Convert logo image
      Uint8List logoData = (await rootBundle.load('assets/images/logo.png'))
          .buffer
          .asUint8List();

      List<List<dynamic>> paymentData = payment.map((payment) {
        final payment_date =
            DateFormat('dd/MM/yyy HH:mm:ss').format(payment.pay_date.toDate());
        final total = numberFormat.format(payment.total);
        final busNames = payment.booking_id
            .map((bus) => bus.departure_id.bus_id.name)
            .toList();
        final busid = payment.booking_id
            .map((bus) => bus.departure_id.bus_id.carnamber)
            .toList();

        final ticketid =
            payment.booking_id.map((bus) => bus.ticket_id.name).toList();
        final ticketname =
            payment.booking_id.map((bus) => bus.ticket_id.price).toList();

        final departure_station_id = payment.booking_id
            .map((bus) => bus.departure_id.route_id.departure_station_id.id)
            .toList();
        final arrival_station_id = payment.booking_id
            .map((bus) => bus.departure_id.route_id.arrival_station_id.id)
            .toList();

        final passname =
            payment.booking_id.map((pass) => pass.passenger_id.name).toList();
        final passid = payment.booking_id
            .map((pass) => pass.passenger_id.phoneNumber)
            .toList();
        List<dynamic> combinedBusData = [];
        combinedBusData.addAll(busNames);
        combinedBusData.addAll(busid);
        List<dynamic> comnbiedData = [];
        comnbiedData.addAll(ticketid);
        comnbiedData.addAll(ticketname);
        List<dynamic> routeData = [];
        routeData.addAll(departure_station_id);
        routeData.addAll(arrival_station_id);
        List<dynamic> Pass = [];
        Pass.addAll(passname);
        Pass.addAll(passid);

        return [
          combinedBusData,
          comnbiedData,
          routeData,
          payment_date,
          Pass,
          total
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
                          ' ລາຍງານຂໍ້ມູນການຊໍາລະ',
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
                            'ລະຫັດລົດ',
                            'ລາຄາແພັກແກັດ',
                            'ລະຫັດອອກເດີນທາງ',
                            'ເວລາຊໍາລະ',
                            'ຜູ້ຊໍາລະ',
                            'ລວມເງີນ',
                          ],
                          data: paymentData),
                    ),
                ],
              ),
            );
          },
        ),
      );
    } catch (e) {
      print('Error generating document: $e');
      // Handle error
    }

    return doc.save();
  }
}
