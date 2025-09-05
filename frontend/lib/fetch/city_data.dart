import 'package:expedia/customWidgets/form_headers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Assumption: CityConfig is in this path. Adjust if necessary.
import '../configurations/city_config.dart';

// Assumption: City model is in this path. Adjust if necessary.
import '../customWidgets/table_cell.dart';
import '../models/city.dart';

GetIt getIt = GetIt.instance;

class CitiesData extends StatefulWidget {
  const CitiesData({super.key});

  @override
  State<CitiesData> createState() => _CitiesDataState();
}

class _CitiesDataState extends State<CitiesData> {
  final cityConfig = getIt.get<CityConfig>();

  @override
  Widget build(BuildContext context) {
    final cityListFuture = cityConfig.mapCities();
    final cityCountryListFuture = cityConfig.mapCitiesCountry();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 20),
          FormHeader(header: "Available Cities"), // Changed header
          const SizedBox(height: 20),
          Divider(
            thickness: 1.3,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<City>>(
                future: cityListFuture,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SpinKitWanderingCubes(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  } else if (asyncSnapshot.hasError) {
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
                    final List<City> cityList = asyncSnapshot.data!;
                    final List<String> columnNames = ["ID", "Name", "Country"];

                    return Table(
                      border: TableBorder.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                        width: 1.5,
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(50), // For ID
                        1: FlexColumnWidth(), // For Name
                        2: FlexColumnWidth(), // For Country
                      },
                      children: <TableRow>[
                        // Header Row
                        TableRow(
                          children: <Widget>[
                            for (String header in columnNames)
                              TableCell(
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
                        // Data Rows
                        for (City cityItem
                            in cityList) // Iterate over City objects
                          TableRow(
                            children: <Widget>[
                              // Access assumed City properties
                              CustomTableCell(cellText: cityItem.id.toString()),
                              CustomTableCell(cellText: cityItem.name),
                              CustomTableCell(
                                cellText: cityItem.countryId.toString(),
                              ),
                            ],
                          ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No data available (unknown state).'),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            thickness: 1.3,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          FormHeader(header: "Cities with Countries"),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<CityCountry>>(
                future: cityCountryListFuture,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: SpinKitWanderingCubes(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  } else if (asyncSnapshot.hasError) {
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
                    final List<CityCountry> cityCountryList =
                        asyncSnapshot.data!;
                    final List<String> columnNames = ["City", "Country"];
                    return Table(
                      border: TableBorder.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                      },
                      children: <TableRow>[
                        TableRow(
                          children: [
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
                        for (var cityCountry in cityCountryList)
                          TableRow(
                            children: [
                              CustomTableCell(cellText: cityCountry.city),
                              CustomTableCell(cellText: cityCountry.country),
                            ],
                          ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          SpinKitSquareCircle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          SizedBox(height: 20),
                          Text('No data available (unknown state).'),
                        ],
                      ),
                    );
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
