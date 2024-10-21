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
 return SingleChildScrollView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            children: [
              _buildDecoratedText('Name', styles.resultsGrid),
              _buildDecoratedText(widget.model['name'],  styles.resultsGrid),
            ],
          ),
          Row(
            children: [
              _buildDecoratedText('Type', styles.resultsGrid),
              _buildDecoratedText(widget.model['DisplayAs'],  styles.resultsGrid),
            ],
          ),
          Row(
            children: [
              _buildDecoratedText('StartChannel', styles.resultsGrid),
              _buildDecoratedText(widget.model['StartChannel'].toString(),  styles.resultsGrid),
            ],
          ),
          Row(
            children: [
              _buildDecoratedText('LayoutGroup',  styles.resultsGrid),
              _buildDecoratedText(widget.model['LayoutGroup'], styles.resultsGrid),
            ],
          ),
          Row(
            children: [
              _buildDecoratedText('Controller',styles.resultsGridController),
              _buildDecoratedText(widget.model['Controller'], styles.resultsGridController),
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
       Row(
              children: [
                _buildDecoratedText('Controller Port', styles.resultsGrid),
                _buildDecoratedText(widget.model['ControllerConnection'] == null||
                  widget.model['ControllerConnection']['Port'] == null ? '':widget.model['ControllerConnection']?['Port'].toString() ?? '', styles.resultsGrid),
              ],
            ),
          Row(
            children: [
              _buildDecoratedText('Model Chain', styles.resultsGrid),
              _buildDecoratedText(widget.model['ModelChain'] ?? "Beginning", styles.resultsGrid),
            ],
          ),
          Row(
            children: [
              _buildDecoratedText('Controller Protocol',  styles.resultsGridController),
              _buildDecoratedText(widget.model['ControllerConnection'] == null ||
                widget.model['ControllerConnection']['Protocol'] == null ? '':widget.model['ControllerConnection']?['Protocol'], styles.resultsGridController),
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
              _buildDecoratedText('StringType', styles.resultsGrid),
              _buildDecoratedText(widget.model['StringType'], styles.resultsGrid),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildDecoratedText(String text, TextStyle style) => Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          //borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        //margin: const EdgeInsets.all(4),
        child: Text(text, style: style),
      ),
    );

class styles {
  static const TextStyle resultsGrid = TextStyle(fontSize: 16, letterSpacing: 1.0);
  static const TextStyle resultsGridController = TextStyle(fontSize: 16, letterSpacing: 1.0);
}

