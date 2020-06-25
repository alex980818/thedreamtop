import 'dart:convert';
import 'product.dart';
import 'productdetail.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'cartscreen.dart';
import 'profilescreen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List productdata;
  double screenHeight, screenWidth;
  bool _visible = false;
  bool _visible1 = false;
  int curnumber = 1;
  int _currentIndex = 0;
  int index;
  String curr = "Recent";
  String titlecenter = "Loading products...";

  @override
  void initState() {
    super.initState();
    _loadData();
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
            title: Text('Products List'),
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
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                searchProduct(),
                sortProduct(),
                Container(
                  height: 180.0,
                  child: new Carousel(
                    boxFit: BoxFit.cover,
                    images: [
                      AssetImage('assets/images/1.jpg'),
                      AssetImage('assets/images/2.jpg'),
                      AssetImage('assets/images/3.jpg'),
                      AssetImage('assets/images/4.jpg'),
                    ],
                    autoplay: false,
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 1000),
                    dotSize: 4.0,
                  ),
                ),
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
                                        onTap: () => _onProductDetail(
                                          productdata[index]['codeno'],
                                          productdata[index]['brand'],
                                          productdata[index]['model'],
                                          productdata[index]['processor'],
                                          productdata[index]['osystem'],
                                          productdata[index]['graphic'],
                                          productdata[index]['ram'],
                                          productdata[index]['storage'],
                                          productdata[index]['price'],
                                          productdata[index]['quantity'],
                                        ),
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
                                                              "http://justforlhdb.com/thedreamtop/productimage/${productdata[index]['codeno']}.png")))),
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
                            builder: (BuildContext context) => MainScreen()));
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

  // void _loadData() async {
  //  //String urlLoadJobs = "https://justforlhdb.com/thedreamtop/php/load_data.php";
  //   String urlLoadJobs =  "https://grocery.com/grocery/php/load_products.php";
  //   print("load data");
  //   await http.post(urlLoadJobs, body: {}).then((res) {
  //     print("res: $res");
  //     if (res.body == "nodata") {
  //       titlecenter = "No product found";
  //       setState(() {
  //         productdata = null;
  //       });
  //     } else {
  //       setState(() {
  //         var extractdata = json.decode(res.body);
  //         productdata = extractdata["products"];
  //         print("productdata = $productdata");
  //       });
  //     }
  //   }).catchError((err) {
  //     print("Error $err");
  //   });
  // }

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

  void _onProductDetail(
    String code,
    String brand,
    String model,
    String processor,
    String osystem,
    String graphic,
    String ram,
    String storage,
    String price,
    String quantity,
  ) {
    Product product = new Product(
      code: code,
      brand: brand,
      model: model,
      processor: processor,
      osystem: osystem,
      graphic: graphic,
      ram: ram,
      storage: storage,
      price: price,
      quantity: quantity,
    );
    print(productdata);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductDetail(product: product, user: widget.user)));
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
}
