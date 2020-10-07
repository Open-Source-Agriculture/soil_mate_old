import 'package:flutter/material.dart';
import 'package:texture_app/screens/home/addsample.dart';
import 'package:texture_app/services/auth.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: Text("McTexture"),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(onPressed: () async {
              await _auth.signOut();
            },
                icon: Icon(Icons.person),
                label: Text("Logout"))
          ],
        ),
        body: Column(
          children: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
              icon: Icon(
                Icons.edit_location
              ),
              label: Text(
                'Tap to see location'
              ),

            )
          ],
        ),
      )
    );
  }
}
