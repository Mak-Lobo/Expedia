import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class BookingClassForm extends StatefulWidget {
  const BookingClassForm({super.key});

  @override
  State<BookingClassForm> createState() => _BookingClassFormState();
}

class _BookingClassFormState extends State<BookingClassForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Booking class form"),
          const SizedBox(height: 40),
          FormWrapper(
            child: Form(
              child: TextFormField(
                decoration: customInputField(context, "Booking Class"),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 2),

          // booking type form
          const SizedBox(height: 10),
          const FormHeader(header: "Booking type form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: TextFormField(
              decoration: customInputField(context, "Booking type"),
            ),
          ),
          const SizedBox(height: 40),
          SubmitButton(onPressed: () {}),
        ],
      ),
    );
  }
}
