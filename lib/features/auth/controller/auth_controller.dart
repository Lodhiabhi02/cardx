import 'package:appwrite/models.dart';
import 'package:cardx/apis/auth_api.dart';
import 'package:cardx/core/core.dart';
import 'package:cardx/features/auth/pages/login_page.dart';
import 'package:cardx/features/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
      return AuthController(authApi: ref.watch(authAPIProvider));
    });

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  AuthController({required AuthApi authApi})
    : _authApi = authApi,
      super(false);

  //signup
  void signUp({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.signUp(
      email: email,
      password: password,
      name: name,
    );

    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Account created! Please Log in");
      Navigator.push(context, LoginPage.route());
    });
  }

  // login
  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final res = await _authApi.logIn(
      email: email,
      password: password,
    );

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Account created! Please Log in");
      Navigator.push(context, HomePage.route());
    });
  }

  // getting user session
  Future<User?> currentUser() => _authApi.currentUserAccount();
}
