import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webdemo/models/hasta.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

TextEditingController _isim = new TextEditingController();
TextEditingController _email = new TextEditingController();
TextEditingController _telefon = new TextEditingController();
TextEditingController _adres = new TextEditingController();
TextEditingController _kisiselnot = new TextEditingController();
TextEditingController _danisman = new TextEditingController();
String _currentvalue;

class HastaEkleSilGuncelle extends StatefulWidget {
  @override
  _HastaEkleSilGuncelleState createState() => _HastaEkleSilGuncelleState();
}

class _HastaEkleSilGuncelleState extends State<HastaEkleSilGuncelle> {
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String dropdownValue = "One";
  List<Hasta> _hastaListesi = <Hasta>[];
  List<String> _isimlistesi = <String>['Hasta Seçiniz....'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verigetir();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> getDropDownMenuItems() {
      List<DropdownMenuItem<String>> items = new List();

      for (String danisman in _isimlistesi) {
        items.add(new DropdownMenuItem(value: danisman, child: new Text(danisman)));
      }
      return items;
    }

    _dropDownMenuItems = getDropDownMenuItems();
    try {
      _currentvalue == null ? _currentvalue = _isimlistesi[0] : _currentvalue;
    } catch (e) {}
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasta Ekle Sil Güncelle Sayfası"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(border: Border.all()),
                  child: _isimlistesi.length < 2
                      ? CircularProgressIndicator()
                      : Center(
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: _currentvalue,
                            isExpanded: true,
                            items: _dropDownMenuItems,
                            onChanged: (String secilenisim) {
                              setState(() {
                                _currentvalue = secilenisim;
                              });
                              if (_currentvalue != "Danışman Seçiniz...") doldur();
                            },
                          ),
                        )),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                    controller: _isim,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "İsim",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ))),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                    controller: _telefon,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "Telefon",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ))),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                    controller: _email,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "Email",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ))),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                    controller: _adres,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "Adres",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ))),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                    controller: _danisman,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "Danisman",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ))),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                    controller: _kisiselnot,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintText: "Kisisel Not",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyanAccent),
                        ))),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: hastaekle,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Colors.cyanAccent,
                    child: Text("Ekle"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      hastasil(_currentvalue);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Colors.cyanAccent,
                    child: Text("Sil"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      hastaguncelle(_currentvalue);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Colors.cyanAccent,
                    child: Text("Güncelle"),
                  ),
                  RaisedButton(
                    onPressed: temizle,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Colors.cyanAccent,
                    child: Text("Temizle"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void doldur() {
    setState(() {
      for (int i = 0; i < _hastaListesi.length; i++) {
        if (_currentvalue == _hastaListesi[i].isim) {
          _isim.text = _hastaListesi[i].isim;
          _telefon.text = _hastaListesi[i].telefon;
          _email.text = _hastaListesi[i].email;
          _adres.text = _hastaListesi[i].adres;
          _kisiselnot.text = _hastaListesi[i].kisiselNot;
          _danisman.text = _hastaListesi[i].danisman;
        }
      }
    });
  }

  void verigetir() async {
    _hastaListesi.clear();
    _isimlistesi.clear();
    _isimlistesi.add("Hasta Seçiniz....");
    await _firestore.collection("hasta").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        setState(() {
          _hastaListesi.add(new Hasta(value.docs[i]["isim"], value.docs[i]["telefon"], value.docs[i]["email"],
              value.docs[i]["adres"], value.docs[i]["danisman"], value.docs[i].id));
          _isimlistesi.add(value.docs[i]["isim"]);
        });
      }
    });
  }

  void hastaekle() async {
    Map<String, dynamic> map = Map();
    map["isim"] = _isim.text;
    map["telefon"] = _telefon.text;
    map["email"] = _email.text;
    map["adres"] = _adres.text;
    map["danisman"] = _danisman.text;
    map["kişiselNot"] = _kisiselnot.text;

    await _firestore.collection("hasta").add(map);
    temizle();
    verigetir();
  }

  void temizle() {
    setState(() {
      _currentvalue = _isimlistesi[0];
      _isim.text = "";
      _telefon.text = "";
      _email.text = "";
      _adres.text = "";
      _danisman.text = "";
      _kisiselnot.text = "";
    });
  }

  void hastasil(String isim) async {
    String documentid;
    for (int i = 0; i < _hastaListesi.length; i++) {
      if (_hastaListesi[i].isim == isim) documentid = _hastaListesi[i].hastaid;
    }
    print(documentid);
    await _firestore.doc("hasta/$documentid").delete().then((v) {
      debugPrint("Danışman başarı ile silindi");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));

    temizle();
    verigetir();
  }

  void hastaguncelle(String isim) async {
    String documentid;
    for (int i = 0; i < _hastaListesi.length; i++) {
      if (_hastaListesi[i].isim == isim) documentid = _hastaListesi[i].hastaid;
    }
    print(documentid);
    await _firestore.doc("hasta/$documentid").update({
      'adres': _adres.text,
      'danisman': _danisman.text,
      'email': _email.text,
      'isim': _isim.text,
      'kişiselNot': _kisiselnot.text,
      'telefon': _telefon.text
    }).then((v) {
      debugPrint("Danışman başarı ile güncellendi");
    }).catchError((e) => debugPrint("Güncellerken hata cıktı" + e.toString()));

    temizle();
    verigetir();
  }
}
