import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wedding/news/new_item.dart';

import 'news_detail.dart';

class Feeds extends StatelessWidget {
  const Feeds({
    Key key,
    @required this.newsList,
  }) : super(key: key);

  final List<NewsItem> newsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: this.newsList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 4,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetail(
                      newsTitle: newsList[index].title,
                      newsDetail: newsList[index].icon,
                    )),
              );
            },
            title: Text(
              newsList[index].title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            leading: CircleAvatar(
              radius: 25.0,
              //backgroundImage: ImageIcon(Icons.add_box), // AssetImage('assets/red_logo.png'),
              backgroundColor: Colors.red,
            ),
            subtitle: Container(
              padding: EdgeInsets.all(4),
              child: Text(
                newsList[index].icon,
                style: TextStyle(fontSize: 15),
                maxLines: 2,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
            ),
          ),
        );
      },
    );
  }
}