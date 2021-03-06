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
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text("Daftar Kerajinan"),
      // ),
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

      body: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 100),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: RefreshIndicator(
              onRefresh: () => Future.sync(() => _pagingController.refresh()),
              child: PagedListView<int, Kerajinan>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Kerajinan>(
                  itemBuilder: (context, item, index) => Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DetailKerajinanPage(
                                  kerajinan: item,
                                )));
                      },
                      child: Container(
                        height: 100,
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
                              ApiStatic.host + '/' + item.foto,
                              width: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: [
                                  Text(item.nama_kerajinan),
                                  Text(
                                    item.harga,
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
                                                  kerajinan: item,
                                                )));
                                  },
                                  child: Icon(Icons.edit),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    deleteKerajinan(item.id_kerajinan);
                                    _pagingController.refresh();
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
                                                  kerajinan: item,
                                                )));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Kerajinan",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      )),
                  Text(
                    "Data Kerajinan",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.white,
                    ),
                    initialValue: _publish,
                    onSelected: (String result) {
                      setState(() {
                        _publish = result;
                        _pagingController.refresh();
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                          child: const Text('Aktif'), value: 'Y'),
                      new PopupMenuItem<String>(
                          child: const Text('Non Aktif'), value: 'N'),
                      new PopupMenuItem<String>(
                          child: const Text('Semua'), value: 'A'),
                      new PopupMenuItem<String>(
                          child: const Text('Deleted'), value: 'D'),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: TextField(
                      controller: _s,
                      onSubmitted: (_s) {
                        _pagingController.refresh();
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          hintText: "Masukkan Nama Kerajinan",
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 16),
                          prefixIcon: Material(
                            elevation: 0.0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Icon(Icons.search),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 13)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
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
