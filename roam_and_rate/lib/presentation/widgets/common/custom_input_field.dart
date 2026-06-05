import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class CustomInputField extends StatelessWidget {
  final String inputText;
  final bool isObscureText;
  final String regFilter;
  final FaIcon? inputIcon;
  final TextEditingController controller;
  final bool numberKeyBoard;
  final String? Function(String?)? validator;
  final Color? inputFieldColour;
  final double? inputPadding;
  final double? inputTextSize;
  final bool? isReadOnly;
  final Widget? prefix;
  const CustomInputField({
    super.key,
    required this.inputText,
    this.inputIcon,
    required this.controller,
    this.isObscureText = false,
    this.regFilter = ".*",
    this.numberKeyBoard = false,
    this.validator,
    this.inputFieldColour,
    this.inputPadding,
    this.inputTextSize,
    this.isReadOnly,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;

    return Container(
      decoration: BoxDecoration(
        color: inputFieldColour ?? custom.surface,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: EdgeInsets.all(inputPadding ?? 8.0),
        child: TextFormField(
          readOnly: isReadOnly ?? false,
          controller: controller,
          obscureText: isObscureText,
          onChanged: (value) => controller.text = value,
          validator: validator,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(regFilter)),
          ],
          keyboardType: numberKeyBoard
              ? TextInputType.numberWithOptions(decimal: true)
              : null,
          style: TextStyle(
            color: custom.primaryText,
            fontSize: inputTextSize ?? 14,
          ),
          decoration: InputDecoration(
            hintText: inputText,
            hintStyle: TextStyle(
              color: custom.secondaryText,
              fontSize: inputTextSize ?? 14,
            ),
            prefix: prefix,
            icon: inputIcon,
            iconColor: custom.primary,
            filled: false,
            contentPadding: const EdgeInsets.only(left: 8.0),
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
