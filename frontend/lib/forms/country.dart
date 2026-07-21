import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/country.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountryForm extends StatefulWidget {
  const CountryForm({super.key});

  @override
  State<CountryForm> createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final countryController = context.read<CountryController>();

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Country form"),
          const SizedBox(height: 30),
          FormWrapper(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _countryController,
                decoration: customInputField(context, "Country Name"),
                validator: (value) => value == null || value.isEmpty ? "Country name is required" : null,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SubmitButton(
            label: "Save Country",
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              try {
                await countryController.saveCountry(
                  Country(name: _countryController.text.trim()),
                  userId: authController.currentUserId,
                );

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    message: "Country saved successfully",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                Navigator.of(context).pop();
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    message: "Failure to save country: $error",
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
