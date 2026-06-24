import 'package:flutter/material.dart';
import 'package:xlights_test/startscreen.dart';
import 'package:xlights_test/settings.dart';


void main() {
  runApp(
    MaterialApp(
      title: 'xLights Remote',
      debugShowCheckedModeBanner: false,
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const StartScreen(),
        //'/controllerinfo': (context) => ControllerInfoScreen(controller: Controller(),),
        //'/controllerwiring': (context) => const ControllerModelScreen(controllerIP: '', controllerName: '',),
        //'/modelInfo': (context) => ModelInfoScreen(modelName: '',),
        '/settings': (context) => const SettingsScreen(),
      },
    ),
  );
} 

