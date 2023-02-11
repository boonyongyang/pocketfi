class Tag {
  final String tagId;
  final String tagName;
  final String tagColor;
  final String tagIcon;
  // final bool isSelected;

  Tag({
    required this.tagId,
    this.tagName = '',
    this.tagColor = '',
    this.tagIcon = '',
    // this.isSelected, {required name},
  });
}
