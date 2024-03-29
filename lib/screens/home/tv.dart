import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pricecompare/models/product.dart';
import 'package:pricecompare/screens/home/home.dart';
import 'package:pricecompare/screens/home/phone.dart';
import 'package:pricecompare/services/auth.dart';
import 'package:pricecompare/services/database.dart';
import 'package:pricecompare/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class tv extends StatelessWidget {
  Future<void> browse(String url) async{
    if(await canLaunch(url)){
      await launch(url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key':'header_value'},
      );
    }else{
      throw 'Could not launch url';
    }
  }
  final AuthService _auth = AuthService();
  final bool loading = false;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override

  Widget build(BuildContext context) {


    return StreamProvider<List<ProductData>>.value(
      value: DatabaseService().products,

      child: Scaffold(
        backgroundColor: Colors.white,

        key: _drawerKey, // assign key to Scaffold
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  '\n    Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[400],

                ),
              ),
              ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Loading();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  }
              ),
              ListTile(
                title: Text('Television'),
                onTap: () {
                  Loading();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => tv(),
                  ),
                  );
                }
              ),
              ListTile(
                title: Text('Mobiles'),
                onTap: () {
                  Loading();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => phone(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        
        appBar: AppBar(

          title: Text('Vertino'),
          backgroundColor: Colors.deepPurple[400],
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              //label: Text('Search'),
              onPressed: () async {
                // Loading();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CloudFirestoreSearch()),
                );
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),


          ],

        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('product')
              .where("searchKeywords", arrayContains: "tv" )
              .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: Loading())
                : ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data.documents[index];
                return Padding(
                    padding: EdgeInsets.only(left: 10.0,right: 20.0,top: 5.0),

                    child:

                    InkWell(
                        onTap: (){
                          browse(data['url']);
                        },
                        borderRadius: BorderRadius.circular(15.0),
                        highlightColor: data['url'].contains('amazon') ?  Colors.greenAccent : Colors.blue,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  child: Row(
                                      children: [
                                        ClipRRect(

                                          child: Image.network(
                                              data['imageurl'],
                                              height: 70.0,
                                              width: 70.0
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  width: 140.0,
                                                  child: AutoSizeText(
                                                    data['name'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                    maxLines: 2,
                                                  )
                                              ),
                                              SizedBox(height: 3.0),
                                              Text(
                                                  data['price'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 11.5,
                                                      color: Colors.grey
                                                  )
                                              )
                                            ]
                                        ),
                                      ]
                                  )
                              ),
                              Column(
                                  children: [
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: data['rating'],
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize : 11.0,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        SizedBox(width: 3.0),
                                        Text(
                                            data['rating'].toString(),
                                            style: TextStyle(
                                                fontSize: 12.0
                                            )
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                        data['reviews'].toString()+' reviews',
                                        style: TextStyle(
                                            fontSize: 11.0
                                        )
                                    )

                                  ]
                              )
                            ]
                        )
                    )
                );
              },
            );
          },
        ),
      ),
    );
  }
}
class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";
  Future<void> browse(String url) async{
    if(await canLaunch(url)){
      await launch(url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key':'header_value'},
      );
    }else{
      throw 'Could not launch url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            //Loading();
            Navigator.of(context).pop();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Home()),
            // );
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Enter Product'),
            onChanged: (val) {
              setState(() {
                name = val.toLowerCase();
                print(name);
              });
            },
          ),
        ),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? Firestore.instance
            .collection('product')
            .where("searchKeywords", arrayContains: name )
            .snapshots()
            : Firestore.instance.collection("product").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: Loading())
              : ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data.documents[index];
              return Padding(
                  padding: EdgeInsets.only(left: 10.0,right: 20.0,top: 5.0),

                  child:

                  InkWell(
                      onTap: (){
                        browse(data['url']);
                      },
                      borderRadius: BorderRadius.circular(15.0),
                      highlightColor: data['url'].contains('amazon') ?  Colors.greenAccent : Colors.blue,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: Row(
                                    children: [
                                      ClipRRect(

                                        child: Image.network(
                                            data['imageurl'],
                                            height: 70.0,
                                            width: 70.0
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 140.0,
                                                child: AutoSizeText(
                                                  data['name'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                )
                                            ),
                                            SizedBox(height: 3.0),
                                            Text(
                                                data['price'].toString(),
                                                style: TextStyle(
                                                    fontSize: 11.5,
                                                    color: Colors.grey
                                                )
                                            )
                                          ]
                                      ),
                                    ]
                                )
                            ),
                            Column(
                                children: [
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating: data['rating'],
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize : 11.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      SizedBox(width: 3.0),
                                      Text(
                                          data['rating'].toString(),
                                          style: TextStyle(
                                              fontSize: 12.0
                                          )
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 7.0),
                                  Text(
                                      data['reviews'].toString()+' reviews',
                                      style: TextStyle(
                                          fontSize: 11.0
                                      )
                                  )

                                ]
                            )
                          ]
                      )
                  )
              );
            },
          );
        },
      ),
    );
  }

}

