import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:texture_app/models/texture_models.dart';
import 'package:texture_app/services/app_hive.dart';
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/models/common_keys.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/services/site_database.dart';
import 'date.dart';


class PolygonMap extends StatefulWidget {

  PolygonMap({Key key, this.title = 'Add Sample'}) : super(key: key);

  final String title;

  @override
  _PolygonMapState createState() => _PolygonMapState();
}

class _PolygonMapState extends State<PolygonMap> {
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


  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  Future<Map<String,double>> getCurrentLocation() async {
    double lat = sampledLat;
    double lon = sampledLon;

    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          sampledLat = newLocalData.latitude;
          sampledLon = newLocalData.longitude;

          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(lat, lon),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

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

  @override
  Widget build(BuildContext context) {
    site = Site(
        name: DateTime.now().toIso8601String(),
        classification: "Aus",
        rawSamples: []
    );


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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,  // or use fixed size like 200
              height: MediaQuery.of(context).size.height*0.8,
              child: GoogleMap(

                mapType: MapType.hybrid,
                initialCameraPosition: initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },

              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
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

                }


              });
            });

          }),
    );
  }
}