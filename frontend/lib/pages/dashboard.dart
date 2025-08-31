import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryFixedVariant,
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Dashboard'),
          ),
        ),
      ),
    );
  }
}
