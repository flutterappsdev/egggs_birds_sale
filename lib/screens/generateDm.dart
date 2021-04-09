import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../network/network.dart';
import '../constant/constants.dart';
String dmdate ='';
Future<Uint8List> generateInvoice(PdfPageFormat pageFormat, String dmno) async {

  final products = <Product>[];

  String url = '$Url/SingleDMDetails?dmno=$dmno';
  print(url);
  NetworkHelper networkHelper = NetworkHelper(url);
  var data = await networkHelper.getData();
  //print(data);
  var invoice;

  for (var c in data['SingleDMDetails']) {
    if (c['DMNo'].toString() != 'null') {
      invoice = Invoice(
        invoiceNumber: dmno,
        products: products,
        customerName: c['CName'].toString(),
        customerAddress: '',
        paymentInfo: c['ShedDetails'].toString(),
        tax:  c['Insurace'].toString()!= null ? double.parse(c['Insurace'].toString()) : 0,
        tcsper : double.parse(c['Tcs_Per'].toString()),
        tcsamt : double.parse(c['Tcs_Amt'].toString()),
        VehNo : c['VehNo'].toString(),
        DriverName : c['DriverName'].toString(),
        Remarks : c['Remarks'].toString(),
        //tax: 0.00,

        baseColor: PdfColors.teal,
        accentColor: PdfColors.blueGrey900,
      );
      dmdate=c['DMDate'].toString();
    }
  }

  url = '$Url/DMDetails?dmno=$dmno';
  print(url);
  networkHelper = NetworkHelper(url);
  data = await networkHelper.getData();
  for (var c in data['DMDetails']) {
    if (c['Product'].toString() != 'null') {
      products.add(
        Product(
          c['HsnCode'].toString(),
          c['Product'].toString(),
          double.parse(c['Rate'].toString()),
          double.parse(c['QtyNos'].toString()),
          double.parse(c['QtyKg'].toString()),
          double.parse(c['Amount'].toString()),
        ),
      );
    }
  }

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    this.products,
    this.customerName,
    this.customerAddress,
    this.invoiceNumber,
    this.tax,
    this.paymentInfo,
    this.baseColor,
    this.accentColor,
    this.tcsper,
    this.tcsamt,
    this.VehNo,
    this.DriverName,
    this.Remarks

  });

  final List<Product> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final double tcsper;
  final double tcsamt;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;
  final String VehNo;
  final String DriverName;
  final String Remarks;


  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor =>
      baseColor.luminance < 0.5 ? _lightColor : _darkColor;

  PdfColor get _accentTextColor =>
      baseColor.luminance < 0.5 ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _grandTotal => _total + tax+tcsamt;

  String _logo;

  String _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    final font1 = await rootBundle.load('assets/roboto1.ttf');
    final font2 = await rootBundle.load('assets/roboto2.ttf');
    final font3 = await rootBundle.load('assets/roboto3.ttf');

    _logo = await rootBundle.loadString('assets/logo.svg');
    _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          font1 != null ? pw.Font.ttf(font1) : null,
          font2 != null ? pw.Font.ttf(font2) : null,
          font3 != null ? pw.Font.ttf(font3) : null,
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'PHOENIX POULTRY FIRM',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 10, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    width: 500,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _accentTextColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('CM/DM No.#'),
                          pw.Text(invoiceNumber.substring(0,15)),
                          pw.Text('Date:'),
                          pw.Text(dmdate),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child:
                        _logo != null ? pw.SvgImage(svg: _logo) : pw.PdfLogo(),
                  ),
                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# $invoiceNumber',
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context){
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 10),
          pw.Text(
            'CM/DM to: $customerName',
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 20,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Vehicle Number: ' + VehNo.toUpperCase(),
            style: pw.TextStyle(
                color: PdfColors.black,
                fontStyle: pw.FontStyle.italic,
                fontSize: 15
            ),),
          pw.SizedBox(height: 2),
          pw.Text(
            'Driver: ' + DriverName.toUpperCase(),
            style: pw.TextStyle(
                color: PdfColors.black,
                fontStyle: pw.FontStyle.italic,
                fontSize: 15
            ),
          ),
          pw.SizedBox(height: 10),

        ]

    );

  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Shed Details: ' + paymentInfo,
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Remarks in any:',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                Remarks,
                style: const pw.TextStyle(
                  fontSize: 12,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(_total)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Insurance:'),
                    pw.Text(tax.toStringAsFixed(1)),
                                  ],
                ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TCS %:'),
                    pw.Text(tcsper.toStringAsFixed(3)),
                  ],
                ),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [

                    pw.Text('TCS Amount:'),
                    pw.Text(tcsamt.toStringAsFixed(1)),

                  ],
                ),


                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(_grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
               '*E & O E\n Subject to Jabalpur jurisdiction \nReceived above mentioned material in good condition',
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'HSN#',
      'Item Description',
      'Qty Nos.',
      'Qty Kg.',
      'Price',
      'Total'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return amount.toStringAsFixed(2);
}

String _formatDate(DateTime date) {
  //final format = DateFormat.yMMMd('en_US');
  final format = DateFormat.d('dd/MMM/yy');
  return format.format(date);
}

class Product {
  const Product(
    this.sku,
    this.productName,
    this.price,
    this.quantity,
    this.quantityKG,
    this.amount,
  );

  final String sku;
  final String productName;
  final double price;
  final double quantity;
  final double quantityKG;
  final double amount;
  double get total => amount;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
         return quantity.toString();
      case 3:
        return quantityKG.toString();
      case 4:
        return _formatCurrency(price);
      case 5:
        return _formatCurrency(amount);
    }
    return '';
  }
}
