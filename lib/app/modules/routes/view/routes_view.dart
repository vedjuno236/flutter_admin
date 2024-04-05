import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/routes_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import '../../../service/routes_service.dart';
import 'package:flutter_admin/app/modules/routes/view/report_routes.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({Key? key}) : super(key: key);

  @override
  _RoutesViewState createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  final List<String> busItems = [];

  String? _selectedarrival_station;
  String? _selecteddeparture_station;
  final DatabaseService _databaseService = DatabaseService();
  var _searchQuery = "";

  TextEditingController dateController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();
  TextEditingController stationController = TextEditingController();
  TextEditingController stationsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
    datetimeController.text = ""; // Corrected variable name
  }

  DateFormat format = DateFormat("dd/MM/yyyy HH:mm:ss");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ຈັດການຂໍ້ມູນອອກເສັ້ນທາງຂອງລົດ',
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
                      RouteDialog();
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
                  SizedBox(width: 6),
                  ElevatedButton(
                   onPressed: () async {
                      try {
                        final DocumentSnapshot<Map<String, dynamic>> snapshot =
                            await FirebaseFirestore.instance
                                .collection('Routes')
                                .doc('routesId')
                                .get();
                        final docId = snapshot.id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => report_routes(docId: docId),
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
            SizedBox(height: 10),
            Container(
              child: Expanded(
                child: StreamBuilder<List<Routes>>(
                    stream: _databaseService.getRoutes(nameQuery: _searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        // Check if data is null or empty
                        return Center(child: Text('No routes found.'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final routesData = snapshot.data![index];

                            String routesId = routesData.id;
                            String arrival = routesData.arrival_station_id.name;
                            String departure =
                                routesData.departure_station_id.name;
                            return Card(
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ລະຫັດ: $routesId',
                                      style:
                                          GoogleFonts.notoSansLao(fontSize: 15),
                                    ),
                                    SizedBox(height: 9),
                                    Text(
                                      'ລະຫັດຕົ້ນທາງ: $departure',
                                      style: GoogleFonts.notoSansLao(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      'ເວລາອອກ: ${DateFormat("dd-MM-yyyy h:mm a").format(routesData.departure_time.toDate())}',
                                      style: GoogleFonts.notoSansLao(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      'ລະຫັດປາຍທາງ: $arrival',
                                      style: GoogleFonts.notoSansLao(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      'ເວລາຮອດ: ${DateFormat("dd-MM-yyyy h:mm a").format(routesData.arrival_time.toDate())}',
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
      ),
    );
  }

  Future RouteDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 450,
                width: 600,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'ຂໍ້ມູນການອອກເດີນທາງຂອງລົດ',
                      style: GoogleFonts.notoSansLao(
                        fontSize: 19,
                        color: Colors.black26,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Stations")
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
                                        'ເລືອກສະຖານີຕົ້ນທາງ',
                                        style: GoogleFonts.notoSansLao(),
                                      ),
                                    ],
                                  ),
                                  items: programItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selecteddeparture_station = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'ກະລຸນາເລືອກສະຖານີຕົ້ນທາງກ່ອນ.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _selecteddeparture_station = value;
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: datetimeController,
                          decoration: InputDecoration(
                            hintText: 'ເລືອກເວລາອອກເດີນທາງ',
                            hintStyle: GoogleFonts.notoSansLao(),
                            prefixIcon: IconButton(
                              icon: const Icon(
                                Icons.date_range,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                  locale: Locale('th', 'TH'),
                                );
                                if (pickedDate != null) {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    pickedDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    String formattedDateTime = DateFormat(
                                            "dd/MM/yyyy HH:mm:ss", 'th')
                                        .format(pickedDate); // Use Thai locale
                                    setState(() {
                                      datetimeController.text =
                                          formattedDateTime;
                                    });
                                  }
                                } else {
                                  print("Not selected");
                                }
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Stations")
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
                                        'ເລືອກສະຖານີປາຍທາງ',
                                        style: GoogleFonts.notoSansLao(),
                                      ),
                                    ],
                                  ),
                                  items: programItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedarrival_station = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'ກະລຸນາເລືອກສະຖານີປາຍທາງກ່ອນ.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _selectedarrival_station = value;
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                            hintText: 'ເລືອກເວລາປາຍທາງ',
                            hintStyle: GoogleFonts.notoSansLao(),
                            prefixIcon: IconButton(
                              icon: const Icon(
                                Icons.date_range,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                  locale: Locale('th', 'TH'), // Set Thai locale
                                );
                                if (pickedDate != null) {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    pickedDate = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                    String formattedDateTime = DateFormat(
                                            "dd/MM/yyyy HH:mm:ss", 'th')
                                        .format(pickedDate); // Use Thai locale
                                    setState(() {
                                      dateController.text = formattedDateTime;
                                    });
                                  }
                                } else {
                                  print("Not selected");
                                }
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
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
                          onPressed: () {
                            // Convert station text inputs to Stations objects
                            if (_selectedarrival_station == null ||
                                _selecteddeparture_station == null) {
                              throw Exception("Please select values for");
                            }
                            DateTime arrivalDateTime =
                                format.parse(dateController.text);
                            DateTime departureDateTime =
                                format.parse(datetimeController.text);

// Convert DateTime objects to Timestamp objects
                            Timestamp arrivalTime =
                                Timestamp.fromDate(arrivalDateTime);
                            Timestamp departureTime =
                                Timestamp.fromDate(departureDateTime);

// Create Routes object with corrected parameters

                            // Call _databaseService.addRoutes with the corrected Routes object
                            _databaseService.addRoutes({
                              "arrival_station_id": _selectedarrival_station,
                              "arrival_time": arrivalDateTime,
                              "departure_station_id":
                                  _selecteddeparture_station,
                              "departure_time": departureTime,
                            });

                            // Close the current context
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
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
              ),
            ),
          ),
        ),
      );

  Future EditeDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding:
              EdgeInsets.zero, // No padding to let Container control the size
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                        SizedBox(height: 20),
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
                              _selectedarrival_station = value;
                            });
                          },
                          onSaved: (value) {
                            _selectedarrival_station = value;
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20),
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
