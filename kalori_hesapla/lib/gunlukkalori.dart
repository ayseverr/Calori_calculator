class GunKalori {
  int gunID;
  String gunTarih;
  int gunKalori;

  GunKalori(this.gunTarih, this.gunKalori);

  GunKalori.withID(this.gunID, this.gunTarih,
      this.gunKalori); //kategorileri dbden okurken kullanılır.

  Map<String, dynamic> toMap() { // maptan Gunkalori isimli sınıfıma cevirir.
    var map = Map<String, dynamic>();
    map['gun_tarih'] = gunTarih;
    map['gun_id'] = gunID;
    map["gun_kalori"] = gunKalori;
    return map;
  }

  GunKalori.fromMap(Map<String, dynamic> map) { //GunKaloriden mapa cevirir
    this.gunID = map['gun_id'];
    this.gunTarih = map['gun_tarih'];
    this.gunKalori = map["gun_kalori"];
  }

  @override
  String toString() { // veritabanının çalışıp çalışmadığını denemek için konsola yazdırırken kullanıldı.
    return 'GunKalori{gun_id: $gunID, gun_tarih: $gunTarih, gun_kalori: $gunKalori}';
  }
}
