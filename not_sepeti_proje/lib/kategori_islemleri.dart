import 'package:flutter/material.dart';
import 'package:not_sepeti_proje/models/kategori.dart';
import 'package:not_sepeti_proje/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  @override
  _KategorilerState createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori>? tumKategoriler;
  late DataBaseHelper dataBaseHelper;

  @override
  void initState() {
    super.initState();
    dataBaseHelper = DataBaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler= <Kategori>[];
      kategoriListesiniGuncelle();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategoriler"),
      ),
      body: ListView.builder(
        itemCount: tumKategoriler!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tumKategoriler![index].kategoriBaslik),
            trailing: Icon(Icons.delete),
            leading: Icon(Icons.category),
          );
        },
      ),
    );
  }

  void kategoriListesiniGuncelle() {

    dataBaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {

      setState(() {
        tumKategoriler=kategorileriIcerenList;
      });
    });
  }
}
