import 'package:flutter/material.dart';

class CommonTextfield extends StatefulWidget {
  final String title, hint;
  final bool? isNumber;
  final TextEditingController controller;
  final Key formkey;


  const CommonTextfield(
      {super.key,
      required this.title,
      required this.hint,
      this.isNumber,
      required this.controller,
      required this.formkey});

  @override
  State<CommonTextfield> createState() => _CommonTextfieldState();
}

class _CommonTextfieldState extends State<CommonTextfield> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: TextFormField(keyboardType: widget.isNumber == null
          ? TextInputType.text
          : TextInputType.number,
        decoration: InputDecoration(label: Text(widget.title),hintText: widget.hint),
        validator: (value) => value!.isEmpty ? "Cannot be empty" : null,
        controller: widget.controller,
      ),
    );
  }
}
