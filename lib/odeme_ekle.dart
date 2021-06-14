import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:webdemo/calender.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

TextEditingController _isim = new TextEditingController();
TextEditingController _baslangicTarih = new TextEditingController();
TextEditingController _bitisTarih = new TextEditingController();
TextEditingController _odemeTutari = new TextEditingController();

class OdemeEklemeSayfasi extends StatefulWidget {
  final String hastaAd;
  OdemeEklemeSayfasi({Key key, @required this.hastaAd}) : super(key: key);
  @override
  _OdemeEklemeSayfasiState createState() => _OdemeEklemeSayfasiState();
}

class _OdemeEklemeSayfasiState extends State<OdemeEklemeSayfasi> {
  @override
  void initState() {
    _baslangicTarih.text = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 0)));
    _bitisTarih.text = DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 30)));
    _isim.text = widget.hastaAd;
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _baslangicTarih.text = DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
        if (args.value.endDate != null) {
          _bitisTarih.text = DateFormat('yyyy-MM-dd').format(args.value.endDate).toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _isim.text = widget.hastaAd;
    return Scaffold(
      appBar: AppBar(
        title: Text("Odeme Ekle"),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.fromLTRB(50, 20, 50, 10),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
              child: Column(
                children: [
                  Container(
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hasta Adı :"),
                        Container(
                          width: 200,
                          child: TextField(
                            readOnly: true,
                            controller: _isim,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Başlama Tarihi : "),
                        Container(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(hintText: "YYYY-AA-GG"),
                            controller: _baslangicTarih,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Bitiş Tarihi :"),
                        Container(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(hintText: "YYYY-AA-GG"),
                            controller: _bitisTarih,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ödeme Tutarı :"),
                        Container(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(hintText: "Örn. 500"),
                            controller: _odemeTutari,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(onPressed: _odemeYap, child: Text("Ekle")),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 500,
            child: SfDateRangePicker(
              showNavigationArrow: true,
              onSelectionChanged: _onSelectionChanged,
              rangeSelectionColor: Colors.blue,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange:
                  PickerDateRange(DateTime.now().subtract(const Duration(days: 0)), DateTime.now().add(const Duration(days: 30))),
            ),
          ),
        ],
      ),
    );
  }

  void _odemeYap() async {
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

  void hastaKontrolu(bool hastavarmi) async {
    if (hastavarmi == true) {
      Map<String, dynamic> map = Map();
      map['baslangicTarihi'] = _baslangicTarih.text;
      map['bitisTarihi'] = _bitisTarih.text;
      map['odemeTutari'] = _odemeTutari.text == "" ? "500" : _odemeTutari.text;
      await _firestore.collection("odeme").doc(widget.hastaAd).update({_baslangicTarih.text: map});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      Map<String, dynamic> map = Map();
      map['baslangicTarihi'] = _baslangicTarih.text;
      map['bitisTarihi'] = _bitisTarih.text;
      map['odemeTutari'] = _odemeTutari.text == "" ? "500" : _odemeTutari.text;
      await _firestore.collection("odeme").doc(widget.hastaAd).set({_baslangicTarih.text: map});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }
}
