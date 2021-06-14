class Danisman {
  String isim;
  String telefon;
  String email;
  String renk;
  String userid;

  Danisman(this.isim, this.telefon, this.email, this.renk, this.userid);

  @override
  String toString() {
    return 'Danisman{isim: $isim, telefon: $telefon, email: $email, user id: $userid, renk: $renk}';
  }
}
