import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/booking_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_admin/app/modules/booking/view/report_booking.dart';

import '../../../service/booking_service.dart';
import '../../../service/routes_service.dart' as routes;

class BookingView extends StatefulWidget {
  const BookingView({Key? key}) : super(key: key);

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final DatabaseService _databaseService = DatabaseService();

  final routes.DatabaseService _databaseRoutesService =
      routes.DatabaseService();
  var _searchQuery = "";
  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'lo_LA', symbol: '₭');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຂໍ້ມູນການຈອງ',
            style: GoogleFonts.notoSansLao(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                                  .collection('Departures')
                                  .doc('departuresId')
                                  .get();
                          final docId = snapshot.id;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  report_booking(docId: docId),
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
                  child: StreamBuilder<List<Booking>>(
                      stream:
                          _databaseService.getBooking(nameQuery: _searchQuery),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No booking found.'));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final bookingData = snapshot.data![index];

                              String bookingId = bookingData.id;

                    
                              return Card(
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ລະຫັດ: $bookingId',
                                        style: GoogleFonts.notoSansLao(
                                            fontSize: 15),
                                      ),
                                      SizedBox(height: 9),
                                      Text(
                                        'ເວລາຈອງ: ${DateFormat("dd-MM-yyyy h:mm a").format(bookingData.book_date.toDate())}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'ລະຫັດລົດ:${bookingData.departure_id.bus_id.carnamber} ',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                       Text(
                                        'ເສັ້ນທາງ:${bookingData.departure_id.route_id.departure_station_id.id} -> ${bookingData.departure_id.route_id.arrival_station_id.id}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      
                                     
                                      Text(
                                        'ເວລາໝົດກໍານົດຂອງປີ້: ${DateFormat("dd-MM-yyyy h:mm a").format(bookingData.expired_time.toDate())}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'ລະຫັດຜູ້ໂດຍສານ: ${bookingData.passenger_id.name}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'ໝາຍເລກບ່ອນນັ່ງ: ${bookingData.seat}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'ສະຖານະ: ${bookingData.status}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'ລະຫັດອແພັກເກັດ: ${bookingData.ticket_id.name} ${numberFormat.format(bookingData.ticket_id.price)}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'ເວລາການຈອງ: ${DateFormat("dd-MM-yyyy h:mm a").format(bookingData.time.toDate())}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'ລະຫັດຜູ້ໃຊ້:  ${bookingData.passenger_id.phoneNumber}',
                                        style: GoogleFonts.notoSansLao(
                                          fontSize: 16,
                                        ),
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
                                            Navigator.pop(context);
                                            AwesomeDialog(
                                              context: context,
                                              animType: AnimType.scale,
                                              dialogType: DialogType.info,
                                              body: Center(
                                                child: Text(
                                                  'ທ່ານຕ້ອງການລົບປີ້ແມ່ນບໍ່?',
                                                  style:
                                                      GoogleFonts.notoSansLao(
                                                          fontSize: 15),
                                                ),
                                              ),
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {
                                                // _databaseService
                                                //     .deletelBooking(bookingId);
                                              },
                                            ).show();
                                          },
                                          leading: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          title: Text(
                                            'ລົບ',
                                            style: GoogleFonts.notoSansLao(),
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
                      }),
                ),
              )
            ],
          ),
        ));
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
