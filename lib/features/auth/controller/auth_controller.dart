import 'package:appwrite/models.dart';
import 'package:cardx/apis/auth_api.dart';
import 'package:cardx/apis/user_api.dart';
import 'package:cardx/core/core.dart';
import 'package:cardx/features/auth/pages/login_page.dart';
import 'package:cardx/features/home/view/home_page.dart';
import 'package:cardx/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
      return AuthController(
        authApi: ref.watch(authAPIProvider),
        userApi: ref.watch(userAPIProvider),
      );
    });

//account details of the logged user
final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

// to get the details of current user
final currentUserDeatilsProvider = FutureProvider((ref) {
  final currentUserId =
      ref
          .watch(currentUserAccountProvider)
          .value!
          .$id; // this gives the id of current user
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

// to get the user deatils by uid
// this same provider is called above but provided current user id
final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userApi;
  AuthController({required AuthApi authApi, required UserApi userApi})
    : _authApi = authApi,
      _userApi = userApi,
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

    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
        name: name,
        uid: r.$id,
        email: email,
        profilePic: '',
        savedCards: const [],
        favCards: const [],
      );
      final res2 = await _userApi.saveUserData(userModel);

      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, "Account created! Please Log in");
        Navigator.push(context, LoginPage.route());
      });
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
      showSnackBar(context, "Logged in");
      Navigator.pushAndRemoveUntil(
        context,
        HomePage.route(),
        (route) => false,
      );
    });
  }

  // getting user session
  Future<User?> currentUser() => _authApi.currentUserAccount();

  Future<UserModel> getUserData(String uid) async {
    final doucment = await _userApi.getUserData(uid);
    final updatedUser = UserModel.fromMap(doucment.data);
    return updatedUser;
  }
}
