import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cardx/core/failure.dart';
import 'package:cardx/core/providers.dart';
import 'package:cardx/core/type_defs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authAPIProvider = Provider((ref) {
  // getting account from providers
  final account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});

abstract class IAuthApi {
  FutureEither<User> signUp({
    required String email,
    required String password,
    required String name,
  });

  FutureEither<Session> logIn({
    required String email,
    required String password,
  });

  FutureEitherVoid logoutUser();
  Future<User?> currentUserAccount();
}

class AuthApi implements IAuthApi {
  final Account
  _account; // will provide this above when creating provider

  AuthApi({required Account account}) : _account = account;

  @override
  FutureEither<Session> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Unknown", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Unknown", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid logoutUser() async {
    try {
      await _account.deleteSession(sessionId: "current");

      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Unknown", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }
}
