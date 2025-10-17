import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class DropdownWithInput extends StatefulWidget {
  final List<String> items;
  final String preSelected;
  final Function onChanged;
  const DropdownWithInput({
    super.key,
    required this.items,
    required this.preSelected,
    required this.onChanged,
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

  @override
  void didUpdateWidget(DropdownWithInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preSelected != widget.preSelected) {
      setState(() {
        selectedItem = widget.preSelected;
      });
    }
  }

  void _notifyParent() {
    widget.onChanged(selectedItem + _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColours.darkSurface,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: DropdownButtonHideUnderline(
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
                },
              ),
            ),
          ),
        ),
        onChanged: (value) {
          _notifyParent();
        },
      ),
    );
  }
}
