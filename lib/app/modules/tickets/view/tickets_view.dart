import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../service/tickets_service.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({Key? key}) : super(key: key);

  @override
  _TicketsViewState createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  final DatabaseService _databaseService = DatabaseService();
  var _searchQuery = "";
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
                        openDialog();
                      },
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
                      onPressed: () {},
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
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'ລາຄາຈອງ: ${ticketsData.booking_price}',
                                    style: GoogleFonts.notoSansLao(
                                      fontSize: 17,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text(
                                    'ລາຄາແພັກເກັດ: ${ticketsData.price}',
                                    style: GoogleFonts.notoSansLao(
                                      fontSize: 17,
                                      color: Colors.orangeAccent,
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
                                        EditeDialog();
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
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.scale,
                                          dialogType: DialogType.info,
                                          body: Center(
                                            child: Text(
                                              'Are you sure you want to delete?',
                                              style: GoogleFonts.notoSansLao(
                                                  fontSize: 15),
                                            ),
                                          ),
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {},
                                        )..show();
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

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding:
                EdgeInsets.zero, // No padding to let Container control the size
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
                                  onPressed: () {},
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
                                  onPressed: () {},
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.save,
                                        size: 24.0,
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

  Future EditeDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding:
                EdgeInsets.zero, // No padding to let Container control the size
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
                                  onPressed: () {},
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
                                  onPressed: () {},
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
