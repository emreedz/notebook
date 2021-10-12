import 'dart:io';
import 'package:flutter/material.dart';
import 'package:not_sepeti_proje/models/kategori.dart';
import 'package:not_sepeti_proje/not_detay.dart';
import 'package:not_sepeti_proje/utils/database_helper.dart';
import 'kategori_islemleri.dart';
import 'models/notlar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var databaseHelper = DataBaseHelper();
    databaseHelper.kategorileriGetir();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text("Not Sepeti"),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: ListTile(
                leading: Icon(Icons.category),
                    title: Text("Kategoriler"),onTap: ()=>_kategorilerSayfasinaGit(context),)),
            ];
          }),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              kategoriEkleDialog(context);
            },
            tooltip: "Kategori Ekle",
            child: Icon(Icons.add_circle),
            mini: true,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              _detaySayfasinaGit(context);
            },
            tooltip: "Not Ekle",
            child: Icon(Icons.add),
          )
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    late String yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      yeniKategoriAdi = yeniDeger.toString();
                    },
                    decoration: InputDecoration(
                        labelText: "Kategori Adi",
                        border: OutlineInputBorder()),
                    validator: (girilenKategoriAdi) {
                      if (girilenKategoriAdi!.length < 3) {
                        return "En az 3 Karakter Giriniz.";
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        dataBaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriId) {
                          if (kategoriId > 0) {
                            final snackbar = SnackBar(
                              content: Text("Ekleme gerçeklesti"),
                              duration: Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                            debugPrint("Kategori Eklendi : $kategoriId");
                          }
                        });
                      }
                    },
                    child: Text("Kaydet"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple)),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Vazgeç"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink))),
                ],
              )
            ],
          );
        });
  }

  void _detaySayfasinaGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotDetay(
              baslik: "Yeni Not ",
            )));
  }

  _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Kategoriler()));
  }
}

class Notlar extends StatefulWidget {
  const Notlar({Key? key}) : super(key: key);

  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late List<Not> tumNotlar;
  late DataBaseHelper dataBaseHelper;

  @override
  void initState() {
    super.initState();
    tumNotlar = <Not>[];
    dataBaseHelper = DataBaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataBaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          tumNotlar = snapshot.data!;
          sleep(Duration(milliseconds: 500));

          return ListView.builder(
            itemCount: tumNotlar.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                title: Text(tumNotlar[index].notBaslik.toString()),
                subtitle: Text(tumNotlar[index].kategoriBaslik.toString()),
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Kategori",
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tumNotlar[index].kategoriBaslik.toString(),
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Olusturulma Tarihi",
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                dataBaseHelper.dateFormat(
                                    DateTime.parse(tumNotlar[index].notTarih!)),
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Içerik: " + tumNotlar[index].notIcerik!,
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 20),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  _detaySayfasinaGit(context, tumNotlar[index]);
                                },
                                child: Text(
                                  "GÜNCELLE",
                                  style: TextStyle(color: Colors.purple),
                                )),
                            TextButton(
                                onPressed: () {
                                  _notSil(tumNotlar[index].notId);
                                },
                                child: Text(
                                  "SİL",
                                  style: TextStyle(color: Colors.pink),
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotDetay(
              baslik: "Notu düzenle ",
              duzenlenecekNot: not,
            )));
  }

  _oncelikIconuAta(int? notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          child: Text("Az"),
          backgroundColor: Colors.green.shade500,
        );
      case 1:
        return CircleAvatar(
          child: Text("Orta"),
          backgroundColor: Colors.orangeAccent.shade400,
        );
      case 2:
        return CircleAvatar(
          child: Text("Çok"),
          backgroundColor: Colors.redAccent.shade700,
        );
    }
  }

  void _notSil(int? notId) {
    dataBaseHelper.notSil(notId!).then((silinenID) {
      if (silinenID != 0) {
        final snackbar = SnackBar(
          content: Text("Not Silindi"),
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      }
    });
  }
}
