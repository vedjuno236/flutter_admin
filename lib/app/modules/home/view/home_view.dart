import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/app/modules/Passengers/passengers_view.dart';
import 'package:flutter_admin/app/modules/booking/view/booking_view.dart';
import 'package:flutter_admin/app/modules/bus/view/bus_view.dart';
import 'package:flutter_admin/app/modules/bustype/view/bustype_view.dart';
import 'package:flutter_admin/app/modules/departures/view/departures_view.dart';
import 'package:flutter_admin/app/modules/home/view/scannner.dart';
import 'package:flutter_admin/app/modules/payment/view/payment_view.dart';
import 'package:flutter_admin/app/modules/routes/view/routes_view.dart';
import 'package:flutter_admin/app/modules/stations/view/station_view.dart';
import 'package:flutter_admin/app/modules/tickets/view/tickets_view.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:page_transition/page_transition.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int CountPass = 0;
  int codeCount = 0;
  int Countbus = 0;
  int Countstations = 0;
  int CountDepartures = 0;
  int CountRoutes = 0;
  int CountTickets = 0;
  int CounBooking = 0;
  int CountPayment = 0;
  String _scanBarcodeResult = '';
  void countFirebasePass() {
    FirebaseFirestore.instance
        .collection('Passengers')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        CountPass = snapshot.size;
      });
    });
  }

  void countFirebaseCodes() {
    FirebaseFirestore.instance
        .collection('BusType')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        codeCount = snapshot.size;
      });
    });
  }

  void countFirebasebus() {
    FirebaseFirestore.instance
        .collection('Buses')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        Countbus = snapshot.size;
      });
    });
  }

  void countFirebasestations() {
    FirebaseFirestore.instance
        .collection('Stations')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        Countstations = snapshot.size;
      });
    });
  }

  void countFirebaseDepartures() {
    FirebaseFirestore.instance
        .collection('Departures')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        CountDepartures = snapshot.size;
      });
    });
  }

  void countFirebaseRoutes() {
    FirebaseFirestore.instance
        .collection('Routes')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        CountRoutes = snapshot.size;
      });
    });
  }

  void countFirebaseTickets() {
    FirebaseFirestore.instance
        .collection('Tickets')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        CountTickets = snapshot.size;
      });
    });
  }

  void countFirebaseBooking() {
    FirebaseFirestore.instance
        .collection('Booking')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        CounBooking = snapshot.size;
      });
    });
  }

  void countFirebasePayment() {
    FirebaseFirestore.instance
        .collection('Payment')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        CountPayment = snapshot.size;
      });
    });
  }

 

  Future _openSanner(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (c) => Scannner()));
    _result = result;
  }

  @override
  void initState() {
    super.initState();
    countFirebasePass();
    countFirebaseCodes();
    countFirebasebus();
    countFirebasestations();
    countFirebaseDepartures();
    countFirebaseRoutes();
    countFirebaseTickets();
    countFirebaseBooking();
    countFirebasePayment();
  }

  String? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ໜ້າຫຼັກ',
          style: GoogleFonts.notoSansLao(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: NavigationDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 1, bottom: 5),
                width: MediaQuery.of(context).size.width,
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 166, 18, 235),
                      Colors.blueAccent
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(80),
                  ),
                ),
                alignment: Alignment(2, 0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          radius: 60,
                          lineWidth: 18.0,
                          percent: 0.4,
                          backgroundColor: Color.fromARGB(255, 166, 18, 235),
                          progressColor: Colors.blueAccent,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: const Text(
                            "60%",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'ການຈອງ/ມື້',
                                      style: GoogleFonts.notoSansLao(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    LinearPercentIndicator(
                                      width: 100,
                                      animation: true,
                                      lineHeight: 8.0,
                                      animationDuration: 1000,
                                      percent: 0.9,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: Colors.redAccent,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'ການຈອງ/ເດືອນ',
                                      style: GoogleFonts.notoSansLao(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    LinearPercentIndicator(
                                      width: 100,
                                      animation: true,
                                      lineHeight: 8.0,
                                      animationDuration: 1000,
                                      percent: 0.5,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: Colors.greenAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'ລາຍຮັບ/ມື້',
                                      style: GoogleFonts.notoSansLao(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    LinearPercentIndicator(
                                      width: 100,
                                      animation: true,
                                      lineHeight: 8.0,
                                      animationDuration: 1000,
                                      percent: 0.2,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: Colors.blue,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'ລາຍຮັບ/ເດືອນ',
                                      style: GoogleFonts.notoSansLao(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    LinearPercentIndicator(
                                      width: 100,
                                      animation: true,
                                      lineHeight: 8.0,
                                      animationDuration: 1000,
                                      percent: 0.9,
                                      linearStrokeCap: LinearStrokeCap.roundAll,
                                      progressColor: Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   PageTransition(
                      //     type: PageTransitionType.rightToLeft,
                      //     child: QRViewExample(),
                      //   ),
                      // );
                      _openSanner(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent, // Background color
                      onPrimary: Colors.white, // Text color
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ສະແກນ QR ປີ້',
                          style: GoogleFonts.notoSansLao(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // Image.asset(
                        //   'assets/images/QR.png', // Replace 'assets/your_image.png' with your image path
                        //   width: 25,
                        //   height: 25,
                        // ),
                        const Icon(
                          Icons
                              .center_focus_strong, // Specify the icon you want to use
                          size: 25,
                          color: Colors.white, // Icon color
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'ລາຍການຈັດການຂໍ້ມູນ',
                    style: GoogleFonts.notoSansLao(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: BustypeView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.bus_alert,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຂໍ້ມູນປະເພດລົດ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: BusView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.car_repair,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຂໍ້ມູນລົດ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: StationView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.stacked_line_chart,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຂໍ້ມູນສະຖານີ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: DepartureView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.departure_board_sharp,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ອອກເດີນທາງ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: RoutesView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.roundabout_left_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຂໍ້ມູນເສັ້ນທາງ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: TicketsView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.padding_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຂໍ້ມູນແພັກແກັດ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: BookingView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.book_online,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຂໍ້ມູນການຈອງ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: PaymentView(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 70,
                                height: 70,
                                child: const Icon(
                                  Icons.payment_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຂໍ້ມູນການຊໍາລະ',
                                style: GoogleFonts.notoSansLao(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ຂໍ້ມູນຕ່າງໆ',
                    // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    style: GoogleFonts.notoSansLao(
                        fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Row(
                    children: [
                      Text(
                        'ທົງໝົດ',
                        style: GoogleFonts.notoSansLao(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                      const Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              Icons.bus_alert,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນປະເພດລົດ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $codeCount /ຄັນ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              Icons.car_repair,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນລົດ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $Countbus /ຄັນ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: PassengersView(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 1, bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black12,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 70,
                              height: 70,
                              child: const Icon(
                                Icons.supervised_user_circle,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ຂໍ້ມູນຜູ້ໃຊ້',
                                  style: GoogleFonts.notoSansLao(
                                      fontSize: 17, color: Colors.black38),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'ຈໍານວນ: $CountPass /ຄົນ',
                                  style: GoogleFonts.notoSansLao(
                                      color: Colors.blueGrey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              Icons.stairs_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນສະຖານີ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $Countstations /ສະຖານີ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              Icons.departure_board_rounded,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນອອກເດີນທາງຂອງລົດ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $CountDepartures /ອອກເດີນທາງ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              Icons.roundabout_right,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນເສັ້ນທາງ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $CountRoutes /ເສັ້ນທາງ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              // Icons.package,
                              Icons.playlist_add_check_circle_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນແພັກແກັດ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $CountTickets /ແພັກເກັດ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1, // กำหนดความหนาของเส้น
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              Icons.book_online,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນການຈອງ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $CounBooking /ການຈອງ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 1, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 70,
                            height: 70,
                            child: const Icon(
                              Icons.payment,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ຂໍ້ມູນການຊໍາລະ',
                                style: GoogleFonts.notoSansLao(
                                    fontSize: 17, color: Colors.black38),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'ຈໍານວນ: $CountPayment /ການຊໍາລະ',
                                style: GoogleFonts.notoSansLao(
                                    color: Colors.blueGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ໜ້າຫຼັກ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'ປີ້',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment_outlined),
            label: 'ການຊໍາລະ',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            // Check if the second item is tapped
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: HomeView(),
              ),
            );
          }
          if (index == 1) {
            // Check if the second item is tapped
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: BookingView(),
              ),
            );
          }
          // Handle tap event here
          if (index == 2) {
            // Check if the second item is tapped
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: PaymentView(),
              ),
            );
          }
          // Add more conditions for other items if needed
        },
        // Set the font size of the labels here
        selectedLabelStyle: TextStyle(fontSize: 17),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        // Removed const here
        backgroundColor: Color(0xfff17203A),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context), // Using the buildHeader method
              buildMenuItems(context), // Using the buildMenuItems method
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Row(children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPAAFceBQwSC7S2iU3JN3V1e0Vct643jQjQnY43Y2pCA&s'),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'vedjuno',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  '+856 2052164377',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                )
              ],
            ),
          ]),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        // Removed const here
        child: Wrap(
          runSpacing: 1,
          children: [
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'ໜ້າຫຼັກ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Add the navigation logic here
                Navigator.pop(context); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.bus_alert_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນປະເພດລົດ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Add the navigation logic here
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: BustypeView(),
                  ),
                ); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.car_crash,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນລົດ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Add the navigation logic here
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: BusView(),
                  ),
                ); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.airline_seat_individual_suite_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນສະຖານີ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: StationView(),
                  ),
                ); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.departure_board_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນອອກເດີນທາງ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Add the navigation logic here
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: DepartureView(),
                  ),
                ); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.roundabout_left,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນເສັ້ນທາງ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: RoutesView(),
                  ),
                ); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.playlist_add_check_circle_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນແພັກແກັດ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Add the navigation logic here
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TicketsView(),
                  ),
                ); // Closes the drawer
              },
            ),
            const Divider(
              color: Colors.black54,
            ),
            ListTile(
              leading: const Icon(
                Icons.book_online,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນການຈອງ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Add the navigation logic here
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: BookingView(),
                  ),
                ); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.payments,
                color: Colors.white,
              ),
              title: const Text(
                'ຂໍ້ມູນການຊໍາລະ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: PaymentView(),
                  ),
                ); // Closes the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.login_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'ອອກຈາກລະບົບ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onTap: () {
                // Add the navigation logic here
                Navigator.pop(context); // Closes the drawer
              },
            ),
          ],
        ),
      );
}

class ItemKategori extends StatelessWidget {
  ItemKategori({
    Key? key,
    required this.title,
    required this.icon,
    required this.style,
  }) : super(key: key);

  final String title;
  final String icon;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          child: Image.asset(
            icon,
            // color: Color(0xFFF7B731),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
