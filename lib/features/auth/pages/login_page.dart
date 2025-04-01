import 'package:cardx/common/loading_page.dart';
import 'package:cardx/constants/constants.dart';
import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:cardx/features/auth/widgets/auth_button.dart';
import 'package:cardx/features/auth/widgets/auth_field.dart';
import 'package:cardx/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => LoginPage());
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final appBar = UiConstants.appBar;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogIn() {
    ref
        .read(authControllerProvider.notifier)
        .logIn(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar(),
      body:
          isLoading
              ? const Loader()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 100),
                        Text(
                          "Log In",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 20),
                        AuthField(
                          text: "Email",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 20),
                        AuthField(
                          text: "Password",
                          controller: passwordController,
                          isPass: true,
                        ),
                        SizedBox(height: 30),
                        AuthButton(
                          buttonText: "Log In",
                          onTap: onLogIn,
                        ),
                        SizedBox(height: 50),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 18),
                            children: [
                              TextSpan(
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {},
                                text: "Sign Up",
                                style: TextStyle(
                                  color: AppPalette.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
