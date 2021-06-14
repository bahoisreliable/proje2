import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webdemo/models/randevu.dart';
import 'package:webdemo/odeme_bilgisi_sayfasi.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<Odeme> _listOdeme = <Odeme>[];

TextEditingController _baslangicTarihi = new TextEditingController();
TextEditingController _bitisTarihi = new TextEditingController();
TextEditingController _odemeTutari = new TextEditingController();
String _odemeID;
bool _kayitvarmi = true;

class OdemeGuncelleSayfasi extends StatefulWidget {
  final String hastaAd;
  OdemeGuncelleSayfasi({Key key, @required this.hastaAd}) : super(key: key);
  @override
  _OdemeGuncelleSayfasiState createState() => _OdemeGuncelleSayfasiState();
}

class _OdemeGuncelleSayfasiState extends State<OdemeGuncelleSayfasi> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verigetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.fromLTRB(50, 20, 50, 10),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
              width: 500,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Başlama Tarihi"),
                      Container(
                        width: 250,
                        child: TextField(
                          controller: _baslangicTarihi,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bitiş Tarihi"),
                      Container(
                        width: 250,
                        child: TextField(
                          controller: _bitisTarihi,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Ödeme Tutarı"),
                      Container(
                        width: 250,
                        child: TextField(
                          controller: _odemeTutari,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(onPressed: odemeGuncelle, child: Text("Güncelle")),
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Text("Başlangıç Tarihi"), Text("Bitiş Tarihi"), Text("Ödeme Tutarı")],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _listOdeme.length == 0
                ? _kayitvarmi == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text("Eski Bir Ödeme Bulunamadı")
                : ListView.builder(
                    itemCount: _listOdeme.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cardOlustur(index);
                    }),
          )
        ],
      ),
    );
  }

  void _verigetir() async {
    _listOdeme.clear();
    _baslangicTarihi.clear();
    _bitisTarihi.clear();
    _odemeTutari.clear();
    bool hastavarmi = false;

    _firestore.collection("odeme").get().then((querySnapshots) {
      for (int i = 0; i < querySnapshots.docs.length; i++) {
        if (widget.hastaAd == querySnapshots.docs[i].id) {
          hastavarmi = true;
        }
      }
      hastaKontrolu(hastavarmi);
    });
  }

  Widget cardOlustur(int index) {
    return Card(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _baslangicTarihi.text = _listOdeme[index].baslamaTarihi;
                _bitisTarihi.text = _listOdeme[index].bitisTarihi;
                _odemeTutari.text = _listOdeme[index].odemeTutari;
                _odemeID = _listOdeme[index].odemeID;
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(_listOdeme[index].baslamaTarihi),
                Text(_listOdeme[index].bitisTarihi),
                Text(_listOdeme[index].odemeTutari)
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          )
        ],
      ),
    );
  }

  void odemeGuncelle() async {
    bool same = false;
    if (_baslangicTarihi != null) {
      await _firestore.collection("odeme").doc(widget.hastaAd).update({_odemeID: FieldValue.delete()});
      await _firestore.collection("odeme").doc(widget.hastaAd).update({_baslangicTarihi.text: FieldValue.delete()});
      DocumentSnapshot documentSnapshot = await _firestore.doc("odeme/${widget.hastaAd}").get();
      documentSnapshot.data().forEach((key, value) {
        if (key == _baslangicTarihi.text) {
          same = true;
        }
      });

      if (same != true) {
        Map<String, dynamic> map = Map();
        map['baslangicTarihi'] = _baslangicTarihi.text;
        map['bitisTarihi'] = _bitisTarihi.text;
        map['odemeTutari'] = _odemeTutari.text;
        await _firestore.collection("odeme").doc(widget.hastaAd).update({_baslangicTarihi.text: map});
      } else {
        Map<String, dynamic> map = Map();
        map['baslangicTarihi'] = _baslangicTarihi.text;
        map['bitisTarihi'] = _bitisTarihi.text;
        map['odemeTutari'] = _odemeTutari.text;
        String same = _baslangicTarihi.text + "+";
        await _firestore.collection("odeme").doc(widget.hastaAd).update({same: map});
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OdemeBilgisiSayfasi(hastaAd: widget.hastaAd)));
    }
  }

  void hastaKontrolu(bool hastavarmi) async {
    if (hastavarmi == true) {
      DocumentSnapshot documentSnapshot = await _firestore.doc("odeme/${widget.hastaAd}").get();
      documentSnapshot.data().forEach((key, value) {
        setState(() {
          _listOdeme.add(new Odeme(key, value["baslangicTarihi"], value["bitisTarihi"], value["odemeTutari"]));
        });
      });
    } else {
      setState(() {
        _kayitvarmi = false;
      });
    }
  }
}
