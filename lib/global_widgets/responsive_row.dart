import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:flutter/material.dart';

/// Lays children out in a [Row] on web/tablet and stacks them in a [Column]
/// on mobile (width &lt; [Breakpoints.mobile]).
///
/// On mobile it drops [Spacer]s and unwraps [Expanded]/[Flexible] children so
/// the column can never hit the "unbounded height" flex assertion inside a
/// scroll view. The web layout is identical to a plain [Row].
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width < Breakpoints.mobile;

    if (!isMobile) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      );
    }

    final List<Widget> stacked = [];
    for (final child in children) {
      if (child is Spacer) continue;
      if (child is Flexible) {
        stacked.add(child.child);
      } else {
        stacked.add(child);
      }
    }

    // Fill the available width and left-align so a parent that centers its
    // children (the common case in the checklist) doesn't center the stack.
    // Align expands to the incoming width without reporting an infinite
    // intrinsic width (unlike SizedBox(width: infinity)).
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stacked,
      ),
    );
  }
}
