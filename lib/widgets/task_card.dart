import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final Widget? trailing;

  const TaskCard({Key? key, required this.title,required this.leading, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        title: Text(title ?? ''),
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}
