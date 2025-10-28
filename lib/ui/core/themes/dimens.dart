import 'package:flutter/material.dart';

abstract class Dimens {
  const Dimens();

  /// General padding used to separate UI items
  static const paddingAll = 20.0;
  static const borderRadius = BorderRadius.all(Radius.circular(8));

  /// Horizontal padding for screen edges
  double get paddingScreenAll;

  double get profilePictureSize;

  /// Horizontal symmetric padding for screen edges
  EdgeInsets get edgeInsetsScreen => EdgeInsets.all(paddingAll);

  static const Dimens desktop = _DimensDesktop();
  static const Dimens mobile = _DimensMobile();

  /// Get dimensions definition based on screen size
  factory Dimens.of(BuildContext context) =>
      switch (MediaQuery.sizeOf(context).width) {
        > 600 && < 840 => desktop,
        _ => mobile,
      };
}

/// Mobile dimensions
final class _DimensMobile extends Dimens {
  @override
  final double paddingScreenAll = 20.0;

  @override
  final double profilePictureSize = 64.0;

  const _DimensMobile();
}

/// Desktop/Web dimensions
final class _DimensDesktop extends Dimens {
  @override
  final double paddingScreenAll = 100.0;

  @override
  final double profilePictureSize = 128.0;

  const _DimensDesktop();
}
