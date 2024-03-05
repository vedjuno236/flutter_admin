import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class BustypeView extends StatefulWidget {
  const BustypeView({Key? key}) : super(key: key);

  @override
  _BustypeViewState createState() => _BustypeViewState();
}

class _BustypeViewState extends State<BustypeView> {
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
                  child: ListView(
                    // Using ListView instead of Column to allow scrolling if necessary
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(
                            'ຊື່ :ລົດເມ',
                            style: GoogleFonts.notoSansLao(fontSize: 17),
                          ),
                          subtitle: Text(
                            'ລະຫັດ : 123',
                            style: GoogleFonts.notoSansLao(fontSize: 16),
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
                                  leading: Icon(
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
                                          'ທ່ານຕ້ອງການລົບຂໍ້ມູນບໍ່.',
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
                                    'ລົບ',
                                    style: GoogleFonts.notoSansLao(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Add more ListTiles if needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future openDialog() => showDialog(
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
            decoration: InputDecoration(
              hintText: 'ປ້ອນຂໍ້ມູນປະເພດລົດ',
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

  Future EditeDialog() => showDialog(
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
            decoration: InputDecoration(
              hintText: 'ປ້ອນຂໍ້ມູນປະເພດລົດ',
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
