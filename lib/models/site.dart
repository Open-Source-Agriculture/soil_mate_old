import 'package:texture_app/models/sample.dart';

class Site{
  final DateTime date = DateTime.now();
  final String classification;
  List<Sample> samples = [];

  Site({this.classification});

  void addSample(Sample sample){
    samples.add(sample);
  }
}