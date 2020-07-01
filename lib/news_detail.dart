import 'package:flutter/material.dart';

class NewsDetail extends StatelessWidget {

  final String newsTitle;
  final String newsDetail;

  NewsDetail({Key key, @required this.newsTitle, @required this.newsDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          newsTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            child: ListTile(

              subtitle: Container(
                padding: EdgeInsets.all(4),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}