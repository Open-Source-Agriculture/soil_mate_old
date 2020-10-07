import 'package:texture_app/services/app_hive.dart';
import 'package:texture_app/models/site.dart';
import 'package:texture_app/models/common_keys.dart';

List<Site> getSites(){
  List<Site> sites = [];
  if (appBoxes.isLoaded){
    if (appBoxes.siteBox.isNotEmpty){
      print(appBoxes.siteBox.length);
      List<String> siteKeys = appBoxes.siteBox.keys;
      List<Map<String,dynamic>> siteInfo = siteKeys.map((e) => appBoxes.siteBox.get(e));

      sites = siteInfo.map((si) => Site(
        name: si[SITE_NAME],
        classification: si[TEXTURE_CLACIFICATION],
        rawSamples: si[SAMPLES]
      ));
    }
  }
  return sites;
}

void saveSite(Site site){
  if (appBoxes.isLoaded){
    Map<String, dynamic> siteMap = {
      SITE_NAME: site.name,
      TEXTURE_CLACIFICATION: site.classification,
      DATE: site.date,
      SAMPLES: site.samples.map((s) => s.getData())
    };
    appBoxes.queSiteBox.add(siteMap);
    appBoxes.siteBox.add(siteMap);
  }
}