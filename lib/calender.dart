import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:webdemo/models/danisman.dart';
import 'package:webdemo/models/danisman_ekle_sil_guncelle.dart';
import 'package:webdemo/models/hasta.dart';
import 'package:webdemo/models/meeting.dart';
import 'package:webdemo/odeme_bilgisi_sayfasi.dart';
import 'package:webdemo/randevu_sayfasi.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<Hasta> _listHasta = <Hasta>[];
List<Appointment> _listappointment = <Appointment>[];
List<Appointment> _listappointmentkisisel = <Appointment>[];
List<Danisman> _listDanisman = <Danisman>[];
CalendarController _cfcontroleller;
String _hastaID;
bool kisiselmi = true;

class MyHomePage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Meeting> meetings;
  String isim = "", soyisim = "", telefon = "", email = "", adres = "", not = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cfcontroleller = CalendarController();
    _cfcontroleller.view = CalendarView.month;
    _gerekliVerileriGetir();
    //_veriGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diyetin"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.subject,
            color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DanismanEkleSilGuncelle()));
            },
            child: Icon(
              Icons.settings,
              size: 38,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Randevu()));
            Navigator.push(context, MaterialPageRoute(builder: (context) => Randevu()));
          },
          label: Text("Ekle")),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: _listappointment.length == 0 || _listappointmentkisisel.length == 0 || _listDanisman.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  kisiselmi = true;
                                });
                              },
                              child: Text("Kişisel")),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  kisiselmi = false;
                                });
                              },
                              child: Text("Genel"))
                        ],
                      ),
                      Expanded(
                          child: SfCalendar(
                        firstDayOfWeek: 1,
                        onTap: _yakala,
                        controller: _cfcontroleller,
                        showNavigationArrow: true,
                        allowedViews: [CalendarView.week, CalendarView.month],
                        backgroundColor: Colors.grey.shade300,
                        dataSource:
                            kisiselmi == true ? AppoDataSource(_listappointmentkisisel) : AppoDataSource(_listappointment),
                        monthViewSettings: MonthViewSettings(showAgenda: true),
                      ))
                    ],
                  ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height * 11 / 12,
            child: Container(
              margin: MediaQuery.of(context).size.width > 1200 ? EdgeInsets.fromLTRB(100, 50, 100, 50) : EdgeInsets.all(0),
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              decoration: BoxDecoration(border: Border.all()),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          child: Text(
                            "Kullanıcı Adı :",
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            isim,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          child: Text(
                            "Telefon :",
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            telefon,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          child: Text(
                            "Email :",
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            email,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          child: Text(
                            "Adres :",
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            adres,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          child: Text(
                            "Kullanıcı Özel Not :",
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 15),
                          width: MediaQuery.of(context).size.width / 8,
                          decoration: BoxDecoration(border: Border.all()),
                          child: Text(
                            not,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (isim != "" && isim != null)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OdemeBilgisiSayfasi(hastaAd: isim)));
                      },
                      color: Colors.orange,
                      child: Text(
                        "Ödeme Bilgileri",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _yakala(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      Appointment meet = details.appointments[0];
      for (int i = 0; i < _listHasta.length; i++) {
        if (meet.hastaAdi == _listHasta[i].isim)
          setState(() {
            _hastaID = _listHasta[i].hastaid;
            isim = _listHasta[i].isim;
            telefon = _listHasta[i].telefon;
            adres = _listHasta[i].adres;
            email = _listHasta[i].email;
            if (_listHasta[i].kisiselNot == null)
              not = " ";
            else
              not = _listHasta[i].kisiselNot;
          });
      }
    } else {
      setState(
        () {
          isim = "";
          soyisim = "";
          telefon = "";
          adres = "";
          email = "";
          not = "";
        },
      );
    }
  }

  void _gerekliVerileriGetir() async {
    _listDanisman.clear();
    await _firestore.collection("danisman").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        setState(() {
          _listDanisman.add(new Danisman(
              value.docs[i]["isim"], value.docs[i]["telefon"], value.docs[i]["email"], value.docs[i]["renk"], value.docs[i].id));
        });
      }
      _veriGetir();
    });
  }

  void _veriGetir() async {
    _listappointment.clear();
    _listappointmentkisisel.clear();
    _listHasta.clear();

    await _firestore.collection("hasta").get().then(
      (querySnapshots) {
        for (int i = 0; i < querySnapshots.docs.length; i++) {
          setState(
            () {
              _listHasta.add(new Hasta(
                querySnapshots.docs[i]["isim"],
                querySnapshots.docs[i]["telefon"],
                querySnapshots.docs[i]["email"],
                querySnapshots.docs[i]["adres"],
                querySnapshots.docs[i]["danisman"],
                querySnapshots.docs[i].id,
                kisiselNot: querySnapshots.docs[i]["kişiselNot"],
              ));
            },
          );
        }
      },
    );

    await _firestore.collection("randevu").get().then(
      (querySnapshots) {
        for (int i = 0; i < querySnapshots.docs.length; i++) {
          DateTime dateTime = DateTime.parse(querySnapshots.docs[i]['tarih'].toString());
          setState(
            () {
              List<String> list = querySnapshots.docs[i]['baslangicsaait'].split(":");
              List<String> list1 = querySnapshots.docs[i]['bitissaati'].split(":");
              List<String> list2 = querySnapshots.docs[i]['tarih'].split("-");
              String hour = list[0];
              String hour1 = list1[0];
              String min = list[1];
              String min1 = list1[1];
              String yil = list2[0];
              String ay = list2[1];
              String gun = list2[2];
              DateTime randevutarihbaslangic =
                  DateTime(int.parse(yil), int.parse(ay), int.parse(gun), int.parse(hour), int.parse(min));
              DateTime randevutarihbitis =
                  DateTime(int.parse(yil), int.parse(ay), int.parse(gun), int.parse(hour1), int.parse(min1));
              _listappointment.add(new Appointment(
                  startTime: randevutarihbaslangic,
                  endTime: randevutarihbitis,
                  color: Color(int.parse(renkBul(querySnapshots.docs[i]['danisman'].toString()))),
                  //color: Color(int.parse(querySnapshots.docs[i]['renk'])),
                  subject: querySnapshots.docs[i]['hasta'],
                  hastaAdi: querySnapshots.docs[i]['hasta']));
            },
          );
        }
      },
    );
    await _firestore.collection("randevu").get().then(
      (querySnapshots) {
        for (int i = 0; i < querySnapshots.docs.length; i++) {
          DateTime dateTime = DateTime.parse(querySnapshots.docs[i]['tarih'].toString());
          if (querySnapshots.docs[i]["danisman"] == "ayca cabbariye")
            setState(
              () {
                List<String> list = querySnapshots.docs[i]['baslangicsaait'].split(":");
                List<String> list1 = querySnapshots.docs[i]['bitissaati'].split(":");
                List<String> list2 = querySnapshots.docs[i]['tarih'].split("-");
                String hour = list[0];
                String hour1 = list1[0];
                String min = list[1];
                String min1 = list1[1];
                String yil = list2[0];
                String ay = list2[1];
                String gun = list2[2];
                DateTime randevutarihbaslangic =
                    DateTime(int.parse(yil), int.parse(ay), int.parse(gun), int.parse(hour), int.parse(min));
                DateTime randevutarihbitis =
                    DateTime(int.parse(yil), int.parse(ay), int.parse(gun), int.parse(hour1), int.parse(min1));
                _listappointmentkisisel.add(new Appointment(
                    startTime: randevutarihbaslangic,
                    endTime: randevutarihbitis,
                    color: Color(int.parse(renkBul(querySnapshots.docs[i]['danisman'].toString()))),
                    //color: Color(int.parse(querySnapshots.docs[i]['renk'])),
                    subject: querySnapshots.docs[i]['hasta'],
                    hastaAdi: querySnapshots.docs[i]['hasta']));
              },
            );
        }
      },
    );
  }

  String renkBul(String deger) {
    bool eslesme = false;
    String eslesenRenk;
    _listDanisman.forEach((element) {
      if (element.isim == deger) {
        eslesme = true;
        eslesenRenk = element.renk;
      }
    });
    if (eslesme == false)
      return "0x00000000";
    else
      return eslesenRenk;
  }
}
