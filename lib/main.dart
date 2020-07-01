import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:wedding/Colors.dart';
import 'file:///C:/Users/User/AndroidStudioProjects/wedding/lib/tabs/tab_bar.dart';
import 'package:wedding/news_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();
    analytics.logEvent(name: "open app");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MAIN_COLOR,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
int currentPage = 0;

GlobalKey bottomNavigationKey = GlobalKey();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Fancy Bottom Navigation"),
    ),
    body: Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: _getPage(currentPage),
      ),
    ),
    bottomNavigationBar: FancyBottomNavigation(
      tabs: [
        TabData(
            iconData: Icons.home,
            title: "Home",
            onclick: () {
              final FancyBottomNavigationState fState =
                  bottomNavigationKey.currentState;
              fState.setPage(2);
            }),
        TabData(
            iconData: Icons.search,
            title: "Search",
            onclick: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewsPage()))),
        TabData(iconData: Icons.shopping_cart, title: "Basket")
      ],
      initialSelection: 1,
      key: bottomNavigationKey,
      onTabChangedListener: (position) {
        setState(() {
          currentPage = position;
        });
      },
    ),
  );
}

_getPage(int page) {
  switch (page) {
    case 0:
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("This is the home page"),
          RaisedButton(
            child: Text(
              "Start new page",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewsPage()));
            },
          ),
          RaisedButton(
            child: Text(
              "Change to page 3",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              final FancyBottomNavigationState fState =
                  bottomNavigationKey.currentState;
              fState.setPage(2);
            },
          )
        ],
      );
    case 1:
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("This is the search page"),
          RaisedButton(
            child: Text(
              "Start new page",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewsPage()));
            },
          )
        ],
      );
    default:
      return NewsPage();
  }
}
}