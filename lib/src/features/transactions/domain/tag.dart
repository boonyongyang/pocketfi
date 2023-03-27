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
class TagChip extends StatefulWidget {
  final String label;
  bool selected;
  final Function onSelected;

  TagChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

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

List<TagChip> tags = [
  TagChip(
    label: 'Lunch',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Dinner',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Rent',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Foodpanda',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Movie',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Shopee',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Clothes',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Snacks',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Donation',
    onSelected: () {},
    selected: false,
  ),
  TagChip(
    label: 'Parking',
    onSelected: () {},
    selected: false,
  ),
];

List<TagChip> selectedTags = [];

class Tag {
  String tagId;
  String tagName;
  String tagColor;
  String tagIcon;
  bool isSelected;

  Tag({
    required this.tagId,
    required this.tagName,
    this.tagColor = '',
    this.tagIcon = '',
    this.isSelected = false,
  });
}
