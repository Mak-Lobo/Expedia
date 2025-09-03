import 'package:flutter/material.dart';

InputDecoration customInputField(BuildContext context, String label) {
  return InputDecoration(
    labelText: label,
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 2,
      ),
    ),
    filled: true,
    fillColor: Theme.of(context).colorScheme.tertiaryContainer,
    labelStyle: TextStyle(fontFamily: "Urbanist"),
  );
}

// custom submit button
class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.primaryContainer,
          ),
          foregroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          textStyle: WidgetStatePropertyAll(
            Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontFamily: "Texturina"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Text("Submit"),
        ),
      ),
    );
  }
}

// custom text button
class CustomTextButton extends StatelessWidget {
  final String text;

  const CustomTextButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(
            context,
          ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall!.copyWith(fontFamily: "Montserrat"),
      ),
    );
  }
}
