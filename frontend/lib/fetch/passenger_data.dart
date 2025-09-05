import 'package:expedia/customWidgets/form_headers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../configurations/passenger_config.dart';
import '../customWidgets/table_cell.dart';

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
    print(passengerListFuture.toString());
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
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List>(
                future: passengerListFuture,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SpinKitWanderingCubes(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  } else if (asyncSnapshot.hasError) {
                    print(
                      "Error in fetching data from database: ${asyncSnapshot.data}",
                    );
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitSquareCircle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 20),
                        Text('Error: ${asyncSnapshot.error}'),
                      ],
                    );
                  } else if (asyncSnapshot.hasData) {
                    final passengerList = asyncSnapshot.data!;
                    // loop to get the keys at each index to be used as column names
                    final columnNames = [
                      "ID",
                      "First Name",
                      "Last Name",
                      "Sex",
                      "Date of Birth",
                      "Email",
                      "Doc Type",
                      "Doc Number",
                      "Doc Expiry",
                      "Nationality",
                    ];
                    return Table(
                      border: TableBorder.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
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
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      header.toUpperCase(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        for (var val in passengerList)
                          TableRow(
                            children: <Widget>[
                              CustomTableCell(cellText: val.id.toString()),
                              CustomTableCell(cellText: val.firstName),
                              CustomTableCell(cellText: val.lastName),
                              CustomTableCell(cellText: val.sex),
                              CustomTableCell(cellText: val.birthDate),
                              CustomTableCell(cellText: val.email),
                              CustomTableCell(cellText: val.docType.toString()),
                              CustomTableCell(
                                cellText: val.docNumber.toString(),
                              ),
                              CustomTableCell(cellText: val.docExpiry),
                              CustomTableCell(
                                cellText: val.nationality.toString(),
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
            ),
          ),
        ],
      ),
    );
  }
}
