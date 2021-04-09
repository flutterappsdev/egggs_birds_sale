import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'generateDmGst.dart';


class PdfDmGst extends StatefulWidget {
  static const String id = 'PdfDmGst';
  @override
  _PdfDmGstState createState() => _PdfDmGstState();
}

class _PdfDmGstState extends State<PdfDmGst> {
  @override
  Widget build(BuildContext context) {
    var dmdata = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format)=>generateInvoiceGst(format,dmdata['dmno'].toString()),
      ),
    );
  }
}
