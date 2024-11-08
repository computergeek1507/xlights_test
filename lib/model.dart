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
    List<String> st_controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    controllers = await getControllers();
    st_controllers = getAutoControllers();
    //setState(() {});
  }

  void setControllerPort(String modelName , int port) {
    print(modelName);
    setModelControllerPort(modelName, port);    
  }

  void setController(String itemValue, int itemIndex) {
    print(itemIndex);
    setModelController(itemValue, itemIndex);
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
          /*Row(
            children: [
              _buildDecoratedText('Controller',styles.resultsGridController),
              _buildDecoratedText(widget.model['Controller'] ?? 'Use Start Channel', styles.resultsGridController),
            ],
          ),*/
          Row(
           // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [            
             _buildDecoratedText('Controller',styles.resultsGridController),
             Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    //borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  //margin: const EdgeInsets.all(4),
                  child: MaterialButton(
                    onPressed: () async {
                      String? val = await showSelectionDialog(
                          context,
                          "Select Controller",
                          st_controllers,
                          widget.model['Controller'] ?? 'Use Start Channel');
                      if (val != null) {
                        setState(
                          () {
                            setController(widget.model['name'],
                                st_controllers.indexOf(val.toString()));
                            widget.model['Controller'] = val;
                          },
                        );
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.model['Controller'] ?? 'Use Start Channel',
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.right),
                    ),
                  ),
                ),
              ),   
          ],
          ),
         Row(
            children: [            
            _buildDecoratedText('Controller Port', styles.resultsGrid),
             Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  child: MaterialButton(
                    onPressed: widget.model['ControllerConnection']['Port'] == null ? null : () async {
                      int? val = await showNumberDialog(
                          context,
                          "Select Controller Port",
                          int.parse(widget.model['ControllerConnection']?['Port']?? "1"));
                          if (val != null) {
                            setState(
                              () {
                                setControllerPort(widget.model['name'],val);
                                widget.model['ControllerConnection']['Port'] = val;
                              },
                            );
                          }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.model['ControllerConnection'] == null||
                  widget.model['ControllerConnection']['Port'] == null ? '':widget.model['ControllerConnection']?['Port'].toString() ?? '',
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.right),
                    ),
                  ),
                ),
              ),   
          ],
          ),
       /*Row(
              children: [
                _buildDecoratedText('Controller Port', styles.resultsGrid),
                _buildDecoratedText(widget.model['ControllerConnection'] == null||
                  widget.model['ControllerConnection']['Port'] == null ? '':widget.model['ControllerConnection']?['Port'].toString() ?? '', styles.resultsGrid),
              ],
            ),*/
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

    Widget _buildDecoratedButton(String text, TextStyle style) => Expanded(
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
  static const TextStyle resultsGrid = TextStyle(fontSize: 20, letterSpacing: 1.0);
  static const TextStyle resultsGridController = TextStyle(fontSize: 20, letterSpacing: 1.0);
}

Future<String?> showSelectionDialog(BuildContext context, String title, List<String> items, String? selectedItem ) async {   
    //Creating an Dialog 
    return await showDialog<String?>( 
      context: context, 
      builder: (BuildContext context) { 
        // Use a nullable type 
        return AlertDialog( 
          
          title: Text(title), 
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column( 
                mainAxisSize: MainAxisSize.min, 
                children: [ 
                  DropdownButton<String>( 
                    value: selectedItem, 
                    items: items.map((String item) { 
                      return DropdownMenuItem<String>( 
                        value: item, 
                        child: Text(item), 
                      ); 
                    }).toList(), 
                    onChanged: (String? newValue) { 
                      // Use a nullable type for onChanged 
                      if (newValue != null) { 
                        setState(() => selectedItem = newValue);
                        selectedItem = newValue; 
                      } 
                    }, 
                  ), 
                ], 
              );
            }
          ), 
          actions: [ 
            ElevatedButton( 
              onPressed: () { 
                Navigator.of(context).pop(); 
              }, 
              child: Text('Cancel'), 
            ), 
            ElevatedButton( 
              onPressed: () { 
                // Handle the selected item here 
                if (selectedItem != null) { 
                  //print('Selected item: $selectedItem'); 
                } 
                Navigator.pop(context, selectedItem);
                //Navigator.of(context, selectedItem).pop(); 
              }, 
              child: Text('OK'), 
            ), 
          ], 
        ); 
      }, 
    ); 
  } 

Future<int?> showNumberDialog(BuildContext context, String title, int selectedItem ) async {   
    //Creating an Dialog 
    return await showDialog<int?>( 
      context: context, 
      builder: (BuildContext context) { 
        // Use a nullable type 
        return AlertDialog( 
          
          title: Text(title), 
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column( 
                mainAxisSize: MainAxisSize.min, 
                children: [ 
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Port',
                      hintText: '1-48',
                    ),
                    maxLength: 2,
                    //hintinput: "1-48",
                    autocorrect: false,
                     keyboardType: TextInputType.number,
                    initialValue: selectedItem.toString(),
                    textAlign: TextAlign.center,
                    onSaved: (val) {
                      setState(() {
                        if (val != null) {
                          selectedItem = int.parse(val);
                        }
                       });
                      //titleController.text = val;
                      //setState(() {});
                    },
                   // autovalidate: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '1-48';
                      }

                      return null;
                    },
                  )
                ], 
              );
            }
          ), 
          actions: [ 
            ElevatedButton( 
              onPressed: () { 
                Navigator.of(context).pop(); 
              }, 
              child: Text('Cancel'), 
            ), 
            ElevatedButton( 
              onPressed: () { 
                // Handle the selected item here 
                //if (selectedItem != null) { 
                //  Navigator.pop(context);
                //} 
                Navigator.pop(context, selectedItem);
                //Navigator.of(context, selectedItem).pop(); 
              }, 
              child: Text('OK'), 
            ), 
          ], 
        ); 
      }, 
    ); 
  } 
