import 'package:expedia/forms/airports.dart';
import 'package:expedia/forms/city.dart';
import 'package:flutter/material.dart';

import '../customWidgets/form_headers.dart';
import '../forms/airline.dart';
import '../forms/country.dart';
import '../forms/passengers.dart';

class Edits extends StatefulWidget {
  const Edits({super.key});

  @override
  State<Edits> createState() => _EditsState();
}

class _EditsState extends State<Edits> {
  final Map<String, Widget> entities = {
    "Passengers": const PassengerForm(),
    "Cities": const CityForm(),
    "Countries": const CountryForm(),
    "Airlines": const AirlineForm(),
    "Airports": const AirportForm(),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        FormHeader(header: "EDITS"),
        const SizedBox(height: 20),
        Divider(
          thickness: 1.3,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Save Entries",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entities.length,
                itemBuilder: (context, i) {
                  final texts = entities.keys.toList();
                  final forms = entities.values.toList();
                  return Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(texts[i]),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: forms[i]);
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Update entries",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entities.length,
                itemBuilder: (context, i) {
                  final texts = entities.keys.toList();
                  return Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(texts[i]),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog();
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
