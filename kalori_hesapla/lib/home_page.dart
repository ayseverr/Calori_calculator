import 'package:flutter/material.dart';
import 'package:kalori_hesapla/gunlukkalori.dart';
import 'package:kalori_hesapla/yemek.dart';

import 'database_helper.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  int tabindex;
  int sabahkalori = 0;
  int oglekalori = 0;
  int aksamkalori = 0;
  int toplamkalori = 0;

  List<Yemek> sabahyemek = [];
  List<Yemek> ogleyemek = [];
  List<Yemek> aksamyemek = [];

  List<GunKalori> dbgunListesi;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController =
        TabController(length: 4, vsync: this); //tabbarın controlleri
    /* Program ilk çalıştığında veritabanından geçmiş günlerin verisini getirmek için initstate içinde*/
    dataBaseHelper.gunListesiniGetir().then((gunlistesi) {
      dbgunListesi = gunlistesi; // gelen gün listesi dbgunlistesine atıldı.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalori Hesaplama"),
        bottom: TabBar(controller: tabController, tabs: <Widget>[
          //Tabbarın öğeleri
          Tab(text: "Sabah"),
          Tab(text: "Öğle"),
          Tab(text: "Akşam"),
          Tab(text: "Toplam"),
        ]),
      ),
      // tabbarwiew içine tab sayın kadar children verebilirsin
      body: TabBarView(controller: tabController, children: <Widget>[
        Container(
          //sabah sayfası
          child: tabWidget(sabahyemek), //Kod kalabalığı olmasın diye
          //bir widget oluşturup onu kullandım .
        ),
        Container(
          //ogle sayfası
          child: tabWidget(ogleyemek),
        ),
        Container(
          //aksam sayfası
          child: tabWidget(aksamyemek),
        ),
        Container(
            //Toplam sayfası
            child: Column(
          children: <Widget>[
            Card(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Center(
                      child: Text(
                    "Sabah alınan kalori : ${sabahkalori}",
                    style: TextStyle(fontSize: 20),
                  ))),
            ),
            Card(
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    "Öğlen alınan kalori : ${oglekalori}",
                    style: TextStyle(fontSize: 20),
                  ))),
            ),
            Card(
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    "Akşam alınan kalori : ${aksamkalori}",
                    style: TextStyle(fontSize: 20),
                  ))),
            ),
            FlatButton(
              //Kaydetme butonu
              onPressed: () {
                dataBaseHelper //Veritabanına suanki zamanla toplam kaloriyi ekler
                    .gunEkle(GunKalori(DateTime.now().toString(), toplamkalori))
                    .then((gunid) {
                  //Eğer hatasız eklenirse günıd 0 dan büyük olur
                  if (gunid > 0) {
                    print("gun eklendi");
                    dataBaseHelper.gunListesiniGetir().then((gunlistesi) {
                      // Listeyi tekrar getirdim
                      dbgunListesi = gunlistesi;
                      setState(() {});
                    });
                    setState(() {});
                  }
                });
              },
              child: Text(
                "Kaydet",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
            ),
            Expanded(
              child: ListView.builder(
                  //veritabanından gelen listeyi index index dolaşır ve ekrana yazdırır.
                  itemCount: (dbgunListesi == null)
                      ? 0
                      : dbgunListesi
                          .length, // veritabanı boşsa 0 yaz değilse veritabanını kullan
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                // veritabanından gelen tarıh verisini databasehelperdeki dateformat fonsiyonu ile çecirip ekrana yazdırma
                                "${dataBaseHelper.dateFormat(DateTime.parse(dbgunListesi[index].gunTarih))}",
                              ),
                            ),
                            Text(
                                "Kalori : ${dbgunListesi[index].gunKalori}"), //Kaloriyi ekrana yazdırma
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  // Inkwell içindeki widgeta ontap ozelliği kazandırır.
                                  onTap: () {
                                    // çöp kovasına basıldığı zaman günü siler listeyi tekrar çağırarak sayfayı yeniler.
                                    dataBaseHelper
                                        .gunSil(dbgunListesi[index].gunID)
                                        .then((id) {
                                      dataBaseHelper
                                          .gunListesiniGetir()
                                          .then((gunlistesi) {
                                        dbgunListesi = gunlistesi;
                                        setState(() {});
                                      });
                                      setState(() {
                                        print("gun silindi");
                                      });
                                    });
                                  },
                                  child: Icon(Icons.delete_forever)),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        )),
      ]),
    );
  }

  Widget tabWidget(List yemek) {
    // yemek değişkeni yukarıda gönderildiği duruma göre değişir
    //sabahyemek aksamyemek ogleyemek
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  // Menuye kenar çizgisi ekler
                  child: Container(
                    child: DropdownButton<int>(
                      hint: Text("Seçiniz"), // default değer
                      items:
                          yemekitems(), // aşağıda oluşan dropdownmenuitem listesi
                      value: tabindex, // kaçıncı itemde olduğunu anlamak için
                      onChanged: (secilen) {
                        setState(() {
                          // yeni seçildiği zaman onu secili iteme atar ekranı yeniler.
                          tabindex = secilen;
                          print(tabindex.toString());
                        });
                      },
                    ),
                    margin: EdgeInsetsDirectional.only(
                        top: 10), // DropdownButtonun tasarımsal özellikleri
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
              //Sağdaki ekleme buttonu
              child: Text(
                "Ekle",
              ),
              onPressed: () {
                // yeni yiyeceği ve kaloriyi toplar
                kaloritopla(tabindex);
              },
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
              // seçilenyemeklistesi kadar çalışır her seferinde farklı indexi yazdırır
              //
              itemCount: (yemek == null) ? 0 : yemek.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              '${yemek[index].resimUrl}'), // secilen yemeğin resmi
                        ),
                      ),
                      Text(
                          " ${yemek[index].yemekAdi}   ${yemek[index].kalori}"),
                    ],
                  ),
                );
              }),
        ),
        FlatButton(
          child: Text("Temizle"),
          onPressed: () {
            yemek.clear(); // listeyi temizler
            kaloritemizle(tabController.index); // kalorileri sıfırlar
            setState(() {}); //sayfayı yeniler
          },
        ),
      ],
    );
  }

  //Yemek sınıfında oluşturduğum listeleri
  // Dropdownmenu itema dünuştüren foksiyon
  List<DropdownMenuItem<int>> yemekitems() {
    List<DropdownMenuItem<int>> yemekler = [];
    for (int i = 0; i < Yemek.yemek_ad.length; i++) {
      yemekler.add(DropdownMenuItem(
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              child: Image(
                // resim göstermek için kullanılır
                fit: BoxFit.cover, //resimi sıgdırması için
                image: AssetImage('${Yemek.image_Url[i]}'),
              ),
            ),
            Text(" ${Yemek.yemek_ad[i]}  =  ${Yemek.kalorileri[i]} Kalori"),
          ],
        ),
        value: i,
      ));
    }
    return yemekler; // geriye dropdownMenuitem listesi gönderir
  }

  void kaloritopla(int index) {
    //tabcontrollere göre sayfayı belirleyip
    //kalorileri toplar
    // ve sabah ogle aksam yemek listelerine yeni yiyeceği ekler
    switch (tabController.index) {
      case 0:
        {
          sabahkalori = sabahkalori + Yemek.kalorileri[index];
          sabahyemek.add(Yemek(Yemek.image_Url[index], Yemek.yemek_ad[index],
              Yemek.kalorileri[index]));
          break;
        }
      case 1:
        {
          oglekalori = oglekalori + Yemek.kalorileri[index];
          ogleyemek.add(Yemek(Yemek.image_Url[index], Yemek.yemek_ad[index],
              Yemek.kalorileri[index]));
          break;
        }
      case 2:
        {
          aksamkalori = aksamkalori + Yemek.kalorileri[index];
          aksamyemek.add(Yemek(Yemek.image_Url[index], Yemek.yemek_ad[index],
              Yemek.kalorileri[index]));
          break;
        }
    }

    toplamkalori = sabahkalori + aksamkalori + oglekalori;
    setState(() {
      print(toplamkalori.toString());
    });
  }

  void kaloritemizle(int index) {
    // listeler temizlendikten sonra toplam kalorileride temizler
    switch (tabController.index) {
      case 0:
        {
          sabahkalori = 0;

          break;
        }
      case 1:
        {
          oglekalori = 0;

          break;
        }
      case 2:
        {
          aksamkalori = 0;

          break;
        }
    }

    toplamkalori = sabahkalori + aksamkalori + oglekalori;
    setState(() {});
  }
}
