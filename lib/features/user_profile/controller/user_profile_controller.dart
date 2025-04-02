import 'package:cardx/apis/card_api.dart';
import 'package:cardx/apis/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileControllerprovider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
      return UserProfileController(
        userApi: ref.watch(userAPIProvider),
        cardApi: ref.watch(cardAPIProvider),
      );
    });

class UserProfileController extends StateNotifier<bool> {
  final UserApi _userApi;
  final CardApi _cardApi;
  UserProfileController({
    required UserApi userApi,
    required CardApi cardApi,
  }) : _userApi = userApi,
       _cardApi = cardApi,
       super(false);
}
