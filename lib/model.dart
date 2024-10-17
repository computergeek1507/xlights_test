import 'package:flutter/material.dart';
import 'package:xlights_test/controller.dart';
import 'package:xlights_test/xlightsserver.dart';

class ModelDisplay extends StatefulWidget {
final Map<String, dynamic> model;
  final Function callback;

  const ModelDisplay({Key? key, required this.model, required this.callback}) : super(key: key);

  @override
  _ModelDisplayState createState() => _ModelDisplayState();
}

class _ModelDisplayState extends State<ModelDisplay> {
  bool isDialogVisible = false;
  List<Controller> controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    controllers = await getControllers();
    //setState(() {});
  }

  void sendInput(String inputText) {
    print(inputText);
    //setModelControllerPort({'model': widget.model.name, 'port': inputText}, widget.callback);
    setState(() {
      isDialogVisible = false;
    });
  }

  void setController(String itemValue, int itemIndex) {
    print(itemIndex);
    //setModelController({'model': widget.model.name, 'controller': itemIndex}, widget.callback);
  }

  void setProtocol(String itemValue, int itemIndex) {
    print(itemIndex);
    //setModelControllerProtocol({'model': widget.model.name, 'protocol': itemIndex}, widget.callback);
  }

  List<String> getProtocols(String controlName) {
    var isObjectPresent = controllers.firstWhere((o) => o.name == controlName, orElse: () => Controller());
    var arr1 = isObjectPresent.controllercap?.pixelprotocols ?? [];
    var arr2 = isObjectPresent.controllercap?.serialprotocols ?? [];
    return [...arr1, ...arr2];
  }

  List<String> getAutoControllers() {
    var arr = ["Use Start Channel", "No Controller"];
    for (var item in controllers) {
      if (item.autolayout == true) {
        if (item.name != null) {
          arr.add(item.name!);
        }
      }
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Name', style: styles.resultsGrid),
            Text(widget.model['name'], style: styles.resultsGrid),
          ],
        ),
        Row(
          children: [
            Text('Type', style: styles.resultsGrid),
            Text(widget.model['DisplayAs'], style: styles.resultsGrid),
          ],
        ),
        Row(
          children: [
            Text('StartChannel', style: styles.resultsGrid),
            Text(widget.model['StartChannel'].toString(), style: styles.resultsGrid),
          ],
        ),
        Row(
          children: [
            Text('LayoutGroup', style: styles.resultsGrid),
            Text(widget.model['LayoutGroup'], style: styles.resultsGrid),
          ],
        ),
        Row(
          children: [
            Expanded(child: Text('Controller', style: styles.resultsGridController)),
            Expanded(child: Text(widget.model['Controller'], style: styles.resultsGridController)),
           /*Expanded(
              child: SelectDropdown(
                data: getAutoControllers(),
                defaultButtonText: widget.model.Controller == null ? "Use Start Channel" : widget.model.Controller,
                onSelect: setController,
                buttonTextAfterSelection: (selectedItem, index) => selectedItem,
                rowTextForSelection: (item, index) => item,
              ),
            ),*/
          ],
        ),
        /*DialogInput(
          isDialogVisible: isDialogVisible,
          message: "Set Controller Port",
          hintInput: "1-48",
          autoCorrect: false,
          keyboardType: TextInputType.number,
          initValueTextInput: widget.model.ControllerConnection?['Port'],
          submitInput: (inputText) => sendInput(inputText),
          closeDialog: () => setState(() {
            isDialogVisible = false;
          }),
        ),*/
         Expanded(child: Text( widget.model['controllerConnection'] == null ? '':widget.model['controllerConnection']['Port'], style: styles.resultsGridController)),
        GestureDetector(
          onTap: () {
            setState(() {
              isDialogVisible = true;
            });
          },
          child: Row(
            children: [
              Text('Controller Port', style: styles.resultsGrid),
              Text(widget.model['controllerConnection'] == null ? '':widget.model['controllerConnection']?['Port'].toString() ?? '', style: styles.resultsGrid),
            ],
          ),
        ),
        Row(
          children: [
            Text('Model Chain', style: styles.resultsGrid),
            Text(widget.model['ModelChain'] ?? "Beginning", style: styles.resultsGrid),
          ],
        ),
        Row(
          children: [
            Expanded(child: Text('Controller Protocol', style: styles.resultsGridController)),
            Expanded(child: Text(widget.model['controllerConnection'] == null ? '':widget.model['controllerConnection']?['Protocol'], style: styles.resultsGridController)),
           /* Expanded(
              child: SelectDropdown(
                data: getProtocols(widget.model?.Controller),
                defaultButtonText: widget.model.ControllerConnection?['Protocol'],
                onSelect: setProtocol,
                buttonTextAfterSelection: (selectedItem, index) => selectedItem,
                rowTextForSelection: (item, index) => item,
              ),
            ),*/
          ],
        ),
        Row(
          children: [
            Text('StringType', style: styles.resultsGrid),
            Text(widget.model['StringType'], style: styles.resultsGrid),
          ],
        ),
      ],
    );
  }
}

class styles {
  static const TextStyle resultsGrid = TextStyle(fontSize: 16, letterSpacing: 1.0);
  static const TextStyle resultsGridController = TextStyle(fontSize: 16, letterSpacing: 1.0);
}

