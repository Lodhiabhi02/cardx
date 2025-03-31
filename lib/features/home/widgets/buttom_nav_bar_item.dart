import 'package:cardx/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtomNavBarItem extends StatelessWidget {
  final String label;
  final String filledIconPath;
  final String outlinedIconPath;
  final bool isSelected;
  final double? iconHeight;

  const ButtomNavBarItem({
    super.key,
    required this.label,
    required this.filledIconPath,
    required this.outlinedIconPath,
    required this.isSelected,
    this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: SvgPicture.asset(
            isSelected ? filledIconPath : outlinedIconPath,
            color: AppPalette.white,
            height: iconHeight,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppPalette.textWhite, fontSize: 10),
        ),
      ],
    );
  }
}
