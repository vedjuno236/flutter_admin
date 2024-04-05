import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/departures_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import '../../../model/bus_model.dart';
import '../../../model/routes_model.dart';
import '../../../model/stations_model.dart';
import '../../../model/tickets_model.dart';
import '../../../service/departures_servide.dart';
import '../../../service/routes_service.dart' as routes;
import 'package:rxdart/rxdart.dart';

import 'package:flutter_admin/app/modules/departures/view/report_departures.dart';

class DepartureView extends StatefulWidget {
  const DepartureView({Key? key}) : super(key: key);

  @override
  _DepartureViewState createState() => _DepartureViewState();
}

class _DepartureViewState extends State<DepartureView> {
  final DatabaseService _databaseService = DatabaseService();
  final routes.DatabaseService _databaseRoutesService =
      routes.DatabaseService();

  NumberFormat numberFormat =
      NumberFormat.currency(locale: 'lo_LA', symbol: '₭');

      
  var _searchQuery = "";
  @override
  final List<String> busItems = [];
  String? _selectedValueBuses;
  String? _selectedValueRoutes;

  final oCcy = NumberFormat("#,##0", "en_US");
  final TextEditingController textbustypeController = TextEditingController();
  final TextEditingController textroutesController = TextEditingController();

  final List<Routes> routesList = [];

  // Variable to hold the selected Route
  Routes? selectedRoute;
  DateFormat dateFormat = DateFormat("HH:mm");
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ຈັດການຂໍ້ມູນອອກເດີນທາງຂອງລົດ',
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
                      openDialog(context);
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
                                .collection('Departures')
                                .doc('departuresId')
                                .get();
                        final docId = snapshot.id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                report_departures(docId: docId),
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
                    stream: CombineLatestStream.combine2(
                      _databaseService.getDepartures(nameQuery: _searchQuery),
                      _databaseRoutesService.getRoutes(nameQuery: _searchQuery),
                      (departures, routes) =>
                          {'departures': departures, 'routes': routes},
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('No data found.'));
                      } else {
                        final Map<String, dynamic> data =
                            snapshot.data as Map<String, dynamic>;
                        final List<dynamic> departuresList = data['departures'];
                        final List<dynamic> routesList = data['routes'];

                        return ListView.builder(
                          itemCount: departuresList.length,
                          itemBuilder: (context, index) {
                            final departuresData = departuresList[index];
                            final routesData = routesList[index];

                            String departuresId = departuresData.id;

                            String busName = departuresData.bus_id.carnamber;

                            String departureStationName =
                                departuresData.route_id.departure_station_id.id;
                            String arrivalStationName =
                                departuresData.route_id.arrival_station_id.id;
                            DateTime arrivalTime =
                                routesData.arrival_time.toDate();
                            DateTime departureTime =
                                routesData.departure_time.toDate();

                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ລະຫັດ: $departuresId',
                                      style:
                                          GoogleFonts.notoSansLao(fontSize: 15),
                                    ),
                                    const SizedBox(height: 9),
                                    Text(
                                      'ລະຫັດລົດ: $busName',
                                      style:
                                          GoogleFonts.notoSansLao(fontSize: 17),
                                    ),
                                    Text(
                                      'ສະຖານີຕົ້ນທາງ: $departureStationName',
                                      style:
                                          GoogleFonts.notoSansLao(fontSize: 17),
                                    ),
                                    Text(
                                      'ເວລາອອກ: ${DateFormat("HH:mm:ss").format(departureTime)}',
                                      style:
                                          GoogleFonts.notoSansLao(fontSize: 17),
                                    ),
                                    Text(
                                      'ສະຖານີປາຍທາງ: $arrivalStationName',
                                      style:
                                          GoogleFonts.notoSansLao(fontSize: 17),
                                    ),
                                    Text(
                                      'ເວລາອອກ: ${DateFormat(" HH:mm:ss").format(arrivalTime)}',
                                      style:
                                          GoogleFonts.notoSansLao(fontSize: 17),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: departuresData.bus_id.ticketId
                                          .map<Widget>((ticket) {
                                        print(
                                            ticket); 
                                        return Text(
                                          '  ລາຄາແພັກແກັດ:${numberFormat.format(  ticket.price)}', 
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
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
                                                'ທ່ານຕ້ອງການລົບບໍ່?',
                                                style: GoogleFonts.notoSansLao(
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
      ),
    );
  }

  Future openDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding:
                EdgeInsets.zero, // No padding to let Container control the size
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 300,
                  width: 600,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'ຂໍ້ມູນລົດ',
                          style: GoogleFonts.notoSansLao(
                            fontSize: 19,
                            color: Colors.black26,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("Buses")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        "Some error occurred ${snapshot.error}"),
                                  );
                                }
                                List<DropdownMenuItem<String>> programItems =
                                    [];
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                } else {
                                  final selectProgram =
                                      snapshot.data?.docs.reversed.toList();
                                  if (selectProgram != null) {
                                    for (var program in selectProgram) {
                                      programItems.add(
                                        DropdownMenuItem<String>(
                                          value: program.id,
                                          child: Text(program['carnamber']),
                                        ),
                                      );
                                    }
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      hint: Row(
                                        children: [
                                          const Icon(Icons.car_crash),
                                          const SizedBox(width: 5),
                                          Text(
                                            'ເລືອກລົດ',
                                            style: GoogleFonts.notoSansLao(),
                                          ),
                                        ],
                                      ),
                                      items: programItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValueBuses = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'ກະລຸນາເລືອກລົດກ່ອນ.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _selectedValueBuses = value;
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            StreamBuilder(
                              stream: _databaseRoutesService.getRoutes(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No departures found.'));
                                } else {
                                  List<DropdownMenuItem<String>> programItems =
                                      [];
                                  for (var routeData in snapshot.data!) {
                                    //
                                    String departureTimeString =
                                        dateFormat.format(
                                            routeData.departure_time.toDate());
                                    String arrivalTimeString =
                                        dateFormat.format(
                                            routeData.arrival_time.toDate());

                                    //
                                    programItems.add(
                                      DropdownMenuItem<String>(
                                        value: routeData.id,
                                        child: Text(
                                          "${routeData.departure_station_id.name}: $departureTimeString -> ${routeData.arrival_station_id.name} $arrivalTimeString",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      hint: Row(
                                        children: [
                                          const Icon(Icons.car_crash),
                                          const SizedBox(width: 5),
                                          Text(
                                            'ເລືອກເສັ້ນທາງ',
                                            style: GoogleFonts.notoSansLao(),
                                          ),
                                        ],
                                      ),
                                      items: programItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValueRoutes = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'ກະລຸນາເລືອກເສັ້ນທາງກ່ອນ.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _selectedValueRoutes = value;
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),
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
                                  onPressed: () async {
                                    if (_selectedValueBuses == null ||
                                        _selectedValueRoutes == null) {
                                      throw Exception(
                                          "Please select values for buses and routes.");
                                    }
                                    _databaseService.adddepartures({
                                      "bus_id": _selectedValueBuses,
                                      "route_id": _selectedValueRoutes
                                    });
                                    Navigator.pop(context);
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
              padding: EdgeInsets.all(20.0),
              child: Container(
                height: 300,
                width: 350, // Set your desired height here
                // Take the maximum width available
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ແກ້ໄຂຂໍ້ມູນລົດ',
                      style: GoogleFonts.notoSansLao(
                        fontSize: 19,
                        color: Colors.black26,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'ປ້ອນຂໍ້ມູນລົດ',
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
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          hint: Row(
                            children: [
                              const Icon(Icons.car_crash),
                              const SizedBox(width: 5),
                              Text(
                                'ເລືອກປະເພດລົດ',
                                style: GoogleFonts.notoSansLao(),
                              ),
                            ],
                          ),
                          items: busItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'ກະລຸນາເລືອກປະເພດລົດກ່ອນ.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedValueBuses = value;
                            });
                          },
                          onSaved: (value) {
                            _selectedValueBuses = value;
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
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
                                MaterialStateProperty.all<Color>(Colors.blue),
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
