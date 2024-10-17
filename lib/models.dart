import 'package:flutter/material.dart';
import 'package:xlights_test/modelinfo.dart';
import 'package:xlights_test/startscreen.dart';

import 'package:xlights_test/xlightsserver.dart';

class ModelsScreen extends StatefulWidget {
  const ModelsScreen({super.key});

  @override
  State<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  late Future<List<String>> modelsList;

  @override
  void initState() {
    super.initState();
    modelsList = getModels();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Models'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => StartScreen()));
          },
        ),
      ),
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<String>>(
          future: modelsList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // until data is fetched, show loader
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // once data is fetched, display it on screen (call buildPosts())
              final controllers = snapshot.data!;
              return buildControllers(controllers);
            } else {
              // if no data, show simple Text
              return const Text("Not Connected to xLights");
            }
          },
        ),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildControllers(List<String> models) {
    // ListView Builder to show data in a list
    return ListView.separated(
      itemCount: models.length,
      itemBuilder: (context, index) {
        final modelName = models[index];
        //String itemTitle = modelName;
        //String itemsubTitle = "${controller.address!} ${controller.vendor!} ${controller.model!} Active: ${controller.active!}";
        return ListTile(
        title: Text(modelName),
        //subtitle: Text(itemsubTitle),
        onTap: () {

          //var snackBar = SnackBar(content: Text("Tapped on $itemTitle"));
          //ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ModelInfoScreen( modelName: modelName,)));
        },
      );
       
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}