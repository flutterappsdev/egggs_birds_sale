import 'package:egggs_birds_sale/screens/pdf_dm_gst.dart';
import 'package:egggs_birds_sale/widgets/round_button.dart';
import 'package:flutter/material.dart';
import '../screens/pdf_dm_gst.dart';
import '../network/network.dart';
import '../constant/constants.dart';

class PrdList {
  final String prd;
  final String qtyNos;
  final String qtykg;
  final String rate;
  final String amount;
  final String hnscode;
  final String taxType;
  final String taxPer;
  final String taxValue;


  PrdList(
      {this.prd,
        this.qtyNos,
        this.qtykg,
        this.rate,
        this.amount,
        this.hnscode,
        this.taxType,
      this.taxPer,
      this.taxValue});
}

class DmDetailsGst extends StatefulWidget {
  static const String id = 'DmDetailsGst';
  @override
  _DmDetailsGstState createState() => _DmDetailsGstState();
}

class _DmDetailsGstState extends State<DmDetailsGst> {

  var dmdata = {};
  List<PrdList> prdlist = [];

  void fillPrdDetails() async {
    dmdata = ModalRoute.of(context).settings.arguments as Map;
    print(dmdata['dmno'].toString());
    String url = '$Url/DMDetails?dmno=${dmdata['dmno'].toString()}';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    prdlist.clear();
    print(dmdata['dmno'].toString());
    for (var c in data['DMDetails']) {
      if (c['Product'].toString() != 'null') {
        setState(() {
          prdlist.add(
            PrdList(
              prd: c['Product'].toString(),
              qtyNos: c['QtyNos'].toString(),
              qtykg: c['QtyKg'].toString(),
              rate: c['Rate'].toString(),
              amount: c['Amount'].toString(),
              hnscode: c['HsnCode'].toString(),
              taxType: c['TaxType'].toString(),
              taxPer: c['TaxPer'].toString(),
              taxValue: c['TaxValue'].toString(),

            ),
          );
        });
      }
    }
  }
 @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
   fillPrdDetails();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    dmdata = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text('DM Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dmdata['dmno'].toString()),
            Text(dmdata['customer'].toString()),
            Text("TCS %:" + dmdata['tcsper'].toString()),
            Text("TCS Amount:" + dmdata['tcsamt'].toString()),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Product Name:' + prdlist[index].prd,
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          'Qty in Nos.:' + prdlist[index].qtyNos,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Qty in KG.:' + prdlist[index].qtykg,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Rate.:' + prdlist[index].rate,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Amount.:' + prdlist[index].amount,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Tax Type.:' + prdlist[index].taxType,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Tax %.:' + prdlist[index].taxPer,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Tax value.:' + prdlist[index].taxValue,
                          style: TextStyle(color: Colors.black),
                        ),

                        Text(
                          'HSN Code.:' + prdlist[index].hnscode,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Divider(
                          height: 3,
                          thickness: 1.5,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                  ),
                  itemCount: prdlist.length,
                ),
              ),
            ),
            RoundButton(
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pushNamed(PdfDmGst.id, arguments: {
                  'dmno': dmdata['dmno'].toString(),
                  'customer': dmdata['customer'].toString(),
                });
              },
              title: 'PRINT DM',
            )
          ],
        ),
      ),
    );
  }
}
