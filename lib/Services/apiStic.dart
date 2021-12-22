import 'dart:convert';
//import 'dart:html';
import 'package:flutter_application_1/Models/errMsg.dart';
import 'package:flutter_application_1/Models/perusahaan.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Models/kerajinan.dart';

class ApiStatic {
  static final host = 'http://192.168.185.53/laravel-breeze/public';
  static final token = "7|ywob1uZPxP0b6MNWxP92sewpC3DCfPK0JhHzctsW";
  static getHost() {
    return host;
  }

  // static Future<List<Kerajinan>> getKerajinan2() async {
  //   List<Kerajinan> kerajinan = [];
  //   for (var i = 0; i < 10; i++) {
  //     kerajinan.add(Kerajinan(
  //         id_kerajinan: i,
  //         id_perusahaan: 1,
  //         foto: "foto",
  //         nama_kerajinan: "Guci" + i.toString(),
  //         deskripsi: "Produk guci untuk tanaman dari tanah liat" + i.toString(),
  //         harga: "20000",
  //         createdAt: "",
  //         updatedAt: ""));
  //   }
  //   return kerajinan;
  // }

  static Future<List<Kerajinan>> getKerajinan() async {
    //String response = '{"current_page":1,"data":[{"id_kerajinan":1,"id_perusahaan":1,"foto":"-","nama_kerajinan":"Guci Gerabah","deskripsi":"-","harga":"-","created_at":null,"updated_at":null,"nama_perusahaan":"Kerajinan Restu Mulya","alamat":"Singaraja","nohp":"089222877212"}],"first_page_url":"http:\/\/192.168.0.196\/laravel-breeze\/public\/api\/kerajinan?page=1","from":1,"last_page":1,"last_page_url":"http:\/\/192.168.0.196\/laravel-breeze\/public\/api\/kerajinan?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"http:\/\/192.168.0.196\/laravel-breeze\/public\/api\/kerajinan?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"http:\/\/192.168.0.196\/laravel-breeze\/public\/api\/kerajinan","per_page":5,"prev_page_url":null,"to":1,"total":1}';
    try {
      final response =
          await http.get(Uri.parse("$host/api/kerajinan"), headers: {
        'Authorization': 'Bearer ' + token,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        final parsed = json['data'].cast<Map<String, dynamic>>();
        return parsed
            .map<Kerajinan>((json) => Kerajinan.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Kerajinan>> getKerajinanFilter(
      int pageKey, String _s, String _selectedChoice) async {
    try {
      final response = await http.get(
          Uri.parse("$host/api/kerajinan?page=" +
              pageKey.toString() +
              "&s=" +
              _s +
              "&publish=" +
              _selectedChoice),
          headers: {
            'Authorization': 'Bearer ' + token,
          });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        //print(json);
        final parsed = json['data'].cast<Map<String, dynamic>>();
        return parsed
            .map<Kerajinan>((json) => Kerajinan.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Perusahaan>> getPerusahaan() async {
    try {
      final response =
          await http.get(Uri.parse("$host/api/kerajinan"), headers: {
        'Authorization': 'Bearer ' + token,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        final parsed = json.cast<Map<String, dynamic>>();
        return parsed
            .map<Perusahaan>((json) => Perusahaan.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<ErrorMSG> saveKerajinan(id, kerajinan, filepath) async {
    try {
      var url = Uri.parse('$host/api/kerajinan');
      if (id != 0) {
        url = Uri.parse('$host/api/kerajinan' + id.toString());
      }

      var request = http.MultipartRequest('POST', url);
      request.fields['nama_kerajinan'] = kerajinan['nama_kerajinan'];
      request.fields['deskripsi'] = kerajinan['deskripsi'];
      request.fields['harga'] = kerajinan['harga'];
      request.fields['id_perusahaan'] = kerajinan['id_perusahaan'].toString();
      if (filepath != '') {
        request.files.add(await http.MultipartFile.fromPath('foto', filepath));
      }
      request.headers.addAll({
        'Authorization': 'Bearer' + token,
      });
      var response = await request.send();

      // final response = await http.post(Uri.parse('$_host/'), body);
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        print(jsonDecode(respStr));
        return ErrorMSG.fromJson(jsonDecode(respStr));
      } else {
        return ErrorMSG(success: false, message: 'err Request');
      }
    } catch (e) {
      ErrorMSG responseRequest =
          ErrorMSG(success: false, message: 'error caught: $e');
      return responseRequest;
    }
  }

  static Future<ErrorMSG> deleteKerajinan(id) async {
    try {
      final response = await http
          .delete(Uri.parse('$host/api/kerajinan' + id.toString()), headers: {
        'Authorization': 'Bearer' + token,
      });
      if (response.statusCode == 200) {
        return ErrorMSG.fromJson(jsonDecode(response.body));
      } else {
        return ErrorMSG(success: false, message: 'Error, Gagal Menghapus');
      }
    } catch (e) {
      ErrorMSG responseRequest =
          ErrorMSG(success: false, message: 'error caught: $e');
      return responseRequest;
    }
  }
}
