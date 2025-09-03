import 'package:expedia/customWidgets/form_headers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../configurations/passenger_config.dart';

GetIt getIt = GetIt.instance;

class PassengersData extends StatefulWidget {
  const PassengersData({super.key});

  @override
  State<PassengersData> createState() => _PassengersDataState();
}

class _PassengersDataState extends State<PassengersData> {
  final passengerConfig = getIt.get<PassengerConfig>();

  @override
  Widget build(BuildContext context) {
    final passengerListFuture = passengerConfig.mapPassengers();
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 20),
          FormHeader(header: "Registered Passengers"),
          const SizedBox(height: 20),
          Divider(
            thickness: 1.3,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 30),
          FutureBuilder<List>(
            future: passengerListFuture,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitWanderingCubes(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                );
              } else if (asyncSnapshot.hasError) {
                return Center(child: Text('Error: ${asyncSnapshot.error}'));
              } else if (asyncSnapshot.hasData) {
                final passengerList = asyncSnapshot.data!;
                // loop to get the keys at each index to be used as column names
                final columnNames = passengerList[0].keys.toList();
                final values = passengerList[0].values.toList();
                return Table(
                  border: TableBorder.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    width: 1.5,
                  ),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(50),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                    4: FlexColumnWidth(),
                    5: FlexColumnWidth(),
                    6: FlexColumnWidth(),
                    7: FlexColumnWidth(),
                    8: FlexColumnWidth(),
                    9: FlexColumnWidth(),
                  },
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        for (String header in columnNames)
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  header.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    for (var passenger in passengerList)
                      TableRow(
                        children: <Widget>[
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(passenger.id.toString()),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(passenger.name),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(passenger.email),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(passenger.trips.toString()),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              } else {
                return const Center(child: Text('No data available'));
              }
            },
          ),
        ],
      ),
    );
  }
}
