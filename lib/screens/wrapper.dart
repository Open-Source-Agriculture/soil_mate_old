import 'package:flutter/material.dart';
import 'package:texture_app/screens/home/sample_list.dart';
import 'package:permission_handler/permission_handler.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  Future<void> requestLocation() async {
    if (await Permission.location.isGranted) {
      print("Granted");
    }else{
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
      print(statuses[Permission.location]);
    }
  }





  @override
  Widget build(BuildContext context) {


    requestLocation();


    return SampleList();
//    // This is hidden for the minimal app
//    final user = Provider.of<User>(context);
//    if (user == null){
//      return Authenticate();
//    }else{
//      return Home();
//    }
  }
}
