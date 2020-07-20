import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'editproduct.dart';
import 'newproduct.dart';
import 'product.dart';
import 'user.dart';
import 'mainscreen.dart';
import 'profilescreen.dart';
import 'productdetail.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'cartscreen.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AdminPage extends StatefulWidget {
  final User user;
  final ProductDetail product;

  const AdminPage({
    Key key,
    this.user,
   this.product,
  }) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  bool _visible1 = false;
  int _currentIndex = 0;
  // bool _visible2 = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  String titlecenter = "Loading products...";
  var _tapPosition;
  String server = "https://justforlhdb.com/thedreamtop";
  String scanCode;
  String curr = "Recent";

  @override
  void initState() {
    super.initState();
    _loadData();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.red));
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text('Manage Products'),
            backgroundColor: Colors.black87,
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon:
                    _visible ? new Icon(Icons.search) : new Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    if (_visible) {
                      _visible = false;
                    } else {
                      _visible = true;
                    }
                  });
                },
              ),
              IconButton(
                color: Colors.white,
                icon: _visible1
                    ? new Icon(Icons.expand_more)
                    : new Icon(Icons.more_horiz),
                onPressed: () {
                  setState(() {
                    if (_visible1) {
                      _visible1 = false;
                    } else {
                      _visible1 = true;
                    }
                  });
                },
              ),
            ],
          ),
          body:  RefreshIndicator(
            key: refreshKey,
            color: Color.fromRGBO(101, 255, 218, 50),
            onRefresh: () async {
              await refreshList();
            },
            child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                searchProduct(),
                sortProduct(),
                productdata == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        titlecenter,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))))
                    : Flexible(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.7,
                            children:
                                List.generate(productdata.length, (index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  //margin: EdgeInsets.all(5),
                                  elevation: 10,
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () => _showPopupMenu(index),
                                        onTapDown: _storePosition,
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () =>
                                                  _onImageDisplay(index),
                                              child: Container(
                                                  height: screenWidth / 4,
                                                  width: screenWidth / 2.5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                          color: Colors
                                                              .blueAccent),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              "http://justforlhdb.com/thedreamtop/productimage/${productdata[index]['codeno']}.jpg")))),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  productdata[index]['brand'],
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  productdata[index]['model'],
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Quantity Left: " +
                                                      productdata[index]
                                                          ['quantity'],
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "RM " +
                                                      productdata[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )));
                            })))
              ],
            ),
          ),),
           floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.new_releases),
              label: "New Product",
              labelBackgroundColor: Colors.white,
              onTap: createNewProduct),
          SpeedDialChild(
              child: Icon(MdiIcons.barcodeScan),
              label: "Scan Product",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => scanProductDialog()),
          SpeedDialChild(
              child: Icon(Icons.report),
              label: "Product Report",
              labelBackgroundColor: Colors.white, //_changeLocality()
              onTap: () => null),
        ],
      ),
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
                            builder: (BuildContext context) => MainScreen(user: widget.user)));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CartScreen(
                                  user: widget.user,
                                )));
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
        ));
  }

  void scanProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Select scan options:",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanBarcodeNormal,
                  elevation: 5,
                  child: Text(
                    "Bar Code",
                    style: TextStyle(color: Colors.black),
                  )),
              MaterialButton(
                  color: Color.fromRGBO(101, 255, 218, 50),
                  onPressed: scanQR,
                  elevation: 5,
                  child: Text(
                    "QR Code",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
        );
      },
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanCode = "";
      } else {
        scanCode = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanCode);
      }
    });
  }

  void _loadSingleProduct(String scanCode) {
    String urlLoadJobs = server + "/php/load_data.php";
    http.post(urlLoadJobs, body: {
      "code": scanCode,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        Toast.show("Not found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          print(productdata);
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        scanCode = "";
      } else {
        scanCode = barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleProduct(scanCode);
      }
    });
  }

  void _loadData() async {
    String urlLoadJobs =
        "https://justforlhdb.com/thedreamtop/php/load_data.php";
    //String urlLoadJobs = "https://slumberjer.com/grocery/php/load_products.php";
    print("load data");
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        //cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          print("if res: $res");
          productdata = null;
        });
      } else {
        setState(() {
          print("else res: $res");
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          print("Productdata: $productdata");
          // cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  // void _sortItem(String type) {
  //   try {
  //     ProgressDialog pr = new ProgressDialog(context,
  //         type: ProgressDialogType.Normal, isDismissible: true);
  //     pr.style(message: "Searching...");
  //     pr.show();
  //     String urlLoadJobs = server + "/php/load_products.php";
  //     http.post(urlLoadJobs, body: {
  //       "type": type,
  //     }).then((res) {
  //       if (res.body == "nodata") {
  //         setState(() {
  //           curtype = type;
  //           titlecenter = "No product found";
  //           productdata = null;
  //         });
  //         pr.dismiss();
  //         return;
  //       } else {
  //         setState(() {
  //           curtype = type;
  //           var extractdata = json.decode(res.body);
  //           productdata = extractdata["products"];
  //           FocusScope.of(context).requestFocus(new FocusNode());
  //           pr.dismiss();
  //         });
  //       }
  //     }).catchError((err) {
  //       print(err);
  //       pr.dismiss();
  //     });
  //     pr.dismiss();
  //   } catch (e) {
  //     Toast.show("Error", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   }
  // }

  // void _sortItembyName(String prname) {
  //   try {
  //     print(prname);
  //     ProgressDialog pr = new ProgressDialog(context,
  //         type: ProgressDialogType.Normal, isDismissible: true);
  //     pr.style(message: "Searching...");
  //     pr.show();
  //     String urlLoadJobs = server + "/php/load_products.php";
  //     http
  //         .post(urlLoadJobs, body: {
  //           "name": prname.toString(),
  //         })
  //         .timeout(const Duration(seconds: 4))
  //         .then((res) {
  //           if (res.body == "nodata") {
  //             Toast.show("Product not found", context,
  //                 duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //             pr.dismiss();
  //             FocusScope.of(context).requestFocus(new FocusNode());
  //             return;
  //           }
  //           setState(() {
  //             var extractdata = json.decode(res.body);
  //             productdata = extractdata["products"];
  //             FocusScope.of(context).requestFocus(new FocusNode());
  //             curtype = prname;
  //             pr.dismiss();
  //           });
  //         })
  //         .catchError((err) {
  //           pr.dismiss();
  //         });
  //     pr.dismiss();
  //   } on TimeoutException catch (_) {
  //     Toast.show("Time out", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   } on SocketException catch (_) {
  //     Toast.show("Time out", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   } catch (e) {
  //     Toast.show("Error", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   }
  // }

  gotoCart() {
    if (widget.user.email == "unregistered") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
    }
  }

  

  _onProductDetail(int index) async {
    print("code no = "+productdata[index]['codeno']);
    Product product = new Product(
        code: productdata[index]['codeno'],
      brand: productdata[index]['brand'],
      model:productdata[index]['model'],
      processor: productdata[index]['processor'],
      osystem: productdata[index]['osystem'],
      graphic: productdata[index]['graphic'],
      ram: productdata[index]['ram'],
      storage: productdata[index]['storage'],
      price: productdata[index]['price'],
      quantity: productdata[index]['quantity']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditProduct(
                  user: widget.user,
                  product: product,
                )));
    _loadData();
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _onProductDetail(index)},
              child: Text(
                "Update Product?",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _deleteProductDialog(index)},
              child: Text(
                "Delete Product?",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deleteProductDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete laptop " + productdata[index]['model'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                print("1");
                Navigator.of(context).pop();
                print("2 $index");
                _deleteProduct(index);
                print("3");
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting product...");
    pr.show();
    String scanCode = productdata[index]['codeno'];
    print("scanCode:" + scanCode);
    http.post(server + "/php/delete_product.php", body: {
      "codeno": scanCode,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        
        // Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct()));
    _loadData();
  }

  searchProduct() {
    TextEditingController _searchController = new TextEditingController();
    return Visibility(
        visible: _visible,
        child: Container(
          color: Colors.yellow[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                  child: Container(
                color: Colors.white,
                height: 30,
                child: TextField(
                    autofocus: false,
                    controller: _searchController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        border: OutlineInputBorder())),
              )),
              Flexible(
                  child: MaterialButton(
                      color: Colors.blue[200],
                      onPressed: () =>
                          {_searchItembyName(_searchController.text)},
                      elevation: 5,
                      child: Text(
                        "Search Product",
                        style: TextStyle(color: Colors.black),
                      )))
            ],
          ),
        ));
  }

  sortProduct() {
    return Visibility(
        visible: _visible1,
        child: Container(
          color: Colors.yellow[100],
          child: Column(
            children: <Widget>[
              Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => _sortItembyBrand("Recent"),
                              color: Colors.blue[100],
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(
                                    MdiIcons.update,
                                    color: Colors.blueGrey[900],
                                  ),
                                  Text(
                                    "Recent",
                                    style:
                                        TextStyle(color: Colors.blueGrey[900]),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => _sortItembyBrand("Asus"),
                              color: Colors.blue[100],
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/asus.png',
                                    width: 100,
                                    height: 25,
                                  ),
                                  Text(
                                    "Asus",
                                    style:
                                        TextStyle(color: Colors.blueGrey[900]),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => _sortItembyBrand("Acer"),
                              color: Colors.blue[100],
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/acer.png',
                                    width: 100,
                                    height: 25,
                                  ),
                                  Text(
                                    "Acer",
                                    style:
                                        TextStyle(color: Colors.blueGrey[900]),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => _sortItembyBrand("Lenovo"),
                              color: Colors.blue[100],
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/lenovo.png',
                                    width: 100,
                                    height: 25,
                                  ),
                                  Text(
                                    "Lenovo",
                                    style:
                                        TextStyle(color: Colors.blueGrey[900]),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () => _sortItembyBrand("HP"),
                              color: Colors.blue[100],
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/hp.png',
                                    width: 100,
                                    height: 25,
                                  ),
                                  Text(
                                    "HP",
                                    style:
                                        TextStyle(color: Colors.blueGrey[900]),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _sortItembyBrand(String brand) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://justforlhdb.com/thedreamtop/php/load_data.php";
      http.post(urlLoadJobs, body: {
        "brand": brand,
      }).then((res) {
        setState(() {
          curr = brand;
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.dismiss();
        });
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _searchItembyName(String productname) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://justforlhdb.com/thedreamtop/php/load_data.php";
      http.post(urlLoadJobs, body: {
        "model": productname,
      }).then((res) {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.dismiss();
        });
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Container(
          height: screenWidth / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 2,
                  width: screenWidth / 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "http://justforlhdb.com/thedreamtop/productimage/${productdata[index]['codeno']}.png")))),
            ],
          ),
        ));
      },
    );
  }

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

  
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    //_getLocation();
    _loadData();
    return null;
  }
}
