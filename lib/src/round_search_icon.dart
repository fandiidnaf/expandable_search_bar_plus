import 'package:flutter/material.dart';

/// A rounded icon button used internally by [ExpandableSearchBarPlus].
///
/// You can also use it standalone if you want the same look and feel.
class RoundSearchIcon extends StatelessWidget {
  const RoundSearchIcon({
    super.key,
    this.width = 40,
    this.boxShadow,
    this.iconColor = const Color(0xff47E10C),
    this.backgroundColor = const Color(0xff353535),
    this.icon = const Icon(Icons.search_rounded, size: 22),
  });

  final double width;
  final List<BoxShadow>? boxShadow;
  final Color iconColor;
  final Color backgroundColor;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: boxShadow,
      ),
      alignment: Alignment.center,
      child: IconTheme(
        data: IconThemeData(color: iconColor),
        child: icon,
      ),
    );
  }
}
