import 'dart:async';
import 'dart:convert';

import 'package:xlights_test/controller.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlights_test/controllerports.dart';

  final dio = Dio();

Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('@ip') ?? '127.0.0.1';
    final port = prefs.getString('@port') ?? '49913';
    var url = 'http://$ip:$port';
    return url;
  }

Future<List<Controller>> getControllers() async {
  final baseurl = await getBaseUrl();
  final fullURL = '$baseurl/getControllers';

  //final dio = Dio();
  final response = await dio.get(fullURL);
  print(response.data);
    if (response.statusCode == 200) {
 return (json.decode(response.data) as List)
      .map((data) => Controller.fromJson(data))
      .toList();
      }else{throw Exception('Failed to load Controller');}
}

Future<bool> uploadControllerConfig(String? address) async {
  final baseurl = await getBaseUrl();
  final fullURL = '$baseurl/uploadController?ip=$address';

  final response = await dio.get(fullURL);
  print(response.data);
    if (response.statusCode == 200) {
 return true;
      }else{throw Exception('Failed to load Controller');}
 //return false;
}

Future<ControllerPorts> getModelsOnController(String? address) async {
    final baseurl = await getBaseUrl();
final fullURL = '$baseurl/getControllerPortMap?ip=$address';
    final response = await dio.get(fullURL);
  
  if (response.statusCode == 200) {
    // print('received: ${response.body}');
    return (ControllerPorts.fromJson(json.decode(response.data)));
  } else {
    throw Exception('Failed to load data from server');
  }
}

Future<List<String>> getModels() async {
    final baseurl = await getBaseUrl();
    final fullURL = '$baseurl/getModels';
    final response = await dio.get(fullURL);
  
  if (response.statusCode == 200) {
    // print('received: ${response.body}');
    List<dynamic> rawTags = json.decode(response.data);
    List<String> tags = rawTags.map(
      (item) {
        return item as String;
      },
    ).toList();
    return tags;
  } else {
    throw Exception('Failed to load data from server');
  }
}

Future<Map<String, dynamic>> getModel(String? name) async {
    final baseurl = await getBaseUrl();
    final fullURL = '$baseurl/getModel?model=$name';
    final response = await dio.get(fullURL);
  
  if (response.statusCode == 200) {
    // print('received: ${response.body}');
    return json.decode(response.data);
  } else {
    throw Exception('Failed to load data from server');
  }
}

Future<String> getVersion(String? address) async {
  final baseurl = await getBaseUrl();
  final fullURL = '$baseurl/getVersion';

  final response = await dio.get(fullURL);
  print(response.data);
    if (response.statusCode == 200) {
 return response.data;
      }else{throw Exception('Failed to load Controller');}
 //return false;
}

Future<String> getShowFolder(String? address) async {
  final baseurl = await getBaseUrl();
  final fullURL = '$baseurl/getShowFolder';

  final response = await dio.get(fullURL);
  print(response.data);
    if (response.statusCode == 200) {
 return response.data;
      }else{throw Exception('Failed to load Controller');}
 //return false;
}

/*
import axios from "axios";

import AsyncStorage from '@react-native-async-storage/async-storage';

const xLightsServer = axios.create({
   baseURL: `http://127.0.0.1:49913`,
});

export async  function getBaseUrl() {
    const ip = await AsyncStorage.getItem('@ip');
    const port = await AsyncStorage.getItem('@port');
    var url = `http://${ip}:${port}`;
    return url;
  }

  xLightsServer.interceptors.request.use( async config => { 
    config.baseURL=await getBaseUrl(); 
    return config; 
}, error => Promise.reject(error) );

export const getVersion = async (callback, failcallback) => {
    try {
    const response = await xLightsServer.get(
        `/getVersion`
        );
        console.log("received: ", response.data);
        callback(response.data);  
    } catch (err) {
        failcallback(err)
    }
};

export const getShowFolder = async (callback, failcallback) => {
    try {
        const response = await xLightsServer.get(
            `/getShowFolder`
            );
            //console.log("received: ", response.data);
            callback(response.data);  
        } catch (err) {
            failcallback(err)
        }
 };

export const getControllers = async (callback) => {
const response = await xLightsServer.get(
    `/getControllers`
    );
    //console.log("received: ", response.data);
    callback(response.data);  
    };

export const getModelsOnController = async (values, callback) => {
    const response = await xLightsServer.get(
        `/getControllerPortMap?ip=${values}`
        );
        //console.log("received: ", response.data);
        callback(response.data);  
        };

export const getModels = async (callback) => {
    const response = await xLightsServer.get(
        `/getModels`
        );
        //console.log("received: ", response.data);
        callback(response.data);  
        };

export const getModel = async (values, callback) => {
    const response = await xLightsServer.get(
        `/getModel?model=${values}`
        );
        //console.log("received: ", response.data);
        callback(response.data);  
        };

export const uploadController = async (values, callback) => {
    console.log("sent: ", values);
    const response = await xLightsServer.get(
        `/uploadController?ip=${values}`
        );
        console.log("received: ", response.data);
        callback(response.data);  
        };

    export const setModelControllerPort = async (values, callback) => {
        try {
            console.log(values);  
            const response = await xLightsServer.get(
                `/setModelProperty?model=${values.model}&key=ModelControllerConnectionPort&data=${values.port}`
                );
                console.log("received: ", response.data);
                callback();
                
            } catch (err) {
                console.log(err);
            }
        //console.log("sent: ", values);
    };

    export const setModelController = async (values, callback) => {
        try {
            const response = await xLightsServer.get(
                `/setModelProperty?model=${values.model}&key=Controller&data=${values.controller}`
                );
                callback();
                
            } catch (err) {
                console.log(err);
            }
        console.log("sent: ", values);
    };

    export const setModelControllerProtocol = async (values, callback) => {
        try {
            const response = await xLightsServer.get(
                `/setModelProperty?model=${values.model}&key=ModelControllerConnectionProtocol&data=${values.protocol}`
                );
                callback();
                
            } catch (err) {
                console.log(err);
            }
        console.log("sent: ", values);
    };

    export const setModelModelChain = async (values, callback, failcallback) => {
        try {
            const response = await xLightsServer.get(
                `/setModelProperty?model=${values.model}&key=ModelChain&data=${values.modelchanin}`
                );
                console.log("received: ", response.data);
                callback(response.data);  
                
            } catch (err) {
                failcallback(err)
            }
        console.log("sent: ", values);
    };

    export const setModelSmartRemote = async (values, callback, failcallback) => {
        try {
            const response = await xLightsServer.get(
                `/setModelProperty?model=${values.model}&key=SmartRemote&data=${values.smartremote}`
                );
                console.log("received: ", response.data);
                callback(response.data);  
                
            } catch (err) {
                failcallback(err)
            }
        console.log("sent: ", values);
    };

    export const setModelSmartRemoteType = async (values, callback, failcallback) => {
        try {
            const response = await xLightsServer.get(
                `/setModelProperty?model=${values.model}&key=SmartRemoteType&data=${values.smartremotetype}`
                );
                console.log("received: ", response.data);
                callback(response.data);  
                
            } catch (err) {
                failcallback(err)
            }
        console.log("sent: ", values);
    };

        

export default xLightsServer;
*/