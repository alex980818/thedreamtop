import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thedreamtop/mainscreen.dart';
import 'package:thedreamtop/user.dart';
// import 'mainscreen2.dart';
import 'package:thedreamtop/registerscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  String urlLogin = "https://justforlhdb.com/thedreamtop/php/login_user.php";


  @override
  void initState() {
    super.initState();
    //print("Hello i'm in INITSTATE");
    this.loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 340,
      margin: EdgeInsets.only(top: screenHeight / 3),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _passController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Remember Me ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 50,
                        child: Text('Login'),
                        color: Colors.brown,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: _userLogin,
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
              Text("Don't have an account? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _registerUser,
                child: Text(
                  "Sign up",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Forgot your password? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _forgotPassword,
                child: Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Text("Guest Mode", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _unregisterUserLogin,
                child: Text(
                  "Guest Mode",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
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
      margin: EdgeInsets.only(top: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.laptop_windows,
            size: 40,
            color: Colors.white,
          ),
          Text(
            "TheDreamTop",
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _userLogin() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in...");
      pr.show();
      String _email = _emailController.text;
      String _password = _passController.text;
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      })
          //.timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: _email,
              password: _password,
              phone: userdata[3],
              credit: userdata[4],
              quantity: userdata[5]);
          pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          pr.dismiss();
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

   void _unregisterUserLogin() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in...");
      pr.show();
      String _email ="unregistered@justforlhdb.com";
      String _password = "abc12345";
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      })
          //.timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: _email,
              password: _password,
              phone: userdata[3],
              credit: userdata[4],
              quantity: userdata[5]);
          pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          pr.dismiss();
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }


  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email",
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
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

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text("Exit")),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("Cancel")),
            ],
          ),
        ) ??
        false;
  }

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailController.text = email;
        _passController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailController.text;
    String password = _passController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailController.text = '';
        _passController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
