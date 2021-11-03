import 'dart:convert';

class Perusahaan {
  Perusahaan({
    required this.idPerusahaanKerajinan,
    required this.namaPerusahaanKerajinan,
  });
  int idPerusahaanKerajinan;
  String namaPerusahaanKerajinan;
  factory Perusahaan.fromJson(Map<String, dynamic> json) => Perusahaan(
      idPerusahaanKerajinan: json["id_perusahaan"],
      namaPerusahaanKerajinan: json["nama_perusahaan"] == null
          ? ''
          : json["nama_perusahaan"].toString());
  Map<String, dynamic> toJson() => {
        "id_perusahaan": idPerusahaanKerajinan,
        "nama_perusahaan": namaPerusahaanKerajinan
      };
}
