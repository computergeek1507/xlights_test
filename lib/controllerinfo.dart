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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Column(
                children: [
                  _buildResultRow('Name', controller.name),
                  _buildResultRow('IP', controller.address),
                  _buildResultRow(controller.vendor, controller.model),
                  _buildResultRow('Protocol', controller.protocol),
                  _buildResultRow('Type', controller.type),
                  _buildResultRow(
                      'Start Channel', controller.startchannel.toString()),
                  _buildResultRow('Channels', controller.channels.toString()),
                  _buildResultRow('Managed', controller.managed.toString()),
                  _buildResultRow('Active', controller.active.toString(),
                      isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ControllerModelScreen(
                                  controllerIP: controller.address!,
                                  controllerName: controller.name!)));
                    },
                    icon: const Icon(Icons.account_tree_outlined),
                    label: const Text('Visualize'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: uploadDisabled()
                        ? null
                        : () {
                            uploadtoController(controller.address);
                          },
                    icon: const Icon(Icons.upload_outlined),
                    label: const Text('Upload Outputs'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: openDisabled()
                        ? null
                        : () {
                            launchController(controller.address);
                          },
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Open Controller'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String? label, String? value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
            ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? '',
              style: const TextStyle(fontSize: 16),
            ),
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
