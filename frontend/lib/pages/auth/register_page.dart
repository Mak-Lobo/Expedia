import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/country.dart';
import 'package:expedia/models/documents.dart';
import 'package:expedia/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'auth_shell.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  String? _sex;
  int? _documentType;
  int? _nationality;
  DateTime? _dateOfBirth;
  DateTime? _documentExpiry;

  Future<List<Country>>? _countriesFuture;
  Future<List<Document>>? _documentsFuture;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) {
        return;
      }

      setState(() {
        _countriesFuture = context.read<CountryController>().loadCountries();
        _documentsFuture = context.read<DocumentController>().loadDocuments();
        _initialized = true;
      });
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _docNumberController.dispose();
    _birthDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: "Create your account",
      subtitle: "Register a passenger profile, secure a login, and unlock the booking experience from one place.",
      footerText: "Already have an account? Sign in",
      onFooterPressed: () => context.go('/login'),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Consumer<AuthController>(
              builder: (context, authController, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FormHeader(header: "Register"),
                      const SizedBox(height: 20),
                      FormWrapper(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: customInputField(context, "Sex"),
                                    dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                                    items: const [
                                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                                      DropdownMenuItem(value: 'Intersex', child: Text('Intersex')),
                                    ],
                                    onChanged: (value) => setState(() => _sex = value),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Select sex';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    decoration: customInputField(context, "First name"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'First name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    decoration: customInputField(context, "Last name"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Last name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: customInputField(context, "Email address"),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration: customInputField(context, "Password"),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _birthDateController,
                                    readOnly: true,
                                    decoration: customInputField(context, "Date of birth"),
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(1995),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _dateOfBirth = pickedDate;
                                          _birthDateController.text = DateFormat.yMMMMd().format(pickedDate);
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (_dateOfBirth == null) {
                                        return 'Select a birth date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: TextFormField(
                                    controller: _expiryDateController,
                                    readOnly: true,
                                    decoration: customInputField(context, "Document expiry"),
                                    onTap: () async {
                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now().add(const Duration(days: 365)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(DateTime.now().year + 20),
                                      );
                                      if (pickedDate != null) {
                                        setState(() {
                                          _documentExpiry = pickedDate;
                                          _expiryDateController.text = DateFormat.yMMMMd().format(pickedDate);
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (_documentExpiry == null) {
                                        return 'Select expiry date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _docNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: customInputField(context, "Document number"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Document number is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: FutureBuilder<List<Document>>(
                                    future: _documentsFuture,
                                    builder: (context, snapshot) {
                                      final documents = snapshot.data ?? const <Document>[];
                                      return DropdownButtonFormField<int>(
                                        decoration: customInputField(context, "Document type"),
                                        dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                                        items: documents.isEmpty
                                            ? const [
                                                DropdownMenuItem(
                                                  value: 1,
                                                  child: Text("Passport"),
                                                ),
                                              ]
                                            : documents
                                                .map(
                                                  (document) => DropdownMenuItem(
                                                    value: document.id,
                                                    child: Text(document.name),
                                                  ),
                                                )
                                                .where((item) => item.value != null)
                                                .toList(),
                                        onChanged: (value) => setState(() => _documentType = value),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Select document type';
                                          }
                                          return null;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            FutureBuilder<List<Country>>(
                              future: _countriesFuture,
                              builder: (context, snapshot) {
                                final countries = snapshot.data ?? const <Country>[];
                                return DropdownButtonFormField<int>(
                                  decoration: customInputField(context, "Nationality"),
                                  dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
                                  items: countries.isEmpty
                                      ? const [
                                          DropdownMenuItem(value: 1, child: Text("Default country")),
                                        ]
                                      : countries
                                          .map(
                                            (country) => DropdownMenuItem(
                                              value: country.id,
                                              child: Text(country.name),
                                            ),
                                          )
                                          .where((item) => item.value != null)
                                          .toList(),
                                  onChanged: (value) => setState(() => _nationality = value),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Select nationality';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            SubmitButton(
                              label: authController.isBusy ? 'Creating account...' : 'Register',
                              onPressed: authController.isBusy
                                  ? () {}
                                  : () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      final success = await authController.register(
                                        RegisterRequest(
                                          firstName: _firstNameController.text.trim(),
                                          lastName: _lastNameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                          sex: _sex!,
                                          dateOfBirth: _dateOfBirth!,
                                          documentType: _documentType!,
                                          documentExpiry: _documentExpiry!,
                                          documentNo: int.parse(_docNumberController.text),
                                          nationality: _nationality!,
                                        ),
                                      );

                                      if (!context.mounted) return;

                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          customSnackBar(
                                            message: 'Account registered successfully',
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                          ),
                                        );
                                        context.go('/login');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          customSnackBar(
                                            message: authController.errorMessage ?? 'Registration failed',
                                            backgroundColor: Theme.of(context).colorScheme.error,
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
