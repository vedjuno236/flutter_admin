import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_admin/app/modules/tickets/view/report_ticket.dart';

import '../../../service/tickets_service.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({Key? key}) : super(key: key);

  @override
  _TicketsViewState createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  final DatabaseService _databaseService = DatabaseService();
  var _searchQuery = "";
  final TextEditingController textnameController = TextEditingController();
  final TextEditingController textbooking_priceController =
      TextEditingController();
  final TextEditingController textbookingpriceController =
      TextEditingController();

  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'lo_LA', symbol: '₭');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຈັດການຂໍ້ມູນແພັກແກັດ',
            style: GoogleFonts.notoSansLao(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
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
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
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
                      onPressed: () {
                        addTicketsDialog();
                      },
                       style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                      onPrimary: Colors.white, // Text color
                    ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ເພີ່ມຂໍ້ມູນ',
                            style: GoogleFonts.notoSansLao(),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.add,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6),
                    ElevatedButton(
                       onPressed: () async {
                      try {
                        final DocumentSnapshot<Map<String, dynamic>> snapshot =
                            await FirebaseFirestore.instance
                                .collection('Stations')
                                .doc('stationsId')
                                .get();
                        final docId = snapshot.id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => report_ticket(docId: docId),
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
                  child: StreamBuilder(
                    stream:
                        _databaseService.getTickets(nameQuery: _searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      List tickets = snapshot.data?.docs ?? [];
                      if (tickets.isEmpty) {
                        return Center(
                          child: Text(
                            'ບໍ່ມີຂໍ້ມູນ.',
                            style: GoogleFonts.notoSansLao(fontSize: 15),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          Tickets ticketsData = tickets[index].data();
                          String ticketsId = tickets[index].id;
                          return Card(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ລະຫັດ: $ticketsId',
                                    style:
                                        GoogleFonts.notoSansLao(fontSize: 15),
                                  ),
                                  SizedBox(height: 9),
                                  Text(
                                    'ຊື່: ${ticketsData.name}',
                                    style: GoogleFonts.notoSansLao(
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    'ລາຄາຈອງ: ${numberFormat.format(ticketsData.booking_price)}',
                                    style: GoogleFonts.notoSansLao(
                                      fontSize: 17,
                                   
                                    ),
                                  ),
                                  Text(
                                    'ລາຄາແພັກເກັດ: ${numberFormat.format(ticketsData.price)}',
                                    style: GoogleFonts.notoSansLao(
                                      fontSize: 17,
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
                                      onTap: () async {
                                        Navigator.pop(context);
                                        textnameController.text =
                                            ticketsData.name;
                                        textbooking_priceController.text =
                                            ticketsData.booking_price
                                                .toString();
                                        textbookingpriceController.text =
                                            ticketsData.price.toString();

                                        EditeDialog(
                                            context, ticketsId, ticketsData);
                                      },
                                      leading: const Icon(
                                        Icons.edit,
                                        color: Colors.orangeAccent,
                                      ),
                                      title: Text(
                                        'ແກ້ໄຂ',
                                        style: GoogleFonts.notoSansLao(),
                                      ),
                                    ),
                                  ),
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
                                              'ຕ້ອງການລົບແມ່ນບໍ່?',
                                              style: GoogleFonts.notoSansLao(
                                                  fontSize: 15),
                                            ),
                                          ),
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            _databaseService
                                                .deleteTickets(ticketsId);
                                          },
                                        ).show();
                                      },
                                      leading: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      title: Text(
                                        'Delete',
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
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future addTicketsDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding:
                EdgeInsets.zero, // No padding to let Container control the size
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 350,
                  width: 350,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'ຂໍ້ມູນແພັກແກັດ',
                          style: GoogleFonts.notoSansLao(
                            fontSize: 19,
                            color: Colors.black26,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            TextField(
                              controller: textnameController,
                              decoration: InputDecoration(
                                hintText: 'ປ້ອນຂໍ້ມູນແພັກແກັດ',
                                hintStyle: GoogleFonts.notoSansLao(),
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.payment),
                                  onPressed: () {},
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: textbooking_priceController,
                              decoration: InputDecoration(
                                hintText: 'ປ້ອນຂໍ້ມູນລາຄາຈອງ',
                                hintStyle: GoogleFonts.notoSansLao(),
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.book_outlined),
                                  onPressed: () {},
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: textbookingpriceController,
                              decoration: InputDecoration(
                                hintText: 'ປ້ອນຂໍ້ມູນລາຄາ',
                                hintStyle: GoogleFonts.notoSansLao(),
                                prefixIcon: IconButton(
                                  icon: Icon(Icons.price_change),
                                  onPressed: () {},
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'ອອກ',
                                        style: GoogleFonts.notoSansLao(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.outbond,
                                        size: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Tickets tickets = Tickets(
                                      name: textnameController.text,
                                      booking_price: int.parse(
                                          textbooking_priceController.text),
                                      price: int.parse(
                                          textbookingpriceController.text),
                                    );

                                    _databaseService.addTickets(tickets);

                                    Navigator.pop(context);

                                    textnameController.clear();
                                    textbooking_priceController.clear();
                                    textbookingpriceController.clear();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'ບັນທືກ',
                                        style: GoogleFonts.notoSansLao(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.save, size: 24.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ));

  Future EditeDialog(BuildContext context, String ticketsId, Tickets tickets) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                contentPadding: EdgeInsets
                    .zero, // No padding to let Container control the size
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 350,
                      width: 350, // Set your desired height here
                      // Take the maximum width available
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'ຂໍ້ມູນແພັກແກັດ',
                              style: GoogleFonts.notoSansLao(
                                fontSize: 19,
                                color: Colors.black26,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Column(
                              children: [
                                TextField(
                                  controller: textnameController,
                                  decoration: InputDecoration(
                                    hintText: 'ປ້ອນຂໍ້ມູນແພັກແກັດ',
                                    hintStyle: GoogleFonts.notoSansLao(),
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.payment),
                                      onPressed: () {},
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                TextField(
                                  controller: textbooking_priceController,
                                  decoration: InputDecoration(
                                    hintText: 'ປ້ອນຂໍ້ມູນລາຄາຈອງ',
                                    hintStyle: GoogleFonts.notoSansLao(),
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.book_outlined),
                                      onPressed: () {},
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                TextField(
                                  controller: textbookingpriceController,
                                  decoration: InputDecoration(
                                    hintText: 'ປ້ອນຂໍ້ມູນລາຄາ',
                                    hintStyle: GoogleFonts.notoSansLao(),
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.price_change),
                                      onPressed: () {},
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'ອອກ',
                                            style: GoogleFonts.notoSansLao(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.outbond,
                                            size: 24.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Tickets updateTickets =
                                            tickets.copyWith(
                                          name: textnameController.text,
                                          booking_price: int.parse(
                                              textbooking_priceController.text),
                                          price: int.parse(
                                              textbookingpriceController.text),
                                        );
                                        _databaseService.updateTickets(
                                            ticketsId, updateTickets);

                                        Navigator.pop(context);

                                        textnameController.clear();
                                        textbooking_priceController.clear();
                                        textbookingpriceController.clear();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'ແກ້ໄຂ',
                                            style: GoogleFonts.notoSansLao(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.edit,
                                            size: 24.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              ));
}
