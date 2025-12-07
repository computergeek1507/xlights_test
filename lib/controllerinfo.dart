import 'package:flutter/material.dart';
import 'package:xlights_test/controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xlights_test/controllermodel.dart';
import 'package:xlights_test/xlightsserver.dart';

class ControllerInfoScreen extends StatelessWidget {
  const ControllerInfoScreen( {super.key, required this.controller});
  final Controller controller;

bool uploadDisabled() => !controller.managed!;
bool openDisabled() => controller.type != 'Ethernet';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controller: ${controller.name}'),
      ),
      body: 
     SingleChildScrollView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
      child:
            Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              //borderRadius: BorderRadius.circular(15),
            ),
            child: 
                Column(
               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultRow('Name', controller.name),
                  _buildResultRow('IP',  controller.address),
                  _buildResultRow(controller.vendor,  controller.model),
                  _buildResultRow('Protocol', controller.protocol),
                  _buildResultRow('Type', controller.type),
                  _buildResultRow('Start Channel',controller.startchannel.toString()),
                  _buildResultRow('Channel', controller.channels.toString()),
                  _buildResultRow('Managed', controller.managed.toString()),
                  _buildResultRow('Active', controller.active.toString()),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ControllerModelScreen ( controllerIP: controller.address!,controllerName: controller.name!)));
                    },
                    child: const Text('Visualize',
            style: TextStyle(fontSize: 16),),
                  ),
                  TextButton(
                    onPressed: uploadDisabled() ? null : () {
                      uploadtoController(controller.address);
                    },
                    child: const Text('Upload Outputs',
            style: TextStyle(fontSize: 16),),
                  ),
                  TextButton(
                    onPressed: openDisabled() ? null : () {
                      launchController (controller.address);
                    },
                    child: const Text('Open Controller',
            style: TextStyle(fontSize: 16),),
                  ),
                ],
                

            ),
            ),
          ),

    );
  }

  Widget _buildResultRow(String? label, String? value) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black)),
      ),
      child: Row(
        
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value!,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  
  void uploadtoController(String? address) 
  {
    uploadControllerConfig(address);
  }

  void launchController(String? address) async {
   final Uri url = Uri.parse('https://$address');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
    }
  }
}
