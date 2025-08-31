import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String header;

  const FormHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Text(
      header,
      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
        decoration: TextDecoration.combine([
          TextDecoration.underline,
          TextDecoration.overline,
        ]),
        fontFamily: "Texturina",
      ),
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }
}
