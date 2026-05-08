import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class WLargeTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const WLargeTextfield({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: custom.secondaryText),
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),

        fillColor: custom.surface,
        filled: true,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing!";
        }

        return null;
      },
    );
  }
}
