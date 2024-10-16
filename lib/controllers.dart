import 'package:flutter/material.dart';
import 'package:xlights_test/controller.dart';
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
              final posts = snapshot.data!;
              return buildPosts(posts);
            } else {
              // if no data, show simple Text
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildPosts(List<Controller> posts) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Container(
          color: Colors.grey.shade300,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Row(
            children: [
              Expanded(flex: 1, child: Text(post.name!)),
              Expanded(flex: 1, child: Text(post.address!)),
              Expanded(flex: 1, child: Text(post.vendor!)),
              Expanded(flex: 1, child: Text(post.model!)),
              Expanded(flex: 1, child: Text(post.type!)),
               Expanded(flex: 1, child: Text(post.startchannel!.toString())),
               Expanded(flex: 1, child: Text(post.active!.toString())),
            ],
          ),
        );
      },
    );
  }
}