import 'package:flutter/material.dart';

class Study extends StatelessWidget {
  final String name, category, description, max;
  const Study({
    super.key,
    required this.name,
    required this.category,
    required this.description,
    required this.max,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: $name',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text('Category: $category'),
          const SizedBox(height: 8.0),
          Text('Description: $description'),
          const SizedBox(height: 8.0),
          Text('Max Participants: $max'),
        ],
      ),
    );
  }
}
