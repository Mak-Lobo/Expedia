import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class FlightForm extends StatefulWidget {
  const FlightForm({super.key});

  @override
  State<FlightForm> createState() => _FlightFormState();
}

class _FlightFormState extends State<FlightForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Flight form"),
          const SizedBox(height: 40),
          FormWrapper(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputField(context, "Flight No"),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text("Kenya Airways"),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customInputField(context, "Departure time"),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputField(
                          context,
                          "Duration (minutes)",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        decoration: customInputField(
                          context,
                          "Number of seats",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: customInputField(
                          context,
                          "Departure airport",
                        ),
                        onChanged: (_) {},
                        dropdownColor: Theme.of(
                          context,
                        ).colorScheme.tertiaryContainer,
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text(
                              "Jomo Kenyatta International Airport",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: customInputField(
                          context,
                          "Destination airport",
                        ),
                        onChanged: (_) {},
                        dropdownColor: Theme.of(
                          context,
                        ).colorScheme.tertiaryContainer,
                        items: [
                          DropdownMenuItem(
                            value: 4,
                            child: Text(
                              "Mombasa International Airport",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SubmitButton(onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
