import 'package:crud_project/common/theme/colors.dart';
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  final double? height;
  final double? width;
  final bool hasAllCornersRounded;

  const RoundedContainer({
    super.key,
    required this.child,
    this.radius,
    this.color,
    this.width,
    this.height,
    this.hasAllCornersRounded = false,
  });

  @override
  Widget build(BuildContext context) {
    double borderRadius = radius ?? 32;
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
            bottomRight: hasAllCornersRounded
                ? Radius.circular(borderRadius)
                : Radius.zero,
            bottomLeft: hasAllCornersRounded
                ? Radius.circular(borderRadius)
                : Radius.zero,
          ),
        ),
        child: child);
  }
}