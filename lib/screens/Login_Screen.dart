import 'package:flutter/material.dart';
import '../screens/menu_grid.dart';
import '../util/color.dart';
import '../util/animation.dart';
import '../constant/constants.dart';
import '../network/network.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _userNameController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              backgroundImageWidget(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(
                          1.5,
                          Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          1.7,
                          Center(
                            child: Image.asset('assets/images/logo.png',
                                height: 150),
                          )),
                      loginFormWidget(),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget backgroundImageWidget() {
    return Positioned(
        top: -0,
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(color: primaryColor),
        ));
  }

  Widget loginFormWidget() {
    return FadeAnimation(
        1.7,
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(196, 135, 198, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              // key: _formKey,
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                      1.8,
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Text(
                          "Login",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 55.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: splashIndicatorColor)),
                    child: TextFormField(
                      controller: _userNameController,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "User",
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: splashIndicatorColor.withOpacity(0.8)),
                        icon: Icon(Icons.supervised_user_circle_rounded),
                        border: InputBorder.none,
                      ),
                      onSaved: (String value) {
                        // this._data.email = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email address required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 55.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: splashIndicatorColor)),
                    child: TextFormField(
                      controller: _passwordTextController,
                      obscureText: true,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: splashIndicatorColor.withOpacity(0.8),
                          ),
                          icon: Icon(Icons.lock),
                          border: InputBorder.none),
                      onSaved: (String value) {
                        //this._data.password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password required';
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () async {},
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Center(
                          child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      )),
                    ),
                  ),
                  FadeAnimation(
                      1.8,
                      FloatingActionButton(
                        backgroundColor: primaryColor,
                        onPressed: () async {
                          print(_userNameController.text);

                          String _url =
                              'http://117.240.18.180:3000/phoeapi.asmx/Login?User=${_userNameController.text}&Password=${_passwordTextController.text}';
                          print(_url);
                          NetworkHelper networkHelper = NetworkHelper(_url);
                          var _userData = await networkHelper.getData();
                          UserName = _userData['Login'][0]['UserName'];
                          UserType = _userData['Login'][0]['UserType'];
                          AreaCode = _userData['Login'][0]['AreaCode'];
                          AreaName = _userData['Login'][0]['AreaName'];

                          if (_userData['Login'].length == 0) {
                            print(_userData['Login'].lenght);
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                  title: Text('Alert'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Invalid username or password'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]),
                            );
                          } else {
                            if (UserType == 'Sales') {
                              print(UserType);

                              Navigator.pushNamedAndRemoveUntil(
                                  context, SalesMenuGrid.id, (route) => false);
                            }
                          }

                          Navigator.pushNamedAndRemoveUntil(
                              context, SalesMenuGrid.id, (route) => false);
                        },
                        child: Icon(Icons.arrow_forward),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
