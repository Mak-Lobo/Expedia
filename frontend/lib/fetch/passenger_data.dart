import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/customWidgets/table_cell.dart';
import 'package:expedia/models/passengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class PassengersData extends StatefulWidget {
  const PassengersData({super.key});

  @override
  State<PassengersData> createState() => _PassengersDataState();
}

class _PassengersDataState extends State<PassengersData> {
  final _idToBeDeleted = TextEditingController();
  Future<List<Passenger>>? _passengersFuture;
  bool _initialized = false;

  @override
  void dispose() {
    _idToBeDeleted.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) {
        return;
      }

      final authController = context.read<AuthController>();
      final passengerController = context.read<PassengerController>();
      setState(() {
        _passengersFuture = passengerController.loadPassengers(
          userId: authController.currentUserId,
        );
        _initialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.read<AuthController>();
    final passengerController = context.read<PassengerController>();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const FormHeader(header: "Registered Passengers"),
          const SizedBox(height: 20),
          Divider(
            thickness: 1.3,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<Passenger>>(
                future: _passengersFuture,
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

                  final passengerList = snapshot.data ?? const <Passenger>[];
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
                      4: FlexColumnWidth(),
                      5: FlexColumnWidth(),
                      6: FlexColumnWidth(),
                      7: FlexColumnWidth(),
                      8: FlexColumnWidth(),
                      9: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          for (final header in const [
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
                          ])
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
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
                      for (final passenger in passengerList)
                        TableRow(
                          children: [
                            CustomTableCell(cellText: passenger.id.toString()),
                            CustomTableCell(cellText: passenger.firstName),
                            CustomTableCell(cellText: passenger.lastName),
                            CustomTableCell(cellText: passenger.sex),
                            CustomTableCell(cellText: passenger.birthDate),
                            CustomTableCell(cellText: passenger.email),
                            CustomTableCell(cellText: passenger.docType.toString()),
                            CustomTableCell(cellText: passenger.docNumber.toString()),
                            CustomTableCell(cellText: passenger.docExpiry),
                            CustomTableCell(cellText: passenger.nationality.toString()),
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _idToBeDeleted,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: customInputField(context, "Passenger to delete"),
                ),
              ),
              const SizedBox(width: 20),
              DeleteButton(
                onPressed: () async {
                  if (_idToBeDeleted.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all required fields.")),
                    );
                    return;
                  }

                  try {
                    await passengerController.deletePassenger(
                      int.parse(_idToBeDeleted.text),
                      userId: authController.currentUserId,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar(
                        message: "Passenger deleted successfully",
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                    setState(() {
                      _passengersFuture = passengerController.loadPassengers(
                        userId: authController.currentUserId,
                      );
                    });
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar(
                        message: "Failure to delete passenger: $error",
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
