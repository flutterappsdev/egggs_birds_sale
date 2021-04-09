import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'generateDm.dart';

class PdfDm extends StatefulWidget {
  static const id = 'PdfDm';
  @override
  _PdfDmState createState() => _PdfDmState();
}

class _PdfDmState extends State<PdfDm> {

  @override
  Widget build(BuildContext context) {
    var dmdata = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format)=>generateInvoice(format,dmdata['dmno'].toString()),
      ),
    );
  }
}
