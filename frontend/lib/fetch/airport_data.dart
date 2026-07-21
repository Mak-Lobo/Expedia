import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/table_cell.dart';
import 'package:expedia/models/airport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AirportsData extends StatefulWidget {
  const AirportsData({super.key});

  @override
  State<AirportsData> createState() => _AirportsDataState();
}

class _AirportsDataState extends State<AirportsData> {
  Future<List<Airport>>? _airportsFuture;
  Future<List<AirportCityCountry>>? _airportsWithCountryFuture;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) {
        return;
      }

      final authController = context.read<AuthController>();
      final airportController = context.read<AirportController>();
      setState(() {
        _airportsFuture = airportController.loadAirports(userId: authController.currentUserId);
        _airportsWithCountryFuture = airportController.loadAirportsWithCountry(
          userId: authController.currentUserId,
        );
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const FormHeader(header: "Available Airports"),
          const SizedBox(height: 20),
          Divider(
            thickness: 1.3,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<Airport>>(
                future: _airportsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitWanderingCubes(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitSquareCircle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 20),
                        Text('Error: ${snapshot.error}'),
                      ],
                    );
                  }

                  final airportList = snapshot.data ?? const <Airport>[];
                  return Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          for (final header in const ["ID", "Name", "Code", "City"])
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    header,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      for (final airport in airportList)
                        TableRow(
                          children: [
                            CustomTableCell(cellText: airport.id?.toString() ?? ''),
                            CustomTableCell(cellText: airport.name),
                            CustomTableCell(cellText: airport.code),
                            CustomTableCell(cellText: airport.city.toString()),
                          ],
                        ),
                    ],
                  );
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
          const FormHeader(header: "Airports with Locations"),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<AirportCityCountry>>(
                future: _airportsWithCountryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitWanderingCubes(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitSquareCircle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 20),
                        Text('Error: ${snapshot.error}'),
                      ],
                    );
                  }

                  final airportCountryList = snapshot.data ?? const <AirportCityCountry>[];
                  return Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          for (final header in const ["Airport", "Code", "City", "Country"])
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    header,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      for (final airportCountry in airportCountryList)
                        TableRow(
                          children: [
                            CustomTableCell(cellText: airportCountry.name),
                            CustomTableCell(cellText: airportCountry.code),
                            CustomTableCell(cellText: airportCountry.city),
                            CustomTableCell(cellText: airportCountry.country),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
