import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:string_validator/string_validator.dart';
import 'package:toast/toast.dart';
import '../constant/constants.dart';
import '../models/customer.dart';
import '../widgets/round_button.dart';
import '../network/network.dart';

class TrEntryScreen extends StatefulWidget {
  static const String id = 'TrEntryScreen';
  @override
  _TrEntryScreenState createState() => _TrEntryScreenState();
}

class _TrEntryScreenState extends State<TrEntryScreen> {
  final GlobalKey<ScaffoldState> ScafoldKey = new GlobalKey<ScaffoldState>();

  final _qtyNos = TextEditingController();
  final _qtyKg = TextEditingController();
  final _Rate = TextEditingController();
  final _Amount = TextEditingController();
  final _hsnCode = TextEditingController();
  final txtController = TextEditingController();
  final _insuranceAmount = TextEditingController();

  final _remarksController = TextEditingController();

  final _trDateController = TextEditingController();
  final _trAmountController = TextEditingController();
  final _chqNumberController = TextEditingController();
  final _bandepositDateController = TextEditingController();
  final _hatchDateController = TextEditingController();
  final _chickrateController = TextEditingController();
  final _reamrkController = TextEditingController();
  final _bankDetialsController = TextEditingController();
  final _prodDetialsController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime selectedBankDate = DateTime.now();
  String _value = 'CHEQUE';
  String _MobileNumber = "";
  String _TRNumber = "";
  String _dMNumber = '';
  List<String> customerList = [];
  List<Customer> customerList1 = [];
  List<String> added = [];
  double amount = 0;
  bool _isSaved = false;
  bool _isLoadingCustomers = false;

  @override
  void initState() {
    // TODO: implement initState
    filCustomer();
    fetchTrNumber();
    super.initState();
  }

  void filCustomer() async {
    setState(() {
      _isLoadingCustomers = true;
    });
    String url = '$Url/Customer?AreaCode=$AreaCode';
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();

    for (var c in data['Customer']) {
      if (c['customer'].toString() != 'null') {
        //print(c['customer'].toString());
        customerList.add(c['customer'].toString());
        customerList1.add(Customer(customerName: c['customer'].toString()));
      }
    }

    setState(() {
      _isLoadingCustomers = false;
    });
  }

  void fetchTrNumber() async {
    try {
      String url = '$Url/GetTRNumber?AreaCode=$AreaCode';
      NetworkHelper networkHelper = NetworkHelper(url);
      var data = await networkHelper.getData();
      // print(data);
      setState(() {
        if (data['TrNo'].length > 0) {
          _TRNumber = data['TrNo'][0]['trno'];
          print('trno' + _TRNumber);
        } else {
          _TRNumber = '-';
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _TRNumber = '-';
      });
    }
  }

  void showSnackBar(String tittle) {
    final snackBar = SnackBar(
      content: Text(
        tittle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    ScafoldKey.currentState.showSnackBar(snackBar);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _trDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _trDateController.text = selectedDate.toString().split(' ')[0];
    }
  }

  _selectbankdepostDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedBankDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedBankDate) {
      setState(() {
        selectedBankDate = picked;
        _bandepositDateController.text =
            selectedBankDate.toString().split(' ')[0];
      });
    } else {
      _bandepositDateController.text =
          selectedBankDate.toString().split(' ')[0];
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScafoldKey,
      appBar: AppBar(
        title: Text('TR Entry'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(
                height: 25,
              ),
              _isLoadingCustomers
                  ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )) :
              AutoCompleteTextField<Customer>(
                controller: txtController,
                clearOnSubmit: false,
                suggestions: customerList1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.w700,
                ),
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Select Customer.',
                ),
                itemFilter: (item, query) {
                  return item.customerName
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.customerName.compareTo(b.customerName);
                },
                itemSubmitted: (item) {
                  setState(() {
                    txtController.text = item.customerName;
                    added = txtController.text.split('#');
                  });
                  // fetchCustomerMobile(added[1]);
                  // print('Customer' + added[1]);
                },
                itemBuilder: (context, item) {
                  // ui for the autocomplete row
                  return row(item);
                },
              ),
              SizedBox(
                height: 8,
              ),
              Text('Mobile: ' + _MobileNumber),
              SizedBox(
                height: 10,
              ),
              Text(
                'TR: ' + _TRNumber,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _trDateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select TR Date'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  )
                ],
              ), //Tr date
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _trAmountController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Enter TR Amount'),
              ),
              SizedBox(
                height: 10,
              ),
              //bnak Payment mode
              Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: DropdownButton(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        dropdownColor: Colors.white,
                        value: _value,
                        items: [
                          DropdownMenuItem(
                            child: Text("CHEQUE"),
                            value: 'CHEQUE',
                          ),
                          DropdownMenuItem(
                            child: Text("CASH"),
                            value: 'CASH',
                          ),
                          DropdownMenuItem(
                            child: Text("TRANSFER"),
                            value: 'TRANSFER',
                          ),
                          DropdownMenuItem(
                            child: Text("RTGS"),
                            value: 'RTGS',
                          ),
                          DropdownMenuItem(
                            child: Text("NEFT"),
                            value: 'NEFT',
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _chqNumberController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'CHQ/NEFT/RTGS NUMBER'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _bankDetialsController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Bank Details'),
              ),

              SizedBox(
                height: 10,
              ),
              //Bank Deposir Date
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _bandepositDateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select Deposit Date'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectbankdepostDate(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _prodDetialsController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Product  Details'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _remarksController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Enter Remarks'),
              ),
              SizedBox(
                height: 10,
              ),
              //SAVE BUTTTON
              _isSaved
                  ? Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                  : RoundButton(
                      title: 'SAVE',
                      color: Colors.red,
                      onPressed: () async {
                        setState(() {
                          _isSaved = true;
                        });
                        if (txtController.text.length <= 0) {
                          showSnackBar('Please provide a Customer');
                          return;
                        }

                        if (_trAmountController.text.length <= 0) {
                          showSnackBar('Please provide a TR amount');
                          return;
                        } else {
                          if (isNumeric(_trAmountController.text) == true) {
                          } else {
                            showSnackBar('Please provide a TR amount');
                          }
                        }
                        if (_trDateController.text.length <= 0) {
                          showSnackBar('Please provide a TR date');
                          return;
                        }

                        if (_bandepositDateController.text.length <= 0) {
                          showSnackBar('Please provide a Bank deposit date');
                          _bandepositDateController.text= '1/1/2000';
                          //return;
                        }

                        try {
                          String url =
                              '$Url/InsertTrPoultry?AreaCode=$AreaCode&Area=$AreaName&TRNo=$_TRNumber&';
                          url +=
                              "TrDate=${_trDateController.text}&HatchDate=1/1/2000&uname=$UserName&Code=${added[1]}&CName=${added[0]}&";
                          url +=
                              "Pay_mode=$_value&DD_No=${_chqNumberController.text}&Bank_det=${_prodDetialsController.text}&Pay_type=$_value&Chick_type=BR&";
                          url +=
                              "CihckRate=0&Remarks=${_remarksController.text}&TrAmount=${_trAmountController.text}&bankdate=${_bandepositDateController.text}";
                          print(url);
                          NetworkHelper networkHelper = NetworkHelper(url);
                          var data = await networkHelper.getData();
                          //  print(data);
                        } catch (e) {
                          print(e);
                        }
                        // showToast("Show Long Toast", duration: Toast.LENGTH_LONG);
                        setState(() {
                          _isSaved = false;
                        });

                        Toast.show("TR Data Saved...", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

                        Navigator.pop(context);
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}

Widget row(Customer maker) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Text(
            maker.customerName,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
    ],
  );
}
