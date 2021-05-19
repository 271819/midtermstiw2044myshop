import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midtermstiw2044myshop/newproduct.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Material',
      home: MyShop());
  }
}

class MyShop extends StatefulWidget {
  @override
  _MyShopState createState() => _MyShopState();
}

class _MyShopState extends State<MyShop> {

  double screenHeight, screenWidth;
  List productlist;
  String _titlecenter = "Loading...";
  @override
  void initState() {
    super.initState();
    _loadproduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
        ),
        body: Center(
          child: Container(
              child: Column(
            children: [
      productlist == null
          ? Flexible(child: Center(child: Text(_titlecenter)))
          : Flexible(
              child: Center(
                  child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio:
                    (screenWidth / screenHeight) / 0.9,
                children:
                    List.generate(productlist.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(7),
                    child: Card(
                      elevation:10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          
                          height: screenHeight / 4.5,
                          width: screenWidth / 1.2,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://crimsonwebs.com/s271819/myshop/images/${productlist[index]['id']}.png",
                          ),
                        ),
                        Padding(padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text("Name: "+productlist[index]['name'],style: TextStyle(fontSize: 20))),
                          SizedBox(height:10),
                        Padding(padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text("Type: "+productlist[index]['type'],style: TextStyle(fontSize: 20))),
                          SizedBox(height:10),
                        Padding(padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text("Price:RM "+productlist[index]['price'],style: TextStyle(fontSize: 20))),
                          SizedBox(height:10),
                        Padding(padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text("Quantity: "+productlist[index]['qty'],style: TextStyle(fontSize: 20))),
                      ],
                    )),
              );
            }))
          )
        ),
      ],
    )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          onPressed: addItem,
        ));
  }

  void addItem() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => NewProduct()));
  }

  void _loadproduct() {
    http.post(
        Uri.parse("https://crimsonwebs.com/s271819/myshop/php/loadproduct.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "Sorry no product";
        return;
      } else {
        var jsondata = json.decode(response.body);
        productlist = jsondata["products"];
        setState(() {});
        print(productlist);
      }
    });
  }
}
