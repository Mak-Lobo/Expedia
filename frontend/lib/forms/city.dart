import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class CityForm extends StatefulWidget {
  const CityForm({super.key});

  @override
  State<CityForm> createState() => _CityFormState();
}

class _CityFormState extends State<CityForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "City Form"),
          SizedBox(height: 20),
          FormWrapper(
            child: Form(
              // autovalidateMode: AutovalidateMode.onUnfocus,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: customInputField(context, "City name"),
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: customInputField(context, "Country Name"),
                      dropdownColor: Theme.of(
                        context,
                      ).colorScheme.tertiaryContainer,
                      items: [
                        DropdownMenuItem(value: 1, child: Text("Vietnam")),
                        DropdownMenuItem(value: 2, child: Text("USA")),
                        DropdownMenuItem(value: 8, child: Text("Kenya")),
                        DropdownMenuItem(value: 14, child: Text("Germany")),
                        DropdownMenuItem(
                          value: 7,
                          child: Text("Czechoslovakia"),
                        ),
                      ],
                      onChanged: (_) {},
                    ),
                  ),
                ],
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
