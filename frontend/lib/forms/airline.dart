import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AirlineForm extends StatefulWidget {
  const AirlineForm({super.key});

  @override
  State<AirlineForm> createState() => _AirlineFormState();
}

class _AirlineFormState extends State<AirlineForm> {
  String? _imagePath;
  final TextEditingController _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const FormHeader(header: "Airline Form"),
            const SizedBox(height: 20),
            FormWrapper(
              child: Column(
                children: [
                  TextFormField(
                    decoration: customInputField(context, "Airline Name"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _imageController,
                    readOnly: true,
                    decoration: customInputField(context, "Airline Logo")
                        .copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null) {
                                final fileName = result.files.single.name;
                                setState(
                                  () => _imageController.text =
                                      fileName, // Display only the name
                                );
                              }
                            },
                          ),
                        ),
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
