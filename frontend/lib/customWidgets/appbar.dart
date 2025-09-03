import 'dart:ui';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 1.7, sigmaY: 1.9),
          child: Text(
            "EXPEDIA",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontFamily: "Rubik-Glitch",
              letterSpacing: 15,
            ),
          ),
        ),
      ),
      scrolledUnderElevation: 10,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        const CustomTextButton(text: "About us"),
        const SizedBox(width: 10),
        const CustomTextButton(text: "Contact us"),
        const SizedBox(width: 10),
        const CustomTextButton(text: "Helpline"),
        const SizedBox(width: 10),
      ],
    );
  }
}
