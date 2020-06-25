import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'mainscreen.dart';
import 'paymentscreen.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartData;
  double screenHeight, screenWidth;
  double _weight = 0.0, _totalprice = 0.0;
  Position _currentPosition;
  String curaddress;
  GoogleMapController gmcontroller;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String label;
  double deliverycharge;
  double amountpayable;
  String titlecenter = "Loading your cart";

  @override
  void initState() {
    super.initState();
    _getLocation();
    //_getCurrentLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('My Cart'),
            actions: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.deleteEmpty),
                onPressed: () {
                  deleteAll();
                },
              ),
            ]),
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Container(
                child: Column(
              children: <Widget>[
                cartData == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        titlecenter,
                        style: TextStyle(
                            color: Color.fromRGBO(101, 255, 218, 50),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))))
                    : Expanded(
                        child: ListView.builder(
                            itemCount:
                                cartData == null ? 1 : cartData.length + 2,
                            itemBuilder: (context, index) {
                              if (index == cartData.length) {
                                return Column(children: <Widget>[
                                  InkWell(
                                    onLongPress: () => {print("Delete")},
                                    child: Card(
                                      //color: Colors.yellow,
                                      elevation: 10,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]);
                              }

                              if (index == cartData.length + 1) {
                                return Container(
                                    alignment: Alignment.bottomCenter,
                                    //height: screenHeight / 3,
                                    child: Card(
                                      elevation: 5,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  50, 0, 50, 0),
                                              child: Table(
                                                  defaultColumnWidth:
                                                      FlexColumnWidth(1.0),
                                                  columnWidths: {
                                                    0: FlexColumnWidth(7),
                                                    1: FlexColumnWidth(3),
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 20,
                                                            child: Text(
                                                                "Total Amount ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black))),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          height: 20,
                                                          child: Text(
                                                              "RM" +
                                                                      amountpayable
                                                                          .toStringAsFixed(
                                                                              2) ??
                                                                  "0.0",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                      ),
                                                    ]),
                                                  ])),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            minWidth: 200,
                                            height: 40,
                                            child: Text('Check out'),
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            elevation: 10,
                                            onPressed: makePayment,
                                          ),
                                        ],
                                      ),
                                    ));
                              }
                              index -= 0;

                              return Card(
                                  elevation: 10,
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              height: screenHeight / 8,
                                              width: screenWidth / 5,
                                              child: ClipRect(
                                                  child: CachedNetworkImage(
                                                fit: BoxFit.scaleDown,
                                                imageUrl:
                                                    "http://justforlhdb.com/thedreamtop/productimage/${cartData[index]['codeno']}.png",
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              )),
                                            ),
                                            
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 1, 10, 1),
                                            child: SizedBox(
                                                width: 2,
                                                child: Container(
                                                  height: screenWidth / 3.5,
                                                  color: Colors.grey,
                                                ))),
                                        Container(
                                            width: screenWidth / 1.45,
                                            //color: Colors.blue,
                                            child: Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        cartData[index]
                                                            ['model'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                        maxLines: 1,
                                                      ),
                                                      Text(
                                                        "Available " +
                                                            cartData[index]
                                                                ['quantity'] +
                                                            " unit",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Your Quantity " +
                                                            cartData[index]
                                                                ['cquantity'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 20,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _updateCart(
                                                                      index,
                                                                      "add")
                                                                },
                                                                child: Icon(
                                                                  MdiIcons.plus,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                              Text(
                                                                cartData[index][
                                                                    'cquantity'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _updateCart(
                                                                      index,
                                                                      "remove")
                                                                },
                                                                child: Icon(
                                                                  MdiIcons
                                                                      .minus,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                              "Total RM " +
                                                                  cartData[index]
                                                                      [
                                                                      'yourprice'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                          FlatButton(
                                                            onPressed: () => {
                                                              _deleteCart(index)
                                                            },
                                                            child: Icon(
                                                              MdiIcons.delete,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ])));
                            })),
              ],
            ))));
  }

  Future<bool> _onBackPressed() {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(
                  user: widget.user,
                )));
  }

  void _loadCart() {
    _totalprice = 0.0;
    amountpayable = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadJobs =
        "https://justforlhdb.com/thedreamtop/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print("cart email = " + widget.user.email);
      pr.hide();
      if (res.body == "Cart Empty") {
        print("cart empty");
        //Navigator.of(context).pop(false);
        widget.user.quantity = "0";
        Toast.show("Cart is Empty", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        print("cart1");
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
        }
        amountpayable = _totalprice;

        print(_weight);
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs =
        "https://justforlhdb.com/thedreamtop/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "codeno": cartData[index]['codeno'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(
                    "https://justforlhdb.com/thedreamtop/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                      "codeno": cartData[index]['codeno'],
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  Future<void> makePayment() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyyhhmmss-');
    String orderid = widget.user.email +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(10);
    print("orderid = " + orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: _totalprice.toStringAsFixed(2),
                  orderid: orderid,
                )));
    _loadCart();
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(
                    "https://justforlhdb.com/thedreamtop/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }
}
