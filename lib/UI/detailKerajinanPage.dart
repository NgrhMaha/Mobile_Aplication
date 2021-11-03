import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/kerajinan.dart';

class DetailKerajinanPage extends StatefulWidget {
  //const DetailKerajinanPage({Key? key}) : super(key: key);

  DetailKerajinanPage({required this.kerajinan});
  final Kerajinan kerajinan;

  @override
  _DetailKerajinanPageState createState() => _DetailKerajinanPageState();
}

class _DetailKerajinanPageState extends State<DetailKerajinanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kerajinan.nama_kerajinan),
      ),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: [
            Image.network(widget.kerajinan.foto),
            Container(
              padding: EdgeInsets.all(5),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xff3164bd), const Color(0xff295cb5)],
                ),
              ),
              child: Text(
                widget.kerajinan.harga,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.lightBlue,
              width: double.infinity,
              height: double.maxFinite,
              child: new Text(widget.kerajinan.deskripsi),
            ),
          ],
        ),
      ),
    );
  }
}
