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
    return _buildDecoratedText(item, styles.resultsGrid);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
      child: Column(
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
                _buildDecoratedText('Name', styles.resultsGrid),
                _buildDecoratedText(model['name'],styles.resultsGrid),
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
                _buildDecoratedText('LayoutGroup', styles.resultsGrid),
                _buildDecoratedText(model['LayoutGroup'], styles.resultsGrid),
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
                _buildDecoratedText('Layout',  styles.resultsGrid),
                _buildDecoratedText(model['layout'], styles.resultsGrid),
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
                _buildDecoratedText('Models',  styles.resultsGrid),
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
            child: Expanded(
              child: ListView.separated(
                //scrollDirection: Axis.vertical,
                //physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                itemCount: model['models'].split(',').length,
                separatorBuilder: renderSeparator,
                itemBuilder: (context, index) => renderModel(context, index, model['models'].split(',')[index]),
              ),
            ),
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


class styles {
  static const TextStyle resultsGrid = TextStyle(
    fontSize: 20,
    letterSpacing: 1.0,
    //padding: EdgeInsets.all(10),
  );
}

