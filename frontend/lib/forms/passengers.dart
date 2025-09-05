import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/passengers.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../configurations/passenger_config.dart';

class PassengerForm extends StatefulWidget {
  const PassengerForm({super.key});

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  final passengerConfig = GetIt.instance.get<PassengerConfig>();
  TextEditingController? _dateController;
  TextEditingController? _firstNameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _docNumberController;
  TextEditingController? _docExpiryController;
  TextEditingController?
  _nationalityController; // For Dropdown, optional if only using _nationalityText

  String? _sexText,
      _nationalityText,
      _submitBirthDate,
      _docType,
      _docExpiryDate;
  final _formKey = GlobalKey<FormState>();
  final List<String> sex = ["Male", "Female", "Intersex"];

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _docNumberController = TextEditingController();
    _docExpiryController = TextEditingController();
    _nationalityController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController?.dispose();
    _firstNameController?.dispose();
    _lastNameController?.dispose();
    _emailController?.dispose();
    _docNumberController?.dispose();
    _docExpiryController?.dispose();
    _nationalityController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "First name"),
                          controller: _firstNameController,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "Last name"),
                          controller: _lastNameController,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: customInputField(context, "Gender"),
                          dropdownColor: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          items: [
                            DropdownMenuItem<String>(
                              value: sex[0],
                              child: Text("Male"),
                            ),
                            DropdownMenuItem<String>(
                              value: sex[1],
                              child: Text("Female"),
                            ),
                            DropdownMenuItem<String>(
                              value: sex[2],
                              child: Text("Intersex"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _sexText = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(
                            context,
                            "Email address",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter an email address";
                            }
                            if (!value.contains("@")) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(
                            context,
                            "Date of Birth",
                          ),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          controller: _dateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            print(pickedDate);

                            if (pickedDate != null) {
                              // formattedDate was for printing runtimeType, not strictly needed for logic
                              // final formattedDate = DateFormat.yMMMd().format(
                              //   pickedDate,
                              // );
                              // print(formattedDate.runtimeType);
                              setState(() {
                                _dateController!.text = DateFormat.yMMMMd()
                                    .format(pickedDate);
                                _submitBirthDate = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(pickedDate);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          // Made String type consistent
                          decoration: customInputField(
                            context,
                            "Document Type",
                          ),
                          dropdownColor: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          items: const [
                            DropdownMenuItem<String>(
                              value: "1",
                              child: Text("Ordinary Passport"),
                            ),
                            DropdownMenuItem<String>(
                              value: "2",
                              child: Text("Diplomatic Passport"),
                            ),
                            DropdownMenuItem<String>(
                              value: "3",
                              child: Text("Service Passport"),
                            ),
                            DropdownMenuItem<String>(
                              value: "4",
                              child: Text("Emergency Passport"),
                            ),
                            DropdownMenuItem<String>(
                              value: "5",
                              child: Text("Refugee Card"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _docType = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(
                            context,
                            "Document Number",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _docNumberController,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "Expiry Date"),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          controller: _docExpiryController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              // Expiry usually starts from today
                              lastDate: DateTime(
                                DateTime.now().year + 20,
                              ), // Expiry usually in future
                            );
                            print(pickedDate);
                            if (pickedDate != null) {
                              final formattedDate = DateFormat.yMMMd().format(
                                pickedDate,
                              );
                              print(formattedDate);
                              setState(() {
                                _docExpiryController!.text = formattedDate;
                                _docExpiryDate = DateFormat(
                                  "yyyy-MM-dd",
                                ).format(pickedDate);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          // Made String type consistent
                          decoration: customInputField(context, "Nationality"),
                          dropdownColor: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          items: [
                            // Assuming values are strings
                            DropdownMenuItem<String>(
                              value: "16", // Example value
                              child: Text("Botswana"),
                            ),
                            DropdownMenuItem<String>(
                              value: "8", // Example value
                              child: Text("Kenya"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _nationalityText = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(
                    onPressed: () {
                      savePassengerDetails(context);
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

  // saving function
  Future<void> savePassengerDetails(BuildContext context) async {
    if (_sexText == null ||
        _submitBirthDate == null ||
        _docType == null ||
        _nationalityText == null ||
        _docExpiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all required fields, including dates and dropdowns.",
          ),
        ),
      );
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final passenger = Passenger(
          firstName: _firstNameController!.text,
          lastName: _lastNameController!.text,
          sex: _sexText!,
          birthDate: _submitBirthDate!,
          email: _emailController!.text,
          docType: int.parse(_docType!),
          docNumber: int.parse(_docNumberController!.text),
          docExpiry: _docExpiryDate!,
          nationality: int.parse(_nationalityText!),
        );
        await passengerConfig.savePassenger(passenger);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              message: "Passenger saved successfully",
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),

            snackBarAnimationStyle: AnimationStyle(
              // This property does not exist on SnackBar
              curve: Curves.easeOut,
              reverseCurve: Curves.easeInCirc,
            ),
          );
          context.pop();
        }
      } on Exception catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failure to save passenger: ${e.toString()}"),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          message: "Failure to save passenger",
          backgroundColor: Theme.of(
            context,
          ).colorScheme.error.withValues(blue: 0.4, green: 0.4, red: 0.4),
        ),
      );
    }
  }
}
