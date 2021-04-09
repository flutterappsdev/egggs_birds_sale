import 'package:flutter/material.dart';
import '../screens/generateTrPrint.dart';
import 'package:printing/printing.dart';

class PdfTr extends StatefulWidget {
  static const id = 'PdfTr';
  @override
  _PdfTrState createState() => _PdfTrState();
}

class _PdfTrState extends State<PdfTr> {
  @override
  Widget build(BuildContext context) {
    var trdata = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format)=>generateTrPrint(format,trdata['trno'].toString(),
            trdata['trdate'].toString(),
            trdata['cname'].toString(),
            trdata['amt'].toString(),
            trdata['bankdet'].toString()

        ),
      ),
    );
  }
}

