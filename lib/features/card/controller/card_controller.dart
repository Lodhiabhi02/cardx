import 'dart:io';
import 'package:cardx/apis/card_api.dart';
import 'package:cardx/apis/storage_api.dart';
import 'package:cardx/apis/user_api.dart';
import 'package:cardx/core/core.dart';
import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:cardx/features/home/view/home_page.dart';

import 'package:cardx/models/card_model.dart';
import 'package:cardx/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardControllerProvider =
    StateNotifierProvider<CardController, bool>((ref) {
      return CardController(
        ref: ref,
        cardApi: ref.watch(cardAPIProvider),
        storageApi: ref.watch(storageApiProvider),
        userApi: ref.watch(userAPIProvider),
      );
    });

final getUserSavedCardsProvider = FutureProvider.family((
  ref,
  String uid,
) async {
  final cardController = ref.watch(cardControllerProvider.notifier);
  return cardController.getUserSavedCards(uid);
});

final getUserLikedCardsProvider = FutureProvider.family((
  ref,
  String uid,
) async {
  final cardController = ref.watch(cardControllerProvider.notifier);
  return cardController.getUserLikedCards(uid);
});

final getLatestCardProvider = StreamProvider((ref) {
  final cardApi = ref.watch(cardAPIProvider);
  return cardApi.getLatestCard();
});

final searchCardsByNameProvider = FutureProvider.family((
  ref,
  String name,
) async {
  final cardController = ref.watch(cardControllerProvider.notifier);
  return cardController.searchCardsByname(name);
});

// final getLatestLikedCardProvider = StreamProvider.family((
//   ref,
//   String uid,
// ) {
//   final cardApi = ref.watch(cardAPIProvider);
//   return cardApi.getLatestLikedCard(uid);
// });

// final userLikedCardsStreamProvider =
//     StreamProvider.family<List<CardModel>, String>((ref, userId) {
//       final cardApi = ref.watch(cardAPIProvider);
//       return cardApi.getLikedCardsStream(userId);
//     });

class CardController extends StateNotifier<bool> {
  final CardApi _cardApi;
  final Ref _ref;
  final StorageApi _storageApi;
  final UserApi _userApi;
  CardController({
    required Ref ref,
    required CardApi cardApi,
    required StorageApi storageApi,
    required UserApi userApi,
  }) : _ref = ref,
       _cardApi = cardApi,
       _storageApi = storageApi,
       _userApi = userApi,
       super(false);

  void saveCard({
    required File? image,
    required String name,
    required String jobtitle,
    required String company,
    required String phone,
    required String email,
    required String website,
    required String address,
    required bool isFavorite,
    required notes,
    required BuildContext context,
  }) async {
    if (state) return; // Prevent duplicate submissions
    state = true;

    // Validate image
    if (image == null || !image.existsSync()) {
      showSnackBar(context, "Please select a valid image.");
      state = false; // Reset state if validation fails
      return;
    }

    // current user
    final user = _ref.watch(currentUserDeatilsProvider).value!;

    final avatarUrl = await _storageApi.uploadImage(image);

    CardModel card = CardModel(
      id: "",
      uid: user.uid,
      name: name,
      jobTitle: jobtitle,
      company: company,
      phone: phone,
      email: email,
      website: website,
      address: address,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
      isFavorite: isFavorite,
      notes: notes,
    );

    final res = await _cardApi.saveCard(card);

    res.fold(
      (l) {
        showSnackBar(context, l.message);
        state = false; // Reset state on failure
      },
      (r) async {
        final cardId = r.$id;

        List<String> updatedSavedCards = List.from(user.savedCards)
          ..add(cardId);
        UserModel updatedUser = user.copyWith(
          savedCards: updatedSavedCards,
        );

        final res2 = await _userApi.addCardToUserData(updatedUser);
        state = false; // Reset state after success
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, "Card saved Successfully!");
          Navigator.pushAndRemoveUntil(
            context,
            HomePage.route(),
            (route) => false,
          );
        });
      },
    );
  }

  Future<List<CardModel>> getUserSavedCards(String uid) async {
    final cards = await _cardApi.getUserSavedCards(uid);
    return cards.map((e) => CardModel.fromMap(e.data)).toList();
  }

  Future<List<CardModel>> getUserLikedCards(String uid) async {
    final cards = await _cardApi.getLikedCards(uid);
    return cards.map((e) => CardModel.fromMap(e.data)).toList();
  }

  Future<List<CardModel>> searchCardsByname(String name) async {
    final cards = await _cardApi.seacrhCardByNameCompnay(name);
    return cards.map((e) => CardModel.fromMap(e.data)).toList();
  }

  void likeCard(CardModel cardModel) async {
    final updatedCard = cardModel.copyWith(
      isFavorite: !cardModel.isFavorite,
    );
    final res = await _cardApi.likeCard(updatedCard);
    res.fold((l) => l.message, (r) {
      debugPrint("Card liked: ${updatedCard.isFavorite}");
    });
  }

  void deleteCard({
    required String cardId,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _cardApi.deleteCard(cardId);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, "Card deleted successfully!"),
    );
  }
}
