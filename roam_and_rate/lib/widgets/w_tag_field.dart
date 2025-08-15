import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';

class WTagField extends StatefulWidget {
  final Function(List<String>) onTagsChanged;
  final List<String> addedTags;
  const WTagField({
    super.key,
    required this.onTagsChanged,
    required this.addedTags,
  });

  @override
  State<WTagField> createState() => _WTagFieldState();
}

class _WTagFieldState extends State<WTagField> {
  final TextEditingController _controller = TextEditingController();
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    // Initialize _tags with the provided addedTags
    _tags = List.from(widget.addedTags);
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty) {
      setState(() {
        _tags.add(tag);
        widget.onTagsChanged(_tags);
      });
      _controller.clear();
      // print('Tag added: $tag'); // Debug statement
      // print('Current tags: $_tags'); // Debug statement
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      widget.onTagsChanged(_tags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColours.darkSurface,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children:
                _tags
                    .map(
                      (tag) => Chip(
                        backgroundColor: CustomColours.darkBackground,
                        label: Text(
                          tag,
                          style: TextStyle(color: CustomColours.darkPrimary),
                        ),
                        deleteIcon: Icon(Icons.clear),
                        onDeleted: () => _removeTag(tag),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: CustomColours.darkBackground,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Add a tag',
                  icon: Icon(Icons.tag),
                  hintStyle: TextStyle(color: CustomColours.darkSecondaryText),
                  iconColor: CustomColours.darkPrimary,
                  filled: false,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onSubmitted: _addTag,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
