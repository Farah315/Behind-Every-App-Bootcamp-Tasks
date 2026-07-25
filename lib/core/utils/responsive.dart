import 'package:flutter/widgets.dart';

/// Simple MediaQuery-based breakpoints — no external package needed.
/// mobile: <600, tablet: 600-900, desktop/web: >900.
class Responsive {
  Responsive._();

  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  /// How many product cards per row.
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint) return 4;
    if (width >= tabletBreakpoint) return 3;
    return 2;
  }

  /// Horizontal page padding — grows a bit on larger screens.
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint) return 32;
    if (width >= tabletBreakpoint) return 24;
    return 16;
  }

  /// Caps content width on very wide screens (web) so cards don't
  /// stretch edge-to-edge and look distorted.
  static const double maxContentWidth = 1100;
}
