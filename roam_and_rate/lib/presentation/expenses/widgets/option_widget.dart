import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    super.key,
    required this.custom,
    required this.icon,
    required this.action,
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.expandedState,
  });

  final CustomColours custom;
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget action;
  final Widget expanded;
  final bool expandedState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: custom.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: custom.secondarySurface.withValues(alpha: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: custom.secondarySurface,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(child: FaIcon(icon, color: custom.icon)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: custom.primaryText)),
                  Text(subtitle, style: TextStyle(color: custom.secondaryText)),
                ],
              ),
              action,
              
            ],
          ),
          SizedBox(height: 8),
          expandedState ? expanded : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
