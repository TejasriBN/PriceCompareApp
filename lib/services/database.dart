import 'package:pricecompare/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String name;
  DatabaseService({ this.name });

  // collection reference
  final CollectionReference productCollection = Firestore.instance.collection('product');
  final CollectionReference productCollection2 = Firestore.instance.collection('flipkart');

  // brew list from snapshot
  List<ProductData> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return ProductData(
        imageurl: doc.data['imageurl'] ?? '0',
        name: doc.data['name'] ?? '',
        price: doc.data['price'].toDouble() ?? 0.0,
        rating: doc.data['rating'].toDouble() ?? 0.0,
        reviews: doc.data['reviews'] ?? 0,
        url: doc.data['url'] ?? '0',
      );
    }).toList();
  }

  // get brews stream
  Stream<List<ProductData>> get products {
    return Firestore.instance.collection('product').snapshots()
        .map(_productListFromSnapshot);
  }
  Stream<List<ProductData>> get products2 {
    return Firestore.instance.collection('flipkart').snapshots()
        .map(_productListFromSnapshot);
  }


}

