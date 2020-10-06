class Sample{
  final double lat;
  final double lon;
  final String textureClass;
  // nearest cm
  final int depthShallow;
  final int depthDeep;
  // nearest %
  final int sand;
  final int silt;
  final int clay;
  Sample({this.lat, this.lon,this.textureClass, this.depthShallow, this.depthDeep, this.sand, this.silt, this.clay});

}