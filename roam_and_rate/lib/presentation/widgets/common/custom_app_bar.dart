import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.custom,
  });
  final String title;
  final CustomColours custom;

  @override
  Widget build(BuildContext context) {
    return AppBar(leading: Navigator.canPop(context) ? Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(decoration: BoxDecoration(color: custom.surface, shape: BoxShape.circle), child: IconButton(icon: FaIcon(FontAwesomeIcons.chevronLeft, color: custom.primary,), onPressed: () => Navigator.pop(context))),
    ) : null, centerTitle: true, title: Text(title, style: TextStyle(color: custom.primaryText)), backgroundColor: custom.background,);
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
