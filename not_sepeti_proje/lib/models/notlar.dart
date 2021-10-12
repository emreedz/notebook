

class Not {
  int? notId;
  int? kategorID;
  String? kategoriBaslik;
  String? notBaslik;
  String? notIcerik;
  String? notTarih;
  int? notOncelik;

  Not(this.kategorID, this.notBaslik, this.notIcerik,this.notTarih ,this.notOncelik);

  Not.withID(this.notId, this.kategorID, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notId'] = notId;
    map['kategorID'] = kategorID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notTarih'] = notTarih;
    map['notOncelik'] = notOncelik;

    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    this.notId = map['notId'];
    this.kategorID = map['kategorID'];
    this.kategoriBaslik= map["kategoriBaslik"];
    this.notBaslik = map['notBaslik'];
    this.notIcerik = map['notIcerik'];
    this.notTarih = map['notTarih'];
    this.notOncelik = map['notOncelik'];
  }

  @override
  String toString() {
    return 'Not{notId: $notId, kategorID: $kategorID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik}';
  }


}
