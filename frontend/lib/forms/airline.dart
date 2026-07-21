import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/airline.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AirlineForm extends StatefulWidget {
  const AirlineForm({super.key});

  @override
  State<AirlineForm> createState() => _AirlineFormState();
}

class _AirlineFormState extends State<AirlineForm> {
  final _formKey = GlobalKey<FormState>();
  final _airlineController = TextEditingController();
  final _logoController = TextEditingController();

  @override
  void dispose() {
    _airlineController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final airlineController = context.read<AirlineController>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const FormHeader(header: "Airline Form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _airlineController,
                    decoration: customInputField(context, "Airline Name"),
                    validator: (value) => value == null || value.isEmpty ? "Airline name is required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _logoController,
                    readOnly: true,
                    decoration: customInputField(context, "Airline Logo").copyWith(
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () async {
                          final result = await FilePicker.pickFiles(type: FileType.image);
                          if (result != null) {
                            setState(() => _logoController.text = result.files.single.name);
                          }
                        },
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? "Pick a logo image" : null,
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(
                    label: "Save Airline",
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        await airlineController.saveAirline(
                          Airline(
                            airlineName: _airlineController.text.trim(),
                            logoPath: _logoController.text.trim(),
                          ),
                          userId: authController.currentUserId,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Airline saved successfully",
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Failure to save airline: $error",
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
