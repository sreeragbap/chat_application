import 'package:flutter/material.dart';

class PopupmenuButton extends StatelessWidget {
  List<String> menuItems = [];
  void Function(String item) onselected;
  PopupmenuButton({
    Key key,
    this.menuItems,
    this.onselected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onselected,
      itemBuilder: (BuildContext context) {
        return menuItems.map((item) {
          return PopupMenuItem(
            child: Text(item),
            value: item,
          );
        }).toList();
      },
    );
  }
}
