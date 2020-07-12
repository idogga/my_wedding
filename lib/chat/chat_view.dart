import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Colors.dart';
import 'chat_screen.dart';

class ChatView extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  ChatView({Key key, @required this.peerId, @required this.peerAvatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
      ),
    );
  }
}