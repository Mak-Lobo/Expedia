import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

import '../customWidgets/form_headers.dart';

class DocForm extends StatefulWidget {
  const DocForm({super.key});

  @override
  State<DocForm> createState() => _DocFormState();
}

class _DocFormState extends State<DocForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Document form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: Form(
              child: TextFormField(
                decoration: customInputField(context, "Document Name"),
              ),
            ),
          ),
          const SizedBox(height: 40),
          SubmitButton(onPressed: () {}),
        ],
      ),
    );
  }
}
