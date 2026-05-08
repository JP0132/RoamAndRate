import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class CustomInputField extends StatelessWidget {
  final String inputText;
  final bool isObscureText;
  final String regFilter;
  final FaIcon inputIcon;
  final TextEditingController controller;
  final bool numberKeyBoard;
  final String? Function(String?)? validator;
  const CustomInputField({
    super.key,
    required this.inputText,
    required this.inputIcon,
    required this.controller,
    this.isObscureText = false,
    this.regFilter = ".*",
    this.numberKeyBoard = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Container(
      decoration: BoxDecoration(
        color: custom.surface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          obscureText: isObscureText,
          validator: validator,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(regFilter)),
          ],
          keyboardType: numberKeyBoard
              ? TextInputType.numberWithOptions(decimal: true)
              : null,
          decoration: InputDecoration(
            hintText: inputText,
            hintStyle: TextStyle(color: custom.secondaryText),
            icon: inputIcon,
            iconColor: custom.primary,
            filled: false,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
