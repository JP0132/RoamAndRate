import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class DropdownWithInput extends StatefulWidget {
  final List<String> items;
  final String preSelected;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const DropdownWithInput({
    super.key,
    required this.items,
    required this.preSelected,
    required this.onChanged,
    required this.controller,
    this.validator,
  });

  @override
  State<DropdownWithInput> createState() => _DropdownWithInputState();
}

class _DropdownWithInputState extends State<DropdownWithInput> {
  
  late String selectedItem;
  FormFieldState<String?>? _formFieldState;
  VoidCallback? _controllerListener;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.preSelected;
    _addControllerListener();
  }

  @override
  void didUpdateWidget(covariant DropdownWithInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preSelected != widget.preSelected) {
      setState(() {
        selectedItem = widget.preSelected;
      });
      _updateValue();
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_controllerListener!);
      _addControllerListener();
    }
  }

  void _addControllerListener() {
    _controllerListener = () => _updateValue();
    widget.controller.addListener(_controllerListener!);
  }

  void _updateValue() {
    final combinedValue = '$selectedItem${widget.controller.text}';
    _formFieldState?.didChange(combinedValue);
    widget.onChanged(combinedValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    return FormField<String>(
      validator: widget.validator,
      builder: (state) {
        // Storing the form field state for later updates
        if (_formFieldState != state) {
          _formFieldState = state;
          // Setting the initial value after state is available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _updateValue();
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: custom.surface,
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
                        _updateValue();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                      ),
                      onChanged: (_) => _updateValue(),
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