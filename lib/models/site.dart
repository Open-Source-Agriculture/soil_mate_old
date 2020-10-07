
import 'package:texture_app/models/sample.dart';
import 'package:texture_app/models/common_keys.dart';

class Site{
  final DateTime date = DateTime.now();
  String name;
  String classification;
  List rawSamples;
  List<Sample> samples = [];
  var defaultList;

  Site(Map e){
    this.name = e[SITE_NAME];
    this.classification = e[TEXTURE_CLACIFICATION];
    this.rawSamples = e[SAMPLES].toList();
    this.samples = [];
    print("rawSamples");
    print(this.rawSamples);
    this.rawSamples = this.rawSamples.map((rawSample) => rawSample).toList();
    List<Sample> mysamples = this.rawSamples.map((e) => Sample(
      lat: e[LAT],
      lon: e[LON],
      textureClass: e[TEXTURECLASS],
      depthShallow: e[DEPTHSHALLOW],
      depthDeep: e[DEPTHDEEP],
      sand: e[SAND],
      silt: e[SILT],
      clay: e[CLAY]

    )).toList();
    print(mysamples);
    samples = mysamples;
  }

  void addSample(Sample sample){
    samples.add(sample);
  }
}