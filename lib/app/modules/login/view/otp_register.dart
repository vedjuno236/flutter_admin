import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_admin/app/modules/home/view/home_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';
import 'package:pinput/pinput.dart';

class OtpRegisterView extends StatefulWidget {
  // final String verificationId;
  // final String fullName;
  // final String email;
  // final String phoneNumber;
  // final String idCard;
  // final DateTime dob;
  // final File? profile;
  // final File? idCardImage;
  // final String phoneCode;
  // const OtpRegisterView(
  //     {Key? key,
  //     required this.verificationId,
  //     required this.fullName,
  //     required this.email,
  //     required this.phoneNumber,
  //     required this.idCard,
  //     required this.dob,
  //     required this.profile,
  //     this.idCardImage,
  //     required this.phoneCode})
  //     : super(key: key);

  @override
  _OtpRegisterViewState createState() => _OtpRegisterViewState();
}

class _OtpRegisterViewState extends State<OtpRegisterView> {
  String? otpCode;

  // late RegisterController registerController;
  // late LoginController loginController;

  @override
  void initState() {
    // print("id image:${widget.idCardImage?.path}");
    // registerController = Get.put(RegisterController());
    // loginController = Get.find<LoginController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      "assets/images/6.png",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ລົງທະບຽນດ້ວຍເບີ",
                    style: GoogleFonts.notoSansLao(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ເມືອເຂົ້າສູ່ລະບົບ/ລົງທະບຽນ ສະແດງວ່າທ່ານເຫັນດີ ຕໍ່ຂໍ້ຕົກລົງຄວາມເປັນສ່ວນຕົວ",
                    style: GoogleFonts.notoSansLao(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    onChanged: (val) {
                      // registerController.setSmsCode(val);
                    },
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.purple.shade200,
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: CustomButton(
                      text: "ກວດສອບ",
                      onPressed: () {
                        // if (otpCode != null) {
                        //   verifyOtp(context, otpCode!);
                        // } else {
                        //   showSnackBar(context, "Enter 6-Digit code");
                        // }
                        // registerController.signInAuthCredential(
                        //     widget.verificationId,
                        //     widget.fullName,
                        //     widget.email,
                        //     widget.phoneNumber,
                        //     widget.idCard,
                        //     widget.dob,
                        //     widget.profile,
                        //     widget.idCardImage,
                        //     widget.phoneCode);
  Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: HomeView(),
                          ),
                        );

                        // QuickAlert.show(
                        //   context: context,
                        //   type: QuickAlertType.loading,
                        //   text: 'ກະລຸນາລໍຖ້າ',
                        //   cancelBtnTextStyle: GoogleFonts.notoSansLao(
                        //       color: Colors.white, fontSize: 25),
                        // );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "ຢືນຢັນວ່າບໍ່ໄດ້ຮັບລະຫັດໃດໆ?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "ສົ່ງລະຫັດໃໝ່",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  // Text(
                  // "${widget.fullName}",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.purple,
                  //   ),
                  // ),
                  // Text(
                  //   "${widget.phoneNumber}",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.pinkAccent,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
