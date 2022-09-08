import 'dart:convert';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:gallery_app/model.dart';
import 'package:gallery_app/showpage.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String link =
      "https://picsum.photos/v2/list?fbclid=IwAR2qk2kE60PcFr1S3OdDKwH9v6bhfWzmIaByJTvViW2iVnLMtDC4Lg7IyeI";

  List<ModelData> allData = [];

  fetchData() async {
    var response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      print(response.body);

      var item = jsonDecode(response.body);
      print(item);

      for (var data in item) {
        ModelData modelDataObj = ModelData(
            id: data["id"],
            author: data["author"],
            width: data["width"],
            height: data["height"],
            url: data["url"],
            download_url: data["download_url"]);
        setState(() {
          allData.add(modelDataObj);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Artworks",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: Row(
          children: [
            Icon(
              Icons.settings,
              color: Colors.orange,
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.filter_alt,
              color: Colors.orange,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 14, right: 12),
            child: Text(
              "Share",
              style: TextStyle(color: Colors.orange, fontSize: 20),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12),
            margin: EdgeInsets.only(top: 10),
            height: 50,
            width: 450,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 22,
                ),
                Text(
                  "Search",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Expanded(
            child: StaggeredGridView.countBuilder(
              itemCount: allData.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    color: Colors.white,
                    child: allData != null
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Showpage(
                                                      image: allData[index]
                                                          .download_url,
                                                    )));
                                      },
                                      child: index.isEven
                                          ? Image.network(
                                              "${allData[index].download_url}",
                                              height: 330,
                                              //
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "${allData[index].download_url}",
                                              height: 200,
                                              //
                                              fit: BoxFit.cover,
                                            )),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 45,
                                        width: 200,
                                        color: Colors.black54,
                                      )),
                                  Positioned(
                                      bottom: 15,
                                      left: 15,
                                      child: Text(
                                        "${allData[index].author}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      )),
                                ],
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                );
              },
              //
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              staggeredTileBuilder: (int index) {
                new StaggeredTile.fit(2);
                return StaggeredTile.count(1, index.isEven ? 1.5 : 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
