
import 'package:cloud_firestore/cloud_firestore.dart';

import 'new_item.dart';

class NewsData{
  List<NewsItem> get items => _items;
  List<NewsItem> _items;
  NewsData(){
    _items = List<NewsItem>();
  }

  void add(DocumentSnapshot document){
    print(document.data.keys.join(","));
    var news = NewsItem(document);
    _items.add(news);
  } 
}