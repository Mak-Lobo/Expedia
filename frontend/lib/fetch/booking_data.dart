import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/table_cell.dart';
import 'package:expedia/models/booking_class.dart';
import 'package:expedia/models/booking_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BookingData extends StatefulWidget {
  const BookingData({super.key});

  @override
  State<BookingData> createState() => _BookingDataState();
}

class _BookingDataState extends State<BookingData> {
  Future<List<BookingType>>? _bookingTypesFuture;
  Future<List<BookingClass>>? _bookingClassesFuture;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) {
        return;
      }

      final authController = context.read<AuthController>();
      final bookingTypeController = context.read<BookingTypeController>();
      final bookingClassController = context.read<BookingClassController>();

      setState(() {
        _bookingTypesFuture = bookingTypeController.loadBookingTypes(
          userId: authController.currentUserId,
        );
        _bookingClassesFuture = bookingClassController.loadBookingClasses(
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
          const FormHeader(header: "Booking Data"),
          const SizedBox(height: 20),
          Divider(
            thickness: 1.3,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<BookingType>>(
                future: _bookingTypesFuture,
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

                  final bookingTypes = snapshot.data ?? const <BookingType>[];
                  return Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          for (final header in const ["ID", "Name"])
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
                      for (final bookingType in bookingTypes)
                        TableRow(
                          children: [
                            CustomTableCell(cellText: bookingType.id?.toString() ?? ''),
                            CustomTableCell(cellText: bookingType.name),
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
          const FormHeader(header: "Booking Classes"),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<BookingClass>>(
                future: _bookingClassesFuture,
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

                  final bookingClasses = snapshot.data ?? const <BookingClass>[];
                  return Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(50),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          for (final header in const ["ID", "Class Name"])
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
                      for (final bookingClass in bookingClasses)
                        TableRow(
                          children: [
                            CustomTableCell(cellText: bookingClass.id?.toString() ?? ''),
                            CustomTableCell(cellText: bookingClass.className),
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
