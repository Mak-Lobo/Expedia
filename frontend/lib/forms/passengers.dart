import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/passengers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PassengerForm extends StatefulWidget {
  const PassengerForm({super.key});

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _docExpiryController = TextEditingController();

  String? _sexText;
  String? _birthDate;
  String? _docType;
  String? _docExpiryDate;
  String? _nationalityText;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _docNumberController.dispose();
    _docExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final passengerController = context.read<PassengerController>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Passengers form"),
          const SizedBox(height: 40),
          FormWrapper(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: customInputField(context, "First name"),
                          validator: (value) => value == null || value.isEmpty ? "First name is required" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: customInputField(context, "Last name"),
                          validator: (value) => value == null || value.isEmpty ? "Last name is required" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: customInputField(context, "Gender"),
                          dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                          items: const [
                            DropdownMenuItem(value: "Male", child: Text("Male")),
                            DropdownMenuItem(value: "Female", child: Text("Female")),
                            DropdownMenuItem(value: "Intersex", child: Text("Intersex")),
                          ],
                          onChanged: (value) => setState(() => _sexText = value),
                          validator: (value) => value == null ? "Select gender" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: customInputField(context, "Email address"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Email is required";
                            if (!value.contains("@")) return "Enter a valid email address";
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          decoration: customInputField(context, "Date of birth"),
                          readOnly: true,
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(1995),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dateController.text = DateFormat.yMMMMd().format(pickedDate);
                                _birthDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                          validator: (value) => _birthDate == null ? "Select birth date" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: customInputField(context, "Document type"),
                          dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                          items: const [
                            DropdownMenuItem(value: "1", child: Text("Ordinary Passport")),
                            DropdownMenuItem(value: "2", child: Text("Diplomatic Passport")),
                            DropdownMenuItem(value: "3", child: Text("Service Passport")),
                            DropdownMenuItem(value: "4", child: Text("Emergency Passport")),
                            DropdownMenuItem(value: "5", child: Text("Refugee Card")),
                          ],
                          onChanged: (value) => setState(() => _docType = value),
                          validator: (value) => value == null ? "Select document type" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _docNumberController,
                          decoration: customInputField(context, "Document number"),
                          keyboardType: TextInputType.number,
                          validator: (value) => value == null || value.isEmpty ? "Document number is required" : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          controller: _docExpiryController,
                          decoration: customInputField(context, "Expiry date"),
                          readOnly: true,
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(const Duration(days: 365)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 20),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _docExpiryController.text = DateFormat.yMMMMd().format(pickedDate);
                                _docExpiryDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                          validator: (value) => _docExpiryDate == null ? "Select expiry date" : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 320,
                    child: DropdownButtonFormField<String>(
                      decoration: customInputField(context, "Nationality"),
                      dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                      items: const [
                        DropdownMenuItem(value: "1", child: Text("Vietnam")),
                        DropdownMenuItem(value: "2", child: Text("USA")),
                        DropdownMenuItem(value: "5", child: Text("South Africa")),
                        DropdownMenuItem(value: "8", child: Text("Kenya")),
                        DropdownMenuItem(value: "10", child: Text("India")),
                        DropdownMenuItem(value: "14", child: Text("Germany")),
                        DropdownMenuItem(value: "16", child: Text("Botswana")),
                        DropdownMenuItem(value: "17", child: Text("Namibia")),
                      ],
                      onChanged: (value) => setState(() => _nationalityText = value),
                      validator: (value) => value == null ? "Select nationality" : null,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(
                    label: "Save Passenger",
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final passenger = Passenger(
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        sex: _sexText!,
                        birthDate: _birthDate!,
                        email: _emailController.text.trim(),
                        docType: int.parse(_docType!),
                        docNumber: int.parse(_docNumberController.text),
                        docExpiry: _docExpiryDate!,
                        nationality: int.parse(_nationalityText!),
                      );

                      try {
                        await passengerController.savePassenger(
                          passenger,
                          userId: authController.currentUserId,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Passenger saved successfully",
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Failure to save passenger: $error",
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
