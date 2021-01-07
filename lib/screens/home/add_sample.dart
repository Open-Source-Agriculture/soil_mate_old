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
  Site site = Site(
      name: 'placeHolder',
      classification: "aus",
      rawSamples: [],
      increment: 0
  );




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

  TextureClass selectedTexture = AusClassification().getTextureList()[0];

  @override
  Widget build(BuildContext context) {

    Site iSite = Site(
        name: baseSiteKey,
        classification: "aus",
        rawSamples: [],
        increment: 0
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


    Function setTexture(TextureClass tc){
      this.selectedTexture = tc;
      setState(() {
        this.selectedTexture = tc;
      });
    }


    var txt2 = TextEditingController();
    txt2.text = depthUpper.toString();
    txt2.selection = TextSelection.fromPosition(TextPosition(offset: depthUpper.toString().length));

    var txt3 = TextEditingController();
    txt3.text = depthLower.toString();
    txt3.selection = TextSelection.fromPosition(TextPosition(offset: depthLower.toString().length));

    var txt4 = TextEditingController();
    txt4.text = site.increment.toString();
    txt4.selection = TextSelection.fromPosition(TextPosition(offset: site.increment.toString().length));



    AusClassification ausClassification = AusClassification();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData( color: Colors. black),
        backgroundColor: Colors.grey[300],
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 17),
            Text(
              'Specify a soil texture',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 180,
              child: GridView.count(
                childAspectRatio: (3/1),
                crossAxisCount: 3,
                children: AusClassification().getTextureList().map((texture) => TextureButton(
                    textureClass: texture,
                    setTextureFunction: setTexture,
                )).toList(),
              ),

            ),
            SizedBox(height: 30),
            Text(
                'Specify the depth range and sample ID',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 30),
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
            SizedBox(height: 30),
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
            SizedBox(height: 30),
            Row(
              children: [
                Text('Sample ID: '),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(100, 25)),
                  child: TextFormField(
                    maxLength: 5,
                    decoration: InputDecoration(
                        counterText: ''
                    ),

                    // initialValue: att.toString(),
                    controller: txt4,
                    // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    autovalidate: true,
                    keyboardType: TextInputType.number,
                    onChanged: (val){
                      setState(() {
                        site.increment = int.parse(val);
                        print(site.increment);
                      });

                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: FlatButton(
                padding: const EdgeInsets.all(15),
                color: selectedTexture.getColor().withOpacity(0.5),
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: selectedTexture.getColor(),
                    width: 2,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(15)),
                onPressed:(){
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
                            clay: selectedTexture.clay,
                            id: site.increment,
                        );
                        print(s.getData().toString());
                        site.addSample(s);
                        print(site.samples.map((e) => e.textureClass));
                        site.increment = site.increment + 1;
                        print(site.increment);
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


                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Confirm Sample',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                        'Texture:        '
                            + selectedTexture.name
                            + '\nDepth range:     ' + depthUpper.toString() + ' cm to ' + depthLower.toString() + ' cm',
                      style: TextStyle(
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );



  }

}


class TextureButton extends StatelessWidget {
  final TextureClass textureClass;
  final Function setTextureFunction;



  TextureButton({Key /*?*/ key, @required this.textureClass, @required this.setTextureFunction,}) : super(key: key){}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        color: textureClass.getColor().withOpacity(0.5),
        shape: RoundedRectangleBorder(side: BorderSide(
            color: textureClass.getColor(),
            width: 2,
            style: BorderStyle.solid
        ), borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          print(this.textureClass.name);
          this.setTextureFunction(this.textureClass);
        },
        child: Text(
          textureClass.name,
          style: TextStyle(
          ),
        ),
      ),
    );
  }
}
