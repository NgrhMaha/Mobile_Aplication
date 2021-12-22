//import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/errMsg.dart';
import 'package:flutter_application_1/Models/kerajinan.dart';
import 'package:flutter_application_1/Models/perusahaan.dart';
import 'package:flutter_application_1/Services/apiStic.dart';
import 'package:flutter_application_1/UI/kerajinanPage.dart';
import 'package:image_picker/image_picker.dart';

class InputKerajinan extends StatefulWidget {
  //const InputKerajinan({Key? key}) : super(key: key);
  final Kerajinan kerajinan;
  InputKerajinan({required this.kerajinan});

  @override
  _InputKerajinanState createState() => _InputKerajinanState();
}

class _InputKerajinanState extends State<InputKerajinan> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController foto, nama_kerajinan, deskripsi, harga;
  late List<Perusahaan> _perusahaan = [];
  late int idPerusahaan = 0;
  late int idKerajinan = 0;
  bool _isupdate = false;
  bool _validate = false;
  bool _success = false;
  late ErrorMSG response;
  late String _imagePath = "";
  late String _imageURL = "";
  final ImagePicker _picker = ImagePicker();
  void getPerusahaan() async {
    final response = await ApiStatic.getPerusahaan();
    setState(() {
      _perusahaan = response.toList();
    });
  }

  void submit() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      var params = {
        'nama_kerajinan': nama_kerajinan.text.toString(),
        'deskripsi': deskripsi.text.toString(),
        'harga': harga.text.toString(),
        'id_perusahaan': idPerusahaan,
      };
      response = await ApiStatic.saveKerajinan(idKerajinan, params, _imagePath);
      _success = response.success;
      final snackBar = SnackBar(
        content: Text(response.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (_success) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => KerajinanPage()));
      } else {
        _validate = true;
      }
    }
  }

  @override
  void initState() {
    nama_kerajinan = TextEditingController();
    deskripsi = TextEditingController();
    harga = TextEditingController();

    getPerusahaan();
    if (widget.kerajinan.id_kerajinan != 0) {
      idKerajinan = widget.kerajinan.id_kerajinan;
      nama_kerajinan =
          TextEditingController(text: widget.kerajinan.nama_kerajinan);
      deskripsi = TextEditingController(text: widget.kerajinan.deskripsi);
      harga = TextEditingController(text: widget.kerajinan.harga);
      idPerusahaan = widget.kerajinan.id_perusahaan;
      _isupdate = true;
      _imageURL = ApiStatic.host + '/' + widget.kerajinan.foto;
    }
    idPerusahaan = widget.kerajinan.id_perusahaan;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isupdate ? Text('Update Data') : Text('Input Data'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: nama_kerajinan,
                    validator: (u) => u == "" ? "Wajib Diisi" : null,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.perm_identity),
                      hintText: 'Nama Kerajinan',
                      labelText: 'Nama Kerajinan',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: deskripsi,
                    validator: (u) => u == "" ? "Wajib Diisi" : null,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.assignment_ind),
                      hintText: 'Deskripsi',
                      labelText: 'Deskripsi',
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(5),
                //   child: DropdownButtonFormField(
                //     value: idPerusahaan == 0 ? null : idPerusahaan,
                //     hint: Text("Pilih Asal Kerajinan"),
                //     decoration: const InputDecoration(
                //       icon: Icon(Icons.category_rounded),
                //     ),
                //     items: _perusahaan.map((item) {
                //       return DropdownMenuItem(
                //           child: Text(item.namaPerusahaanKerajinan),
                //           value: item.idPerusahaanKerajinan.toInt());
                //     }).toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         idPerusahaan = value as int;
                //       });
                //     },
                //     validator: (u) => u == null ? "Required" : null,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: harga,
                    keyboardType: TextInputType.number,
                    validator: (u) => u == "" ? "Wajib Diisi" : null,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.assignment_ind),
                      hintText: 'Harga',
                      labelText: 'Harga',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.image),
                      Flexible(
                          child: _imagePath != ''
                              ? GestureDetector(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_imagePath),
                                      fit: BoxFit.fitWidth,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                    ),
                                  ),
                                  onTap: () {
                                    getImage(ImageSource.gallery);
                                  },
                                )
                              : _imageURL != ''
                                  ? GestureDetector(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _imageURL,
                                          fit: BoxFit.fitWidth,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                        ),
                                      ),
                                      onTap: () {
                                        getImage(ImageSource.gallery);
                                      },
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        getImage(ImageSource.gallery);
                                      },
                                      child: Container(
                                        height: 100,
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 25),
                                            ),
                                            Text("Ambil Gambar")
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.greenAccent,
                                                    width: 1))),
                                      ),
                                    )),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: RaisedButton(
                    color: Colors.green,
                    child: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      submit();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource media) async {
    var img = await _picker.pickImage(source: media);
    //final pickedImageFile = File(img!.path);
    setState(() {
      _imagePath = img!.path;
      print(_imagePath);
    });
  }
}
