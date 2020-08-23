import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedding/auth/login_screen.dart';
import 'package:wedding/user/user_page.dart';

import '../Colors.dart';
import '../loading.dart';
import '../main.dart';

class UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  String _avatar_link =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRdtkvepjyc_AhNH06RBHK7WUfuLTM2g8revg&usqp=CAU';

  final FocusNode myFocusNode = FocusNode();

  String _name = '';
  String _about_me = '';
  bool _is_loading = false;
  int currentPage = 0;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  void _updateState() async {
    prefs = await SharedPreferences.getInstance();
    _avatar_link = prefs.getString('photoUrl') ?? '';
    _name = prefs.getString('nickname') ?? '';
    _about_me = prefs.getString('aboutMe') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: themeColor.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            left: (MediaQuery.of(context).size.width - 350) / 2,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  clipBehavior: Clip.hardEdge,
                  child: Stack(fit: StackFit.loose, children: <Widget>[
                    CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                        width: 150.0,
                        height: 150.0,
                        padding: EdgeInsets.all(75.0),
                        decoration: BoxDecoration(
                            color: greyColor2,
                            borderRadius: BorderRadius.all(
                              Radius.circular(75.0),
                            ),
                            boxShadow: [
                              BoxShadow(blurRadius: 7, color: greyColor)
                            ]),
                      ),
                      errorWidget: (context, url, error) => Material(
                        child: Image.asset(
                          'images/img_not_available.jpeg',
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(75.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: _avatar_link,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 100.0, right: 0.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                                onTap: _onChangePhotoButtonPressed,
                                child: CircleAvatar(
                                  backgroundColor: greyColor2.withAlpha(125),
                                  radius: 25.0,
                                  child: new Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        )),
                  ]),
                  decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(75.0),
                      ),
                      boxShadow: [BoxShadow(blurRadius: 7, color: greyColor)]),
                ),
                SizedBox(height: 90.0),
                TextField(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.send,
                  controller: TextEditingController()..text = _name,
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Как Вас звать-величать',
                  ),
                  onSubmitted: _onSavePressed,
                  onChanged: (value) => _name = value,
                ),
                SizedBox(height: 15.0),
                TextField(
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.send,
                  autocorrect: false,
                  controller: TextEditingController()..text = _about_me,
                  style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Расскажи немного о себе',
                  ),
                  onSubmitted: _onSavePressed,
                  onChanged: (value) => _about_me = value,
                ),
              ],
            ))
      ],
    ));
  }

  Future getImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      print('imageFile == null');
      return;
    }
    print(imageFile);
    setState(() {
      _is_loading = true;
    });
    await uploadFile(imageFile);
  }

  Future uploadFile(File imageFile) async {
    var fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var reference = FirebaseStorage.instance.ref().child(fileName);
    var uploadTask = reference.putFile(imageFile);
    var storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      setState(() {
        _is_loading = false;
      });
      print(downloadUrl);
      _saveImageAsync(downloadUrl);
    }, onError: (err) {
      setState(() {
        _is_loading = false;
      });
      print(err);
      throw Exception('Выбранный файл не являтся фото');
    });
  }

  void _onSavePressed(String value) async {
    var userId = prefs.getString('id');

    var users = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .getDocuments();
    var document = users.documents[0].documentID;
    Firestore.instance
        .collection('users')
        .document(document)
        .updateData({'nickname': _name, 'aboutMe': _about_me});

    await prefs.setString('nickname', _name);
    await prefs.setString('aboutMe', _about_me);
    MyApp.analytics
        .logViewItemList(itemCategory: "Обновление ника и информации о себе");
    print('Сохраненение ${_name} : ${_about_me}');
    setState(() {});
  }

  void _onChangePhotoButtonPressed() async {
    print('start loading');
    await getImage();
  }

  void _saveImageAsync(String newPath) async {
    var userId = prefs.getString('id');
    var users = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .getDocuments();
    var document = users.documents[0].documentID;
    Firestore.instance
        .collection('users')
        .document(document)
        .updateData({'photoUrl': newPath});
    await prefs.setString('photoUrl', newPath);
    MyApp.analytics.logViewItemList(itemCategory: "Обновлено лого-фото");
    _avatar_link = newPath;
    setState(() {});
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
