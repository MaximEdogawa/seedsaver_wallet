import 'package:flutter/material.dart';

class CustomRadioGroup extends StatefulWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  CustomRadioGroup(
      {required this.options,
      required this.selectedIndex,
      required this.onSelect});

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.options
          .asMap()
          .map((index, option) => MapEntry(
              index,
              InkWell(
                onTap: () {
                  widget.onSelect(index);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.selectedIndex == index
                          ? Colors.black
                          : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: widget.selectedIndex == index
                        ? Colors.green
                        : Colors.white,
                  ),
                  child: Text(option),
                ),
              )))
          .values
          .toList(),
    );
  }
}
