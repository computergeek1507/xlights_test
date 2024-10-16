import 'package:flutter/material.dart';
import 'package:xlights_test/controllers.dart';
import 'package:xlights_test/startscreen.dart';
import 'package:xlights_test/settings.dart';


void main() {
  runApp(
    MaterialApp(
      title: 'xLights Test',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const StartScreen(),
        '/controllers': (context) => const ControllersScreen(),
        //'/controllerinfo': (context) => const ControllerInfoScreen(),
        //'/controllerwiring': (context) => const ControllerWiringScreen(),
        //'/models': (context) => const ModelsScreen(),
        //'/modelInfo': (context) => const ModelInfoScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    ),
  );
}


