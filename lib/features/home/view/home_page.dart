import 'dart:io';

import 'package:cardx/constants/assets_constants.dart';
import 'package:cardx/constants/ui_constants.dart';
import 'package:cardx/core/core.dart';
import 'package:cardx/features/card/view/scan_card_page.dart';
import 'package:cardx/features/home/widgets/bottom_nav_clipper.dart';
import 'package:cardx/features/home/widgets/buttom_nav_bar_item.dart';
import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appbar = UiConstants.appBar();
  File? image;

  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  Future<File?> onPickImage() async {
    File? pickedImage =
        await pickimage(); // Ensure pickimage() returns a File
    setState(() {
      image = pickedImage;
    });
    return pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: IndexedStack(
        index: _page,
        children: UiConstants.bottomBarPages,
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          // Custom shaped bottom bar
          Container(
            height: 55,
            margin: EdgeInsets.only(top: 15),
            child: ClipPath(
              clipper: BottomNavClipper(),
              child: CupertinoTabBar(
                height: 70,
                backgroundColor: const Color.fromARGB(
                  255,
                  37,
                  38,
                  42,
                ),
                currentIndex: _page,
                onTap: (index) {
                  if (index == 2) return;
                  onPageChange(index < 2 ? index : index - 1);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: ButtomNavBarItem(
                      label: "home",
                      filledIconPath: AssetsConstants.homeFilledIcon,
                      outlinedIconPath:
                          AssetsConstants.homeOutlinedIcon,
                      isSelected: _page == 0,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: ButtomNavBarItem(
                      label: "favorites",
                      filledIconPath: AssetsConstants.likeFilledIcon,
                      outlinedIconPath:
                          AssetsConstants.likeOutlinedIcon,
                      isSelected: _page == 1,
                      iconHeight: 24,
                    ),
                  ),
                  // Empty center
                  BottomNavigationBarItem(
                    icon: SizedBox(width: 50),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: ButtomNavBarItem(
                      label: "ar view",
                      filledIconPath: AssetsConstants.arviewFilled,
                      outlinedIconPath: AssetsConstants.arviewOutline,
                      isSelected: _page == 2,
                      iconHeight: 24,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: ButtomNavBarItem(
                      label: "profile",
                      filledIconPath: AssetsConstants.userFilledIcon,
                      outlinedIconPath:
                          AssetsConstants.userOutlineIcon,
                      isSelected: _page == 3,
                      iconHeight: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          File? pickedFile = await onPickImage();
          if (image != null && mounted) {
            Navigator.of(
              context,
            ).push(ScanCardPage.route(pickedFile!));
          }
        },
        shape: CircleBorder(),
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.camera_alt,
          size: 28,
          color: AppPalette.white,
        ),
      ),
      floatingActionButtonLocation:
          CustomFloatingActionButtonLocation(15),
    );
  }
}
