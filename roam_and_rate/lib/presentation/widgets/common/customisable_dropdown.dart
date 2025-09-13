import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class CustomisableDropdown<T> extends StatefulWidget {
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

  // Custom styling options
  final Color? selectedItemColour;
  final Color? selectedItemTextColour;
  final TextStyle? selectedItemTextStyle;
  final Color? unselectedItemTextColour;
  final TextStyle? unselectedItemTextStyle;
  final Widget Function(T, bool isSelected)? dropdownItemBuilder;

  const CustomisableDropdown({
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
    this.backgroundColour,
    this.borderColour,
    this.selectedItemColour,
    this.selectedItemTextColour,
    this.selectedItemTextStyle,
    this.unselectedItemTextColour,
    this.unselectedItemTextStyle,
    this.dropdownItemBuilder,
  });

  @override
  State<CustomisableDropdown<T>> createState() =>
      _CustomisableDropdownState<T>();
}

class _CustomisableDropdownState<T> extends State<CustomisableDropdown<T>> {
  final GlobalKey _buttonKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final overlay = Overlay.of(context);
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonWidth = renderBox.size.width;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // full-screen translucent barrier that closes the dropdown on tap
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
              child: Container(color: Colors.transparent),
            ),
          ),

          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, renderBox.size.height + 4),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Container(
                width: buttonWidth,
                constraints: BoxConstraints(
                  maxHeight: widget.menuMaxHeight ?? 300,
                ),
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
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (widget.selectedItemColour ??
                                    Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.2))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _buildDropdownItem(item, isSelected),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay?.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;

      // Schedule setState safely
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isOpen = false);
          }
        });
      }
    }
  }

  // ---------- _buildDropdownItem ----------
  Widget _buildDropdownItem(T item, bool isSelected) {
    if (widget.dropdownItemBuilder != null) {
      return widget.dropdownItemBuilder!(item, isSelected);
    }

    TextStyle effectiveTextStyle;
    if (isSelected) {
      effectiveTextStyle = TextStyle(
        color: widget.selectedItemTextColour ?? Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ).merge(widget.selectedItemTextStyle);
    } else {
      effectiveTextStyle = TextStyle(
        color:
            widget.unselectedItemTextColour ??
            Theme.of(context).textTheme.bodyLarge?.color,
      ).merge(widget.unselectedItemTextStyle);
    }

    // Use the provided itemBuilder for displaying every item (so caller can map id -> name)
    return DefaultTextStyle(
      style: effectiveTextStyle,
      child: widget.itemBuilder(item),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
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
                const SizedBox(width: 8),
              ],
              Expanded(
                child: widget.value != null
                    ? (widget.selectedItemBuilder != null
                          ? widget.selectedItemBuilder!(widget.value!)
                          : widget.itemBuilder(widget.value!))
                    : Text(
                        widget.hint,
                        style:
                            widget.hintStyle ?? TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
              ),
              widget.suffixIcon ??
                  Icon(
                    _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 25,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
