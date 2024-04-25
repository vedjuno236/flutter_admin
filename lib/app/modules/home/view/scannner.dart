import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scannner extends StatefulWidget {
  const Scannner({Key? key}) : super(key: key);

  @override
  _ScannnerState createState() => _ScannnerState();
}

class _ScannnerState extends State<Scannner> {
  bool _flashOn = false;
  bool _fronCam = false;
  GlobalKey _qrkey = GlobalKey();
  QRViewController? _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
              key: _qrkey,
              overlay: QrScannerOverlayShape(borderColor: Colors.blueAccent),
              onQRViewCreated: (QRViewController controller) {
                this._controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  print(scanData);
                  if (mounted) {
                    _controller?.dispose();
                    Navigator.pop(context, scanData);
                  }
                });
              }),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 60),
              child: Text(
                'ສະແກນປີ້',
                style:
                    GoogleFonts.notoSansLao(fontSize: 19, color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    color: Colors.white,
                    icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
                    onPressed: () {
                      setState(() {
                        _flashOn = !_flashOn;
                      });
                      _controller?.toggleFlash();
                    }),
                IconButton(
                    color: Colors.white,
                    icon:
                        Icon(_fronCam ? Icons.camera_front : Icons.camera_rear),
                    onPressed: () {
                      setState(() {
                        _fronCam = !_fronCam;
                      });
                      _controller?.flipCamera();
                    }),
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context))
              ],
            ),
          )
        ],
      ),
    );
  }
}
