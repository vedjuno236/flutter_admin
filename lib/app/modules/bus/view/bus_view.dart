import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/bus_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_admin/app/modules/bus/view/report_buses.dart';

import '../../../model/bustype_model.dart';
import '../../../model/tickets_model.dart';
import '../../../service/buses_service.dart';

class BusView extends StatefulWidget {
  const BusView({Key? key}) : super(key: key);

  @override
  _BusViewState createState() => _BusViewState();
}

class _BusViewState extends State<BusView> {
  List<String> _busItems = [];
  // String? selectedValue;
  String? _selectedBustype;
  String? _selectedTicket;

  final DatabaseService _databaseService = DatabaseService();
  var _searchQuery = "";

  final oCcy = NumberFormat("#,##0", "en_US");
  final TextEditingController textnameController = TextEditingController();

  final TextEditingController textcarnamberController = TextEditingController();
  final TextEditingController textcapacityController = TextEditingController();
  final TextEditingController textcapacityvipController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDropdownItemsbuses();
  }

  void fetchDropdownItemsbuses() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('BusType').get();

    List<String> items = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຈັດການຂໍ້ມູນລົດ',
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
                        busDialog();
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
                            builder: (context) => report_buses(docId: docId),
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
                            width: 10,
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
                      child: StreamBuilder<List<Buses>>(
                          stream: _databaseService.getBuses(
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
                              return Center(child: Text('No buses found.'));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final busData = snapshot.data![index];

                                  String busId = busData.id;
                                  return Card(
                                      child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ລະຫັດລົດ: $busId',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ຊື່: ${busData.name}',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ປະເພດລົດ: ${busData.bustypeName}', // Accessing bustypeName property
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ທະບຽນລົດ: ${busData.carnamber}', // Accessing bustypeName property
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ຈໍານວນບ່ອນນັ່ງ: ${busData.capacity}',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ຈໍານວນບ່ອນນັ່ງ VIP: ${busData.capacityVip}',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ປະເພດແພັກແກັດ:',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              busData.ticketId.map((ticket) {
                                            return Text(
                                              '  ${ticket.name}', // Assuming ticket has a name property
                                              style: GoogleFonts.notoSans(
                                                  fontSize: 16),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 8),
                                        Divider(),
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
                                              Navigator.pop(context);
                                              AwesomeDialog(
                                                context: context,
                                                animType: AnimType.scale,
                                                dialogType: DialogType.info,
                                                body: Center(
                                                  child: Text(
                                                    'ທ່ານຕ້ອງການລົບຂໍ້ມູນແມ່ນບໍ່?',
                                                    style:
                                                        GoogleFonts.notoSansLao(
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
                                  ));
                                },
                              );
                            }
                          })))
            ])));
  }

  Future<void> busDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 550,
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
                    SizedBox(height: 20),
                    Column(
                      children: [
                        TextField(
                          controller: textnameController,
                          decoration: InputDecoration(
                            hintText: 'ປ້ອນຂໍ້ມູນລົດ',
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
                        SizedBox(height: 10),
                        TextField(
                          controller: textcapacityController,
                          decoration: InputDecoration(
                            hintText: 'ຈໍານວນບ່ອນນັ່ງລົດທໍາມະດາ',
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
                        SizedBox(height: 10),
                        TextField(
                          controller: textcapacityvipController,
                          decoration: InputDecoration(
                            hintText: 'ຈໍານວນບ່ອນນັ່ງລົດvip',
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
                        SizedBox(height: 10),
                        TextField(
                          controller: textcarnamberController,
                          decoration: InputDecoration(
                            hintText: 'ທະບຽນລົດ',
                            hintStyle: GoogleFonts.notoSansLao(),
                            prefixIcon: IconButton(
                              icon: Icon(Icons.near_me_disabled_rounded),
                              onPressed: () {},
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("BusType")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    "Some error occurred ${snapshot.error}"),
                              );
                            }
                            List<DropdownMenuItem<String>> programItems = [];
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
                                      child: Text(program['name']),
                                    ),
                                  );
                                }
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  hint: Row(
                                    children: [
                                      Icon(Icons.car_crash),
                                      SizedBox(width: 5),
                                      Text(
                                        'ເລືອກປະເພດລົດ',
                                        style: GoogleFonts.notoSansLao(),
                                      ),
                                    ],
                                  ),
                                  items: programItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedBustype = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'ກະລຸນາເລືອກປະເພດລົດກ່ອນ.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _selectedBustype = value;
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Tickets")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    "Some error occurred ${snapshot.error}"),
                              );
                            }
                            List<DropdownMenuItem<String>> programItems = [];
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
                                      child: Text(oCcy
                                          .format(program['price'])
                                          .toString()),
                                    ),
                                  );
                                }
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  hint: Row(
                                    children: [
                                      Icon(Icons.airplane_ticket),
                                      SizedBox(width: 5),
                                      Text(
                                        'ເລືອກປະເພດແພັກແກັດ',
                                        style: GoogleFonts.notoSansLao(),
                                      ),
                                    ],
                                  ),
                                  items: programItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTicket = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'ກະລຸນາເລືອກປະເພດແພັກແກັດກ່ອນ.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _selectedTicket = value;
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

                              onPressed: () {
                                try {
                                  if (_selectedBustype == null ||
                                      _selectedTicket == null) {
                                    throw Exception(
                                        "Please select values for bustype and ticket.");
                                  }
                                  int? capacity;
                                  int? capacityVip;
                                  // Parsing capacity
                                  if (textcapacityController.text
                                      .trim()
                                      .isNotEmpty) {
                                    capacity = int.tryParse(
                                        textcapacityController.text.trim());
                                    if (capacity == null) {
                                      throw Exception(
                                          "Capacity must be a valid integer.");
                                    }
                                  }
                                  // Parsing capacityVip
                                  if (textcapacityvipController.text
                                      .trim()
                                      .isNotEmpty) {
                                    capacityVip = int.tryParse(
                                        textcapacityvipController.text.trim());
                                    if (capacityVip == null) {
                                      throw Exception(
                                          "VIP Capacity must be a valid integer.");
                                    }
                                  }
                                  _databaseService.addBuses({
                                    "bus_type_id": _selectedBustype,
                                    "name": textnameController.text,
                                    "capacity":
                                        capacity, // Store capacity as a number
                                    "capacity_vip":
                                        capacityVip, // Store capacityVip as a number
                                    "carnamber": textcarnamberController.text,
                                    "ticket_id": [
                                      _selectedTicket
                                    ] // Assuming ticketId is a List<String>
                                  });
                                  Navigator.pop(context);
                                  textnameController.clear();
                                  textcapacityController.clear();
                                  textcapacityvipController.clear();
                                  textcarnamberController.clear();
                                } catch (e) {
                                  print('Error: $e');
                                  // Handle the exception here
                                }
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
      ),
    );
  }

  Future EditeDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding:
              EdgeInsets.zero, // No padding to let Container control the size
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 550,
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
                    SizedBox(height: 20),
                    Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'ປ້ອນຂໍ້ມູນລົດ',
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
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'ຈໍານວນບ່ອນນັ່ງລົດທໍາມະດາ',
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
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'ຈໍານວນບ່ອນນັ່ງລົດvip',
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
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'ທະບຽນລົດ',
                            hintStyle: GoogleFonts.notoSansLao(),
                            prefixIcon: IconButton(
                              icon: Icon(Icons.near_me_disabled_rounded),
                              onPressed: () {},
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
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
                              Icon(Icons.car_crash),
                              SizedBox(width: 5),
                              Text(
                                'ເລືອກປະເພດລົດ',
                                style: GoogleFonts.notoSansLao(),
                              ),
                            ],
                          ),
                          items: _busItems
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
                              _selectedBustype = value;
                            });
                          },
                          onSaved: (value) {
                            _selectedBustype = value;
                          },
                        ),
                        SizedBox(height: 10),
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
                              Icon(Icons.airplane_ticket),
                              SizedBox(width: 5),
                              Text(
                                'ເລືອກປະເພດແພັກແກັດ',
                                style: GoogleFonts.notoSansLao(),
                              ),
                            ],
                          ),
                          items: _busItems
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
                              _selectedTicket = value;
                            });
                          },
                          onSaved: (value) {
                            _selectedTicket = value;
                          },
                        )
                      ],
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
