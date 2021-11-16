import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputFeild extends StatelessWidget {
  final String? hintText;
  final String? lableText;
  final Widget? icon;
  final TextEditingController? controller;

  const InputFeild({Key? key, this.hintText, this.lableText, this.icon, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width -60,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: lableText,
          icon: icon
        ),
      ),
    );
  }
}
