import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: padding ?? AppSpacing.paddingMd,
      child: child,
    );

    return Card(
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: AppRadius.borderMd,
              child: cardContent,
            )
          : cardContent,
    );
  }
}
