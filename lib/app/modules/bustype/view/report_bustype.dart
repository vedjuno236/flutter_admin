// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class reportt extends StatefulWidget {
//   DocumentSnapshot docid;
//   reportt({required this.docid});
//   @override
//   State<reportt> createState() => _reporttState(docid: docid);
// }

// class _reporttState extends State<reportt> {
//   DocumentSnapshot docid;
//   _reporttState({required this.docid});
//   final pdf = pw.Document();
//   var name;


//   var marks;
//   void initState() {
//     setState(() {
//       name = widget.docid.get('name');
    
      
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PdfPreview(
//       // maxPageWidth: 1000,
//       // useActions: false,
//       // canChangePageFormat: true,
//       canChangeOrientation: false,
//       // pageFormats:pageformat,
//       canDebug: false,

//       build: (format) => generateDocument(
//         format,
//       ),
//     );
//   }

//   Future<Uint8List> generateDocument(PdfPageFormat format) async {
//     final doc = pw.Document(pageMode: PdfPageMode.outlines);

//     final font1 = await PdfGoogleFonts.openSansRegular();
//     final font2 = await PdfGoogleFonts.openSansBold();
//     // final image = await imageFromAssetBundle('assets/r2.svg');

//     String? _logo = await rootBundle.loadString('assets/r2.svg');

//     doc.addPage(
//       pw.Page(
//         pageTheme: pw.PageTheme(
//           pageFormat: format.copyWith(
//             marginBottom: 0,
//             marginLeft: 0,
//             marginRight: 0,
//             marginTop: 0,
//           ),
//           orientation: pw.PageOrientation.portrait,
//           theme: pw.ThemeData.withFont(
//             base: font1,
//             bold: font2,
//           ),
//         ),
//         build: (context) {
//           return pw.Center(
//               child: pw.Column(
//             mainAxisAlignment: pw.MainAxisAlignment.center,
//             children: [
//               pw.Flexible(
//                 child: pw.SvgImage(
//                   svg: _logo,
//                   height: 100,
//                 ),
//               ),
//               pw.SizedBox(
//                 height: 20,
//               ),
//               pw.Center(
//                 child: pw.Text(
//                   'Final Report ',
//                   style: pw.TextStyle(
//                     fontSize: 50,
//                   ),
//                 ),
//               ),
//               pw.SizedBox(
//                 height: 20,
//               ),
//               pw.Divider(),
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.center,
//                 children: [
//                   pw.Text(
//                     'name : ',
//                     style: pw.TextStyle(
//                       fontSize: 50,
//                     ),
//                   ),
//                   pw.Text(
//                     name,
//                     style: pw.TextStyle(
//                       fontSize: 50,
//                     ),
//                   ),
//                 ],
//               ),
              
                
              
//             ],
//           ));
//         },
//       ),
//     );

//     return doc.save();
//   }
// }