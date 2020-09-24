import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekolah/database/database_services.dart';
import 'package:sekolah/models/sekolah.dart';
import 'package:sekolah/ui/LocationScreen.dart';
import 'package:sekolah/ui/editDataScreen.dart';
import 'package:toast/toast.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';

class Home extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Sekolah> items;
  DatabaseServices services = new DatabaseServices();
  StreamSubscription<QuerySnapshot> sekolah;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 10,
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 400.0,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Material(
                                color: Colors.white,
                                elevation: 14.0,
                                shadowColor: Color(0x802196F3),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
//                                      todoType('${items[index].tasktype}'),
                                      Image.network(
                                        '${items[index].photo}',
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //widget nama
                                      Container(
                                          width: double.infinity,
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '${items[index].nama}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),

                                      //widget Alamat
                                      Container(
                                          width: double.infinity,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child:Text(
                                                  '${items[index].alamat}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                  ),
                                              ),

                                              ),
                                            ],
                                          )),

                                      new InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new MapScreen(
                                              alamat: items[index].alamat,
                                              lat: items[index].lat,
                                              long: items[index].long,
                                            ),
                                          ));
                                        },
                                        child: Container(
                                            width: double.infinity,
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.orange[200],
                                                    radius: 20,
                                                    child: Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                                new InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new editDataScreen(
                                                        nama: items[index].nama,
                                                        alamat:
                                                            items[index].alamat,
                                                        photo:
                                                            items[index].photo,
                                                        id: items[index].id,
                                                      ),
                                                    ));
                                                  },
                                                  child: Container(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.orange[200],
                                                      radius: 20,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    alert(items[index].id);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.orange[200],
                                                        radius: 20,
                                                        child: Icon(
                                                          Icons
                                                              .restore_from_trash,
                                                          color: Colors.white,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvents.AddDataClickedEvent);
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    items = new List();

    sekolah?.cancel();
    sekolah = services.getAlData().listen((QuerySnapshot snapshot) {
      final List<Sekolah> sekola = snapshot.documents
          .map((documentSnapshot) => Sekolah.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        this.items = sekola;
      });
    });
  }

  void alert(String data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: new Text("yakin Menghapus data ini?"),
            actions: <Widget>[
              new RaisedButton(
                  child: new Text(
                    'Iya',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    // ignore: unnecessary_statements
                    services.delete(data).then((_) {
                      Navigator.pop(context);
                      Toast.show("Berhasil menghapus data", context,
                          duration: 5, gravity: Toast.BOTTOM);
                    });
                  }),
              FlatButton(
                  child: new Text(
                    'Batalkan',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
