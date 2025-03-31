import 'package:cardx/common/loading_page.dart';
import 'package:cardx/constants/constants.dart';
import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:cardx/features/auth/pages/login_page.dart';
import 'package:cardx/features/auth/widgets/auth_button.dart';
import 'package:cardx/features/auth/widgets/auth_field.dart';
import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => SignupPage());
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  //appBar
  final appbar = UiConstants.appBar;

  // controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() {
    ref
        .read(authControllerProvider.notifier)
        .signUp(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar(),
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
                        SizedBox(height: 60),

                        Text(
                          "Sign up",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        AuthField(
                          text: "Name",
                          controller: nameController,
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
                          buttonText: "Sign Up",
                          onTap: signUp,
                        ),
                        SizedBox(height: 50),
                        RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 18),
                            children: [
                              TextSpan(
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(
                                          context,
                                        ).push(LoginPage.route());
                                      },
                                text: "Sign in",
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
