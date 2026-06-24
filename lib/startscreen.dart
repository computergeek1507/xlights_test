import 'package:flutter/material.dart';
import 'package:xlights_test/controller.dart';
import 'package:xlights_test/controllerinfo.dart';
import 'package:xlights_test/modelinfo.dart';
import 'package:xlights_test/xlightsserver.dart';

class StartScreen extends StatefulWidget {
  final Map<String, dynamic>? routeParams;

  const StartScreen({Key? key, this.routeParams}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Future<List<Controller>> controllerList;
  late Future<List<String>> modelsList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    controllerList = getControllers();
    modelsList = getModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Controllers' : 'Models'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 36),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildControllersTab(),
          _buildModelsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.developer_board),
            label: 'Controllers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Models',
          ),
        ],
      ),
    );
  }

  Widget _buildControllersTab() {
    return Center(
      child: FutureBuilder<List<Controller>>(
        future: controllerList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return buildControllers(snapshot.data!);
          } else {
            return const Text("Not Connected to xLights");
          }
        },
      ),
    );
  }

  Widget _buildModelsTab() {
    return Center(
      child: FutureBuilder<List<String>>(
        future: modelsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return buildModels(snapshot.data!);
          } else {
            return const Text("Not Connected to xLights");
          }
        },
      ),
    );
  }

  // function to display fetched controllers on screen
  Widget buildControllers(List<Controller> controllers) {
    return ListView.separated(
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        final controller = controllers[index];
        String itemTitle = controller.name!;
        String itemsubTitle =
            "${controller.address!} ${controller.vendor!} ${controller.model!} Active: ${controller.active!}";
        return ListTile(
          title: Text(itemTitle),
          subtitle: Text(itemsubTitle),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ControllerInfoScreen(controller: controller)));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  // function to display fetched models on screen
  Widget buildModels(List<String> models) {
    return ListView.separated(
      itemCount: models.length,
      itemBuilder: (context, index) {
        final modelName = models[index];
        return ListTile(
          title: Text(modelName),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ModelInfoScreen(modelName: modelName)));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
