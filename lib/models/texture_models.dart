import 'package:flutter/cupertino.dart';

class AusClassification {
  TextureClass sandyLoam = TextureClass(name: 'Sandy Loam', sand: 70, silt: 20, clay: 10);
  TextureClass loam = TextureClass(name: 'Loam',sand: 65, silt: 10, clay: 25);
  TextureClass sandyClay = TextureClass(name: 'Sandy Clay',sand: 50, silt: 10, clay: 40);
  TextureClass clay = TextureClass(name: 'Clay',sand: 10, silt: 10, clay: 80);
  TextureClass siltyClay = TextureClass(name: 'Silty Clay',sand: 10, silt: 45, clay: 45);
  TextureClass siltyLoam = TextureClass(name: 'Silty Loam',sand: 15, silt: 65, clay: 20);
}

class TextureClass{
  final int sand;
  final int silt;
  final int clay;
  final String name;
  Color getColor() {
    int R = (225*sand + 225*clay)~/100;
    int G = (225*sand + 225*silt)~/100;
    int B = (225*silt + 225*clay)~/100;
    return Color.fromRGBO(R, G, B, 1);
  }
  TextureClass({this.name, this.sand,this.silt,this.clay});
}
