import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class FlightBookingForm extends StatefulWidget {
  const FlightBookingForm({super.key});

  @override
  State<FlightBookingForm> createState() => _FlightBookingFormState();
}

class _FlightBookingFormState extends State<FlightBookingForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          FormHeader(header: "Flight booking form"),
          const SizedBox(height: 20),
          flightBookingFormFields(context),
        ],
      ),
    );
  }

  Widget flightBookingFormFields(BuildContext context) {
    return FormWrapper(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: customInputField(context, "Flight_ID"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: customInputField(context, "Holder"),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: customInputField(context, "Booking date"),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField(
                  dropdownColor: Theme.of(
                    context,
                  ).colorScheme.tertiaryContainer,
                  items: [
                    DropdownMenuItem(value: 1, child: Text("M-Pesa")),
                    DropdownMenuItem(value: 2, child: Text("Visa")),
                  ],
                  onChanged: (_) {},
                ),
              ),
              const SizedBox(width: 10),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField(
                  decoration: customInputField(context, "Trip Type"),
                  dropdownColor: Theme.of(
                    context,
                  ).colorScheme.tertiaryContainer,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("One-way")),
                    DropdownMenuItem(value: 2, child: Text("Return")),
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
    );
  }
}
