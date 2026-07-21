import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/customWidgets/form_headers.dart';
import 'package:expedia/customWidgets/form_wrapper.dart';
import 'package:expedia/customWidgets/inputs.dart';
import 'package:expedia/customWidgets/snack.dart';
import 'package:expedia/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'auth_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: "Welcome back",
      subtitle: "Sign in to manage flights, passengers, bookings, and all the admin tools tied to your account.",
      footerText: "Need an account? Register here",
      onFooterPressed: () => context.go('/register'),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Consumer<AuthController>(
              builder: (context, authController, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FormHeader(header: "Login"),
                      const SizedBox(height: 20),
                      FormWrapper(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: customInputField(context, "Email address"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!value.contains('@')) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: customInputField(context, "Password"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            SubmitButton(
                              label: authController.isBusy ? 'Signing in...' : 'Login',
                              onPressed: authController.isBusy
                                  ? () {}
                                  : () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      final success = await authController.login(
                                        LoginRequest(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                        ),
                                      );

                                      if (!context.mounted) return;

                                      if (success) {
                                        context.go('/home');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          customSnackBar(
                                            message: authController.errorMessage ?? 'Login failed',
                                            backgroundColor: Theme.of(context).colorScheme.error,
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
