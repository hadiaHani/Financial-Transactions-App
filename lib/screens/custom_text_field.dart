import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      required TextEditingController titleTextController,
      required this.hintText,
      this.maxLines})
      : _titleTextController = titleTextController,
        super(key: key);
  int? maxLines;
  final TextEditingController _titleTextController;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        controller: _titleTextController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(7),
          hintText: hintText,
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  String text;
  CustomText({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }
}
