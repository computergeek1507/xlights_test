import 'package:flutter/material.dart';

class ModelGroupDisplay extends StatelessWidget {
  final Map<String, dynamic> model;

  const ModelGroupDisplay({Key? key, required this.model}) : super(key: key);

  Widget renderSeparator(BuildContext context, int index) {
    return Container(
      height: 0.5,
      color: Colors.black,
    );
  }

  Widget renderModel(BuildContext context, int index, String item) {
    return Container(
      child: Text(item, style: styles.resultsGrid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black, width: 1),
              right: BorderSide(color: Colors.black, width: 1),
              top: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text('Name', style: styles.resultsGrid)),
              Expanded(child: Text(model['name'], style: styles.resultsGrid)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black, width: 1),
              right: BorderSide(color: Colors.black, width: 1),
              top: BorderSide(color: Colors.black, width: 0.5),
              bottom: BorderSide(color: Colors.black, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text('LayoutGroup', style: styles.resultsGrid)),
              Expanded(child: Text(model['LayoutGroup'], style: styles.resultsGrid)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black, width: 1),
              right: BorderSide(color: Colors.black, width: 1),
              top: BorderSide(color: Colors.black, width: 0.5),
              bottom: BorderSide(color: Colors.black, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text('Layout', style: styles.resultsGrid)),
              Expanded(child: Text(model['layout'], style: styles.resultsGrid)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black, width: 1),
              right: BorderSide(color: Colors.black, width: 1),
              top: BorderSide(color: Colors.black, width: 0.5),
              bottom: BorderSide(color: Colors.black, width: 3),
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text('Models', style: styles.resultsGrid)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.black, width: 1),
              right: BorderSide(color: Colors.black, width: 1),
              top: BorderSide(color: Colors.black, width: 0.5),
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: model['models'].split(',').length,
            separatorBuilder: renderSeparator,
            itemBuilder: (context, index) => renderModel(context, index, model['models'].split(',')[index]),
          ),
        ),
      ],
    );
  }
}

class styles {
  static const TextStyle resultsGrid = TextStyle(
    fontSize: 16,
    //padding: EdgeInsets.all(10),
  );
}

