import 'package:flutter/material.dart';
import 'package:wedding/news/debug_data.dart';

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
    //final stack =
    //contentstack.Stack('api_key', 'delivery_token', 'environment');
    //final query = stack.contentType('news').entry().query();
    final data = DebugData();
//    await query.find().then((response) {
//      isDataAvailable = true;
//      setState(() {
//        newsList =  response['entries'];
//      });
//    }).catchError((error) {
//      print(error.message.toString());
//    });
    {
    isDataAvailable = true;
    await setState(() {
    newsList = data.items;
    });
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isDataAvailable
            ? Feeds(newsList: this.newsList)
            : Center(child: CircularProgressIndicator()));
  }


}