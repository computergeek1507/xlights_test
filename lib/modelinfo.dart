import 'package:flutter/material.dart';
import 'package:xlights_test/models.dart';
import 'package:xlights_test/startscreen.dart';
import 'package:xlights_test/xlightsserver.dart';

import 'package:xlights_test/model.dart';
import 'package:xlights_test/modelgroup.dart';

class ModelInfoScreen extends StatefulWidget {
  final String modelName;

  ModelInfoScreen({Key? key, required this.modelName}) : super(key: key);

  @override
  _ModelInfoScreenState createState() => _ModelInfoScreenState();
}

class _ModelInfoScreenState extends State<ModelInfoScreen> {
  late Future<Map<String, dynamic>> modelParm ;

  @override
  void initState() {
    super.initState();
    modelParm = getModel(widget.modelName);
  }

  Future<void> updateModel() async {
    modelParm = getModel(widget.modelName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: modelParm,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            } else if (snapshot.hasData) {
              return Text(snapshot.data!['models'] == null ? "Model Info" : "Model Group Info");
            } else {
              return Text("Error");
            }
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
             Navigator.push(context,
              MaterialPageRoute(builder: (context) => ModelsScreen()));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: (){
             Navigator.push(context,
              MaterialPageRoute(builder: (context) => StartScreen()));
          },
          ),
        ],
      ),
      body: Container(
        child: Container(
          padding: EdgeInsets.all(10),
          //color: Color(0xFFE8EAF6),
        child: Center(
          // FutureBuilder
          child: FutureBuilder<Map<String, dynamic> >(
            future: getModel(widget.modelName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // until data is fetched, show loader
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                // once data is fetched, display it on screen (call buildPosts())
                final modeldata = snapshot.data!;
                return  modeldata['models'] == null
                ? ModelDisplay(model: modeldata, callback: updateModel)
                : ModelGroupDisplay(model: modeldata);
              } else {
                // if no data, show simple Text
                return const Text("Not Connected to xLights");
              }
            },
          ),
          ),
        ),
      ),
    );
  }
}

class Styles {
  static final ButtonStyle button = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Color(0xFFA40000),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
  );

  static final ButtonStyle buttonDisabled = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Color(0xFFA40000), disabledForegroundColor: Colors.white.withOpacity(0.4).withOpacity(0.38), disabledBackgroundColor: Colors.white.withOpacity(0.4).withOpacity(0.12),
    textStyle: TextStyle(fontWeight: FontWeight.bold),
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerButton = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static final BoxDecoration resultsGrid = BoxDecoration(
    border: Border.all(color: Colors.black),
  );

  static final BoxDecoration resultsRow = BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.black)),
  );

  static final BoxDecoration resultsLabelContainer = BoxDecoration(
    border: Border(right: BorderSide(color: Colors.black)),
  );

  static const TextStyle resultsLabelText = TextStyle(
    fontSize: 14,
  );
}

