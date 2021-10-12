import 'package:flutter/material.dart';
import 'package:not_sepeti_proje/models/kategori.dart';
import 'package:not_sepeti_proje/utils/database_helper.dart';

import 'models/notlar.dart';

class NotDetay extends StatefulWidget {
  String? baslik;
  Not? duzenlenecekNot;

  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DataBaseHelper dataBaseHelper;
  late int secilenOncelik;
  late String notBaslik, notIcerik;
  late int kategoriID;

  static var _oncelik = ["düşük", "orta", "yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = <Kategori>[];
    dataBaseHelper = DataBaseHelper();
    dataBaseHelper.kategorileriGetir().then((kategorileriIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in kategorileriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      if(widget.duzenlenecekNot != null){
       kategoriID=widget.duzenlenecekNot!.kategorID!;
       secilenOncelik=widget.duzenlenecekNot!.notOncelik!;
      }else{
        kategoriID=1;
        secilenOncelik=0;
      }



      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(child: Text(widget.baslik!)),
      ),
      body: tumKategoriler.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Kategori",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),

                        //Kategori Bölümü
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.redAccent, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: kategoriItemleriOlustur(),
                              value: widget.duzenlenecekNot != null
                                  ? widget.duzenlenecekNot!.kategorID : kategoriID,
                              onChanged: (secilenKategoriID) {
                                setState(() {
                                  kategoriID = secilenKategoriID!;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),

                    //Not Baslığı Bölümü
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notBaslik
                            : "",
                        validator: (text) {
                          if (text!.length < 4) {
                            return "En az 4 karakter olmalı";
                          }
                        },
                        onSaved: (text) {
                          notBaslik = text!;
                        },
                        decoration: InputDecoration(
                          hintText: "Not başlığını giriniz",
                          labelText: "Başlık",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    //Not içeriği text bölümü
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot!.notIcerik
                            : "",
                        onSaved: (text) {
                          notIcerik = text!;
                        },
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Not içeriğini giriniz",
                          labelText: "Içerik",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    //Oncelik Bolumu
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Oncelik",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.redAccent, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: _oncelik.map((oncelik) {
                                return DropdownMenuItem<int>(
                                    child: Text(oncelik),
                                    value: _oncelik.indexOf(oncelik));
                              }).toList(),
                              value: secilenOncelik,
                              onChanged: (secilenOncelikID) {
                                setState(() {
                                  secilenOncelik = secilenOncelikID!;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),

                    //Kaydet Vazgeç Butonları
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              var suan = DateTime.now();

                              if (widget.duzenlenecekNot == null) {
                                dataBaseHelper
                                    .notEkle(Not(
                                        kategoriID,
                                        notBaslik,
                                        notIcerik,
                                        suan.toString(),
                                        secilenOncelik))
                                    .then((kaydedilenNotID) {
                                  print("Suan : " + suan.toString());
                                  if (kaydedilenNotID != 0) {
                                    Navigator.pop(context);
                                  }
                                });
                              } else {
                                dataBaseHelper.notGuncelle(Not.withID(
                                    widget.duzenlenecekNot!.notId,
                                    kategoriID,
                                    notBaslik,
                                    notIcerik,
                                    suan.toString(),
                                    secilenOncelik)).then((guncellenenId) {
                                      if(guncellenenId != 0){
                                        Navigator.pop(context);
                                      }
                                });
                              }
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
                                    MaterialStateProperty.all(Colors.pink)))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>>? kategoriItemleriOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem<int>(
              child: Text(kategori.kategoriBaslik),
              value: kategori.kategoriId,
            ))
        .toList();
  }
}

/*
* Form(
        child: Column(
          children: [
            DropdownButton<int>(
                items: kategoriItemleriOlustur(),
                value: kategoriID ,
                onChanged: (secilenKategoriID){
                  setState(() {
                    kategoriID=secilenKategoriID!;
                  });
                },
                )

          ],
        ),
      )*/
