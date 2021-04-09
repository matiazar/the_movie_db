import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String image;
  BackgroundWidget({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: (image != null)
            ? DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)
            : null,
      ),
      width: double.infinity,
      height: double.infinity,
      // color: Colors.red,
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.4),
            child: Container(),
          ),
        ),
      ),
    );
  }
}
