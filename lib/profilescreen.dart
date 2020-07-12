import 'package:flutter/material.dart';
import 'paymenthistoryscreen.dart';
import 'user.dart';
import 'cartscreen.dart';
import 'mainscreen.dart';
import 'loginscreen.dart';
import 'adminpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;
  String cartquantity = "0";
  String titlecenter = "Loading...";
  List productdata;
  double screenHeight, screenWidth;
  String server = "https://justforlhdb.com/thedreamtop";
  int quantity = 1;
  bool _isadmin = false;

   @override
  void initState() {
    super.initState();
    if (widget.user.email == "admin@justforlhdb.com") {
      _isadmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, " + widget.user.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(children: <Widget>[
        Card(
          elevation: 10,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/personicon.png',
                  height: 100,
                  width: 100,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        style: TextStyle(fontSize: 20),
                      ),
                    ]),
              ]),
        ),
        Card(
          elevation: 0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    height: 50,
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PaymentHistoryScreen(
                                      user: widget.user,
                                    )));
                      });
                    },
                    child: Text(
                      'Payment History',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    elevation: 0,
                  ),
                ),
              ]),
        ),
        //  Card(
        //   elevation: 0,
        //   child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Expanded(
        //           child: MaterialButton(
        //             height: 50,
        //             onPressed: () {},
        //             child: Text(
        //               'Manage Your Account',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //             color: Colors.blue,
        //             elevation: 0,
        //           ),
        //         ),
        //       ]),
        // ),
        
        Visibility(
          visible: _isadmin,
          child: Column(children: <Widget>[
            Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

          ],)),


        Visibility(
            visible: _isadmin,
            child: Card(
          elevation: 0,
          
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                Expanded(
                  child: MaterialButton(
                    height: 50,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => AdminPage(user: widget.user,)));
                    },
                    child: Text(
                      'My Products',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    elevation: 0,
                  ),
                ),
              ]),
        ),
          ),


        Card(
          elevation: 0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    height: 50,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen()));
                    },
                    child: Text(
                      'Log out',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    elevation: 0,
                  ),
                ),
              ]),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          _currentIndex = value;
          setState(() {
            // _currentIndex = index;
            switch (_currentIndex) {
              case 0:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(
                              user: widget.user,
                            )));
                break;
              case 1:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartScreen(
                              user: widget.user,
                            )));
                _loadData();
                _loadCartQuantity();
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileScreen(
                              user: widget.user,
                            )));

                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            title: Text(
              'My Cart',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(
                'Account',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
              )),
        ],
      ),
    );
  }

  void _loadData() async {
    String urlLoadJobs =
        "https://justforlhdb.com/thedreamtop/php/load_data.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadJobs =
        "https://justforlhdb.com/thedreamtop/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }
}
