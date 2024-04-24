import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/payment_model.dart';
import 'package:flutter_admin/app/modules/payment/view/report_payment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

import '../../../service/payment_service.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final DatabaseService _databaseService = DatabaseService();
  var _searchQuery = "";
  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'lo_LA', symbol: '₭');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຂໍ້ມູນການຊໍາລະ',
            style: GoogleFonts.notoSansLao(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                width: double.infinity,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ຄົ້ນຫາ..',
                    hintStyle: GoogleFonts.notoSansLao(),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final DocumentSnapshot<Map<String, dynamic>>
                              snapshot = await FirebaseFirestore.instance
                                  .collection('Payment')
                                  .doc('paymentId')
                                  .get();
                          final docId = snapshot.id;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  report_payment(docId: docId),
                            ),
                          );
                        } catch (e) {
                          print('Error fetching document: $e');
                          // Handle error appropriately
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent, // Background color
                        onPrimary: Colors.white, // Text color
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ລາຍງານ',
                            style: GoogleFonts.notoSansLao(),
                          ),
                          const SizedBox(
                            width:
                                10, // Adjust the width according to your needs
                          ),
                          const Icon(
                            Icons.read_more_sharp,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                  child: Expanded(
                      child: StreamBuilder<List<Payment>>(
                          stream: _databaseService.getPayment(
                              nameQuery: _searchQuery),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: Text('No payment found.'));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final paymentData = snapshot.data![index];

                                  String paymentId = paymentData.id;
                                  return Card(
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                         
                                          Text(
                                            'ລະຫັດການຈອງ: ',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                         Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: paymentData.booking_id
                                                .map((booking) {
                                              final busid =
                                                  booking.departure_id.bus_id.name;

                                              final carbus =
                                               booking .departure_id.bus_id.carnamber;
                                              
                                              return Text(
                                                '  $busid : $carbus',
                                                style: GoogleFonts.notoSans(
                                                    fontSize: 16),
                                              );
                                            }).toList(),
                                          ),
                                          Divider(),
                                           Text(
                                            'ລະຫັດແພັກແກັດ: ',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                        
                                         Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: paymentData.booking_id
                                                .map((booking) {
                                              final ticketid =
                                                  booking.ticket_id.name;

                                              final ticketname =
                                               booking .ticket_id.price;
                                              
                                              return Text(
                                                '  $ticketid : $ticketname',
                                                style: GoogleFonts.notoSans(
                                                    fontSize: 16),
                                              );
                                            }).toList(),
                                          ),

                                          Divider(),
                                            Text(
                                            'ລະຫັດເດີນທາງ: ',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: paymentData.booking_id
                                                .map((booking) {
                                              final departureId =
                                                  booking.departure_id.route_id.departure_station_id.id;

                                              final arrivalId =
                                               booking .departure_id.route_id  .arrival_station_id .id;
                                              print(
                                                  'ຕົ້ນທາງ: $departureId, ປາຍທາງ: $arrivalId');
                                              return Text(
                                                ' ຕົ້ນທາງ:  $departureId ->ປາຍທາງ: $arrivalId',
                                                style: GoogleFonts.notoSans(
                                                    fontSize: 16),
                                              );
                                            }).toList(),
                                          ),
                                          Text(
                                            'ຄໍາອະທຶບາຍ: ${paymentData.description}',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                           Divider(),
                                          Text(
                                            'ເວລາການຊໍາລະ: ${DateFormat("dd-MM-yyyy h:mm a").format(paymentData.pay_date.toDate())}',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                             Divider(),
                                          Text(
                                            'ຊໍາລະດ້ວຍ: ${paymentData.payment_method}',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                             Divider(),
                                          Text(
                                            'ເງີນລວມ: ${numberFormat.format(paymentData.total)}',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                             Divider(),
                                          Text(
                                            'ລະຫັດຜູ້ຊໍາລະ ${paymentData.user_id}',
                                            style: GoogleFonts.notoSansLao(
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                        icon: Icon(Icons.more_vert),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 1,
                                            child: ListTile(
                                              onTap: () {
                                                AwesomeDialog(
                                                  context: context,
                                                  animType: AnimType.scale,
                                                  dialogType: DialogType.info,
                                                  body: Center(
                                                    child: Text(
                                                      'Are you sure you want to delete?',
                                                      style: GoogleFonts
                                                          .notoSansLao(
                                                              fontSize: 15),
                                                    ),
                                                  ),
                                                  btnCancelOnPress: () {},
                                                  btnOkOnPress: () {},
                                                ).show();
                                              },
                                              leading: const Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              title: Text(
                                                'Delete',
                                                style:
                                                    GoogleFonts.notoSansLao(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          })))
            ])));
  }

  Future EditeDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'ແກ້ໄຂຂໍ້ມູນສະຖານີ',
            style: GoogleFonts.notoSansLao(
              fontSize: 15,
              color: Colors.black26,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'ປ້ອນຂໍ້ມູນສະຖານີ',
              hintStyle: GoogleFonts.notoSansLao(),
              prefixIcon: IconButton(
                icon: Icon(Icons.car_crash),
                onPressed: () {},
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.redAccent), // Set your desired background color
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ແກ້ໄຂ',
                    style: GoogleFonts.notoSansLao(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10, // Adjust the width according to your needs
                  ),
                  const Icon(
                    Icons.edit,
                    size: 24.0,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
