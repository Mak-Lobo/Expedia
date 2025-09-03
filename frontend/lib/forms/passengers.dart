import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class PassengerForm extends StatefulWidget {
  const PassengerForm({super.key});

  @override
  State<PassengerForm> createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
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
              key: GlobalKey<FormState>(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "First name"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "Last name"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: null,
                          decoration: customInputField(context, "Gender"),
                          dropdownColor: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          items: const [
                            DropdownMenuItem<String>(
                              value: "Male",
                              child: Text("Male"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Intersex",
                              child: Text("Intersex"),
                            ),
                          ],
                          onChanged: (value) {
                            // print(value);
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
                          // controller: _dateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            // if (pickedDate != null) {
                            //   _dateController.text = "${pickedDate.toLocal()}"
                            //       .split(' ')[0];
                            // }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          decoration: customInputField(
                            context,
                            "Document Type",
                          ),
                          dropdownColor: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          items: const [
                            DropdownMenuItem(
                              value: "1",
                              child: Text("Ordinary Passport"),
                            ),
                            DropdownMenuItem(
                              value: "2",
                              child: Text("Diplomatic Passport"),
                            ),
                            DropdownMenuItem(
                              value: "3",
                              child: Text("Service Passport"),
                            ),
                            DropdownMenuItem(
                              value: "4",
                              child: Text("Emergency Passport"),
                            ),
                            DropdownMenuItem(
                              value: "5",
                              child: Text("Refugee Card"),
                            ),
                          ],
                          onChanged: (_) {},
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
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          decoration: customInputField(context, "Expiry Date"),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          // controller: _dateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            // if (pickedDate != null) {
                            //   _dateController.text = "${pickedDate.toLocal()}"
                            //       .split(' ')[0];
                            // }
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
                        child: DropdownButtonFormField(
                          decoration: customInputField(context, "Nationality"),
                          dropdownColor: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          items: [
                            DropdownMenuItem(
                              value: 16,
                              child: Text("Botswana"),
                            ),
                            DropdownMenuItem(value: 8, child: Text("Kenya")),
                          ],
                          onChanged: (_) {},
                        ),
                      ),
                    ],
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
