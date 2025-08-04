import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class CustomiseableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final Function(T?) onChanged;
  final Widget Function(T) itemBuilder;
  final Widget Function(T)? selectedItemBuilder;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? menuMaxHeight;

  const CustomiseableDropdown({
    super.key,
    required this.items,
    this.value,
    required this.hint,
    required this.onChanged,
    required this.itemBuilder,
    this.selectedItemBuilder,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.menuMaxHeight = 300,
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
    if (!mounted) return; // prevent inserting overlay if widget is disposed
    final overlay = Overlay.of(context); // overlay might be null in edge cases

    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  // Was called in dispose method but caused expection
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
            top: offset.dy + size.height + 4, // Fixed position below the button
            width: size.width,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                constraints: BoxConstraints(maxHeight: widget.menuMaxHeight!),
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ?? Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: widget.borderColor ?? Colors.grey),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
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
                        child: widget.itemBuilder(item),
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
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: widget.borderColor ?? Colors.grey),
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
