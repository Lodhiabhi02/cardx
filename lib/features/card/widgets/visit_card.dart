import 'package:cardx/constants/assets_constants.dart';
import 'package:cardx/core/utils.dart';
import 'package:cardx/features/card/controller/card_controller.dart';
import 'package:cardx/features/card/view/card_view.dart';
import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:cardx/models/card_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';

class VisitCard extends ConsumerWidget {
  final CardModel card;

  const VisitCard({super.key, required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(card.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        ref
            .watch(cardControllerProvider.notifier)
            .deleteCard(cardId: card.id, context: context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        child: Container(
          padding: const EdgeInsets.all(
            6,
          ).copyWith(left: 10, top: 0, right: 10),
          decoration: BoxDecoration(
            color: AppPalette.cardBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 33,
                backgroundImage: NetworkImage(card.avatarUrl),
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6),
                    // Name
                    Text(
                      card.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Job Title
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsConstants.companyIcon,
                          height: 14,
                          color: AppPalette.iconGray,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            card.company,
                            style: const TextStyle(
                              color: AppPalette.textGray,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Company Name
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsConstants.jobPositionIcon,
                          height: 14,
                          color: AppPalette.iconGray,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            card.jobTitle,
                            style: const TextStyle(
                              color: AppPalette.textGray,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),

                    // Date
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsConstants.clockIcon,
                          height: 10,
                          color: AppPalette.textGray,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formatTime(card.createdAt),

                          style: const TextStyle(
                            color: AppPalette.textGray,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10),
              // Favorite and Next Icons
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  LikeButton(
                    isLiked: card.isFavorite,
                    onTap: (isLiked) async {
                      ref
                          .watch(cardControllerProvider.notifier)
                          .likeCard(card);
                      return !isLiked;
                    },
                    size: 25,
                    likeBuilder: (isLiked) {
                      return isLiked
                          ? SvgPicture.asset(
                            AssetsConstants.likeFilledIcon,
                            color: AppPalette.likeColor,
                          )
                          : SvgPicture.asset(
                            AssetsConstants.likeOutlinedIcon,
                            color: AppPalette.iconGray,
                          );
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 57, 60, 71),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppPalette.iconGray,
                        size: 15,
                      ),
                      onPressed: () {
                        Navigator.push(context, CardView.route(card));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
