import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/city.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CityForm extends StatefulWidget {
  const CityForm({super.key});

  @override
  State<CityForm> createState() => _CityFormState();
}

class _CityFormState extends State<CityForm> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  int? _countryId;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final cityController = context.read<CityController>();
    final countryController = context.watch<CountryController>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "City Form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cityController,
                    decoration: customInputField(context, "City name"),
                    validator: (value) => value == null || value.isEmpty ? "Please enter a city name" : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    decoration: customInputField(context, "Country name"),
                    dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                    initialValue: _countryId,
                    items: countryController.countries.isEmpty
                        ? const [
                            DropdownMenuItem(value: 8, child: Text("Kenya")),
                            DropdownMenuItem(value: 2, child: Text("USA")),
                          ]
                        : countryController.countries
                            .map(
                              (country) => DropdownMenuItem(
                                value: country.id,
                                child: Text(country.name),
                              ),
                            )
                            .where((item) => item.value != null)
                            .toList(),
                    onChanged: (value) => setState(() => _countryId = value),
                    validator: (value) => value == null ? "Select a country" : null,
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(
                    label: "Save City",
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final city = City(
                        name: _cityController.text.trim(),
                        countryId: _countryId!,
                      );

                      try {
                        await cityController.saveCity(
                          city,
                          userId: authController.currentUserId,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "City saved successfully",
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Failure to save city: $error",
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
