import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'calender.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

TextEditingController _email = new TextEditingController();
TextEditingController _password = new TextEditingController();
String emailHataMesaji, sifreHataMesaji;

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  @override
  Widget build(BuildContext context) {
    _email.text = "user@diyetin.com";
    _password.text = "12345678";

    bool _emailSifreKontrol(
      String email,
      String password,
    ) {
      var sonuc = true;
      setState(() {
        if (password.length < 6) {
          sifreHataMesaji = "En az 6 karakter olmalı";
          debugPrint(sifreHataMesaji);
          sonuc = false;
        } else
          sifreHataMesaji = null;
      });

      setState(() {
        if (!email.contains('@')) {
          emailHataMesaji = "Geçersiz email adresi";
          sonuc = false;
        } else
          emailHataMesaji = null;
        return sonuc;
      });
    }

    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            children: [
              Container(
                height: 200,
                margin: EdgeInsets.only(top: 50),
                child: Image(
                  image: AssetImage("images/login.png"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.purple)),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  controller: _email,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    errorText: emailHataMesaji != null ? emailHataMesaji : null,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), border: Border.all(color: Colors.purple)),
                child: TextField(
                  obscureText: true,
                  autofocus: false,
                  controller: _password,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Şifre",
                    errorText: sifreHataMesaji != null ? sifreHataMesaji : null,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: RaisedButton(
                  onPressed: () {
                    login();
                    _emailSifreKontrol(_email.text, _password.text);
                  },
                  color: Colors.purple,
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    await _auth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
    if (_auth.currentUser != null)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
  }
}
