import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

typedef HugeIconData = List<List<dynamic>>;

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.size, this.color, this.strokeWidth});

  final HugeIconData icon;
  final double? size;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return HugeIcon(
      icon: icon,
      size: size ?? 24.0,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      strokeWidth: strokeWidth,
    );
  }
}
