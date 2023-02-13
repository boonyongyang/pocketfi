// ignore_for_file: public_member_api_docs, sort_constructors_first
// class Tag {
//   final String tagId;
//   final String tagName;
//   final String tagColor;
//   final String tagIcon;
//   // final bool isSelected;

//   Tag({
//     required this.tagId,
//     this.tagName = '',
//     this.tagColor = '',
//     this.tagIcon = '',
//     // this.isSelected, {required name},
//   });
// }

import 'package:flutter/material.dart';

@immutable
// ignore: must_be_immutable
class TagChip extends StatefulWidget {
  final String label;
  bool selected;
  final Function onSelected;

  TagChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  TagChipState createState() => TagChipState();
}

class TagChipState extends State<TagChip> {
  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(widget.label),
      selected: widget.selected,
      onSelected: (selected) {
        setState(() {
          widget.selected = selected;
        });
        widget.onSelected(selected);
      },
    );
  }
}

class ChipSelectionPage extends StatefulWidget {
  const ChipSelectionPage({super.key});

  @override
  ChipSelectionPageState createState() => ChipSelectionPageState();
}

class ChipSelectionPageState extends State<ChipSelectionPage> {
  final List<String> _tags = ['Lunch', 'Dinner', 'Rent', 'Parking'];
  final List<TagChip> _tagChips = [];

  @override
  void initState() {
    super.initState();
    for (var tag in _tags) {
      _tagChips.add(TagChip(
        label: tag,
        selected: false,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              for (var tagChip in _tagChips) {
                if (tagChip.label == tag) {
                  tagChip.selected = true;
                } else {
                  tagChip.selected = false;
                }
              }
            } else {
              for (var tagChip in _tagChips) {
                if (tagChip.label == tag) {
                  tagChip.selected = false;
                }
              }
            }
          });
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chip Selection Example'),
      ),
      body: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: _tagChips,
      ),
    );
  }
}
