import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:webdemo/calender.dart';
import 'package:webdemo/models/danisman.dart';
import 'package:webdemo/models/hasta.dart';

import 'models/meeting.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<Hasta> _listHasta = <Hasta>[];
List<Hasta> _listHastaAranan = <Hasta>[];
List<Danisman> _listDanisman = <Danisman>[];
List<String> _listDanismanisim = <String>['Danisman Seçiniz'];
List<Appointment> _listappointment = <Appointment>[];
CalendarController _cfcontroleller;

String dateTime;
bool basHasta = false;
bool basDanisman = false;

String dropdownValue;

TextEditingController _baslangicSaati = new TextEditingController();
TextEditingController _bitisSaati = new TextEditingController();
TextEditingController _danisanAdi = new TextEditingController();
TextEditingController _danismanAdi = new TextEditingController();
TextEditingController _controllertarih = new TextEditingController();
DateTime _date2;
List meetings2 = <Meeting>[];
DateTime _dateTime = DateTime.now();

bool hastaAra = false;

class Randevu extends StatefulWidget {
  @override
  _RandevuState createState() => _RandevuState();
}

class _RandevuState extends State<Randevu> {
  List<Meeting> meetings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cfcontroleller = CalendarController();
    _cfcontroleller.view = CalendarView.month;
    _date2 = null;
    _danisanAdi.clear();
    _veriGetir();
  }

  @override
  Widget build(BuildContext context) {
    dropdownValue == null ? dropdownValue = 'Danisman Seçiniz' : dropdownValue;

    return Scaffold(
      appBar: AppBar(
        title: Text("Randevu"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Icon(
              Icons.settings,
              size: 38,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: _listappointment.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SfCalendar(
                    firstDayOfWeek: 1,
                    onTap: _yakala,
                    controller: _cfcontroleller,
                    showNavigationArrow: true,
                    allowedViews: [CalendarView.week, CalendarView.month],
                    backgroundColor: Colors.grey.shade200,
                    dataSource: AppoDataSource(_listappointment),
                    //monthViewSettings: MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                    monthViewSettings: MonthViewSettings(showAgenda: false),
                  ),
          ),
          _date2 != null
              ? SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      margin:
                          MediaQuery.of(context).size.width > 1200 ? EdgeInsets.fromLTRB(100, 50, 100, 50) : EdgeInsets.all(0),
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            //width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(border: Border.all()),
                            child: TextField(
                              controller: _controllertarih,
                              readOnly: true,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            //width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(border: Border.all()),
                            child: TextField(
                              onTap: () {
                                setState(() {
                                  basHasta = true;
                                });
                              },
                              decoration: InputDecoration(hintText: "Başlangıç Saati"),
                              controller: _baslangicSaati,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            //width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(border: Border.all()),
                            child: TextField(
                              controller: _bitisSaati,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(hintText: "Bitiş Saati"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            //width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(border: Border.all()),
                            child: TextField(
                              controller: _danisanAdi,
                              textAlign: TextAlign.start,
                              onChanged: _hastaBul,
                              decoration: InputDecoration(hintText: "Hasta Adı"),
                            ),
                          ),
                          hastaAra == false
                              ? Container()
                              : Container(
                                  height: 100,
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                  child: ListView.builder(
                                      itemCount: _listHastaAranan.length == 0 ? 1 : _listHastaAranan.length,
                                      itemBuilder: (context, index) {
                                        if (_listHastaAranan.length == 0) {
                                          return Center(
                                            child: Text("Hasta Bulunamadı"),
                                          );
                                        }
                                        return eleman(_listHastaAranan[index].isim);
                                      }),
                                ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 15),
                            //width: MediaQuery.of(context).size.width / 8,
                            decoration: BoxDecoration(border: Border.all()),
                            child: _listDanismanisim.length < 2
                                ? CircularProgressIndicator()
                                : Center(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: dropdownValue,
                                      iconSize: 24,
                                      elevation: 16,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: _listDanismanisim.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              children: <Widget>[
                                hourMinuteSecond(),
                                new Container(
                                  margin: EdgeInsets.symmetric(vertical: 50),
                                  child: new Text(
                                    _dateTime.hour.toString().padLeft(2, '0') + ':' + _dateTime.minute.toString().padLeft(2, '0'),
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          MediaQuery.of(context).size.width < 1500
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green.shade300,
                                              borderRadius: BorderRadius.circular(40),
                                              border: Border.all(color: Colors.green.shade300)),
                                          padding: EdgeInsets.all(10),
                                          child: Center(
                                            child: Text(
                                              "Oluştur",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 12,
                                        ),
                                        onTap: _veriKayit,
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green.shade300,
                                              borderRadius: BorderRadius.circular(40),
                                              border: Border.all(color: Colors.green.shade300)),
                                          padding: EdgeInsets.all(10),
                                          child: Center(
                                            child: Text(
                                              "Başlangıç Saati Seç",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 12,
                                        ),
                                        onTap: () {
                                          setState(
                                            () {
                                              _baslangicSaati.text = _dateTime.hour.toString().padLeft(2, '0') +
                                                  ':' +
                                                  _dateTime.minute.toString().padLeft(2, '0');
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.green.shade300,
                                              borderRadius: BorderRadius.circular(40),
                                              border: Border.all(color: Colors.green.shade300)),
                                          child: Center(
                                            child: Text(
                                              "Bitiş Saati Seç",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 12,
                                        ),
                                        onTap: () {
                                          setState(
                                            () {
                                              _bitisSaati.text = _dateTime.hour.toString().padLeft(2, '0') +
                                                  ':' +
                                                  _dateTime.minute.toString().padLeft(2, '0');
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade300,
                                            borderRadius: BorderRadius.circular(40),
                                            border: Border.all(color: Colors.green.shade300)),
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                          child: Text(
                                            "Oluştur",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width / 12,
                                      ),
                                      onTap: _veriKayit,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade300,
                                            borderRadius: BorderRadius.circular(40),
                                            border: Border.all(color: Colors.green.shade300)),
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                          child: Text(
                                            "Başlangıç Saati Seç",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width / 12,
                                      ),
                                      onTap: () {
                                        setState(
                                          () {
                                            _baslangicSaati.text = _dateTime.hour.toString().padLeft(2, '0') +
                                                ':' +
                                                _dateTime.minute.toString().padLeft(2, '0');
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade300,
                                            borderRadius: BorderRadius.circular(40),
                                            border: Border.all(color: Colors.green.shade300)),
                                        child: Center(
                                          child: Text(
                                            "Bitiş Saati Seç",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        width: MediaQuery.of(context).size.width / 12,
                                      ),
                                      onTap: () {
                                        setState(
                                          () {
                                            _bitisSaati.text = _dateTime.hour.toString().padLeft(2, '0') +
                                                ':' +
                                                _dateTime.minute.toString().padLeft(2, '0');
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _veriKayit() async {
    if (_date2 == null) _date2 = DateTime.now();

    List<String> list = _baslangicSaati.text.split(":");
    List<String> list1 = _bitisSaati.text.split(":");

    String hour = list[0];
    String hour1 = list1[0];
    String min = list[1];
    String min1 = list1[1];

    String renk;
    for (int i = 0; i < _listDanisman.length; i++) {
      if (_listDanisman[i].isim == dropdownValue) {
        renk = _listDanisman[i].renk;
      }
    }
    await _firestore.collection("randevu").add(
      {
        "danisman": dropdownValue,
        "hasta": _danisanAdi.text,
        "tarih":
            _date2.year.toString() + "-" + _date2.month.toString().padLeft(2, '0') + "-" + _date2.day.toString().padLeft(2, '0'),
        "baslangicsaait": hour + ":" + min,
        "bitissaati": hour1 + ":" + min1,
        "renk": renk == null ? "0xffff8215" : renk
      },
    );
    _listDanismanisim.clear();
    _listDanismanisim.add("Danisman Seçiniz");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  Widget hourMinuteSecond() {
    return new TimePickerSpinner(
      isShowSeconds: false,
      spacing: 40,
      minutesInterval: 10,
      onTimeChange: (time) {
        setState(
          () {
            _dateTime = time;
          },
        );
      },
    );
  }

  void _veriGetir() async {
    _listappointment.clear();
    await _firestore.collection("randevu").get().then(
      (querySnapshots) {
        print("eleman sayisi randevu " + querySnapshots.docs.length.toString());
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
                  color: Color(int.parse(querySnapshots.docs[i]['renk'])),
                  subject: querySnapshots.docs[i]['hasta'],
                  hastaAdi: querySnapshots.docs[i]['hasta']));
            },
          );
        }
      },
    );
    await _firestore.collection("hasta").get().then(
      (querySnapshots) {
        print("eleman sayisi hasta " + querySnapshots.docs.length.toString());
        for (int i = 0; i < querySnapshots.docs.length; i++) {
          setState(
            () {
              _listHasta.add(new Hasta(
                  querySnapshots.docs[i]["isim"],
                  querySnapshots.docs[i]["telefon"],
                  querySnapshots.docs[i]["email"],
                  querySnapshots.docs[i]["adres"],
                  querySnapshots.docs[i]["danisman"],
                  querySnapshots.docs[i].id));
            },
          );
        }
      },
    );
    await _firestore.collection("danisman").get().then(
      (querySnapshots) {
        print("eleman sayisi danisman " + querySnapshots.docs.length.toString());
        for (int i = 0; i < querySnapshots.docs.length; i++) {
          setState(
            () {
              _listDanisman.add(
                new Danisman(querySnapshots.docs[i]["isim"], querySnapshots.docs[i]["telefon"], querySnapshots.docs[i]["email"],
                    querySnapshots.docs[i]["renk"], querySnapshots.docs[i].id),
              );
              _listDanismanisim.add(querySnapshots.docs[i]["isim"]);
            },
          );
        }
      },
    );
  }

  void _yakala(CalendarTapDetails calendarTapDetails) {
    _date2 = calendarTapDetails.date;

    setState(() {
      _controllertarih.text =
          '${_date2.year}-${_date2.month.toString().padLeft(2, '0')}-${_date2.day.toString().padLeft(2, '0')}';
    });
  }

  void _hastaBul(String value) async {
    String arananKelime = _danisanAdi.text;
    setState(() {
      _listHastaAranan.clear();
    });
    for (var hasta in _listHasta) {
      if (hasta.isim.contains(arananKelime)) {
        Hasta h = hasta;
        setState(() {
          _listHastaAranan.add(h);
        });
      }
    }
    setState(() {
      hastaAra = true;
    });
  }

  Widget eleman(String isim) {
    return GestureDetector(
      onTap: () {
        setState(() {
          hastaAra = false;
          _danisanAdi.text = isim;
        });
      },
      child: Container(
        height: 30,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.only(left: 10),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(45), color: Colors.white, boxShadow: [BoxShadow(spreadRadius: 2)]),
        child: Center(
          child: Text(isim),
        ),
      ),
    );
  }
}
