
import 'package:flutter/material.dart';

import 'home_page_state.dart';

class HomePage extends StatefulWidget {
  final String currentUserId;
  HomePage({Key key, @required this.currentUserId}) : super(key: key);

  @override
  HomePageState createState() => HomePageState(currentUserId: currentUserId);
}