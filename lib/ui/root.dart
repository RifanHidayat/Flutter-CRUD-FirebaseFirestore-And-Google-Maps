import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekolah/sidebar/sidebar_layout.dart';
import 'package:sekolah/ui/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;
          return SideBarLayout(
            uid: user.uid,
            nama: user.displayName,
            email: user.email,
            photo: user.photoUrl,
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
