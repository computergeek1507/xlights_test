import 'package:flutter/material.dart';
import 'package:xlights_test/controller.dart';
import 'package:xlights_test/controllerinfo.dart';
import 'package:xlights_test/xlightsserver.dart';

class ControllersScreen extends StatefulWidget {
  const ControllersScreen({super.key});

  @override
  State<ControllersScreen> createState() => _ControllersScreenState();
}

class _ControllersScreenState extends State<ControllersScreen> {
  late Future<List<Controller>> controllerList;

  @override
  void initState() {
    super.initState();
    controllerList = getControllers();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controllers'),
      ),
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<Controller>>(
          future: controllerList,
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
  Widget buildControllers(List<Controller> controllers) {
    // ListView Builder to show data in a list
    return ListView.separated(
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        final controller = controllers[index];
        String itemTitle = controller.name!;
        String itemsubTitle = "${controller.address!} ${controller.vendor!} ${controller.model!} Active: ${controller.active!}";
        return ListTile(
        title: Text(itemTitle),
        subtitle: Text(itemsubTitle),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ControllerInfoScreen( controller: controller,)));
        },
      );
       
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  
}