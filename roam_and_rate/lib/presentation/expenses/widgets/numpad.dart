import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

// numeric keypad that updates a TextEditingController.
class Numpad extends StatelessWidget {
  final TextEditingController controller;

  

  /// Maximum number of decimal places allowed will be 2.
  final int decimalPlaces;

  final void Function(String value)? onChanged;

  const Numpad({
    super.key,
    required this.controller,
    this.decimalPlaces = 2,
    this.onChanged,
  });

  void _appendDigit(String digit) {
    final text = controller.text;

    // Prevent adding decimal if already present or if decimalPlaces = 0
    if (digit == '.') {
      if (decimalPlaces == 0) return;
      if (text.contains('.')) return;
      
      // If text is empty, prefix with '0'
      final newText = text.isEmpty ? '0.' : '$text.';
      controller.text = newText;
      onChanged?.call(newText);
      return;
    }

    // Handle digits
    if (digit == '0') {
      // Prevent multiple leading zeros unless it's "0."
      if (text == '0') return;
      if (text == '' && digit == '0') {
        controller.text = '0';
        onChanged?.call('0');
        return;
      }
    }

    // Limit decimal places
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts[1].length >= decimalPlaces) return;
    }

    final newText = text + digit;
    controller.text = newText;
    onChanged?.call(newText);
  }

  void _deleteLast() {
    final text = controller.text;
    if (text.isEmpty) return;
    final newText = text.substring(0, text.length - 1);
    controller.text = newText.isEmpty ? '' : newText;
    onChanged?.call(newText);
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    return Container(
      decoration: BoxDecoration(
        color: custom.surface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButtonRow(['1', '2', '3'], custom),
          const SizedBox(height: 8),
          _buildButtonRow(['4', '5', '6'], custom),
          const SizedBox(height: 8),
          _buildButtonRow(['7', '8', '9'], custom),
          const SizedBox(height: 8),
          _buildButtonRow(['.', '0', '⌫'], custom),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels, CustomColours custom) {
    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: label == '⌫'
                ? _buildActionButton(label, _deleteLast, custom)
                : _buildDigitButton(label, custom),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDigitButton(String digit, CustomColours custom) {
    return ElevatedButton(
      onPressed: () => _appendDigit(digit),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: custom.secondarySurface,
        foregroundColor: custom.primary,
        elevation: 1,
      ),
      child: Text(
        digit,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, CustomColours custom) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: custom.primary,
        foregroundColor: custom.background,
        elevation: 1,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
    );
  }
}