import 'package:texture_app/models/sample.dart';
import 'package:texture_app/models/common_keys.dart';

class Site{
  final DateTime date = DateTime.now();
  final String name;
  final String classification;
  final List<Map<String, dynamic>> rawSamples;
  List<Sample> samples = [];
  var defaultList;

  Site({this.name,this.classification, this.rawSamples}){
    samples = this.rawSamples.map((item) => Sample(
      lat: item[LAT],
      lon: item[LON],
      textureClass: item[TEXTURECLASS],
      depthShallow: item[DEPTHSHALLOW],
      depthDeep: item[DEPTHDEEP],
      sand: item[SAND],
      silt: item[SILT],
      clay: item[CLAY],
    ));
  }

  void addSample(Sample sample){
    samples.add(sample);
  }
}