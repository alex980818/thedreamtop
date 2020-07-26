import 'dart:io';
import 'package:flutter/material.dart';
import 'paymenthistoryscreen.dart';
import 'user.dart';
import 'cartscreen.dart';
import 'mainscreen.dart';
import 'loginscreen.dart';
import 'adminpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

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
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text(
          "Welcome, " + widget.user.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: _takePicture,
              child: Container(
                height: 100,
                width: 100,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  //border: Border.all(color: Colors.black),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: server + "/profileimage/${widget.user.email}.jpg",
                  placeholder: (context, url) => new SizedBox(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      new Icon(MdiIcons.cameraIris, size: 64.0),
                ),
              ),
            ),
            //SizedBox(width: 10),
            Expanded(
                child: Container(
              color: Colors.grey,
              child: Table(
                  defaultColumnWidth: FlexColumnWidth(1.0),
                  columnWidths: {
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(6.5),
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: Container(
                          height: 20,
                        ),
                      ),
                      TableCell(
                        child: Container(
                          height: 20,
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.center,
                            height: 20,
                            child: Text("Name:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(widget.user.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black)),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.center,
                            height: 20,
                            child: Text("Email:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(widget.user.email,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black)),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.center,
                            height: 20,
                            child: Text("Phone:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(widget.user.phone,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black)),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                          height: 20,
                        ),
                      ),
                      TableCell(
                        child: Container(
                          height: 20,
                        ),
                      ),
                    ]),
                  ]),
            )),
          ],
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
                      if (widget.user.email == "unregistered@justforlhdb.com") {
                        Toast.show(
                            "Please login to use this function!!!", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        return;
                      } else if (widget.user.email == "admin@justforlhdb.com") {
                        Toast.show("Admin Mode!!!", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        return;
                      }
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
                    color: Colors.grey[600],
                    elevation: 0,
                  ),
                ),
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
                    onPressed: () => changeName(),
                    child: Text(
                      'Change Your Name',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.grey[600],
                    elevation: 0,
                  ),
                ),
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
                    onPressed: () => changePassword(),
                    child: Text(
                      'Change Your Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.grey[600],
                    elevation: 0,
                  ),
                ),
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
                    onPressed: () => changePhone(),
                    child: Text(
                      'Change Your Phone',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.grey[600],
                    elevation: 0,
                  ),
                ),
              ]),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  height: 2,
                  color: Colors.white,
                ),
              ],
            )),
        SizedBox(
          height: 10,
        ),
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
                                builder: (BuildContext context) => AdminPage(
                                      user: widget.user,
                                    )));
                      },
                      child: Text(
                        'My Products',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.grey[600],
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
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                    },
                    child: Text(
                      'Log out',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.grey[600],
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
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            title: Text(
              'My Cart',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  void _takePicture() async {
    if (widget.user.email == "unregistered@justforlhdb.com") {
      Toast.show("Please login to use this function!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@justforlhdb.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    File _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 300);
    //print(_image.lengthSync());
    if (_image == null) {
      Toast.show("Please take the image", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      print(base64Image);
      http.post(server + "/php/upload_image.php", body: {
        "encoded_string": base64Image,
        "email": widget.user.email,
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
          });
        } else {
          Toast.show("Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
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

  void changeName() {
    if (widget.user.email == "unregistered@justforlhdb.com") {
      Toast.show("Please login to use this function!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@justforlhdb.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your name?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () =>
                        _changeName(nameController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changeName(String name) {
    if (widget.user.email == "unregistered@justforlhdb.com") {
      Toast.show("Please login to use this function!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@justforlhdb.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (name == "" || name == null) {
      Toast.show("Please enter your new name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "name": name,
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.name = name;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePassword() {
    if (widget.user.email == "unregistered@justforlhdb.com") {
      Toast.show("Please login to use this function!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@justforlhdb.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController passController = TextEditingController();
    TextEditingController pass2Controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your password?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      )),
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      controller: pass2Controller,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => updatePassword(
                        passController.text, pass2Controller.text)),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  updatePassword(String pass1, String pass2) {
    if (pass1 == "" || pass2 == "") {
      Toast.show("Please enter your password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pass2;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePhone() {
    if (widget.user.email == "unregistered@justforlhdb.com") {
      Toast.show("Please login to use this function!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@justforlhdb.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController phoneController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your phone?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'New Phone Number',
                    icon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () =>
                        _changePhone(phoneController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changePhone(String phone) {
    if (phone == "" || phone == null || phone.length < 9) {
      Toast.show("Please enter your new phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.phone = phone;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }
}
