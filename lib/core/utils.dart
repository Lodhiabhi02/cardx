import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(content)));
}


 // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SvgPicture.asset(
                //       AssetsConstants.cardxLogo,
                //       // fit: BoxFit.,
                //     ),
                //     SizedBox(width: 20),
                //     Text(
                //       "Crad X",
                //       style: TextStyle(
                //         fontSize: 30,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ],
                // ),