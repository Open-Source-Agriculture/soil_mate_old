import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Credits",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 2.0,
        actions: <Widget>[

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250,
                  child: Text(
                    'This app was developed by Open Source Agriculture \n We are siblings who are passionate about agriculture and open-source.'
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                    child: Image(
                        image: AssetImage('assets/credits_selfie.jpg'),
                        fit: BoxFit.fill
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20,),
            Text(
                'Thank you for using Soil Mate. \nTo keep the development of the app free and open-source, consider supporting us by:'
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Join our community on Discord'
                ),
                GestureDetector(
                  onTap: _launchURLdiscord,
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage('https://i.redd.it/0d63r5dn8f051.jpg'),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Support Our Patreon'
                ),
                GestureDetector(
                  onTap: _launchURLpatreon,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: NetworkImage('https://images-ext-1.discordapp.net/external/8237GLHWkjvA13Gii2N8rvtXKmHD9AXy61iH8J1goEs/https/lh3.googleusercontent.com/proxy/gUpjlzvXpX3rjvG4gONdObt1P2QTSSU_-g3OmglGlLLvfvQtaTqq-KbNaXp65kaZzZZ9KDV5oW97HC62uNTSQZtyGfDQpVyY2PEiewUXc5-ZIljG43IvCxv7jvdoYHXujgE1QSuDSCJg4LJPVpTtzLvnRC9m?width=428&height=428'),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Check us out on GitHub'
                ),
                GestureDetector(
                  onTap: _launchURLgithub,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage('https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Explore our Website'
                ),
                GestureDetector(
                  onTap: _launchURLwebsite,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage('https://images-ext-2.discordapp.net/external/oILHEZeLv57SKia7lKw-587En-p72rtKlSo14uTynTs/https/open-source-agriculture.github.io/assets/img/avatar.png?width=428&height=428'),
                          fit: BoxFit.fill
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

_launchURLdiscord() async {
  const urldiscord = 'https://discord.gg/8x58DuxfGz';
  if (await canLaunch(urldiscord)) {
    await launch(urldiscord);
  } else {
    throw 'Could not launch $urldiscord';
  }
}

_launchURLpatreon() async {
  const urlpatreon = 'https://www.patreon.com/opensourceagriculture';
  if (await canLaunch(urlpatreon)) {
    await launch(urlpatreon);
  } else {
    throw 'Could not launch $urlpatreon';
  }
}

_launchURLgithub() async {
  const urlgithub = 'https://github.com/Open-Source-Agriculture';
  if (await canLaunch(urlgithub)) {
    await launch(urlgithub);
  } else {
    throw 'Could not launch $urlgithub';
  }
}

_launchURLwebsite() async {
  const urlwebsite = 'https://open-source-agriculture.github.io';
  if (await canLaunch(urlwebsite)) {
    await launch(urlwebsite);
  } else {
    throw 'Could not launch $urlwebsite';
  }
}