import 'package:flutter/material.dart';
import 'package:texture_app/screens/home/exportscreen.dart';
import 'package:texture_app/screens/home/addsample.dart';
import 'package:texture_app/screens/home/managescreen.dart';
import 'package:texture_app/services/app_hive.dart';
import 'package:texture_app/services/auth.dart';
import 'package:texture_app/services/site_database.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/models/common_keys.dart';
import 'package:texture_app/screens/home/site_overview.dart';
import 'dart:async';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  List<Site> allSites = [];
  bool dataLoaded = false;
  String baseSiteKey =  "BaseSite";


  @override
  Widget build(BuildContext context) {
    //Add samples to sites
    Site iSite = Site(
        name: baseSiteKey,
        classification: "aus",
        rawSamples: []
    );


    Future<void> loadData() async {
      bool alreadySite = await saveSite(iSite);
      if (alreadySite){
        print("Cant use this name; already exists");
      }
      this.allSites = await getSites();
      print(this.allSites);
      dataLoaded = true;
      print("Data loaded");
//      List<dynamic> allSitesNames = allSites.map((s) => s.name).toList();
//      print(allSitesNames);
      List<dynamic> baseSiteList = allSites.where((s) => s.name == baseSiteKey).toList();
      Site baseSite = baseSiteList[0];
      List<Sample> baseSamples = baseSite.samples;
      print("baseSamples");
      print(baseSamples);
      setState(() {});
    }
    if (!dataLoaded){
      print("trying to load");
      loadData();
    }




//    if (allSitesNames.contains("BaseSite")){
//      print("contains");
//    }

    return Container(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: Text("Home"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(onPressed: () async {
              await _auth.signOut();
            },
                icon: Icon(Icons.person),
                label: Text("Logout"))
          ],
        ),
        body: ListView.builder(
            itemCount: allSites.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => SiteOverviewPage(site: allSites[index],),
                      ),
                      );
                    },
                    // title: Text(locations[index].location),
                    title: Text(allSites[index].name),
                    /*leading: Text('1') CircleAvatar(
                      backgroundImage: AssetImage('assets/${locations[index].flag}'),
                    ),*/
                  ),
                ),
              );
            }
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add'),
            ),
            FlatButton.icon(
              onPressed: (){
                print("will delete");
//                print(baseSamples);
              },
              icon: Icon(Icons.delete),
              label: Text('Delete All'),
            ),
          ],
        ),
      )
    );
  }
}
