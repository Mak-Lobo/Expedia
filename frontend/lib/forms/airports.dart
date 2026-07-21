import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/airport.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AirportForm extends StatefulWidget {
  const AirportForm({super.key});

  @override
  State<AirportForm> createState() => _AirportFormState();
}

class _AirportFormState extends State<AirportForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  int? _cityId;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final airportController = context.read<AirportController>();
    final cityController = context.watch<CityController>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Airport form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: customInputField(context, "Airport Name"),
                          validator: (value) => value == null || value.isEmpty ? "Airport name is required" : null,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          decoration: customInputField(context, "Airport Code"),
                          validator: (value) => value == null || value.isEmpty ? "Airport code is required" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<int>(
                    decoration: customInputField(context, "City Name"),
                    dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                    initialValue: _cityId,
                    items: cityController.cities.isEmpty
                        ? const [
                            DropdownMenuItem(value: 1, child: Text("Nairobi")),
                            DropdownMenuItem(value: 2, child: Text("Kampala")),
                          ]
                        : cityController.cities
                            .map(
                              (city) => DropdownMenuItem(
                                value: city.id,
                                child: Text(city.name),
                              ),
                            )
                            .where((item) => item.value != null)
                            .toList(),
                    onChanged: (value) => setState(() => _cityId = value),
                    validator: (value) => value == null ? "Select a city" : null,
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(
                    label: "Save Airport",
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        await airportController.saveAirport(
                          Airport(
                            name: _nameController.text.trim(),
                            code: _codeController.text.trim(),
                            city: _cityId!,
                          ),
                          userId: authController.currentUserId,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Airport saved successfully",
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Failure to save airport: $error",
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
