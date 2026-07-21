import 'dart:ui';
import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final name =
        "${authController.currentUser?.firstName} ${authController.currentUser?.lastName}";
    return Consumer<AuthController>(
      builder: (context, authController, _) {
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
            if (authController.isAuthenticated)
              CustomTextButton(
                text: "Log out",
                onPressed: () {
                  authController.signOut();
                  context.go('/login');
                },
              ),
            if (authController.isAuthenticated)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Chip(
                  label: Text(
                    name,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
