import 'package:flutter/material.dart';

class CustomAddUserTile extends StatelessWidget {
  final Widget checkbox; 
  
  CustomAddUserTile({
    this.checkbox,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: checkbox
        ),
      ],
    );
  }
}
