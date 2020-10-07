import 'package:flutter/material.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  bool deleteAll = false;
  bool deleteByDate = false;
  bool deleteBySite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        primary: true,
        appBar: new AppBar(
          title: Text('Manage'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: [
                  Checkbox(
                    value: deleteAll,
                    onChanged: (bool value) {
                      setState(() {
                        deleteAll = value;
                      });
                    },
                  ),
                  Text('Delete All'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: deleteByDate,
                    onChanged: (bool value) {
                      setState(() {
                        deleteByDate = value;
                      });
                    },
                  ),
                  Text('Delete By Date'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: deleteBySite,
                    onChanged: (bool value) {
                      setState(() {
                        deleteBySite = value;
                      });
                    },
                  ),
                  Text('Delete by Site'),
                ],
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: (){},
                child:
                Text('Manage'),)
            ],
          ),
        ),
      ),
    );
  }
}
