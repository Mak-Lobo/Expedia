import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/booking_class.dart';
import 'package:expedia/models/booking_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingClassForm extends StatefulWidget {
  const BookingClassForm({super.key});

  @override
  State<BookingClassForm> createState() => _BookingClassFormState();
}

class _BookingClassFormState extends State<BookingClassForm> {
  final _classFormKey = GlobalKey<FormState>();
  final _typeFormKey = GlobalKey<FormState>();
  final _classController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void dispose() {
    _classController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final bookingClassController = context.read<BookingClassController>();
    final bookingTypeController = context.read<BookingTypeController>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const FormHeader(header: "Booking class form"),
          const SizedBox(height: 40),
          FormWrapper(
            child: Form(
              key: _classFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _classController,
                    decoration: customInputField(context, "Booking Class"),
                    validator: (value) => value == null || value.isEmpty ? "Booking class is required" : null,
                  ),
                  const SizedBox(height: 20),
                  SubmitButton(
                    label: "Save Class",
                    onPressed: () async {
                      if (!_classFormKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        await bookingClassController.saveBookingClass(
                          BookingClass(className: _classController.text.trim()),
                          userId: authController.currentUserId,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Booking class saved successfully",
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Failure to save booking class: $error",
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const FormHeader(header: "Booking type form"),
          const SizedBox(height: 20),
          FormWrapper(
            child: Form(
              key: _typeFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _typeController,
                    decoration: customInputField(context, "Booking type"),
                    validator: (value) => value == null || value.isEmpty ? "Booking type is required" : null,
                  ),
                  const SizedBox(height: 20),
                  SubmitButton(
                    label: "Save Type",
                    onPressed: () async {
                      if (!_typeFormKey.currentState!.validate()) {
                        return;
                      }

                      try {
                        await bookingTypeController.saveBookingType(
                          BookingType(name: _typeController.text.trim()),
                          userId: authController.currentUserId,
                        );

                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Booking type saved successfully",
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                        Navigator.of(context).pop();
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            message: "Failure to save booking type: $error",
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
