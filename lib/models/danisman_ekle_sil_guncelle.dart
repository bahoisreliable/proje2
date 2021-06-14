import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:webdemo/calender.dart';
import 'package:webdemo/hasta_ekle_sil_guncelle.dart';
import 'package:webdemo/models/danisman.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

TextEditingController _isim = new TextEditingController();
TextEditingController _email = new TextEditingController();
TextEditingController _renk = new TextEditingController();
TextEditingController _telefon = new TextEditingController();
String _currentvalue;
bool popupac = false;

class DanismanEkleSilGuncelle extends StatefulWidget {
  @override
  _DanismanEkleSilGuncelleState createState() => _DanismanEkleSilGuncelleState();
}

class _DanismanEkleSilGuncelleState extends State<DanismanEkleSilGuncelle> {
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  @override
  void initState() {
    // TODO: implement initState
    _veriGetir();
    super.initState();
  }

  @override
  String dropdownValue = "One";
  List<Danisman> _danismanListesi = <Danisman>[];
  List<String> _isimlistesi = <String>['Danışman Seçiniz....'];
  Color _currentColor = Colors.blue;

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

    return new Scaffold(
      appBar: AppBar(
        title: Text("Danışman Ekle Sil Güncelle Sayfası"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                popupac = true;
              });
            },
            child: Icon(
              Icons.settings,
              size: 38,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HastaEkleSilGuncelle()));
            },
            child: Icon(
              Icons.forward,
              size: 30,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          popupac == false
              ? Container(
                  width: MediaQuery.of(context).size.width < 1000 ? 500 : MediaQuery.of(context).size.width / 2,
                  child: Container(
                    //margin: MediaQuery.of(context).size.width > 1200 ? EdgeInsets.fromLTRB(100, 50, 100, 50) : EdgeInsets.all(0),
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                    //decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(border: Border.all()),
                              child: _isimlistesi.length < 2
                                  ? CircularProgressIndicator()
                                  : Center(
                                      child: DropdownButton(
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
                                controller: _email, textAlign: TextAlign.start, decoration: InputDecoration(hintText: "Email")),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(border: Border.all()),
                            child: TextField(
                                controller: _isim, textAlign: TextAlign.start, decoration: InputDecoration(hintText: "İsim")),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(border: Border.all()),
                            child: TextField(
                                controller: _telefon,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(hintText: "Telefon")),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(border: Border.all()),
                            child: TextField(
                              controller: _renk,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(hintText: "Renk"),
                              readOnly: true,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(border: Border.all()),
                            child: CircleColorPicker(
                              initialColor: _currentColor,
                              onChanged: _onColorChanged,
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Row(
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  danismanEkle();
                                },
                                color: Colors.orange,
                                child: Text(
                                  "Ekle",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  sil(_currentvalue);
                                },
                                color: Colors.orange,
                                child: Text(
                                  "Sil",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  guncelle(_currentvalue);
                                },
                                color: Colors.orange,
                                child: Text(
                                  "Guncelle",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  temizle();
                                },
                                color: Colors.orange,
                                child: Text(
                                  "Temizle",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Positioned(
                  child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.red.shade300)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Emaili Yanlış Girdiniz"),
                        Text("Lütfen Doğru Formatta Giriniz"),
                        RaisedButton(
                          onPressed: () {
                            setState(() {
                              popupac = false;
                            });
                          },
                          child: Text("Tamam"),
                        ),
                      ],
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  void danismanEkle() async {
    Map<String, dynamic> ekle = Map();
    ekle['email'] = _email.text;
    ekle['isim'] = _isim.text;
    ekle['renk'] = _renk.text;
    ekle['telefon'] = _telefon.text;

    await _firestore.collection("danisman").add(ekle).then((v) => debugPrint("ekleme işlemi başarıyla tamamlandı"));
    temizle();
    _veriGetir();
  }

  void temizle() {
    setState(() {
      _currentvalue = _isimlistesi[0];
      _email.text = "";
      _isim.text = "";
      //_renk.text = "";
      _telefon.text = "";
    });
  }

  void doldur() {
    setState(
      () {
        for (int i = 0; i < _danismanListesi.length; i++) {
          if (_currentvalue == _danismanListesi[i].isim) {
            _isim.text = _danismanListesi[i].isim;
            _telefon.text = _danismanListesi[i].telefon;
            _renk.text = _danismanListesi[i].renk;
            _email.text = _danismanListesi[i].email;
          }
        }
      },
    );
  }

  void guncelle(String isim) async {
    String documentid;
    for (int i = 0; i < _danismanListesi.length; i++) {
      if (_danismanListesi[i].isim == isim) documentid = _danismanListesi[i].userid;
    }
    print(documentid);
    await _firestore
        .doc("danisman/$documentid")
        .update({'email': _email.text, 'isim': _isim.text, 'renk': _renk.text, 'telefon': _telefon.text}).then((v) {
      debugPrint("Danışman başarı ile güncellendi");
    }).catchError((e) => debugPrint("Güncellerken hata cıktı" + e.toString()));

    temizle();
    _veriGetir();
  }

  void sil(String isim) async {
    String documentid;
    for (int i = 0; i < _danismanListesi.length; i++) {
      if (_danismanListesi[i].isim == isim) documentid = _danismanListesi[i].userid;
    }
    print(documentid);
    await _firestore.doc("danisman/$documentid").delete().then((v) {
      debugPrint("Danışman başarı ile silindi");
    }).catchError((e) => debugPrint("Silerken hata cıktı" + e.toString()));

    temizle();
    _veriGetir();
  }

  void _veriGetir() async {
    _danismanListesi.clear();
    _isimlistesi.clear();
    _isimlistesi.add("Danışman Seçiniz...");
    await _firestore.collection("danisman").get().then((querySnapshots) {
      for (int i = 0; i < querySnapshots.docs.length; i++) {
        setState(
          () {
            _danismanListesi.add(new Danisman(querySnapshots.docs[i]["isim"], querySnapshots.docs[i]["telefon"],
                querySnapshots.docs[i]["email"], querySnapshots.docs[i]["renk"], querySnapshots.docs[i].id));
            _isimlistesi.add(querySnapshots.docs[i]["isim"]);
          },
        );
      }
    });
  }

  void _onColorChanged(Color value) {
    String x = "0x${_currentColor.value.toRadixString(16)}";
    x.replaceAll('#', '');
    //print(int.parse(x));
    setState(() {
      _currentColor = value;
      _renk.text = x.replaceAll('#', '');
    });
  }
}
