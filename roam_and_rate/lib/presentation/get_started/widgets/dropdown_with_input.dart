import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class DropdownWithInput extends StatefulWidget {
  final List<String> items;
  final String preSelected;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const DropdownWithInput({
    super.key,
    required this.items,
    required this.preSelected,
    required this.onChanged,
    this.validator,
  });

  @override
  State<DropdownWithInput> createState() => _DropdownWithInputState();
}

class _DropdownWithInputState extends State<DropdownWithInput> {
  final TextEditingController _controller = TextEditingController();
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.preSelected;
  }

  void _notifyParent() {
    widget.onChanged('$selectedItem${_controller.text}');
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CustomColours.darkSurface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: state.hasError ? Colors.red : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedItem,
                      items: widget.items.map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value!;
                        });
                        _notifyParent();
                        // tell form field that value changed
                        state.didChange('$selectedItem${_controller.text}');
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (value) {
                        _notifyParent();
                        state.didChange('$selectedItem$value');
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 4),
              Text(
                state.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }
}
