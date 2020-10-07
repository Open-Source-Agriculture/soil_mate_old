import 'package:flutter/material.dart';
import 'package:texture_app/screens/home/exportscreen.dart';
import 'package:texture_app/screens/home/addsample.dart';
import 'package:texture_app/screens/home/managescreen.dart';
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
        body: ListView.builder(
            // itemCount: locations.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      // updateTime(index);
                    },
                    // title: Text(locations[index].location),
                    title: Text('Site One'),
                    /*leading: Text('1') CircleAvatar(
                      backgroundImage: AssetImage('assets/${locations[index].flag}'),
                    ),*/
                  ),
                ),
              );
            }
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add'),
            ),
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportScreen()),
                  );
                },
                icon: Icon(Icons.file_upload),
                label: Text('Export')),
            FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageScreen()),
                  );
                },
                icon: Icon(Icons.insert_drive_file),
                label: Text('Manage')),
            FlatButton.icon(
                onPressed: (){},
                icon: Icon(Icons.more_vert),
                label: Text(''))
          ],
        ),
      )
    );
  }
}
