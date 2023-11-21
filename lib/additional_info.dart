import 'package:flutter/material.dart';

class AdditionaInfo extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const AdditionaInfo(
      {super.key,
      required this.icon,
      required this.lable,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 30,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(lable),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
