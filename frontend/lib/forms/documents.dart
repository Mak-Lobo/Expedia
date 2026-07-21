import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/documents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocForm extends StatefulWidget {
  const DocForm({super.key});

  @override
  State<DocForm> createState() => _DocFormState();
}

class _DocFormState extends State<DocForm> {
  final _formKey = GlobalKey<FormState>();
  final _docController = TextEditingController();

  @override
  void dispose() {
    _docController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final docController = context.read<DocumentController>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Document form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _docController,
                decoration: customInputField(context, "Document Name"),
                validator: (value) => value == null || value.isEmpty ? "Document name is required" : null,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SubmitButton(
            label: "Save Document",
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              try {
                await docController.saveDocument(
                  Document(name: _docController.text.trim()),
                  userId: authController.currentUserId,
                );

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    message: "Document saved successfully",
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                Navigator.of(context).pop();
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    message: "Failure to save document: $error",
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
