import 'package:texture_app/models/sample.dart';
import 'package:texture_app/models/site.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}


Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/temp.csv');
}


Future<void> writeCSV(String csvString) async {
  final file = await _localFile;
  file.writeAsString(csvString);
  String contents = await file.readAsString();
  print("From file:");
  print(contents);
}


void sendEmail(Site site){
  print("make csv");
  List<Sample> samples = site.samples;
  List<List<String>> allSamplesLists = samples.map((s) {
                    List<String> sampleList = [
                      s.lat.toString(),
                      s.lon.toString(),
                      s.textureClass,
                      s.depthShallow.toString(),
                      s.depthDeep.toString(),
                      s.sand.toString(),
                      s.silt.toString(),
                      s.clay.toString()
                    ];
                    print(sampleList);
                    return sampleList;
                  }).toList();


  String csv = const ListToCsvConverter().convert(allSamplesLists);
  writeCSV(csv);



}