import 'package:expedia/fetch/city_data.dart';
import 'package:expedia/fetch/passenger_data.dart';
import 'package:flutter/material.dart';

import '../customWidgets/form_headers.dart';

class ReadData extends StatefulWidget {
  const ReadData({super.key});

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  final Map<String, Widget> entities = {
    "Passengers": const PassengersData(),
    "Cities": const CitiesData(),
    // "Countries": const CountryForm(),
    // "Airlines": const AirlineForm(),
    // "Airports": const AirportForm(),
  };

  @override
  Widget build(BuildContext context) {
    final List<String> entitiesList = entities.keys.toList();
    final List<Widget> forms = entities.values.toList();
    return Column(
      children: [
        const SizedBox(height: 20),
        FormHeader(header: "EDITS"),
        const SizedBox(height: 20),
        Divider(
          thickness: 1.3,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.tertiaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Fetch data",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ListView.builder(
                itemCount: entitiesList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text(entitiesList[i]),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 1280,
                                    maxHeight: 1000,
                                    minHeight: 500,
                                    minWidth: 800,
                                  ),
                                  child: forms[i],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.menu_book_rounded),
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
