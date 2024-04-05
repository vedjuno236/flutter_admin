import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/model/passengers_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/passengers_service.dart';

class PassengersView extends StatefulWidget {
  const PassengersView({Key? key}) : super(key: key);

  @override
  _PassengersViewState createState() => _PassengersViewState();
}

final DatabaseService _databaseService = DatabaseService();

String? _searchQuery = "";

class _PassengersViewState extends State<PassengersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຜູ້ນໍາໃໍຊ້ແອັບ',
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: Expanded(
                child: StreamBuilder(
                  stream: _databaseService.getPassgers(nameQuery: _searchQuery),
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
                    List passengers = snapshot.data?.docs ?? [];
                    if (passengers.isEmpty) {
                      return Center(
                        child: Text(
                          'ບໍ່ມີຂໍ້ມູນ.',
                          style: GoogleFonts.notoSansLao(fontSize: 15),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: passengers.length,
                      itemBuilder: (context, index) {
                        Passengers passengersData = passengers[index].data();
                        return Card(
                          child: ListTile(
                            leading: passengersData.profileImageUrl != null
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        passengersData.profileImageUrl),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors
                                        .grey), 
                               

                            title: Row(
                              children: [
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${passengersData.name}',
                                      style: GoogleFonts.notoSansLao(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '${passengersData.phoneNumber}',
                                      style: GoogleFonts.notoSansLao(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      '${passengersData.email}',
                                      style: GoogleFonts.notoSansLao(
                                        fontSize: 17,
                                      ),
                                    )
                                  ],
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
  Navigator.pop(context);
  AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    body: Center(
      child: Text(
        'ຕ້ອງການລົບແມ່ນບໍ່?',
        style: GoogleFonts.notoSansLao(fontSize: 15),
      ),
    ),
    btnCancelOnPress: () {},
    btnOkOnPress: () {
       String passengerId = passengersData.id;
      _databaseService.deletepassengers(passengerId); // Assuming passengerId is defined elsewhere
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
}
