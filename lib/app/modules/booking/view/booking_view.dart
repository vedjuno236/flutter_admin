import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class BookingView extends StatefulWidget {
  const BookingView({Key? key}) : super(key: key);

  @override
  _BookingViewState createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ຂໍ້ມູນການຈອງ',
            style: GoogleFonts.notoSansLao(
              fontSize: 20,
              color: Colors.redAccent,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ],
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
                    children: [
                      Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ລະຫັດ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ວັນທີເດືອນປີຈອງ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ລະຫັດອອກເດີນທາງ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ໝົດເວລາຂອງປີ້ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ລະຫັດຜູ້ໂດຍສານ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ໝາຍເລກບ່ອນນັ່ງ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ສະຖານີ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ລະຫັດແພັກແກັດ :',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
                              ),
                              Text(
                                'ລະຫັດຜູ້ໂດຍໃຊ້:',
                                style: GoogleFonts.notoSansLao(fontSize: 17),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future EditeDialog() => showDialog(
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
