import 'package:flutter/material.dart';

class ModelGroupDisplay extends StatelessWidget {
  final Map<String, dynamic> model;

  const ModelGroupDisplay({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final models = (model['models'] as String?)
            ?.split(',')
            .where((m) => m.trim().isNotEmpty)
            .toList() ??
        [];
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
                _buildInfoRow('Name', model['name']?.toString()),
                _buildInfoRow('Layout Group', model['LayoutGroup']?.toString()),
                _buildInfoRow('Layout', model['layout']?.toString(),
                    isLast: true),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Models',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Card(
            child: Column(
              children: [
                for (int i = 0; i < models.length; i++)
                  _buildInfoRow(null, models[i].trim(),
                      isLast: i == models.length - 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInfoRow(String? label, String? value, {bool isLast = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: isLast
        ? null
        : const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
          ),
    child: label == null
        ? Text(value ?? '', style: const TextStyle(fontSize: 16))
        : Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Expanded(
                flex: 3,
                child: Text(value ?? '', style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
  );
}
