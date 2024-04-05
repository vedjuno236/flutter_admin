import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/stations_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_admin/app/modules/stations/view/report_station.dart';

import '../../../service/stations_service.dart';

class StationView extends StatefulWidget {
  const StationView({Key? key}) : super(key: key);

  @override
  _StationViewState createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {
  final TextEditingController textnameController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();
  var _searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຈັດການຂໍ້ມູນສະຖານີ',
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
                        addStationsDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Background color
                        onPrimary: Colors.white, // Text color
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ເພີ່ມຂໍ້ມູນສະຖານີ',
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
                            builder: (context) => reportt_station(docId: docId),
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
                  stream: _databaseService.getStations(nameQuery: _searchQuery),
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
                    List stations = snapshot.data?.docs ?? [];
                    if (stations.isEmpty) {
                      return Center(
                        child: Text(
                          'ບໍ່ມີຂໍ້ມູນ.',
                          style: GoogleFonts.notoSansLao(fontSize: 15),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (context, index) {
                        Stations stationsData = stations[index].data();
                        String stationsId = stations[index].id;
                        return Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ລະຫັດ: $stationsId',
                                  style: GoogleFonts.notoSansLao(fontSize: 15),
                                ),
                                SizedBox(height: 9),
                                Text(
                                  'ຊື່: ${stationsData.name}',
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
                                          stationsData.name;
                                      EditeStationsDialog(
                                          context, stationsId, stationsData);
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
                                              .deleteStation(stationsId);
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
              ))
            ],
          ),
        ));
  }

  String generateUniqueId() {
    // Generate a unique ID using a combination of timestamp and random number.
    // You can adjust this logic based on your specific requirements.
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random =
        Random().nextInt(10000); // Adjust 10000 according to your needs
    return '$timestamp-$random';
  }

  Future addStationsDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'ຂໍ້ມູນສະຖານີ',
            style: GoogleFonts.notoSansLao(
              fontSize: 15,
              color: Colors.black26,
            ),
          ),
          content: TextField(
            controller: textnameController,
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
              onPressed: () {
                // Assuming you have a separate ID for the station
                String stationId =
                    generateUniqueId(); // You need to implement `generateUniqueId()`.

                Stations stations =
                    Stations(id: stationId, name: textnameController.text);
                _databaseService.addStation(stations);

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

  Future EditeStationsDialog(
          BuildContext context, String stationsId, Stations stations) =>
      showDialog(
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
            controller: textnameController,
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
              onPressed: () {
                Stations updateStations = stations.copyWith(
                  name: textnameController.text,
                );
                _databaseService.updateStations(stationsId, updateStations);
                Navigator.pop(context);
                textnameController.clear();
              },
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
