import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:webdemo/models/meeting.dart';
import 'package:webdemo/odeme_ekle.dart';
import 'package:webdemo/odeme_guncelle.dart';
import 'package:webdemo/odeme_sil.dart';

CalendarController _controller = new CalendarController();
FirebaseFirestore _firestore = FirebaseFirestore.instance;

bool _kayitvarmi = true;

class OdemeBilgisiSayfasi extends StatefulWidget {
  final String hastaAd;
  OdemeBilgisiSayfasi({Key key, @required this.hastaAd}) : super(key: key);

  @override
  _OdemeBilgisiSayfasiState createState() => _OdemeBilgisiSayfasiState();
}

class _OdemeBilgisiSayfasiState extends State<OdemeBilgisiSayfasi> {
  List<Meeting> meetings = <Meeting>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verigetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diyetin"),
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
      body: Column(
        children: [
          Text(
            widget.hastaAd,
            style: TextStyle(fontSize: 32),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OdemeEklemeSayfasi(
                                hastaAd: widget.hastaAd,
                              )));
                },
                child: Text("Ödeme Ekle"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OdemeSilSayfasi(
                                hastaAd: widget.hastaAd,
                              )));
                },
                child: Text("Ödeme Sil"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OdemeGuncelleSayfasi(
                                hastaAd: widget.hastaAd,
                              )));
                },
                child: Text("Ödeme Güncelle"),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width < 1000 ? 500 : MediaQuery.of(context).size.width / 2,
            child: meetings.isEmpty
                ? _kayitvarmi == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SfCalendar(
                        view: CalendarView.month,
                        firstDayOfWeek: 1,
                        dataSource: null,
                        showDatePickerButton: true,
                        monthViewSettings: MonthViewSettings(
                            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                            numberOfWeeksInView: 4,
                            appointmentDisplayCount: 1),
                      )
                : SfCalendar(
                    view: CalendarView.month,
                    firstDayOfWeek: 1,
                    dataSource: MeetingDataSource(meetings),
                    showDatePickerButton: true,
                    monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                        numberOfWeeksInView: 4,
                        appointmentDisplayCount: 1),
                  ),
          )
        ],
      ),
    );
  }

  void verigetir() async {
    bool hastavarmi = false;
    meetings.clear();
    _firestore.collection("odeme").get().then(
      (querySnapshots) {
        for (int i = 0; i < querySnapshots.docs.length; i++) {
          if (widget.hastaAd == querySnapshots.docs[i].id) {
            hastavarmi = true;
          }
        }
        hastaKontrolu(hastavarmi);
      },
    );
  }

  void hastaKontrolu(bool hastavarmi) async {
    if (hastavarmi == true) {
      DocumentSnapshot documentSnapshot = await _firestore.doc("odeme/${widget.hastaAd}").get();
      documentSnapshot.data().forEach((key, value) {
        setState(() {
          meetings.add(new Meeting("Ödenmiş Günler", DateTime.parse(value["baslangicTarihi"]),
              DateTime.parse(value["bitisTarihi"]), Colors.blue, false));
        });
      });
    } else {
      setState(() {
        _kayitvarmi = false;
      });
    }
  }
}
