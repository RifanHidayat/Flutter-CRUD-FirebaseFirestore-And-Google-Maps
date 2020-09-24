import 'dart:async';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sekolah/ui/root.dart';

class SplassScreen extends StatefulWidget {
  @override
  _SplassScreenState createState() => _SplassScreenState();
}

class _SplassScreenState extends State<SplassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[100],
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478DE0),
                    Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
            ),
            Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sekolah App",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Billion",
                          fontSize: 50),
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  Future<Timer> starTme() async {
    return Timer(Duration(seconds: 6), OnDone);
  }

  Void OnDone() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Root()));
  }

  @override
  void initState() {
    starTme();
    super.initState();
  }
}
