import 'package:flutter/material.dart';
import 'package:kalori_hesapla/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GirisPage(),
    );
  }
}

class GirisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            //Büyük mavi container
            height: MediaQuery.of(context).size.height *
                0.7, // containerin yüksekliği bulunduğu ekranın 0.7 katı yapar
            width: MediaQuery.of(context)
                .size
                .width, // containerin genişliğini ekranın genişliği kadar yapar
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Text widgetları arasında boşluk bırakır.
              children: <Widget>[
                Text("Kalori Hesapla",
                    style: TextStyle(fontSize: 50, color: Colors.white)),
                Column(
                  children: <Widget>[
                    Text("Hoş",
                        style: TextStyle(
                            fontSize: 70,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text("Geldiniz",
                        style: TextStyle(
                            fontSize: 70,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: FlatButton(
                  // Diğer sayfaya geçmek için kullanılan button
                  color: Colors.blue,
                  onPressed: () {
                    // Butona basıldığı zaman Navigator metodunu kullanarak MyHomePage sayfasını stack yapısına ekler.
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text(
                    "Günlük Kalorimi Hesapla",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
          SizedBox(
            // İsim birazdaha aşağıya kayması için biraz boşluk ekledim
            height: 30,
          ),
          Text("Aygül Sever", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
