import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister =
      "https://justforlhdb.com/thedreamtop/php/register_user.php";
  TextEditingController _nameEC = new TextEditingController();
  TextEditingController _emailEC = new TextEditingController();
  TextEditingController _phoneEC = new TextEditingController();
  TextEditingController _passEC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.brown,
      ),
      title: 'Material App',
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/register.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 400,
      margin: EdgeInsets.only(top: screenHeight / 3.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "User Register",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                      controller: _nameEC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.0),
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                      controller: _emailEC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.0),
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                      controller: _phoneEC,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.0),
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _passEC,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 2.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                   
                        },
                      ),
                      GestureDetector(
                        onTap: _showEULA,
                        child: Text('I Agree to Terms  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 115,
                        height: 50,
                        child: Text('Register'),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed:        _acceptRegister,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Text("Already register? ",
                  style: TextStyle(color: Colors.black, fontSize: 16.0)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Back to Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.laptop_windows,
            size: 40,
            color: Colors.indigoAccent[400],
          ),
          Text(
            " TheDreamTop",
            style: TextStyle(
                fontSize: 36,
                color: Colors.indigoAccent[400],
                fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _acceptRegister() {
    //TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Register"),
          content: new Container(
            height: 50,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _showEULA,
                  child: Text('I agree to Terms & Condition and confirm all the information is correct',
                      style:
                          TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: _onRegister,
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRegister() {
    String name = _nameEC.text;
    String email = _emailEC.text;
    String phone = _phoneEC.text;
    String password = _passEC.text;
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

if ((_isEmailValid(email)) &&
        (password.length > 4) &&
        (phone.length > 5)) {




    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
       
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.of(context).pop();
             Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      } else {
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });}else {
      Toast.show("Please make sure your information is correct.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and justforlhdb. This EULA agreement governs your acquisition and use of our TheTopDream software (Software) directly from justforlhdb or indirectly through a justforlhdb authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the TheTopDream software. It provides a license to use the TheTopDream software and contains warranty information and liability disclaimers. If you register for a free trial of the TheTopDream software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the TheTopDream software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by justforlhdb herewith regardless of whether other software is referred to or described herein. The terms also apply to any justforlhdb updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for TheTopDream justforlhdb shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of justforlhdb. Justforlhdb reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
   bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
