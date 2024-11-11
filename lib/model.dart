import 'package:flutter/material.dart';
import 'package:xlights_test/controller.dart';
import 'package:xlights_test/xlightsserver.dart';

class ModelDisplay extends StatefulWidget {
Map<String, dynamic> model;
  final Function callback;

  ModelDisplay({Key? key, required this.model, required this.callback}) : super(key: key);

  @override
  _ModelDisplayState createState() => _ModelDisplayState();
}

class _ModelDisplayState extends State<ModelDisplay> {
  bool isDialogVisible = false;
  List<Controller> controllers = [];
  List<String> st_controllers = [];
  List<String> st_smart_recievers = [];

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

  Future<void> updateModel() async {
    widget.model = await getModel(widget.model['name']);
  }

  void setControllerPort(String modelName , int port) async {
    print(modelName);
    await setModelControllerPort(modelName, port);    
  }

  void setController(String itemValue, int itemIndex) async {
    print(itemIndex);
    await setModelController(itemValue, itemIndex);
  }

  void setModelProtocol(String itemValue, int itemIndex) async{
    print(itemIndex);
    await setModelControllerProtocol(itemValue, itemIndex);
  }

  void setModelSmartRemote(String itemValue, int itemIndex) async {
    print(itemIndex);
    await setModelControllerSmartRemote(itemValue, itemIndex);
  }

  void setModelSmartRemoteType(String itemValue, int itemIndex) async {
    print(itemIndex);
    await setModelControllerSmartRemoteType(itemValue, itemIndex);
  }

  List<String> getProtocols(String controlName) {
    var isObjectPresent = controllers.firstWhere((o) => o.name == controlName, orElse: () => Controller());
    var arr1 = isObjectPresent.controllercap?.pixelprotocols ?? [];
    var arr2 = isObjectPresent.controllercap?.serialprotocols ?? [];
    return [...arr1, ...arr2];
  }
  bool isPixelProtocols(String controlName, String protocol) {
    var isObjectPresent = controllers.firstWhere((o) => o.name == controlName, orElse: () => Controller());
    var arr1 = isObjectPresent.controllercap?.pixelprotocols ?? [];
    return arr1.contains(protocol);
  }
  bool isSerialProtocols(String controlName, String protocol) {
    var isObjectPresent = controllers.firstWhere((o) => o.name == controlName, orElse: () => Controller());
    var arr2 = isObjectPresent.controllercap?.serialprotocols ?? [];
    return arr2.contains(protocol);
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

 Future<List<String>> getModelsOnControllerByPort(String controlName, String modelName, int port, String protocol, String smartRemote) async {
    List<String> arr = ["Beginning"];
    String ip = controllers.firstWhere((o) => o.name == controlName, orElse: () => Controller()).address!;
    
    var controllerports = await getModelsOnController(ip);
    var ports = isPixelProtocols(controlName, protocol) ? controllerports.pixelports : isSerialProtocols(controlName, protocol) ?controllerports.serialports :[];
    for(var controllerport in ports ?? []){
      if(controllerport.port == port){
        for(var model in controllerport.models ?? []){
          String model_smartRemote = model.smartremote == null? '':model.smartremote!;
          if (model.name != null && model.name != modelName && model_smartRemote == smartRemote) {
            arr.add(model.name!);
          }
        }
      }
    }
    return arr;
  }

  List<String> getSmartRemotes(String controlName) {
    var isObjectPresent = controllers.firstWhere((o) => o.name == controlName, orElse: () => Controller());
     List<String> arr = ["None"];
    for (int k = 0; k < (isObjectPresent.controllercap?.smartremotecount ?? 0); k++) {
      // code to be executed on each item
      arr.add(String.fromCharCode(k+65));
    }
    return arr;
  }

  List<String> getSmartRemoteTypes(String controlName) {
    var isObjectPresent = controllers.firstWhere((o) => o.name == controlName, orElse: () => Controller());
    return isObjectPresent.controllercap?.smartremotetypes ?? [];
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
                  padding: const EdgeInsets.all(8.0),
                  //margin: const EdgeInsets.all(4),
                  child: MaterialButton(
                    onPressed: () async {
                      String? val = await showSelectionDialog(
                          context,
                          "Select Controller",
                          st_controllers,
                          widget.model['Controller'] ?? 'Use Start Channel');
                      if (val != null) {
                        setState(() {
                            setController(widget.model['name'],
                                st_controllers.indexOf(val.toString()));
                            widget.model['Controller'] = val;
                            getModel(widget.model['name']).then((model) {
                              setState(() {
                                widget.model = model;
                              });
                            });
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
                  padding: const EdgeInsets.all(8.0),
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
                                getModel(widget.model['name']).then((model) {
                              setState(() {
                                widget.model = model;
                              });
                            });
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
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    //borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  //margin: const EdgeInsets.all(4),
                  child: MaterialButton(
                    onPressed: () async {
                      var models = await getModelsOnControllerByPort(widget.model['Controller'],
                      widget.model['name'],
                      int.parse(widget.model['ControllerConnection']?['Port'] ?? "1"), 
                      widget.model['ControllerConnection']?['Protocol'] ?? '',
                      widget.model['ControllerConnection']?['SmartRemote'] ?? '');
                      String selected_model =widget.model['ModelChain'] ?? "Beginning";
                      selected_model =selected_model.replaceAll(">", "");
                      String? val = await showSelectionDialog(
                          context,
                          "Select Model Chain",
                          models,
                          selected_model);
                      if (val != null) {
                        setState(
                              () {
                                if (val != "Beginning") {
                                  val = val != null ? ">" + val! : val;
                                }
                                setModelModelChain(widget.model['name'], val ?? '');
                                widget.model['ControllerConnection']['ModelChain'] = val;
                                getModel(widget.model['name']).then((model) {
                              setState(() {
                                widget.model = model;
                              });
                            });
                              },
                            );
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.model['ModelChain'] ?? "Beginning",
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
              _buildDecoratedText('Controller Protocol',  styles.resultsGridController),
             // _buildDecoratedText(widget.model['ControllerConnection'] == null ||
             //   widget.model['ControllerConnection']['Protocol'] == null ? '':widget.model['ControllerConnection']?['Protocol'], styles.resultsGridController),
             Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    //borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  //margin: const EdgeInsets.all(4),
                  child: MaterialButton(
                    onPressed: () async {
                      var protocols = getProtocols(widget.model['Controller']);
                      String? val = await showSelectionDialog(
                          context,
                          "Select Controller Protocol",
                          protocols,
                          widget.model['ControllerConnection']?['Protocol'] ?? '');
                      if (val != null) {
                        setState(() {
                          int new_idx = protocols.indexOf(val);
                          setModelProtocol(widget.model['name'], new_idx);
                            //setController(widget.model['name'],
                            //    st_controllers.indexOf(val.toString()));
                            widget.model['ControllerConnection']['Protocol'] = val;
                            getModel(widget.model['name']).then((model) {
                              setState(() {
                                widget.model = model;
                              });
                            });
                          },
                        );
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.model['ControllerConnection'] == null ||
                widget.model['ControllerConnection']['Protocol'] == null ? '':widget.model['ControllerConnection']?['Protocol'],
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.right),
                    ),
                  ),
                ),
              ), 
            ],
          ),
          //Row(
          //  children: [//SmartRemote
          //    _buildDecoratedText('Smart Remote', styles.resultsGrid),
          //    _buildDecoratedText(widget.model['ControllerConnection'] == null ||
         //       widget.model['ControllerConnection']['SmartRemote'] == null ? 'None' : 
         //       (widget.model['ControllerConnection']?['SmartRemote']).toString(), styles.resultsGridController),
         //   ],
         // ),
          Row(
            children: [//SmartRemote
              _buildDecoratedText('Smart Remote', styles.resultsGrid),
             Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    //borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  //margin: const EdgeInsets.all(4),
                  child: MaterialButton(
                    onPressed: () async {
                      var types = getSmartRemotes(widget.model['Controller']);
                      int index = int.parse(widget.model['ControllerConnection']?['SmartRemote'] ?? '0');
                      String? val = await showSelectionDialog(
                          context,
                          "Select Smart Remote",
                          types,
                         types[index]);
                      if (val != null) {
                        setState(
                          () {
                            int new_idx = types.indexOf(val);
                            setModelSmartRemote(widget.model['name'],
                                new_idx - 1);
                            widget.model['ControllerConnection']?['SmartRemote'] = (new_idx.toString());
                            getModel(widget.model['name']).then((model) {
                              setState(() {
                                widget.model = model;
                              });
                            });
                          },
                        );
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text((widget.model['ControllerConnection']?['SmartRemote'] ?? '0') == "0" ? 'None' : String.fromCharCode(int.parse(widget.model['ControllerConnection']?['SmartRemote'] ?? '0') + 64),
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.right),
                    ),
                  ),
                ),
              ), 
            ],
          ),
          Row(
            children: widget.model['ControllerConnection']['SmartRemote'] == null ? [] : [
              _buildDecoratedText('Smart Reciever Type', styles.resultsGrid),
             // _buildDecoratedText(widget.model['ControllerConnection'] == null ||
             //   widget.model['ControllerConnection']['SmartRemoteType'] == null ? '' : 
             //   widget.model['ControllerConnection']?['SmartRemoteType'], styles.resultsGridController),
                Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    //borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  //margin: const EdgeInsets.all(4),
                  child: MaterialButton(
                    onPressed: () async {
                      var types = getSmartRemoteTypes(widget.model['Controller']);
                      String selectedType = widget.model['ControllerConnection']?['SmartRemoteType'] ?? types.first;
                      String? val = await showSelectionDialog(
                          context,
                          "Select Smart Remote Type",
                          types,
                         selectedType);
                      if (val != null) {
                        setState(
                          () {
                            int new_idx = types.indexOf(val);
                            setModelSmartRemoteType(widget.model['name'],
                                new_idx);
                            widget.model['ControllerConnection']?['SmartRemoteType'] = (val);
                            getModel(widget.model['name']).then((model) {
                              setState(() {
                                widget.model = model;
                              });
                            });
                          },
                        );
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.model['ControllerConnection'] == null ||
                widget.model['ControllerConnection']['SmartRemoteType'] == null ? '' : 
                widget.model['ControllerConnection']?['SmartRemoteType'],
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
        padding: const EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.all(8.0),
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
                    onChanged: (val) {
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
