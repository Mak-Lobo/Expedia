import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class CountryForm extends StatefulWidget {
  const CountryForm({super.key});

  @override
  State<CountryForm> createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Country form"),
          const SizedBox(height: 30),
          FormWrapper(
            child: Form(
              child: TextFormField(
                decoration: customInputField(context, "Country Name"),
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
