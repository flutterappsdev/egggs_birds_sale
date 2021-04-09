import 'package:flutter/material.dart';
import '../network/network.dart';
import '../constant/constants.dart';
import '../widgets/round_button.dart';
import '../screens/dm_details.dart';

class ListDm {
  final String dmNo;
  final String dmDate;
  final String totalChicks;
  final String CCode;
  final String CName;
  final String Ctype;
  final String mortalty;
  final String rate;
  final String hdate;
  final String hatchries;
  final String tcsper;
  final String tcsamt;

  ListDm(
      {this.dmNo,
        this.dmDate,
        this.totalChicks,
        this.CCode,
        this.CName,
        this.Ctype,
        this.mortalty,
        this.rate,
        this.hdate,
        this.hatchries,
        this.tcsper,
        this.tcsamt
      });
}


class ListCMData extends StatefulWidget {
  static const String id = 'ListCMData';
  @override
  _ListCMDataState createState() => _ListCMDataState();
}

class _ListCMDataState extends State<ListCMData> {

  final _dmDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<ListDm> dmList = [];
  bool _isDropDownFilled = false;

  void filldmData() async {
    String url =
        '$Url/ShowCMDMDate?AreaCode=$AreaCode&uname=$UserName&DMDate=${_dmDateController.text}';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    // print(data);
    dmList.clear();
    for (var c in data['DMData']) {
      if (c['DMNo'].toString() != 'null') {
        setState(() {
          dmList.add(ListDm(
            dmNo: c['DMNo'].toString(),
            dmDate: c['DMDate'].toString(),
            totalChicks: c['TotalChicks'].toString(),
            CCode: c['Code'].toString(),
            CName: c['CName'].toString(),
            Ctype: c['Chick_type'].toString(),
            mortalty: c['Mortality'].toString(),
            rate: c['Rate'].toString(),
            hdate: c['HatchDate'].toString(),
            hatchries: c['Hatchries'].toString(),
            tcsper:  c['Tcs_Per'].toString(),
            tcsamt:  c['Tcs_Amount'].toString(),
          ));
        });
      }
    }
    _isDropDownFilled = true;
    print(dmList[0].CName);
  }

  void fillAlldmData() async {
    String url = '$Url/ShowCM?AreaCode=$AreaCode&uname=$UserName';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    print(data);
    dmList.clear();
    for (var c in data['DMData']) {
      if (c['DMNo'].toString() != 'null') {
        setState(() {
          dmList.add(ListDm(
            dmNo: c['DMNo'].toString(),
            dmDate: c['DMDate'].toString(),
            totalChicks: c['TotalChicks'].toString(),
            CCode: c['Code'].toString(),
            CName: c['CName'].toString(),
            Ctype: c['Chick_type'].toString(),
            mortalty: c['Mortality'].toString(),
            rate: c['Rate'].toString(),
            hdate: c['HatchDate'].toString(),
            hatchries: c['Hatchries'].toString(),
            tcsper:  c['Tcs_Per'].toString(),
            tcsamt:  c['Tcs_Amt'].toString(),

          ));
        });
      }
    }
    _isDropDownFilled = true;
    print(dmList[0].CName);
  }

  _selectTrDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dmDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _dmDateController.text = selectedDate.toString().split(' ')[0];
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    fillAlldmData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Cash Memo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Hello: $UserName   Area:$AreaName',
              style: TextStyle(fontSize: 19),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              height: 3,
              thickness: 1.5,
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 6,
                  child: TextField(
                    controller: _dmDateController,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Select DM Date'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectTrDate(context);
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            RoundButton(
                title: 'Show Cash Memo',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  filldmData();
                }),
            SizedBox(height: 10),
            RoundButton(
                title: 'Show All Cash Memo',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  fillAlldmData();
                }),
            SizedBox(height: 10),
            !_isDropDownFilled
                ? SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, DmDetails.id ,arguments:{
                        'dmno':dmList[index].dmNo.toString(),
                        'customer' : dmList[index].CName +  "#" +  dmList[index].CCode.toString(),
                        'tcsper':dmList[index].tcsper,
                        'tcsamt':dmList[index].tcsamt,

                      }  );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          dmList[index].dmNo.toString(),
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          dmList[index].CName +
                              "#" +
                              dmList[index].CCode.toString(),
                          style: TextStyle(color: Colors.red),
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
                  itemCount: dmList.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
