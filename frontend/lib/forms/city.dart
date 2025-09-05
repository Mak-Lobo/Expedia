import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../configurations/city_config.dart';
import '../models/city.dart';

class CityForm extends StatefulWidget {
  const CityForm({super.key});

  @override
  State<CityForm> createState() => _CityFormState();
}

class _CityFormState extends State<CityForm> {
  final cityConfig = GetIt.instance.get<CityConfig>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _cityController;
  int? _country;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _cityController?.dispose();
    super.dispose();
  }

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
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: Column(
                children: [
                  TextFormField(
                    decoration: customInputField(context, "City name"),
                    controller: _cityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a city name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: customInputField(context, "Country Name"),
                    dropdownColor: Theme.of(
                      context,
                    ).colorScheme.tertiaryContainer,
                    items: [
                      DropdownMenuItem(value: 1, child: Text("Vietnam")),
                      DropdownMenuItem(value: 2, child: Text("USA")),
                      DropdownMenuItem(value: 8, child: Text("Kenya")),
                      DropdownMenuItem(value: 14, child: Text("Germany")),
                      DropdownMenuItem(value: 7, child: Text("Czechoslovakia")),
                      DropdownMenuItem(value: 16, child: Text("Botswana")),
                      DropdownMenuItem(value: 10, child: Text("India")),
                      DropdownMenuItem(value: 17, child: Text("Namibia")),
                      DropdownMenuItem(value: 5, child: Text("South Africa")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _country = value;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  SubmitButton(
                    onPressed: () {
                      saveCityDetails(context);
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

  Future<void> saveCityDetails(BuildContext context) async {
    if (_cityController!.text.isEmpty || _country == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final city = City(name: _cityController!.text, countryId: _country!);
        await cityConfig.saveCity(city);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              message: "City saved successfully",
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            snackBarAnimationStyle: AnimationStyle(
              // This property does not exist on SnackBar
              curve: Curves.easeOut,
              reverseCurve: Curves.easeInCirc,
            ),
          );
          context.pop();
        }
      } on Exception catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              message: "Failure to save city: ${e.toString()}",
              backgroundColor: Theme.of(
                context,
              ).colorScheme.error.withValues(blue: 0.4, green: 0.4, red: 0.4),
            ),
            snackBarAnimationStyle: AnimationStyle(
              // This property does not exist on SnackBar
              curve: Curves.easeOut,
              reverseCurve: Curves.easeInCirc,
            ),
          );
        }
      }
    }
  }
}
