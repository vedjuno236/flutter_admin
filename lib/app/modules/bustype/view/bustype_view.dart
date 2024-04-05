import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/modules/bustype/view/report_bustype.dart';
import 'package:flutter_admin/app/service/bustype_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../model/bustype_model.dart';
// Import path_provider package

class BustypeView extends StatefulWidget {
  const BustypeView({Key? key}) : super(key: key);

  @override
  _BustypeViewState createState() => _BustypeViewState();
}

class _BustypeViewState extends State<BustypeView> {
  final DatabaseService _databaseService = DatabaseService();

  final TextEditingController textnameController = TextEditingController();

  var _searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຈັດການຂໍ້ມູນປະເພດລົດ',
            style: GoogleFonts.notoSansLao(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
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
                      addBusTypeDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                      onPrimary: Colors.white, // Text color
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ເພີ່ມ',
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
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final DocumentSnapshot<Map<String, dynamic>> snapshot =
                            await FirebaseFirestore.instance
                                .collection('BusType')
                                .doc('bustypeId')
                                .get();
                        final docId = snapshot.id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => reportt(docId: docId),
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
                          width: 10, // Adjust the width according to your needs
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
            const SizedBox(height: 10),
            Container(
              child: Expanded(
                child: StreamBuilder(
                  stream: _databaseService.getBustype(nameQuery: _searchQuery),
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
                    List bustype = snapshot.data?.docs ?? [];
                    if (bustype.isEmpty) {
                      return Center(
                        child: Text(
                          'ບໍ່ມີຂໍ້ມູນ.',
                          style: GoogleFonts.notoSansLao(fontSize: 15),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: bustype.length,
                      itemBuilder: (context, index) {
                        Bustype bustypeData = bustype[index].data();
                        String bustypeId = bustype[index].id;
                        return Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ລະຫັດ: $bustypeId',
                                  style: GoogleFonts.notoSansLao(fontSize: 15),
                                ),
                                const SizedBox(height: 9),
                                Text(
                                  'ຊື່: ${bustypeData.name}',
                                  style: GoogleFonts.notoSansLao(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      textnameController.text =
                                          bustypeData.name;
                                      EditeDialog(
                                          context, bustypeId, bustypeData);
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
                                              .ddeleteBustype(bustypeId);
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
                  },
                ),
              ),
            )
          ]),
        ));
  }

  Future addBusTypeDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'ຂໍ້ມູນປະເພດລົດ',
            style: GoogleFonts.notoSansLao(
              fontSize: 15,
              color: Colors.black26,
            ),
          ),
          content: TextField(
            controller: textnameController,
            decoration: InputDecoration(
              hintText: 'ປ້ອນຂໍ້ມູນປະເພດລົດ',
              hintStyle: GoogleFonts.notoSansLao(),
              prefixIcon: IconButton(
                icon: const Icon(Icons.car_crash),
                onPressed: () {},
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Bustype bustype = Bustype(name: textnameController.text);
                _databaseService.addBustype(bustype);

                Navigator.pop(context);
                textnameController.clear();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Set your desired background color
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ບັນທືກ',
                    style: GoogleFonts.notoSansLao(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10, // Adjust the width according to your needs
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
      );
  Future EditeDialog(BuildContext context, String bustypeId, Bustype bustype) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
              'ແກ້ໄຂຂໍ້ມູນປະເພດລົດ',
              style: GoogleFonts.notoSansLao(
                fontSize: 15,
                color: Colors.black26,
              ),
            ),
            content: TextField(
              controller: textnameController,
              decoration: InputDecoration(
                hintText: 'ປ້ອນຂໍ້ມູນປະເພດລົດກ່ອນ ',
                hintStyle: GoogleFonts.notoSansLao(),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.car_crash),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Bustype updateBustype = bustype.copyWith(
                    name: textnameController.text,
                  );
                  _databaseService.updateBustype(bustypeId, updateBustype);

                  Navigator.pop(context);
                  textnameController.clear();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.redAccent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ແກ້ໄຂ',
                      style: GoogleFonts.notoSansLao(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.edit,
                      size: 24.0,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ]),
      );
}
