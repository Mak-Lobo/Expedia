import 'package:flutter/material.dart';

class CustomTableCell extends StatelessWidget {
  final String cellText;

  const CustomTableCell({super.key, required this.cellText});

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cellText),
        ),
      ),
    );
  }
}
