import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as htmltopdf;
import 'package:printing/printing.dart';
//import 'package:printing/printing.dart';
import 'package:xlights_test/controllerports.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:xlights_test/xlightsserver.dart';


class ControllerModelScreen extends StatefulWidget {
  final String controllerIP;
    final String controllerName;

  const ControllerModelScreen({Key? key, required this.controllerIP, required this.controllerName}) : super(key: key);

  @override
  _ControllerModelScreenState createState() => _ControllerModelScreenState();
}

class _ControllerModelScreenState extends State<ControllerModelScreen> {
  late Future<ControllerPorts> controllerports;

  @override
  void initState() {
    super.initState();

    controllerports = getModelsOnController(widget.controllerIP);
  }

  String objectToHTML(List<Port>? ports, String type) {
    if (ports == null || ports.isEmpty) {
      return "";
    }
    var html = '<table style="width:100%"><tr><th>Port</th><th>Models</th></tr>';
    for (var port in ports) {
      html += '<tr><td> $type Port${port.port!}</td><td>';
      if (port.models != null) {
        for (var model in port.models!) {
          html += '${model.name}, ';
        }
      }
      html += '</td></tr>';
    }
    html += '</table>';
    return html;
  }

  Future<void> storeData(String name, Map<String, dynamic> value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> conNames = prefs.getStringList('storedControllers') ?? [];
      conNames.add(name);
      conNames = conNames.toSet().toList();
      await prefs.setStringList('storedControllers', conNames);
      await prefs.setString('@${name}_models', jsonEncode(value));
    } catch (e) {
      print(e);
    }
  }

 printToFile(String html) async {
const filePath = 'document.pdf';
  final file = File(filePath);
  final newpdf = htmltopdf.Document();
  final List<htmltopdf.Widget> widgets = await htmltopdf.HTMLToPdf().convert(
    html,
  );

  newpdf.addPage(htmltopdf.MultiPage(
      maxPages: 200,
      build: (context) {
        return widgets;
      }));
  await file.writeAsBytes(await newpdf.save());
//await rootBundle.save(filePath);
  //final pdf = await rootBundle.load(filePath);
await Printing.layoutPdf(onLayout: (_) => newpdf.save());
//await Printing.sharePdf(bytes: await newpdf.save(), filename: 'document.pdf');

  //  final pdf = await Printing.convertHtml(
   //   format: PdfPageFormat.letter,
  //    html: html,
   // );
  //  await Printing.sharePdf(bytes: pdf, filename: 'document.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.controllerName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              var html = '<h3>${widget.controllerName}</h3>';
              controllerports.then((ports) {
                html += objectToHTML(ports.pixelports, 'Pixel');
                 html += objectToHTML(ports.serialports, 'Serial');
              html += objectToHTML(ports.ledpanelmatrixports, 'Panel');
              html += objectToHTML(ports.virtualmatrixports, 'VR Matrix');
              printToFile(html);
              });
             
            },
          ),
          IconButton(
            icon: Icon(Icons.add_to_photos),
            onPressed: () async {
              final ports = await controllerports;
              storeData(widget.controllerName, {
                'pixelports': ports.pixelports,
                'serialports': ports.serialports,
                'ledpanelmatrixports': ports.ledpanelmatrixports,
                'virtualmatrixports': ports.virtualmatrixports,
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<ControllerPorts>(
        future: controllerports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final ports = snapshot.data!;
            return ListView(
              children: [
                _buildPortList('Pixel Ports', ports.pixelports),
                _buildPortList('Serial Ports', ports.serialports),
                _buildPortList('LED Panel Matrix Ports', ports.ledpanelmatrixports),
                _buildPortList('Virtual Matrix Ports', ports.virtualmatrixports),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPortList(String title, List<Port>? ports) {
    if (ports == null || ports.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...ports.map((port) => _buildPortItem(port)),
      ],
    );
  }

  Widget _buildPortItem(Port port) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Port ${port.port}:', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        if (port.models != null)
          ...?port.models?.map((model) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
            child: Text('${model.name} ${model.smartremote ==null? '' : 'SR:' + String.fromCharCode(int.parse(model.smartremote!))}'),
          )),
        Divider(),
      ],
    );
  }
}

