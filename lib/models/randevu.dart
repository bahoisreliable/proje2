import 'package:webdemo/models/danisman.dart';
import 'package:webdemo/models/hasta.dart';

class Randevu {
  String renk;
  String randevuid;
  DateTime tarih;
  DateTime baslangicsaati;
  DateTime bitissaati;
  Hasta hasta;
  Danisman danisman;

  Randevu(this.renk, this.tarih, this.baslangicsaati, this.bitissaati, this.randevuid, this.hasta, this.danisman);

  @override
  String toString() {
    return 'Randevu{isim: $renk, tarih: $tarih, başlangic saat: $baslangicsaati, bitis saat: $bitissaati, randevu id : $randevuid, hasta: $hasta, danisman: $danisman}';
  }
}

class Odeme {
  String odemeID;
  String baslamaTarihi;
  String bitisTarihi;
  String odemeTutari;

  Odeme(this.odemeID, this.baslamaTarihi, this.bitisTarihi, this.odemeTutari);

  @override
  String toString() {
    return 'Odeme{odemeID: $odemeID, baslamaTarihi: $baslamaTarihi, bitisTarihi: $bitisTarihi, odemeTutari: $odemeTutari}';
  }
}
