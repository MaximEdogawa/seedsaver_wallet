import 'package:flutter/material.dart';

class DynamicCheckboxList extends StatefulWidget {
  final List<String> items;

  DynamicCheckboxList({required this.items});

  @override
  _DynamicCheckboxListState createState() => _DynamicCheckboxListState();
}

class _DynamicCheckboxListState extends State<DynamicCheckboxList> {
  List<bool> checkedList = [];

  @override
  void initState() {
    super.initState();
    checkedList = List<bool>.filled(widget.items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(widget.items[index]),
          value: checkedList[index],
          onChanged: (value) {
            setState(() {
              checkedList[index] = value!;
            });
          },
        );
      },
    );
  }
}
