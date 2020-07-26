import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wedding/Colors.dart';
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
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
              CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                  padding: EdgeInsets.all(10.0),
                ),
                imageUrl: item.image,
                fit: BoxFit.cover,
              ),
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