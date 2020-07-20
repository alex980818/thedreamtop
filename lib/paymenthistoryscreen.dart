import 'dart:convert';

import 'package:flutter/material.dart';
import 'orderdetailscreen.dart';
import 'package:http/http.dart' as http;
import 'order.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;

  String titlecenter = "Loading payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      // backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.black,
        
        title: Text('Payment History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          _paymentdata == null
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
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: InkWell(
                                onTap: () => loadOrderDetails(index),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1),
                                  child: Card(
                                    elevation: 2,
                                    // color: Colors.grey,
                                    child: Table(
                                      defaultColumnWidth:
                                                  FlexColumnWidth(1),
                                              columnWidths: {
                                                0: FlexColumnWidth(0.1),
                                                1: FlexColumnWidth(0.1),
                                              },
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 30,
                                                  child: Text("Total Amount ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            TableCell(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 30,
                                                  child: Text(
                                                    "RM " +
                                                        _paymentdata[index]
                                                            ['total'],
                                                    style: TextStyle(
                                                        color: Colors.grey[900]),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 30,
                                                  child: Text("Order ID ",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 30,
                                                child: Text(
                                                  _paymentdata[index]
                                                      ['orderid'],
                                                  style: TextStyle(
                                                      color: Colors.grey[900]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 30,
                                                  child: Text("Bill ID ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 30,
                                                child: Text(
                                                  _paymentdata[index]['billid'],
                                                  style: TextStyle(
                                                      color: Colors.grey[900]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 30,
                                                  child: Text("Place on ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black))),
                                            ),
                                            TableCell(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 30,
                                                child: Text(
                                                  f.format(DateTime.parse(
                                                      _paymentdata[index]
                                                          ['date'])),
                                                  style: TextStyle(
                                                      color: Colors.grey[900]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )));
                      }))
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://justforlhdb.com/thedreamtop/php/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailScreen(
                  order: order,
                )));
  }
}
