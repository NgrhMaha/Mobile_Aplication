class Kerajinan {
  Kerajinan({
    required this.id_kerajinan,
    required this.id_perusahaan,
    required this.foto,
    required this.nama_kerajinan,
    required this.deskripsi,
    required this.harga,
    required this.createdAt,
    required this.updatedAt,
  });

  int id_kerajinan;
  int id_perusahaan;
  String foto;
  String nama_kerajinan;
  String deskripsi;
  String harga;
  String createdAt;
  String updatedAt;

  factory Kerajinan.fromJson(Map<String, dynamic> json) => Kerajinan(
        id_kerajinan: json["id_kerajinan"],
        id_perusahaan: json["id_perusahaan"],
        foto: json["foto"].toString(),
        nama_kerajinan: json["nama_kerajinan"].toString(),
        deskripsi: json["deskripsi"].toString(),
        harga: json["harga"].toString(),
        createdAt: json["created_at"].toString(),
        updatedAt: json["updated_at"].toString(),
      );
}
