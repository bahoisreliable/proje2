class Hasta {
  String isim;
  String telefon;
  String email;
  String adres;
  String kisiselNot;
  String danisman;
  String hastaid;

  Hasta(this.isim, this.telefon, this.email, this.adres, this.danisman, this.hastaid, {this.kisiselNot});

  @override
  String toString() {
    return 'Hasta{isim: $isim, telefon: $telefon, email: $email, adres: $adres, hasta id : $hastaid, danisman: $danisman, kisiselNot: $kisiselNot}';
  }
}
