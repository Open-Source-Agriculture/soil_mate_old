import 'package:flutter/material.dart';

class ExportScreen extends StatefulWidget {
  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool selectDataAll = false;
  bool selectDataBySite = false;
  bool selectDataByDate = false;
  bool exportByEmail = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        primary: true,
        appBar: new AppBar(
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Which Samples do you want to export?'),
              Row(
                children: [
                  Checkbox(
                    value: selectDataAll,
                    onChanged: (bool value) {
                      setState(() {
                        selectDataAll = value;
                      });
                    },
                  ),
                  Text('All'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: selectDataByDate,
                    onChanged: (bool value) {
                      setState(() {
                        selectDataByDate = value;
                      });
                    },
                  ),
                  Text('Select By Date'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: selectDataBySite,
                    onChanged: (bool value) {
                      setState(() {
                        selectDataBySite = value;
                      });
                    },
                  ),
                  Text('Select by Site'),
                ],
              ),
              Text('How do you want to export?'),
              Row(
                children: [
                  Checkbox(
                    value: exportByEmail,
                    onChanged: (bool value) {
                      setState(() {
                        exportByEmail = value;
                      });
                    },
                  ),
                  Text('Export by Email'),
                ],
              ),
              FlatButton(
                  onPressed: (){},
                  child:
                  Text('Export'),)
            ],
          ),
        ),
      ),
    );
  }
}
