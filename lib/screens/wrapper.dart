import 'package:flutter/material.dart';
import 'package:texture_app/screens/home/home.dart';
import 'package:texture_app/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:texture_app/models/user.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}
