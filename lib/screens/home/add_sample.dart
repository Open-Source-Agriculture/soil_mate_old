import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:texture_app/models/texture_models.dart';
import 'package:texture_app/screens/home/sample_list.dart';
import 'package:texture_app/services/app_hive.dart';
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/models/common_keys.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/services/site_database.dart';

import '../../models/texture_models.dart';
import 'date.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: AddSamplePage(title: 'Add Sample'),
    );
  }
}

class AddSamplePage extends StatefulWidget {

  AddSamplePage({Key key, this.title = 'Add Sample'}) : super(key: key);

  final String title;

  @override
  _AddSamplePageState createState() => _AddSamplePageState();
}

class _AddSamplePageState extends State<AddSamplePage> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  double sampledLat = 37.42796133580664;
  double sampledLon = -122.085749655962;
  List<Sample> samples = [];
  int depthUpper = 0;
  int depthLower = 10;
  Site site;




  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  Future<Map<String,double>> getCurrentLocation() async {
    double lat = sampledLat;
    double lon = sampledLon;

    try {

//      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      lon = location.longitude;
      lat = location.latitude;



    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
    return {LAT:lat, LON: lon};
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }


  List<Site> allSites = [];
  bool dataLoaded = false;
  String baseSiteKey =  "BaseSite";
  List<Sample> baseSamples = [];

  TextureClass selectedTexture = AusClassification().loam;

  @override
  Widget build(BuildContext context) {

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
      dataLoaded = true;
      List<dynamic> baseSiteList = allSites.where((s) => s.name == baseSiteKey).toList();
      Site baseSite = baseSiteList[0];
      site = baseSite;
      baseSamples = baseSite.samples;
      print(baseSamples);
      setState(() {});
    }
    if (!dataLoaded){
      print("trying to load");
      loadData();
    }


    var txt2 = TextEditingController();
    txt2.text = depthUpper.toString();
    txt2.selection = TextSelection.fromPosition(TextPosition(offset: depthUpper.toString().length));

    var txt3 = TextEditingController();
    txt3.text = depthLower.toString();
    txt3.selection = TextSelection.fromPosition(TextPosition(offset: depthLower.toString().length));

    AusClassification ausClassification = AusClassification();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(17, 20, 17, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Step 1) Please specify a soil texture',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FlatButton(
                    color: AusClassification().sandyLoam.getColor(),
                    onPressed: () {
                      selectedTexture = AusClassification().sandyLoam;
                      setState(() {});
                    },
                    child: Text(
                        ausClassification.sandyLoam.name,
                        style: TextStyle(
                        ),
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: FlatButton(
                    color: AusClassification().loam.getColor(),
                    onPressed: () {
                      selectedTexture = AusClassification().loam;
                      setState(() {});
                    },
                    child: Text(ausClassification.loam.name),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: FlatButton(
                    color: AusClassification().sandyClay.getColor(),
                    onPressed: () {
                      selectedTexture = AusClassification().sandyClay;
                      setState(() {});
                    },
                    child: Text(ausClassification.sandyClay.name),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FlatButton(
                    color: AusClassification().clay.getColor(),
                    onPressed: () {
                      selectedTexture = AusClassification().clay;
                      setState(() {});
                    },
                    child: Text(ausClassification.clay.name),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: FlatButton(
                    color: AusClassification().siltyClay.getColor(),
                    onPressed: () {
                      selectedTexture = AusClassification().siltyClay;
                      setState(() {});
                    },
                    child: Text(ausClassification.siltyClay.name),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: FlatButton(
                    color: AusClassification().siltyLoam.getColor(),
                    onPressed: () {
                      selectedTexture = AusClassification().siltyLoam;
                      setState(() {});
                    },
                    child: Text(ausClassification.siltyLoam.name),
                  ),
                )
              ],
            ),
            Text(
                'Step 2) Please specify the depth range ',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Text('Upper depth: '),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(55, 25)),
                  child: TextFormField(
                    maxLength: 3,
                    decoration: InputDecoration(
                        counterText: ''
                    ),
                    // initialValue: att.toString(),
                    controller: txt2,
                    // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    autovalidate: true,
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() {
                        depthUpper = int.parse(val);
                        print(depthUpper);
                      });

                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Lower depth: '),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(55, 25)),
                  child: TextFormField(
                    maxLength: 3,
                    decoration: InputDecoration(
                        counterText: ''
                    ),

                    // initialValue: att.toString(),
                    controller: txt3,
                    // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    autovalidate: true,
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() {
                        depthLower = int.parse(val);
                        print(depthLower);
                      });

                    },
                  ),
                ),
              ],
            ),
            Container(
              height: 100,
              width: 250,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[500], width: 3),
                borderRadius: BorderRadius.circular(20),
                color: Colors.lightBlue[50],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Sample Summary: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                      'Chosen texture is '
                          + selectedTexture.name
                          + '\n Depth range is ' + depthUpper.toString() + ' to ' + depthLower.toString()
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.save),
          label: Text('Save'),
          onPressed: () {
            print("Pressed");
            print(sampledLat);
            print(sampledLon);
            Future<Map<String,double>> currentLocation =  getCurrentLocation();
            currentLocation.then((Map<String,double> locationDict){
              setState(() {
                print(locationDict.toString());
                if (locationDict[LAT] != null){
                  sampledLat = locationDict[LAT];
                  sampledLon = locationDict[LON];
                  Sample s = Sample(
                      lat: sampledLat,
                      lon: sampledLon,
                    textureClass: selectedTexture.name,
                    depthShallow: depthUpper,
                    depthDeep: depthLower,
                    sand: selectedTexture.sand,
                    silt: selectedTexture.silt,
                    clay: selectedTexture.clay
                  );
                  print(s.getData().toString());
                  site.addSample(s);
                  print(site.samples.map((e) => e.textureClass));
                  Future<void> saveDataPushHome() async {
                    await overrideSite(site);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SampleList()),
                    );
                  }
                  saveDataPushHome();

                } else {
                  print('no gps data');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SampleList()),
                  );
                }


              });
            });


          }),
    );
  }
}