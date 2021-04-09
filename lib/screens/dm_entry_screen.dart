import 'dart:convert';
import 'package:egggs_birds_sale/provider/dmitems.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:http/http.dart' as http;
import '../constant/constants.dart';
import '../models/customer.dart';
import '../widgets/round_button.dart';
import '../provider/dmitems.dart';
import '../widgets/DmItems.dart';
import '../network/network.dart';

class DmEntryScreen extends StatefulWidget {
  static const id = 'DmEntryScreen';
  @override
  _DmEntryScreenState createState() => _DmEntryScreenState();
}

class _DmEntryScreenState extends State<DmEntryScreen> {
  final GlobalKey<ScaffoldState> ScafoldKey = new GlobalKey<ScaffoldState>();

  final _qtyNos = TextEditingController();
  final _qtyKg = TextEditingController();
  final _Rate = TextEditingController();
  final _Amount = TextEditingController();
  final _hsnCode = TextEditingController();
  final txtController = TextEditingController();
  final _insuranceAmount = TextEditingController();
  final _dmDateController = TextEditingController();
  final _remarksController = TextEditingController();
  final _vehNoController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _tcsper = TextEditingController();
  final _tcsamount = TextEditingController();
  final _sheddetails = TextEditingController();
  DateTime selectedDate = DateTime.now();

  String _MobileNumber = "";
  String _product = 'Good Eggs';
  String _dMNumber = '';
  List<String> customerList = [];
  List<Customer> customerList1 = [];
  List<String> added = [];
  List data = [];
  double amount = 0;
  bool _isDropDownFilled = false;
  bool _isLoadingCustomers = false;
  int _radioValue1 = -1;
  int _radioValue2 = 1;
  double dmsum = 0;
  double insamt = 0;
  bool _isSaved = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDMNumber();
    filCustomer();
    fillDropDown();
    // Provider.of<DmItemNotify>(context).clearList();

    super.initState();
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

  void fetchDMNumber() async {
    try {
      String url = '$Url/GetDMNumber?AreaCode=$AreaCode&isDM=$_radioValue2';
      NetworkHelper networkHelper = NetworkHelper(url);
      var data = await networkHelper.getData();
      // print(data);
      setState(() {
        if (data['DmNo'].length > 0) {
          _dMNumber = data['DmNo'][0]['DmNo'];
         // print('dmno' + _dMNumber);
        } else {
          _dMNumber = '-';
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _dMNumber = '-';
      });
    }
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

  void fetchCustomerMobile(String code) async {
    try {
      String url = '$Url/GetMobileNumber?Code=$code';
      NetworkHelper networkHelper = NetworkHelper(url);
      var data = await networkHelper.getData();
      setState(() {
        if (data['MobileNo'].length > 0) {
          _MobileNumber = data['MobileNo'][0]['phone'];
          //print('mobile' + _MobileNumber);
        } else {
          _MobileNumber = '-';
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _MobileNumber = '-';
      });
    }
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
        _dmDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _dmDateController.text = selectedDate.toString().split(' ')[0];
    }
  }

  void fillDropDown() async {
    //_isDropDownFilled = false;

    try {
      const URL =
          'https://eggsale-66fcd-default-rtdb.firebaseio.com/products.json';
      final response = await http.get(URL);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((key, value) {
        if (value['areacode'] == AreaCode) {
          setState(() {
            data.add(value);
          });
        }
      });
      setState(() {
        _product = data[0]['title'].toString();
        _isDropDownFilled = true;
      });

      //print(_myValue);
    } catch (e) {
      print('errpr $e');
    }
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
    });

  }

  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;
    });
    fetchDMNumber();
  }

  @override
  Widget build(BuildContext context) {
    final dmitem = Provider.of<DmItemNotify>(context);
    return Scaffold(
      key: ScafoldKey,
      appBar: AppBar(
        title: Text('DM Entry  ' + 'Total:' + dmsum.toString()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('DM',style: TextStyle(fontSize: 18), ),
                  SizedBox(width: 2,),
                  Radio(value: 1,groupValue: _radioValue2, onChanged: _handleRadioValueChange2),
                  SizedBox(width: 20,),
                  Text('CM',style: TextStyle(fontSize: 18), ),
                  SizedBox(width: 2,),
                  Radio(value: 0,groupValue: _radioValue2, onChanged: _handleRadioValueChange2),
                ],
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
                height: 5,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      readOnly: true,
                      controller: _dmDateController,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select DM Date'),
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
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                _dMNumber,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 8,
              ),
              _isLoadingCustomers
                  ? Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                  : AutoCompleteTextField<Customer>(
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
                        fetchCustomerMobile(added[1]);
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
                height: 8,
              ),
              Row(
                children: [
                  Flexible(
                      child: TextField(

                    controller: _vehNoController,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Vehicle Number'),
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: TextField(
                    controller: _driverNameController,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration:
                        kTextFieldDecoration.copyWith(labelText: 'Driver Name'),
                  ),),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('By Nos.',style: TextStyle(fontSize: 18), ),
                  SizedBox(width: 2,),
                  Radio(value: 0,groupValue: _radioValue1, onChanged: _handleRadioValueChange1),
                  SizedBox(width: 20,),
                  Text('By KG.',style: TextStyle(fontSize: 18), ),
                  SizedBox(width: 2,),
                  Radio(value: 1,groupValue: _radioValue1, onChanged: _handleRadioValueChange1),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Flexible(
                    child: !_isDropDownFilled
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                          )
                        : DropdownButton(
                            isExpanded: true,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            items: data.map((e) {
                              return DropdownMenuItem(
                                child: Text(e['title']),
                                value: e['title'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _product = newVal;
                                print(_product);
                              });
                            },
                            value: _product,
                          ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _qtyNos,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration:
                          kTextFieldDecoration.copyWith(labelText: 'Qty Nos.'),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _qtyKg,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration:
                          kTextFieldDecoration.copyWith(labelText: 'Qty Kg.'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _Rate,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration:
                          kTextFieldDecoration.copyWith(labelText: 'Rate'),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      readOnly: true,
                      controller: _Amount,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration:
                          kTextFieldDecoration.copyWith(labelText: 'Amount'),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      controller: _hsnCode,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration:
                          kTextFieldDecoration.copyWith(labelText: 'HSN code'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              RoundButton(
                onPressed: () {
                  if (_qtyNos.text.length <= 0) {
                    showSnackBar('Please provide a quantity in numbers');
                    return;
                  } else {
                    if (isNumeric(_qtyNos.text) == true) {
                    } else {
                      showSnackBar('Please provide a quantity in numbers');
                    }
                  }

                  if (_qtyKg.text.length <= 0) {
                    showSnackBar('Please provide a quantity in kg');
                    return;
                  } else {
                    if (isNumeric(_qtyKg.text) == true) {
                    } else {
                      showSnackBar('Please provide a quantity in kg');
                    }
                  }

                  if (_Rate.text.length <= 0) {
                    showSnackBar('Please provide a valid rate');
                    return;
                  } else {
                    if (isNumeric(_Rate.text) == true) {
                    } else {
                      showSnackBar('Please provide a valid in rate');
                    }
                  }

                  if (_radioValue1==-1)
                    {
                      showSnackBar('Please select a radio button');
                      return;
                    }

                  if (_radioValue1==0) {
                    amount =
                        double.parse(_qtyNos.text) * double.parse(_Rate.text);
                    print('nos');
                  } else {
                    amount =
                        double.parse(_qtyKg.text) * double.parse(_Rate.text);
                    print('kgs');
                  }

                  print(amount);
                  setState(() {
                    dmsum = dmsum+amount;
                  });
                  dmitem.additems(
                      DateTime.now().toString(),
                      _product,
                      int.parse(_qtyNos.text),
                      double.parse(_qtyKg.text),
                      double.parse(_Rate.text),
                      amount,
                      _hsnCode.text,'',0,0);
                  _qtyNos.text = "";
                  _qtyKg.text = "";
                  _Rate.text = "";
                  _hsnCode.text = "";
                },// onpress add
                color: Colors.redAccent,
                title: 'ADD',
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: ListView.builder(
                  itemCount: dmitem.items.length,
                  itemBuilder: (ctx, i) => DmItems(
                      dmitem.items[i].id,
                      dmitem.items[i].prod,
                      dmitem.items[i].qtynos,
                      dmitem.items[i].qtykg,
                      dmitem.items[i].rate,
                      dmitem.items[i].amount,
                      dmitem.items[i].hsncode),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Flexible(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _insuranceAmount,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Insurance Amount'),
                    onSubmitted: (val){
                      print(val);
                      setState(() {
                        insamt = double.parse(_insuranceAmount.text);
                        dmsum = dmsum + insamt;
                      });
                      if(val.length==0){
                        print(insamt.toString());
                        dmsum = dmsum - insamt;
                      }
                     },
                    onEditingComplete: (){

                    },
                  ),

                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                     // keyboardType: TextInputType.number,
                      controller: _remarksController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration:
                          kTextFieldDecoration.copyWith(labelText: 'Remarks'),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _tcsper,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: kTextFieldDecoration.copyWith(
                            labelText: 'TCS Percentage'),
                        onSubmitted: (val){
                         // print('kkk');
                          print(val);
                          double tcsamt=0;
                          tcsamt =   ((double.parse(val)/100)*dmsum).ceilToDouble();

                          print(tcsamt.toString());
                          setState(() {
                            _tcsamount.text = tcsamt.toString();
                            dmsum = dmsum+tcsamt;
                          },);

                          if(val.isEmpty){
                            setState(() {
                              dmsum = dmsum-tcsamt;
                              _tcsamount.text = "0";
                            });

                          }
                        }
                        ,),),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: TextField(
                      readOnly:  true,
                      keyboardType: TextInputType.number,
                      controller: _tcsamount,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration:
                      kTextFieldDecoration.copyWith(labelText: 'TCS Amount'),

                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _sheddetails,
                style: TextStyle(fontSize: 17),
                decoration: kTextFieldDecoration.copyWith(labelText: 'Enter Shed Details'),

              ),
              SizedBox(height: 5,),
              //Save button
              _isSaved
                  ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ))
             : RoundButton(
                color: Colors.redAccent,
                title: 'SAVE',
                onPressed: () async {


                  if (_dmDateController.text.length <= 0) {
                    showSnackBar('Please provide valid date');
                    return;
                  }

                  if (txtController.text.length <= 0) {
                    showSnackBar('Please provide valid customer');
                    return;
                  }

                  setState(() {
                    _isSaved = true;
                  });

                  try {
                    String url = '$Url/GetDMNumber?AreaCode=$AreaCode&isDM=$_radioValue2';
                    NetworkHelper networkHelper = NetworkHelper(url);
                    var data = await networkHelper.getData();
                    // print(data);
                    setState(() {
                      if (data['DmNo'].length > 0) {
                        _dMNumber = data['DmNo'][0]['DmNo'];
                       // print('dmno' + _dMNumber);
                      } else {
                        _dMNumber = '-';
                      }
                    });
                  } catch (e) {
                    print(e);
                    setState(() {
                      _dMNumber = '-';
                    });
                  }


                  try {
                    String url =
                        '$Url/InsertDMPoultry?AreaCode=$AreaCode&Area=$AreaName&DMNo=$_dMNumber&';
                    url +=
                        "DMDate=${_dmDateController.text}&uname=$UserName&Code=${added[1]}&CName=${added[0]}&";
                    url +=
                        "Remarks=${_remarksController.text}&Insurance=${_insuranceAmount.text}&VehNo=${_vehNoController.text}&DriverName=${_driverNameController.text}&";

                   url+="TcsPer=${_tcsper.text}&TcsAmt=${_tcsamount.text}&isGST=0&ShedDetails=${_sheddetails.text}&isDM=$_radioValue2";
                   // print(url);
                    NetworkHelper networkHelper = NetworkHelper(url);
                    var data = await networkHelper.getData();
                   // print(data);
                  } catch (e) {
                    print(e);
                  }

                  try {
                    for (var d in dmitem.items) {
                      String url_det =
                          '$Url/InsertDMPoultry_det?Product=${d.prod}&QtyNos=${d.qtynos}&QtyKg=${d.qtykg}&';
                      url_det +=
                          "Amount=${d.amount.toStringAsFixed(0)}&HsnCode=${_hsnCode.text}&DMNo=$_dMNumber&Rate=${d.rate}&";
                      url_det += "AreaCode=$AreaCode";
                     // print(url_det);
                      http.Response response = await http.get(url_det);

                     // print(d.qtykg);
                    }
                  } catch (e) {
                    print(e);
                  }
                  Provider.of<DmItemNotify>(context, listen: false).clearList();
                  setState(() {
                    _isSaved=false;
                  });
                  Navigator.of(context).pop();
                },
              ),
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
