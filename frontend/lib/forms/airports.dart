import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class AirportForm extends StatefulWidget {
  const AirportForm({super.key});

  @override
  State<AirportForm> createState() => _AirportFormState();
}

class _AirportFormState extends State<AirportForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Airport form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: Form(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "Airport Name"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "Airport Code"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: customInputField(context, "City Name"),
                    dropdownColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                    items: const [
                      DropdownMenuItem(
                        value: "8",
                        child: Text("Dar es Salaam"),
                      ),
                      DropdownMenuItem(value: 1, child: Text("Kampala")),
                      DropdownMenuItem(value: 4, child: Text("Nairobi")),
                      DropdownMenuItem(value: 5, child: Text("Mombasa")),
                      DropdownMenuItem(value: 6, child: Text("Jinja")),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
