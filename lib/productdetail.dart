// import 'dart:convert';

import 'mainscreen.dart';
import 'product.dart';
import 'user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
// import 'user.dart';

void main() => runApp(ProductDetail());

class ProductDetail extends StatefulWidget {
  final Product product;
  final User user;

  const ProductDetail({Key key, this.product, this.user}) : super(key: key);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1;
  String cartquantity = "0";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blueGrey));
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            backgroundColor: Colors.blueGrey[100],
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('Product Details'),
              backgroundColor: Colors.black,
            ),
            body: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Center(),
                    Container(
                      width: 280,
                      height: 200,
                      child: Image.network(
                        'http://justforlhdb.com/thedreamtop/productimage/${widget.product.code}.jpg',
                      ),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // GridView.count(
                    //   crossAxisCount: 10,
                    // ),
                    //  GridView.count(
                    //           crossAxisCount: 2,
                    //           // childAspectRatio:
                    //           //     (screenWidth / screenHeight) / 0.8,
                    //           children:
                    //               List.generate(10, (index) {
                    //             return Container(
                    //                 child: Card(

                    //  ));})),
                    Card(
                      color: Colors.blueGrey[800],
                      elevation: 20,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Table(children: [
                              TableRow(children: [
                                Text("Brand:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.brand,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("Model:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.model,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("Processor:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.processor,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("Operating System:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.osystem,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("Graphic Card:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.graphic,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("RAM:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.ram,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("Storage:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.storage,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("Price:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.price,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                              TableRow(children: [
                                Text("Quantity Left:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                                Text(widget.product.quantity,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blueGrey[100])),
                              ]),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        width: 150,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                MdiIcons.cart,
                                color: Colors.white,
                              ),
                              Text(
                                " Add to cart",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          color: Colors.red[700],
                          textColor: Colors.white,
                          elevation: 5,
                          onPressed: _addCart,
                        ),
                      ),
                    )
                  ],
                ))));
  }

  void _addCart() {
    if (widget.user.email == "unregistered@justforlhdb.com") {
      Toast.show("Please login to use this function!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }else if (widget.user.email == "admin@justforlhdb.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                title: new Text("Add " + widget.product.model + " to Cart?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Select quantity of product",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () => {
                                newSetState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                })
                              },
                              child: Icon(
                                MdiIcons.minus,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FlatButton(
                              onPressed: () => {
                                newSetState(() {
                                  if (quantity <
                                      (int.parse(widget.product.quantity) -
                                          2)) {
                                    quantity++;
                                  } else {
                                    Toast.show(
                                        "Quantity not available", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  }
                                })
                              },
                              child: Icon(
                                MdiIcons.plus,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        _addtoCart();

                      
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      )),
                  MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      )),
                ],
              );
            },
          );
        });
  }

  void _addtoCart() {
    try {
      int cquantity = int.parse(widget.product.quantity);
      print(cquantity);
      print(widget.product.code);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs =
            "https://justforlhdb.com/thedreamtop/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "code": widget.product.code,
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.hide();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              Navigator.pop(context);
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });
        pr.hide();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }



  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(user: widget.user),
        ));
    return Future.value(false);
  }
}
