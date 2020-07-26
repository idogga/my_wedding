import 'package:flutter/material.dart';
import 'package:wedding/news/new_item.dart';

class NewsDetail extends StatelessWidget {

  final NewsItem item;

  NewsDetail({Key key, @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.title,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.create_date.toDate().toIso8601String(),
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.right,
                ),
              ),Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.data,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(item.image),
                backgroundColor: Colors.red,),
              Container(
                padding: EdgeInsets.all(8),
              child: Text(
                item.author,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.right,
              ),
              ),
            ],
            ),
          ),
        ),
    );
  }
}