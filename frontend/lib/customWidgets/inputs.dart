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
  final String label;

  const SubmitButton({
    super.key,
    required this.onPressed,
    this.label = "Submit",
  });

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
        child: Padding(padding: const EdgeInsets.all(5), child: Text(label)),
      ),
    );
  }
}

// custom delete button
class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const DeleteButton({
    super.key,
    required this.onPressed,
    this.label = "Delete",
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.errorContainer,
          ),
          foregroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.onErrorContainer,
          ),
          textStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontFamily: "Texturina",
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: Padding(padding: const EdgeInsets.all(5), child: Text(label)),
      ),
    );
  }
}

// custom text button
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomTextButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(
            context,
          ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Montserrat",
          color: Theme.of(context).colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
