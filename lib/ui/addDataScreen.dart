import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekolah/database/database_services.dart';
import 'package:sekolah/style/constants.dart';
import 'package:sekolah/ui/homeScreen.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'file:///D:/Aplikasi_Android/Flutter/sekolah/lib/models/Location.dart';
import 'package:stacked/stacked.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';

class addData extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff543B7A),
      ),
      home: addDataScreen(),
    );
  }
}

class addDataScreen extends StatefulWidget {
  @override
  _addDataScreenState createState() => _addDataScreenState();
}

class _addDataScreenState extends State<addDataScreen> {
  DatabaseServices services = new DatabaseServices();
  var datalat, datalong;

  String imageUrl;
  var uuid = Uuid();
  BuildContext context;
  Firestore firestore = Firestore.instance;

  var nama = new TextEditingController();
  var alamat = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  _buildNama(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildAlamat(),
                  SizedBox(
                    height: 10,
                  ),
                  (imageUrl != null)
                      ? Image.network(
                          imageUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        )
                      : Placeholder(
                          fallbackHeight: 200.0,
                          fallbackWidth: double.infinity),
                  SizedBox(
                    height: 20.0,
                  ),
                  new RaisedButton(
                    child: new Text("pilih Foto",
                        style: TextStyle(color: Colors.white)),
                    color: Colors.blue,
                    onPressed: () {
                      uploadImage();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //btn simpan
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 5.0,
                      onPressed: () {
                        if (nama.text.isEmpty) {
                          Toast.show("Nama belum diisi", context,
                              duration: 5, gravity: Toast.BOTTOM);
                        } else if (alamat.text.isEmpty) {
                          Toast.show("Alamat harus diisi", context,
                              duration: 5, gravity: Toast.BOTTOM);
                        } else if (imageUrl.isEmpty) {
                          Toast.show("pilih photoh terlebih dahulu", context,
                              duration: 5, gravity: Toast.BOTTOM);
                        } else {
                          model.searchLocationLat(alamat.text);
                          model.searchLocationLong(alamat.text);
                          if ((model.Lat != null) && model.Long != null) {
                            // Text(model.getSearchLocation);
                            setState(() {
                              datalat = double.parse(model.Lat);
                              datalong = double.parse(model.Long);
                            });

                            services
                                .tambahDataSekolah(nama.text, datalat, datalong,
                                    alamat.text, imageUrl)
                                .then((_) {
                              Toast.show("Data berhasil disimpan", context,
                                  duration: 5, gravity: Toast.BOTTOM);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Home()),
                                  ModalRoute.withName('/addDataScreen'));
                            });
                          } else {
                            Toast.show(
                                "Klik tombol simpan sekali lagi", context,
                                duration: 5, gravity: Toast.BOTTOM);
                          }
                        }
                      },
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.white,
                      child: Text(
                        'Simpan Data',
                        style: TextStyle(
                          color: Color(0xFF527DAA),
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          child: TextFormField(
            controller: nama,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: MultiValidator([
              RequiredValidator(errorText: "Nama sekolah belum diisi"),
            ]),
            decoration: new InputDecoration(
                hintText: "Masukan nama Sekolah",
                hintStyle: kHintTextStyle,
                labelText: "Nama",
                labelStyle: kHintTextStyleLabel,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[300]),
                    borderRadius: new BorderRadius.circular(20.0)),
                focusedBorder: new OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[200]),
                    borderRadius: new BorderRadius.circular(20.0))),
          ),
        ),
      ],
    );
  }

  Widget _buildAlamat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 120.0,
          decoration: kBoxDecorationStyle,
          child: TextFormField(
            maxLines: 15,
            controller: alamat,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: MultiValidator([
              RequiredValidator(
                  errorText: "Alamat harus diisi terlebih dahulu"),
            ]),
            decoration: new InputDecoration(
                hintText: "Masukan Alamat  Sekolah bserta jalan dan kota",
                hintStyle: kHintTextStyle,
                labelText: "Alamat",
                labelStyle: kHintTextStyleLabel,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[300]),
                    borderRadius: new BorderRadius.circular(20.0)),
                focusedBorder: new OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[200]),
                    borderRadius: new BorderRadius.circular(20.0))),
          ),
        ),
      ],
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      var v4Crypto = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
      if (image != null) {
        //Upload to Firebase
        var snapshot = await _storage
            .ref()
            .child("Images/+$v4Crypto")
            .putFile(file)
            .onComplete;

        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }
}
