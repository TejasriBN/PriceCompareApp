import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pricecompare/models/product.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductTile extends StatelessWidget {

  final ProductData product;
  ProductTile({this.product});
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

    return Padding(
        padding: EdgeInsets.only(left: 10.0,right: 20.0,top: 5.0),

        child:

        InkWell(
            onTap: (){
            browse(product.url);
            },

            borderRadius: BorderRadius.circular(15.0),
            highlightColor: product.url.contains('amazon') ?  Colors.greenAccent : Colors.blue,

            child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(

                      child: Row(
                          children: [
                            ClipRRect(

                              child: Image.network(
                                  product.imageurl,
                                  //fit: BoxFit.cover,
                                  height: 70.0,
                                  width: 70.0
                              ),
                            ),
                            SizedBox(width: 10.0),
                            // Row(
                            //   children: [
                            //         product.url.contains('amazon') ? Text("Amazon") : Text("Flipkart")
                            //
                            //
                            //   ],
                            // ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      // margin: const EdgeInsets.all(10.0),
                                      // color: Colors.amber[600],
                                      width: 140.0,
                                      child: AutoSizeText(
                                        product.name,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      )
                                  ),
                                  SizedBox(height: 3.0),
                                  Text(
                                      product.price.toString(),
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
                              initialRating: product.rating,
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
                                product.rating.toString(),
                                style: TextStyle(
                                    fontSize: 12.0
                                )
                            )
                          ],
                        ),
                        SizedBox(height: 7.0),
                        Text(
                            product.reviews.toString()+' reviews',
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
  }
}