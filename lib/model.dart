import 'package:flutter/material.dart';
import 'package:xlights_test/controller.dart';
import 'package:xlights_test/theme.dart';
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
    final cc = widget.model['ControllerConnection'];
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [
                _buildInfoRow('Name', widget.model['name']?.toString()),
                _buildInfoRow('Type', widget.model['DisplayAs']?.toString()),
                _buildInfoRow(
                    'Start Channel', widget.model['StartChannel']?.toString()),
                _buildInfoRow(
                    'Layout Group', widget.model['LayoutGroup']?.toString()),
                _buildEditRow(
                  'Controller',
                  widget.model['Controller'] ?? 'Use Start Channel',
                  () async {
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
                      });
                    }
                  },
                ),
                _buildEditRow(
                  'Controller Port',
                  (cc == null || cc['Port'] == null)
                      ? '0'
                      : cc['Port'].toString(),
                  () async {
                    int? val = await showNumberDialog(
                        context,
                        "Select Controller Port",
                        int.parse(widget.model['ControllerConnection']
                                ?['Port'] ??
                            "1"));
                    if (val != null) {
                      setState(() {
                        setControllerPort(widget.model['name'], val);
                        widget.model['ControllerConnection']['Port'] = val;
                        getModel(widget.model['name']).then((model) {
                          setState(() {
                            widget.model = model;
                          });
                        });
                      });
                    }
                  },
                ),
                _buildInfoRow('Model Chain',
                    widget.model['ModelChain'] ?? "Beginning"),
                _buildEditRow(
                  'Controller Protocol',
                  (cc == null || cc['Protocol'] == null) ? '' : cc['Protocol'],
                  () async {
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
                        widget.model['ControllerConnection']['Protocol'] = val;
                        getModel(widget.model['name']).then((model) {
                          setState(() {
                            widget.model = model;
                          });
                        });
                      });
                    }
                  },
                ),
                _buildEditRow(
                  'Smart Remote',
                  (cc?['SmartRemote'] ?? '0') == "0"
                      ? 'None'
                      : String.fromCharCode(
                          int.parse(cc?['SmartRemote'] ?? '0') + 64),
                  () async {
                    var types = getSmartRemotes(widget.model['Controller']);
                    int index = int.parse(
                        widget.model['ControllerConnection']?['SmartRemote'] ??
                            '0');
                    String? val = await showSelectionDialog(context,
                        "Select Smart Remote", types, types[index]);
                    if (val != null) {
                      setState(() {
                        int new_idx = types.indexOf(val);
                        setModelSmartRemote(widget.model['name'], new_idx - 1);
                        widget.model['ControllerConnection']?['SmartRemote'] =
                            (new_idx.toString());
                        getModel(widget.model['name']).then((model) {
                          setState(() {
                            widget.model = model;
                          });
                        });
                      });
                    }
                  },
                ),
                if (cc != null && cc['SmartRemote'] != null)
                  _buildEditRow(
                    'Smart Receiver Type',
                    (cc['SmartRemoteType'] == null) ? '' : cc['SmartRemoteType'],
                    () async {
                      var types =
                          getSmartRemoteTypes(widget.model['Controller']);
                      String selectedType =
                          widget.model['ControllerConnection']
                                  ?['SmartRemoteType'] ??
                              types.first;
                      String? val = await showSelectionDialog(context,
                          "Select Smart Remote Type", types, selectedType);
                      if (val != null) {
                        setState(() {
                          int new_idx = types.indexOf(val);
                          setModelSmartRemoteType(widget.model['name'], new_idx);
                          widget.model['ControllerConnection']
                              ?['SmartRemoteType'] = (val);
                          getModel(widget.model['name']).then((model) {
                            setState(() {
                              widget.model = model;
                            });
                          });
                        });
                      }
                    },
                  ),
                _buildInfoRow('String Type', widget.model['StringType']?.toString(),
                    isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInfoRow(String label, String? value, {bool isLast = false}) {
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
          child: Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 3,
          child: Text(value ?? '', style: const TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}

Widget _buildEditRow(String label, String value, VoidCallback onTap,
    {bool isLast = false}) {
  return InkWell(
    onTap: onTap,
    child: Container(
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
            child: Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(value, style: const TextStyle(fontSize: 16)),
                ),
                const Icon(Icons.edit, size: 18, color: AppTheme.brandRed),
              ],
            ),
          ),
        ],
      ),
    ),
  );
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
