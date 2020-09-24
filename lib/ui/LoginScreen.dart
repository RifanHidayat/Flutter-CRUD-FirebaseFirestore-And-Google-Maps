import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sekolah/controllers/authentications.dart';
import 'package:sekolah/ui/root.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/bus.jpg",
                  width: double.maxFinite,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                Container(
                  width: double.maxFinite,
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => googleSignIn().whenComplete(() async {
                          FirebaseUser user =
                              await FirebaseAuth.instance.currentUser();

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Root()),
                              ModalRoute.withName('/LoginScreen'));
                        }),
                        child: Image(
                          image: AssetImage('assets/images/signin.png'),
                          width: 200.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
