import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/background_shape.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String loginError = '';
  final userIDController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundShape(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: theme.textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: userIDController,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: "Enrollment Number",
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your enrollment number";
                                }
                                if (value.length != 13 && value.length != 7) {
                                  return "Invalid enrollment number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passController,
                              obscureText: true,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? "Please enter your password"
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLoading ||
                                !_formKey.currentState!.validate()) {
                              return;
                            }
                            setState(() {
                              isLoading = true;
                              loginError = '';
                            });
                            () async {
                              try {
                                await ApiService.handleLogin(
                                  userIDController.text.trim(),
                                  passController.text.trim(),
                                );

                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DashboardScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                setState(() {
                                  loginError = "Login failed\n${e.toString()}";
                                  isLoading = false;
                                });
                              }
                            }();
                          },
                          child: isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  "Login",
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                      if (loginError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            loginError, //loginError,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
