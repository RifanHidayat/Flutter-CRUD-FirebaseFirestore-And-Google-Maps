class Sekolah {
  String _nama;
  double _lat;
  double _long;
  String _alamat;
  String _photo;
  String _id;

  Sekolah(
      this._nama, this._lat, this._long, this._alamat, this._photo, this._id);

  Sekolah.map(dynamic obj) {
    this._nama = obj['nama'];
    this._lat = obj['lat'];
    this._long = obj['long'];
    this._alamat = obj['alamat'];
    this._photo = obj['photo'];
    this._id = obj['id'];
  }

  String get nama => _nama;

  double get lat => _lat;

  double get long => _long;

  String get alamat => _alamat;

  String get photo => _photo;

  String get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['nama'] = _nama;
    map['lat'] = _lat;
    map['long'] = _long;
    map['alamat'] = _alamat;
    map['photo'] = _photo;
    map['id'] = _id;
    return map;
  }

  Sekolah.fromMap(Map<String, dynamic> map) {
    this._nama = map['nama'];
    this._lat = map['lat'];
    this._long = map['long'];
    this._alamat = map['alamat'];
    this._photo = map['photo'];
    this._id = map['id'];
  }
}
