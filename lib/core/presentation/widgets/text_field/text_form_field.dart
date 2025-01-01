import 'package:ReviewPal/core/resources/pallete/dark_theme_palette.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.haveObscureText,
    required this.haveSuffixIconObscure,
    this.inputType,
  });

  final TextEditingController controller;
  final String hintText;
  final bool haveObscureText;
  final bool haveSuffixIconObscure;
  final TextInputType? inputType;

  @override
  State<TextFormFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFormFieldWidget> {
  bool _obsocureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.haveObscureText ? _obsocureText : false,
      cursorColor: DarkThemePalette.textPrimary,
      keyboardType: widget.inputType ?? TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        } else if (value.length < 8) {
          return 'Minimum 8 characters required';
        }
        return null;
      },

      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: widget.haveSuffixIconObscure
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsocureText = !_obsocureText;
                        });
                      },
                      icon: Icon(_obsocureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded)),
                )
              : null),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
