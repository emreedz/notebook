class Kategori{
   int? kategoriId;
  late String kategoriBaslik;

  Kategori(this.kategoriBaslik);  //kategori eklerken kullan

  Kategori.withID(this.kategoriId, this.kategoriBaslik); //kategorileri dbden okurken kullanılır

  Map<String, dynamic>? toMap(){

    var map = Map<String,dynamic>();
    map['kategoriId'] = kategoriId;
    map['kategoriBaslik'] = kategoriBaslik;

    return map;
  }
  Kategori.fromMap(Map<String,dynamic> map){
    this.kategoriId=map['kategoriId'];
    this.kategoriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() {
    return 'Kategori{kategoriId: $kategoriId, kategoriBaslik: $kategoriBaslik}';
  }

}