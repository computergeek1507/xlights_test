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
        title: Text('ControllerInfo ${controller.name}'),
      ),
      body: 
          Center(
            child:Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${controller.name}'),
                  Text('IP: ${controller.address}'),
                  Text('${controller.vendor} ${controller.model}'),
                  Text('Protocol: ${controller.protocol}'),
                  Text('Type: ${controller.type}'),
                  Text('Start Channel: ${controller.startchannel}'),
                  Text('Channel: ${controller.channels}'),
                  Text('Managed: ${controller.managed}'),
                  Text('Active: ${controller.active}'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ControllerModelScreen ( controllerIP: controller.address!,controllerName: controller.name!)));
                    },
                    child: const Text('Visualize'),
                  ),
                  TextButton(
                    onPressed: uploadDisabled() ? null : () {
                      uploadtoController(controller.address);
                    },
                    child: const Text('Upload Outputs'),
                  ),
                  TextButton(
                    onPressed: openDisabled() ? null : () {
                      launchController (controller.address);
                    },
                    child: const Text('Open Controller'),
                  ),
                ],
                
                           ),
              ],
            ),
            ),
          ),

    );
  }

  Widget _buildResultRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black)),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14),
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