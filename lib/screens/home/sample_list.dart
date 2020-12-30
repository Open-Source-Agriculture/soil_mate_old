import 'package:flutter/material.dart';
import 'package:texture_app/screens/home/add_sample.dart';
import 'package:texture_app/services/send_email.dart';
import 'package:texture_app/services/site_database.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/sample.dart';
import 'dart:async';


class SampleList extends StatefulWidget {

  @override
  _SampleListState createState() => _SampleListState();
}

class _SampleListState extends State<SampleList> {
  List<Site> allSites = [];
  bool dataLoaded = false;
  String baseSiteKey =  "BaseSite";
  Site baseSite;
  List<Sample> baseSamples = [];


  @override
  Widget build(BuildContext context) {
    //Add samples to sites
    Site iSite = Site(
        name: baseSiteKey,
        classification: "aus",
        rawSamples: []
    );

    Color getColor(int sand, int silt, int clay) {
    int R = (225*sand + 225*clay)~/100;
    int G = (225*sand + 225*silt)~/100;
    int B = (225*silt + 225*clay)~/100;
    return Color.fromRGBO(R, G, B, 1);
  }


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
      baseSite = baseSiteList[0];
      baseSamples = baseSite.samples;
      print("baseSamples");
      print(baseSamples);
      setState(() {});
    }
    if (!dataLoaded){
      print("trying to load");
      loadData();
    }


    Future<void> deleteSamples() async {
      overrideSite(iSite);
      loadData();

    }




//    if (allSitesNames.contains("BaseSite")){
//      print("contains");
//    }

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Sample List",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.grey[300],
          elevation: 2.0,
          actions: <Widget>[
          ],
        ),
        body: ListView.builder(
            itemCount: baseSamples.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: getColor(baseSamples[index].sand, baseSamples[index].silt, baseSamples[index].clay), width: 3.0),
                    color: getColor(baseSamples[index].sand, baseSamples[index].silt, baseSamples[index].clay).withOpacity(0.7),
                  ),
                  child: ListTile(
                    onTap: () {
                      print("Nothing");
                    },
                    // title: Text(locations[index].location),
                    title: Text('Texture: ' + baseSamples[index].textureClass + '\n' + baseSamples[index].lat.toString() + ', ' + baseSamples[index].lon.toString()),
                    subtitle: Text('Sand: ' + baseSamples[index].sand.toString()
                        + ', Silt: ' + baseSamples[index].silt.toString()
                        + ', Clay: ' +  baseSamples[index].clay.toString()
                        + '\nDepth Upper: ' +  baseSamples[index].depthShallow.toString()
                        + ', Depth Lower: '  + baseSamples[index].depthDeep.toString()),
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
                    MaterialPageRoute(builder: (context) => AddSamplePage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add'),
            ),
            FlatButton.icon(
              onPressed: (){
                print(baseSamples);
                deleteSamples();

              },
              icon: Icon(Icons.delete),
              label: Text('Delete All'),

            ),
            FlatButton.icon(
              onPressed: (){
                print("Export Data");
                sendEmail(baseSite);

              },
              icon: Icon(Icons.import_export),
              label: Text('Export Data'),

            ),
          ],
        ),
      )
    );
  }
}
