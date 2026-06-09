import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/presentation/trips/classes/tabitem.dart';

class SegmentedSwitcher extends StatefulWidget {
  final List<TabItem> items;
  final void Function(int index) onTabSelected;
  final int selectedIndex;

  const SegmentedSwitcher({
    super.key,
    required this.items,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<SegmentedSwitcher> createState() => _SegmentedSwitcherState();
}

class _SegmentedSwitcherState extends State<SegmentedSwitcher> {
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Container(
      width: 340,
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: custom.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: custom.primary.withValues(alpha: 0.5)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / widget.items.length;

          return Stack(
            children: [
              // Animated moving background
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                left: selectedIndex * itemWidth,
                top: 0,
                child: Container(
                  width: itemWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: custom.primary,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: custom.primary.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons
              Row(
                children: List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isSelected = selectedIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          widget.onTabSelected(index);
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                color: isSelected
                                    ? custom.background
                                    : custom.primaryText.withValues(
                                        alpha: 0.35,
                                      ),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedIndex == index ? custom.secondary : custom.secondarySurface,
                              ),
                              child: Text(
                                item.count.toString(),
                                style: TextStyle(color: selectedIndex == index ? custom.primaryText : custom.secondaryText),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
