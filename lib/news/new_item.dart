import 'package:cloud_firestore/cloud_firestore.dart';

class NewsItem {
  String get title => _document['title'];
  String get image => _document['image'];
  String get data => _document['data'];
  String get author => _document['author'];
  Timestamp get create_date => _document['create_date'];
  final DocumentSnapshot _document;

  NewsItem(this._document);
}
