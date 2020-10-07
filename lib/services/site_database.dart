import 'package:texture_app/services/app_hive.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/common_keys.dart';

List<Site> getSites(){
  List<Site> sites = [];
  if (appBoxes.isLoaded){
    if (appBoxes.siteBox.isNotEmpty){
      print(appBoxes.siteBox.length);
      print(appBoxes.siteBox.values);
      print(appBoxes.siteBox.keys);
      sites  = appBoxes.siteBox.values.toList().map((e) => Site(e)).toList();
    }
  }
  return sites;
}

void saveSite(Site site){
  print(site.name);
  print(site.classification);
  print(site.date);
  print(site.samples.map((s) => s.getData()).toList());
  if (appBoxes.isLoaded){
    Map<String, dynamic> siteMap = {
      SITE_NAME: site.name,
      TEXTURE_CLACIFICATION: site.classification,
      DATE: site.date,
      SAMPLES: site.samples.map((s) => s.getData()).toList()
    };
    print(siteMap.toString());
    appBoxes.queSiteBox.put(site.name,siteMap);
    appBoxes.siteBox.put(site.name, siteMap);
  }
}