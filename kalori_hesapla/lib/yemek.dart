

class Yemek {
  String resimUrl;
  String yemekAdi;
  int kalori;

  Yemek(this.resimUrl, this.yemekAdi, this.kalori);

  static const List<String> image_Url = [
    "lib/images/ayran.png",
    "lib/images/balık.png",
    "lib/images/ceviz.png",
    "lib/images/cilek_receli.png",
    "lib/images/et.png",
    "lib/images/fındık.png",
    "lib/images/gevrek.png",
    "lib/images/hamburger.png",
    "lib/images/kola.png",
    "lib/images/makarna.png",
    "lib/images/patates.png",
    "lib/images/peynir.png",
    "lib/images/pilav.png",
    "lib/images/tavuk.png",
    "lib/images/tost.png",
    "lib/images/yumurta.png",
  ];
  static const List<String> yemek_ad = [
    "Ayran",
    "Balık",
    "Ceviz",
    "Cilek Receli",
    "Et",
    "Fındık",
    "Gevrek",
    "Hamburger",
    "Kola",
    "Makarna",
    "Patates",
    "Peynir",
    "Pirinç pilavi",
    "Tavuk",
    "Tost",
    "Yumurta",
  ];

  static const List<int> kalorileri = [
    300,
    400,
    470,
    500,
    347,
    566,
    678,
    456,
    560,
    230,
    600,
    700,
    450,
    780,
    340,
    120
  ];
}
