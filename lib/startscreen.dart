import 'package:flutter/material.dart';
import 'package:xlights_test/xLightsServer.dart';

class StartScreen extends StatefulWidget {
  final Map<String, dynamic>? routeParams;

  const StartScreen({Key? key, this.routeParams}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
   late Future<String> xLightsVersion ;
 late Future< String> showFolder ;
  bool offline = true;
  bool tooOld = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    xLightsVersion = getVersion();
    xLightsVersion.then((version) {
      setState(() {
        tooOld = version.compareTo('2023.06') < 0;
        offline = version.isEmpty;
      });
    });
    showFolder = getShowFolder();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('xLights Remote'),
 automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, size: 36),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],

      ),
      body: Center(
        // FutureBuilder
        child: FutureBuilder<String>(
          future: Future.value(showFolder),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // until data is fetched, show loader
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // once data is fetched, display it on screen (call buildPosts())
              final controllers = snapshot.data!;
             // _buildButton('Models', offline, () => Navigator.pushNamed(context, '/Models'));
             // _buildButton('Controllers', offline, () => Navigator.pushNamed(context, '/controllers'));
              //Text('Show Folder: $showFolder');
             // Text('xLights Version: $xLightsVersion');
              //return _buildButton('Controllers', offline, () => Navigator.pushNamed(context, '/controllers'));
              return FutureBuilder<String>(
                future: xLightsVersion,
                builder: (context, versionSnapshot) {
                  if (versionSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (versionSnapshot.hasData) {
                    return buildScreen(controllers, versionSnapshot.data!, tooOld);
                  } else {
                    return const Text("Failed to get xLights version");
                  }
                },
              );
            } else {
              // if no data, show simple Text
              return const Text("Failed to Connect to xLights, Check IP Address Settings");
            }
          },
        ),
      ),
    );
  }


    Widget buildScreen(String showFolder, String xLightsVersion, bool tooOld) {
    
    return 
 Container(
          padding: EdgeInsets.all(10),
          //color: Color(0xFFE8EAF6),
          child: Column(
            children: [
              _buildButton('Controllers', () => Navigator.pushNamed(context, '/controllers')),
              _buildButton('Models', () => Navigator.pushNamed(context, '/models')),
              //if (offline)
              //  Text('Failed to Connect to xLights, Check IP Address Settings', style: TextStyle(color: Colors.red)),
              if (tooOld)
                Text('Please Update xLights to 2023.06 to use this App', style: TextStyle(color: Colors.red)),
              Text('Show Folder: $showFolder'),
              Text('xLights Version: $xLightsVersion'),
            ],
          ),

    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA40000),
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed:  onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

