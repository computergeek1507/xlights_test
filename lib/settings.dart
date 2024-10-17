import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic>? routeParams;

  const SettingsScreen({Key? key, this.routeParams}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late  TextEditingController iptc = TextEditingController();
   late TextEditingController porttc = TextEditingController();
  //String ipAddress = "127.0.0.1";
  //String port = "49913";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      iptc = TextEditingController(text: prefs.getString('ip') ?? "127.0.0.1");
      porttc = TextEditingController(text: prefs.getString('port') ?? "49913");
      //iptc.text = prefs.getString('ip') ?? "127.0.0.1";
      //porttc.text = prefs.getString('port') ?? "49913";
    });
  }

  Future<void> _storeData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            _storeData('ip', iptc.text);
            _storeData('port', porttc.text);
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'xLight Connection Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

       /*      TextFormField(
          controller: iptc,
        ),
        TextFormField(
          controller: porttc,
        ),*/
            TextField(
              decoration: InputDecoration(
                labelText: 'IP',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 28),
              controller: iptc,
              //onChanged: (val) => setState(() => ipAddress = val),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 28),
              controller: porttc,
              //onChanged: (val) => setState(() => port = val),
            ),
          ],
        ),
      ),
    );
  }
}

