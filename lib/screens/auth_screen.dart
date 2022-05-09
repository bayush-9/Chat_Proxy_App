import 'package:chat_app/providers/user.dart' as luser;
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isloading = false;
  final _auth = FirebaseAuth.instance;
  void _submitFn(String email, String password, String username, bool isLogin,
      File image, BuildContext ctx) async {
    var authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = await FirebaseAuth.instance.currentUser;
        final userid = user.uid;
        // final userName =
        //     Firestore.instance.collection('users').document(userid).get();
        print("userId=" + userid);

        Provider.of<luser.User>(context, listen: false).setUserId(userid);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(image).whenComplete(() => null);

        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .update({
          'username': username,
          'email': email,
          'userImage': url,
        });
        final user = await FirebaseAuth.instance.currentUser;
        final userid = user.uid;
        print("userId=" + userid);
        Provider.of<luser.User>(context, listen: false).setUserId(userid);
      }
    } on PlatformException catch (err) {
      var message = 'There was an error while authenticating';
      if (err.message != null) {
        message = err.message;
      }
      setState(() {
        _isloading = false;
      });
      Scaffold.of(ctx).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (err) {
      print(err);

      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/screenshot(213).jpeg'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AuthForm(_submitFn, _isloading),
            ),
          ],
        ),
      ),
    );
  }
}
