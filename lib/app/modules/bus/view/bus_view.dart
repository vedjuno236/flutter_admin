import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/bus_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../service/buses_service.dart';

class BusView extends StatefulWidget {
  const BusView({Key? key}) : super(key: key);

  @override
  _BusViewState createState() => _BusViewState();
}

class _BusViewState extends State<BusView> {
  final List<String> busItems = [
    'ລົດເມທໍາມະດາ',
    'ລົດເມ vip',
    'ລົດຕູ້ທໍາມະດາ',
    'ລົດຕູ້ vip',
  ];
  String? selectedValue;

  final DatabaseService _databaseService = DatabaseService();
  var _searchQuery = "";
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
                      openDialog();
                    },
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
                    onPressed: () {},
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
                child: StreamBuilder(
                  stream: _databaseService.getBuses(nameQuery: _searchQuery),
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
                    List buses = snapshot.data?.docs ?? [];
                    if (buses.isEmpty) {
                      return Center(
                        child: Text(
                          'ບໍ່ມີຂໍ້ມູນ.',
                          style: GoogleFonts.notoSansLao(fontSize: 15),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: buses.length,
                      itemBuilder: (context, index) {
                        Buses busesData = buses[index].data();
                        String busesId = buses[index].id;
                        return Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ລະຫັດ: $busesId',
                                  style: GoogleFonts.notoSansLao(fontSize: 15),
                                ),
                                SizedBox(height: 9),
                                Text(
                                  'ຊື່: ${busesData.nume}',
                                  style: GoogleFonts.notoSansLao(
                                    fontSize: 17,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'ປະເພດລົດ: ${busesData.busTypeId}',
                                  style: GoogleFonts.notoSansLao(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'ທະບຽນລົດ: ${busesData.carnamber}',
                                  style: GoogleFonts.notoSansLao(
                                    fontSize: 17,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                Text(
                                  'ຈໍານວນບ່ອນນັ່ງ: ${busesData.capacity}',
                                  style: GoogleFonts.notoSansLao(
                                    fontSize: 17,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                Text(
                                  'ຈໍານວນບ່ອນນັ່ງ vip: ${busesData.capacityVip}',
                                  style: GoogleFonts.notoSansLao(
                                    fontSize: 17,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                                Text(
                                  'ປະເພດແພັກເກັດ: ${busesData.ticketId}',
                                  style: GoogleFonts.notoSansLao(
                                    fontSize: 15,
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
                                            'ທ່ານຕ້ອງການລົບຂໍ້ມູນແມ່ນບໍ່?',
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
      ),
    );
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
                height: 550,
                width: 600, // Set your desired height here
                // Take the maximum width available
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
                              selectedValue = value;
                            });
                          },
                          onSaved: (value) {
                            selectedValue = value;
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
                              selectedValue = value;
                            });
                          },
                          onSaved: (value) {
                            selectedValue = value;
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
                              selectedValue = value;
                            });
                          },
                          onSaved: (value) {
                            selectedValue = value;
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
