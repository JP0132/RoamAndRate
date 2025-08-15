import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class CustomiseableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final Function(T?) onChanged;
  final Widget Function(T) itemBuilder;
  final Widget Function(T)? selectedItemBuilder;
  final Color? backgroundColour;
  final Color? borderColour;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? menuMaxHeight;

  // New parameters for selected text customization
  final TextStyle? selectedTextStyle;
  final Color? selectedTextColour;
  final String Function(T)? selectedTextBuilder; // To convert item to string
  final TextOverflow selectedTextOverflow;
  final int? selectedTextMaxLines;
  final Color? selectedItemColour; // Background color of selected item in list
  final Color? selectedItemTextColour; // Text color of selected item in list
  final TextStyle? selectedItemTextStyle; // Text style of selected item in list
  final Color? unselectedItemTextColour; // Text color of unselected items
  final TextStyle? unselectedItemTextStyle; // Text style of unselected items
  final Widget Function(T, bool isSelected)?
  dropdownItemBuilder; // Custom builder with selection state

  const CustomiseableDropdown({
    super.key,
    required this.items,
    this.value,
    required this.hint,
    required this.onChanged,
    required this.itemBuilder,
    this.selectedItemBuilder,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.menuMaxHeight = 300,
    this.selectedTextStyle,
    this.selectedTextBuilder,
    this.selectedTextOverflow = TextOverflow.ellipsis,
    this.selectedTextMaxLines = 1,
    this.backgroundColour,
    this.borderColour,
    this.selectedTextColour,
    this.selectedItemColour,
    this.selectedItemTextColour,
    this.selectedItemTextStyle,
    this.unselectedItemTextColour,
    this.unselectedItemTextStyle,
    this.dropdownItemBuilder,
  });

  @override
  State<CustomiseableDropdown<T>> createState() =>
      _CustomiseableDropdownState<T>();
}

class _CustomiseableDropdownState<T> extends State<CustomiseableDropdown<T>> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!mounted) return;
    final overlay = Overlay.of(context);

    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  // Build dropdown item with proper styling based on selection state
  Widget _buildDropdownItem(T item, bool isSelected) {
    // If custom dropdown item builder is provided, use it
    if (widget.dropdownItemBuilder != null) {
      return widget.dropdownItemBuilder!(item, isSelected);
    }

    // Default styling based on selection state
    TextStyle effectiveTextStyle;
    if (isSelected) {
      effectiveTextStyle = TextStyle(
        color: widget.selectedItemTextColour ?? Colors.white,
      ).merge(widget.selectedItemTextStyle);
    } else {
      effectiveTextStyle = TextStyle(
        color:
            widget.unselectedItemTextColour ??
            Theme.of(context).textTheme.bodyLarge?.color,
      ).merge(widget.unselectedItemTextStyle);
    }

    // If the item is a string, create a Text widget with proper styling
    if (item is String) {
      return Text(
        item,
        style: effectiveTextStyle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }

    // For other types, wrap the original itemBuilder result with styling
    return DefaultTextStyle(
      style: effectiveTextStyle,
      child: widget.itemBuilder(item),
    );
  }

  OverlayEntry _createOverlayEntry() {
    final context = _buttonKey.currentContext;
    if (context == null) {
      throw Exception("Button context is null. Cannot create overlay.");
    }

    final renderBox = context.findRenderObject();
    if (renderBox == null || renderBox is! RenderBox || !renderBox.attached) {
      throw Exception("RenderBox is invalid. Cannot create overlay.");
    }

    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: size.width,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                constraints: BoxConstraints(maxHeight: widget.menuMaxHeight!),
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColour ?? Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: widget.borderColour ?? Colors.grey),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final isSelected = item == widget.value;

                    return InkWell(
                      onTap: () {
                        widget.onChanged(item);
                        _closeDropdown();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration:
                            isSelected
                                ? BoxDecoration(
                                  color:
                                      widget.selectedItemColour ??
                                      Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                )
                                : null,
                        child: _buildDropdownItem(item, isSelected),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: _toggleDropdown,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColour,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: widget.borderColour ?? Colors.grey),
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              SizedBox(width: 8),
            ],
            Expanded(
              child:
                  widget.value != null
                      ? (widget.selectedItemBuilder != null
                          ? widget.selectedItemBuilder!(widget.value!)
                          : widget.itemBuilder(widget.value!))
                      : Text(
                        widget.hint,
                        style:
                            widget.hintStyle ??
                            TextStyle(color: CustomColours.darkSecondaryText),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
            ),
            widget.suffixIcon ??
                Icon(
                  _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: CustomColours.darkPrimary,
                  size: 25,
                ),
          ],
        ),
      ),
    );
  }
}
