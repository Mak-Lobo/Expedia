import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/table_cell.dart';
import 'package:expedia/models/documents.dart';
import 'package:expedia/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class PaymentDocumentData extends StatefulWidget {
  const PaymentDocumentData({super.key});

  @override
  State<PaymentDocumentData> createState() => _PaymentDocumentDataState();
}

class _PaymentDocumentDataState extends State<PaymentDocumentData> {
  Future<List<Payment>>? _paymentsFuture;
  Future<List<Document>>? _documentsFuture;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialized) {
        return;
      }

      final authController = context.read<AuthController>();
      final paymentController = context.read<PaymentController>();
      final documentController = context.read<DocumentController>();

      setState(() {
        _paymentsFuture = paymentController.loadPayments(userId: authController.currentUserId);
        _documentsFuture = documentController.loadDocuments(userId: authController.currentUserId);
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
          const FormHeader(header: "Payment Methods"),
          const SizedBox(height: 20),
          Divider(
            thickness: 1.3,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<Payment>>(
                future: _paymentsFuture,
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

                  final payments = snapshot.data ?? const <Payment>[];
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
                      for (final payment in payments)
                        TableRow(
                          children: [
                            CustomTableCell(cellText: payment.id?.toString() ?? ''),
                            CustomTableCell(cellText: payment.name),
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
          const FormHeader(header: "Documents"),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<List<Document>>(
                future: _documentsFuture,
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

                  final documents = snapshot.data ?? const <Document>[];
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
                      for (final document in documents)
                        TableRow(
                          children: [
                            CustomTableCell(cellText: document.id?.toString() ?? ''),
                            CustomTableCell(cellText: document.name),
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
