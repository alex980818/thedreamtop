import 'dart:convert';

import 'package:flutter/material.dart';
import 'order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List _orderdetails;
  String titlecenter = "Loading order details...";
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(children: <Widget>[
          
          _orderdetails == null
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
                      //Step 6: Count the data
                      itemCount:
                          _orderdetails == null ? 0 : _orderdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                                onTap: null,
                                child: Card(
                                  elevation: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                     Card(
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
                                                    "http://justforlhdb.com/thedreamtop/productimage/${ _orderdetails[index]['codeno']}.png",
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
                                            width: screenWidth / 1.55,
                                            //color: Colors.blue,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        _orderdetails[index]['brand'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
                                                        maxLines: 1,
                                                      ),
                                                      Text(
                                                        
                                                            _orderdetails[index]
                                                                ['model'],
                                                                overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Quantity: "+
                                                            _orderdetails[index]
                                                                ['cquantity'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        "RM " +
                                                            _orderdetails[index]
                                                                ['price'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                     
                                                  
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ])))
                                      // Expanded(
                                      //     flex: 1,
                                      //     child: Text(
                                      //       (index + 1).toString(),
                                      //       style:
                                      //           TextStyle(color: Colors.blue),
                                      //     )),
                                      // Expanded(
                                      //     flex: 2,
                                      //     child: Text(
                                      //       _orderdetails[index]['brand'],
                                      //       style:
                                      //           TextStyle(color: Colors.blue),
                                      //     )),
                                      // Expanded(
                                      //     flex: 4,
                                      //     child: Column(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: <Widget>[
                                      //         Text(
                                      //           _orderdetails[index]['model'],
                                      //           overflow: TextOverflow.ellipsis,
                                      //           style: TextStyle(
                                      //               color: Colors.blue),
                                      //         ),
                                      //         Text(
                                      //           _orderdetails[index]
                                      //               ['cquantity'],
                                      //           style: TextStyle(
                                      //               color: Colors.blue),
                                      //         ),
                                      //       ],
                                      //     )),
                                      // Expanded(
                                      //   child: Text(
                                      //     _orderdetails[index]['price'],
                                      //     style: TextStyle(color: Colors.blue),
                                      //   ),
                                      //   flex: 3,
                                      // ),
                                    ],
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  _loadOrderDetails() async {
    String urlLoadJobs =
        "https://justforlhdb.com/thedreamtop/php/load_carthistory.php";
    print("orderid = " + widget.order.orderid);
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
    }).then((res) {
      print("resbody = " + res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
