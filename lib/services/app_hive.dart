import 'package:hive/hive.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';


AppBoxes appBoxes = AppBoxes();

class AppBoxes {

  bool isLoaded = false;
  Box userBox;
  Box eventBox;

  AppBoxes(){
    load();
  }

  Future<Object> load() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.openBox('eventBox');
    eventBox = Hive.box('eventBox');
    await Hive.openBox('userBox');
    userBox = Hive.box('userBox');
    isLoaded = true;

  }
}