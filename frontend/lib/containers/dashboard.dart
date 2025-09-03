import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        FormHeader(header: "DASHBOARD"),
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
              Card(
                child: ListTile(
                  leading: const Icon(Icons.flight_takeoff),
                  title: const Text('Upcoming Flights'),
                  subtitle: const Text('You have 2 upcoming flights.'),
                  trailing: CustomTextButton(text: "View all"),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Recent Bookings'),
                  subtitle: const Text('Last booking: JFK to LAX'),
                  trailing: CustomTextButton(text: "View details"),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_offer),
                  title: const Text('Special Offers'),
                  subtitle: const Text('Check out the latest flight deals!'),
                  trailing: CustomTextButton(text: "Explore deals"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
