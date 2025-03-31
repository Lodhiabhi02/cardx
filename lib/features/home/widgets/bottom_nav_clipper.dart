import 'package:flutter/material.dart';

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final centerWidth = size.width / 2;
    final circleRadius = 35.0;

    path.moveTo(0, 0); // Start from top-left corner
    path.lineTo(
      centerWidth - circleRadius,
      0,
    ); // Draw to the start of the circle cutout

    // Draw the circle cutout
    path.arcToPoint(
      Offset(centerWidth + circleRadius, 0),
      radius: Radius.circular(circleRadius),
      clockwise: false,
    );

    path.lineTo(size.width, 0); // Draw to top-right corner
    path.lineTo(
      size.width,
      size.height,
    ); // Draw to bottom-right corner
    path.lineTo(0, size.height); // Draw to bottom-left corner
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  final double offsetY; // Positive moves it down

  const CustomFloatingActionButtonLocation(this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Get the default position from centerDocked
    final Offset defaultOffset = FloatingActionButtonLocation
        .centerDocked
        .getOffset(scaffoldGeometry);
    // Return a new offset with adjusted Y position
    return Offset(defaultOffset.dx, defaultOffset.dy + offsetY);
  }
}
