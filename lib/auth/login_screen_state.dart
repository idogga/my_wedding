import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wedding/home_page/home_page.dart';

import '../Colors.dart';
import '../loading.dart';
import 'login_screen.dart';

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  FlutterToast flutterToast;
  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    flutterToast = new FlutterToast(context);
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {

    try{
      prefs = await SharedPreferences.getInstance();
      this.setState(() {
        isLoading = true;
      });

      GoogleSignInAccount googleUser = await googleSignIn.signIn();

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        // Check is already sign up
        final QuerySnapshot result =
        await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          // Update data to server if new user
          Firestore.instance.collection('users').document(firebaseUser.uid).setData({
            'nickname': firebaseUser.displayName,
            'photoUrl': firebaseUser.photoUrl,
            'id': firebaseUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': 'artyom_and_kate'
          });

          // Write data to local
          currentUser = firebaseUser;
          await prefs.setString('id', currentUser.uid);
          await prefs.setString('nickname', currentUser.displayName);
          await prefs.setString('photoUrl', currentUser.photoUrl);
          await prefs.setString('chattingWith', 'artyom_and_kate');
        } else {
          // Write data to local
          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('nickname', documents[0]['nickname']);
          await prefs.setString('photoUrl', documents[0]['photoUrl']);
          await prefs.setString('aboutMe', documents[0]['aboutMe']);
          await prefs.setString('chattingWith',  documents[0]['chattingWith']);
        }
        _showToast("Авторизация прошла успешно");
        this.setState(() {
          isLoading = false;
        });
        print('Авторизация прошла успешно');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(currentUserId: firebaseUser.uid)));
      } else {
        _showToast("Не удалось войти");
        this.setState(() {
          isLoading = false;
        });
      }
    }
    catch (e){
      _showToast(e);
    }

  }
  
  catch (e){
_showToast(e);
  }
  }

  _showToast(String text) {
    print(text);
    
    var toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );


    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Добро пожаловать!',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'Войти с помощью Google',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            ),
          ],
        ));

  }
}