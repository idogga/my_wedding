import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wedding/main.dart';
import 'package:wedding/news/news_data.dart';

import 'feeds.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool isDataAvailable = false;
  var newsList = [];


  @override
  void initState() {
    super.initState();
    _getNews();
  }

  _getNews() async {
    final newsData = NewsData();
    await Firestore.instance
        .collection('news')
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => newsData.add(doc)))
    .onError((x) => print(x));

    isDataAvailable = true;
    await setState(() {
    newsList = newsData.items;
    });
    MyApp.analytics.logViewItemList(itemCategory: "news_load");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isDataAvailable
            ? Feeds(newsList: this.newsList)
            : Center(child: CircularProgressIndicator()));
  }


}