import 'package:flutter/material.dart';

class AuthShell extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final String footerText;
  final VoidCallback onFooterPressed;

  const AuthShell({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    required this.footerText,
    required this.onFooterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(180),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(
                                child: _HeroPanel(
                                  title: title,
                                  subtitle: subtitle,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    child,
                                    const SizedBox(height: 12),
                                    _FooterLink(
                                      footerText: footerText,
                                      onPressed: onFooterPressed,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                _HeroPanel(title: title, subtitle: subtitle),
                                const SizedBox(height: 20),
                                child,
                                const SizedBox(height: 12),
                                _FooterLink(
                                  footerText: footerText,
                                  onPressed: onFooterPressed,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String footerText;
  final VoidCallback onPressed;

  const _FooterLink({required this.footerText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          footerText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: "Montserrat",
          ),
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeroPanel({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 18),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "EXPEDIA",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontFamily: "Rubik-Glitch",
              letterSpacing: 10,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontFamily: "Texturina",
              height: 1.05,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontFamily: "Urbanist",
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FeatureChip(label: "Flights"),
              _FeatureChip(label: "Passengers"),
              _FeatureChip(label: "Bookings"),
              _FeatureChip(label: "Admin tools"),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.72),
    );
  }
}
