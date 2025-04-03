import 'package:cardx/common/error_page.dart';
import 'package:cardx/common/loading_page.dart';
import 'package:cardx/constants/appwrite_constants.dart';
import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:cardx/features/card/controller/card_controller.dart';
import 'package:cardx/features/card/widgets/visit_card.dart';
import 'package:cardx/models/card_model.dart';
import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardList extends ConsumerStatefulWidget {
  const CardList({super.key});

  @override
  ConsumerState<CardList> createState() => _CardListState();
}

class _CardListState extends ConsumerState<CardList> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
          decoration: InputDecoration(
            fillColor: AppPalette.cardBackground,
            filled: true,
            hintText: "Search cards...",
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: AppPalette.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: AppPalette.buttonBlue,
                width: 2,
              ),
            ),
            hintStyle: TextStyle(color: AppPalette.textWhite),
            prefixIcon: Icon(Icons.search, color: AppPalette.white),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: ref
            .watch(
              getUserSavedCardsProvider(
                ref.watch(currentUserAccountProvider).value!.$id,
              ),
            )
            .when(
              data: (cards) {
                final filteredCards =
                    searchQuery.isEmpty
                        ? cards
                        : cards
                            .where(
                              (card) =>
                                  card.name.toLowerCase().contains(
                                    searchQuery,
                                  ) ||
                                  card.company.toLowerCase().contains(
                                    searchQuery,
                                  ) ||
                                  card.jobTitle
                                      .toLowerCase()
                                      .contains(searchQuery),
                            )
                            .toList();
                return ref
                    .watch(getLatestCardProvider)
                    .when(
                      data: (data) {
                        if (data.events.contains(
                          "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.create",
                        )) {
                          final newCard = CardModel.fromMap(
                            data.payload,
                          );
                          // Prevent duplicate insertion
                          if (!cards.any(
                            (card) => card.id == newCard.id,
                          )) {
                            cards.insert(0, newCard);
                          }
                        } else if (data.events.contains(
                          "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.update",
                        )) {
                          final updatedCard = CardModel.fromMap(
                            data.payload,
                          );
                          final index = cards.indexWhere(
                            (element) => element.id == updatedCard.id,
                          );
                          if (index != -1) {
                            cards[index] = updatedCard;
                          }
                        } else if (data.events.contains(
                          "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.delete",
                        )) {
                          final deletedCard = CardModel.fromMap(
                            data.payload,
                          );
                          cards.removeWhere(
                            (element) => element.id == deletedCard.id,
                          );
                        }
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final card = filteredCards[index];
                            return VisitCard(card: card);
                          },
                          itemCount: filteredCards.length,
                        );
                      },
                      error:
                          (error, stackTrace) =>
                              ErrorText(errorText: error.toString()),
                      loading: () {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final card = filteredCards[index];
                            return VisitCard(card: card);
                          },
                          itemCount: filteredCards.length,
                        );
                      },
                    );
              },
              error:
                  (error, stackTrace) =>
                      ErrorText(errorText: error.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
