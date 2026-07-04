import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientTextField extends StatefulWidget {
  final String? fieldName;
  final String? hint;
  final bool obscureText;
  final String? labelText;
  final int? maxLength;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onTouched;
  final String? prefixText;
  final String? errorText;
  final TextInputType? inputType;
  final Icon? icon;
  final Color? fillColor;
  final String? helperText;
  final int? maxLines;

  const GradientTextField({
    this.fieldName,
    super.key,
    this.hint,
    this.obscureText = false,
    this.labelText,
    this.maxLength,
    this.controller,
    this.onChanged,
    this.onTouched,
    this.prefixText,
    this.errorText,
    this.inputType,
    this.icon,
    this.fillColor,
    this.helperText,
    this.maxLines,
  });

  @override
  GradientTextFieldState createState() => GradientTextFieldState();
}

class GradientTextFieldState extends State<GradientTextField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_focusNode.hasFocus) {
        widget.onTouched?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isFocused
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            gradient: _isFocused
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.fillColor ?? Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(6),
            ),
            margin: const EdgeInsets.all(2),
            child: TextFormField(
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: widget.inputType,
              controller: widget.controller,
              obscureText: widget.obscureText,
              focusNode: _focusNode,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                errorText: widget.errorText,
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixText: widget.prefixText,
                prefixIcon: widget.icon,
                hintText: widget.hint,
                helperText: widget.helperText,
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: widget.onChanged,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9@a-zA-Z.]")),
              ],
            ),
          ),
        ),
        if (widget.labelText != null)
          Positioned(
            left: 16,
            top: -5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: widget.fillColor ?? Theme.of(context).colorScheme.surface,
              child: Text(
                widget.labelText!,
                style: TextStyle(
                  color: _isFocused
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class StyledLink extends StatelessWidget {
  final Widget text;
  final VoidCallback onTap;

  const StyledLink({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: text,
    );
  }
}
