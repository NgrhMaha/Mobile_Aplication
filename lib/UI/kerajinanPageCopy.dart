import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/errMsg.dart';
import 'package:flutter_application_1/Models/kerajinan.dart';
//import 'package:flutter_application_1/Models/perusahaan.dart';
import 'package:flutter_application_1/Services/apiStic.dart';
import 'package:flutter_application_1/UI/PPL/inputKerajinan.dart';
import 'package:flutter_application_1/UI/detailKerajinanPage.dart';
import 'package:flutter_application_1/UI/homePage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class KerajinanPage extends StatefulWidget {
  //const KerajinanPage({Key? key}) : super(key: key);

  @override
  _KerajinanPageState createState() => _KerajinanPageState();
}

class _KerajinanPageState extends State<KerajinanPage> {
  late ErrorMSG response;
  final PagingController<int, Kerajinan> _pagingController =
      PagingController(firstPageKey: 0);
  late TextEditingController _s;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String _publish = "Y";
  int _pageSize = 3;
  void deleteKerajinan(id) async {
    response = await ApiStatic.deleteKerajinan(id);
    final snackBar = SnackBar(
      content: Text(response.message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _fetchPage(int pageKey, _s, _publish) async {
    try {
      final newItems =
          await ApiStatic.getKerajinanFilter(pageKey, _s, _publish);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _s = TextEditingController();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, _s.text, _publish);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Kerajinan"),
      ),
      //drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InputKerajinan(
                        kerajinan: Kerajinan(
                            id_kerajinan: 0,
                            id_perusahaan: 0,
                            foto: '',
                            nama_kerajinan: '',
                            deskripsi: '',
                            harga: '',
                            createdAt: '',
                            updatedAt: ''),
                      )));
        },
      ),
      body: FutureBuilder<List<Kerajinan>>(
        future: ApiStatic.getKerajinan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Kerajinan> listKerajinan = snapshot.data!;
            return Container(
              //padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) => Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DetailKerajinanPage(
                                  kerajinan: listKerajinan[index],
                                )));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                            border: Border.all(
                                width: 1, color: Colors.lightGreenAccent)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              ApiStatic.host + '/' + listKerajinan[index].foto,
                              width: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: [
                                  Text(listKerajinan[index].nama_kerajinan),
                                  Text(
                                    listKerajinan[index].harga,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                InputKerajinan(
                                                  kerajinan:
                                                      listKerajinan[index],
                                                )));
                                  },
                                  child: Icon(Icons.edit),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    deleteKerajinan(
                                        listKerajinan[index].id_kerajinan);
                                  },
                                  child: Icon(Icons.delete),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                InputKerajinan(
                                                  kerajinan:
                                                      listKerajinan[index],
                                                )));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (i) {
          switch (i) {
            case 0:
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => HomePage()));
              break;
            case 1:
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (BuildContext context) => KerajinanPage()));
              break;
            default:
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                ' Home',
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              title: Text(
                ' Kerajinan ',
              )),
        ],
      ),
    );
  }
}
